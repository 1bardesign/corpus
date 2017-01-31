local json = require "json"
local b64 = require "base64"
local corpus = require "corpus_compress"
local derive = require "corpus_derive"

---------------------
-- testing
local test_runs = 1000
local test_size_range = {30, 400}
local test_files = {
	"test/zeroes",
	"test/bib",
	"test/book1",
	"test/book2",
	"test/geo",
	"test/news",
	"test/obj1",
	"test/obj2",
	"test/paper1",
	"test/paper2",
	"test/paper3",
	"test/paper4",
	"test/paper5",
	"test/paper6",
	"test/pic",
	"test/progc",
	"test/progl",
	"test/progp",
	"test/trans",
	"test/kagapi",
	"test/github"
}

function do_test(filename)
	local dict = derive.dictionary_from_file(filename)

	io.input(filename)
	local contents = io.read("*all")
	local conlen = contents:len()

	local starttime = os.clock();

	local test_results = {}
	for _=1,test_runs do
		--compute sample bounds
		local sample_from = math.floor(math.random() * conlen);
		local sample_len = math.floor(test_size_range[1] + math.random() * (test_size_range[2] - test_size_range[1]))
		--take sample
		local sample = contents:sub(sample_from, sample_from + sample_len - 1)
		--compress, encode and decompress
		local compressed = corpus.compress(sample, dict);
		local b64_encoded = b64.encode(compressed)
		local decompressed = decompress(compressed, dict);
		table.insert(test_results, {
			decompressed == sample,
			compressed:len() / sample:len(),
			b64_encoded:len() / sample:len()
		})
	end

	local timetaken = os.clock() - starttime;

	local test_average = {
		filename,		--filename
		conlen,			--file length
		timetaken,		--time to compress, base64, decompress
		true,			--no corruption
		0,				--raw ratio
		0				--base64 ratio
	}
	for k,v in ipairs(test_results) do
		test_average[4] = test_average[4] and v[1]
		test_average[5] = test_average[5] + v[2]
		test_average[6] = test_average[6] + v[3]
	end

	test_average[3] = test_average[3] / test_runs
	test_average[5] = test_average[5] / test_runs
	test_average[6] = test_average[6] / test_runs

	--stringify
	for i=1,#test_average do
		test_average[i] = tostring(test_average[i])
	end

	return test_average
end

local csv = {{"filename", "filesize", "time", "success", "rawratio", "b64ratio"}}
for k,f in ipairs(test_files) do
	table.insert(csv, do_test(f))
end

for k,v in ipairs(csv) do
	print(table.concat(v, ",\t"))
end
