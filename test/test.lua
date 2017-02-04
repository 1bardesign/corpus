package.path = "../lua/?.lua;?.lua;;"
local utf8 = require "utf8"
local corpus_compress = require "corpus_compress"
local corpus_derive = require "corpus_derive"

---------------------
-- testing
local test_runs = 1000
local test_size_range = {30, 400}
local test_files = {
	--plain language
	"australian",
	"french",
	"hindi",
	"chinese",
	--apis/languages
	"json",
	"js",
}

function do_test(filename)

	local json_filename = "dict/"..filename..".json"
	local case_filename = "cases/"..filename

	local dict = nil
	local f, err = io.open(json_filename)
	if f then
		--already existing dict, just use that
		json_dict = f:read("*all")
		dict = corpus_derive.json_to_dict(json_dict)
		f:close()
	end

	io.input(case_filename)
	local contents = io.read("*all")
	local conlen = utf8.len(contents);

	if dict == nil then
		--have to derive it from the contents
		dict = corpus_derive.dictionary_from_string(contents)
		local f, err = io.open(json_filename, "w")
		if f then
			f:write(corpus_derive.dict_to_json(dict))
			f:close()
		end
	end

	local starttime = os.clock();

	local test_results = {}
	for _=1,test_runs do
		--compute sample bounds
		local sample_from = math.floor(math.random() * conlen);
		local sample_len = math.floor(test_size_range[1] + math.random() * (test_size_range[2] - test_size_range[1]))
		--take sample
		local sample = utf8.sub(contents, sample_from, sample_from + sample_len - 1)
		--compress, encode and decompress
		local compressed = corpus_compress.compress(sample, dict);
		local decompressed = corpus_compress.decompress(compressed, dict);

		sample_len = string.len(sample)
		table.insert(test_results, {
			decompressed == sample,
			--note: we DO want string.len here to compare byte lengths
			string.len(compressed) / sample_len
		})
	end

	local timetaken = os.clock() - starttime;

	filename = string.gsub(filename, "cases/", "")
	local test_average = {
		filename,		--filename
		conlen,			--file length
		#dict,			--dictionary length
		timetaken,		--time to compress, base64, decompress
		true,			--no corruption
		0,				--ratio
	}
	for k,v in ipairs(test_results) do
		test_average[5] = test_average[5] and v[1]
		test_average[6] = test_average[6] + v[2]
	end

	test_average[4] = string.format("%0.4f", test_average[4] / test_runs)
	test_average[6] = string.format("%0.4f", test_average[6] / test_runs)

	return test_average
end

local csv = {{"filename", "filesize", "dictlen", "time", "success", "ratio"}}
for k,f in ipairs(test_files) do
	local test_safe = false
	if test_safe then
		local success, results = pcall(do_test, f)
		if success then
			table.insert(csv, results)
		else
			table.insert(csv, {
				f,				--filename
				results 		--error
			})
		end
	else
		table.insert(csv, do_test(f))
	end

end

for k,v in ipairs(csv) do
	--stringify
	local form = "%24s"
	for i=1,#v do
		v[i] = string.format(form, tostring(v[i]))
		form = "%12s"
	end
	print(table.concat(v, ",\t"))
end
