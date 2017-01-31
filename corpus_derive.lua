local compress = require "corpus_compress"

local _M = {}

--------------------
--config

--how many entries to collect
local entries = 1024
--how long should the entries be (at maximum)
local levels = 6
--how do you want the populations of each length weighted?
--this controls the overall proportions that go into the final sort
local seen_weights = {1,1,1,1,1,1}
--any hard numerical limits on each population
local seen_hard_limits = {0,0,0,0,0,0}
--the length which should be restricted past the first page
-- (because anything past this requires 2 bytes -> should be at least 1)
local restrict_past_first_page = 2
--whether to apply the similarity filter
local do_similarity_filter = true
--whether to consider different lengths in similarity
-- (seems to hurt ratios but the option is there - test!)
local similar_differentlengths = false

----------------------
--if we're running standalone, will read from
local standalone = (debug.getinfo(2, "n").name == nil)

-----------------------
--setup any computed vars
local first_page_ends = compress.friend.calc_start_multibyte_from_len(entries)
local seen_limits = {}
do
	local sum = 0
	for i = 1,#seen_weights do
		sum = sum + seen_weights[i]
	end
	for i = 1,#seen_weights do
		op = math.floor
		if i == #seen_weights then op = math.ceil end
		seen_limits[i] = op(seen_weights[i] / sum * entries * 2)
		if seen_hard_limits[i] > 0 then
			seen_limits[i] = math.min(seen_limits[i], seen_hard_limits[i])
		end
	end
end

function _M.count_occurences(filename, seen)
	local blocksize = 2^10
	seen = seen or {}

	local f, err;
	if filename and filename ~= "" then
		f, err = io.open(filename, "rb")
		if not f then
			return nil, "error opening file ("..filename.."): "..err
		end
	else
		f = io.stdin
	end

	while true do
		local blk = f:read(blocksize)
		if not blk then break end

		local len = blk:len()

		for i = 1,len do
			for j = 1, levels do
				--allows blanking out specific levels to save perf
				if seen_limits[j] > 0 then
					local sub = blk:sub(i,i+j-1)
					if not seen[sub] then
						seen[sub] = 1
					else
						seen[sub] = seen[sub] + 1
					end
				end
			end
		end
	end

	return seen
end

function _M.dictionary_from_counts(seen)

	--helpers
	function sortpairs(a,b)
		return a[2] > b[2]
	end

	function toosimilar(a, alen, b, blen)
		if similar_differentlengths then
			if math.abs(alen - blen) > 1 then
				return false
			end
			local apref = a:sub(1, alen-1)
			local asuf = a:sub(-alen+1)
			local bpref = b:sub(1, blen-1)
			local bsuf = b:sub(-blen+1)

			return apref == bsuf or bpref == asuf or
				asuf == b or bsuf == a or
				apref == b or bpref == a
		else
			if math.abs(alen - blen) > 0 then
				return false
			end
			local apref = a:sub(1, alen-1)
			local asuf = a:sub(-alen+1)
			local bpref = b:sub(1, blen-1)
			local bsuf = b:sub(-blen+1)

			return apref == bsuf or bpref == asuf
		end
	end

	--------------------
	--go!

	--sort and shred
	local allcounts = {}
	for i = 1,levels do
		--copy to sort if the right length
		local counts = {}
		for k,v in pairs(seen) do
			if k:len() == i then
				table.insert(counts, {k,v})
			end
		end

		table.sort(counts, sortpairs)

		while #counts > seen_limits[i] do
			table.remove(counts)
		end

		--copy out
		for k,v in ipairs(counts) do
			table.insert(allcounts, v)
		end
	end

	table.sort(allcounts, sortpairs)

	--filter very similar
	if do_similarity_filter then
		local i = 1
		repeat
			local a = allcounts[i][1]
			local alen = a:len()
			local j = i + 1
			repeat
				local b = allcounts[j][1]
				local blen = b:len()
				if toosimilar(a, alen, b, blen) then
					allcounts[i][2] = allcounts[i][2] + allcounts[j][2]
					table.remove(allcounts, j)
					j = j - 1
				end
				j = j + 1
			until j > #allcounts
			i = i + 1
		until i > #allcounts - 1
	end

	--filter too short for index
	if #allcounts > first_page_ends then
		local i = first_page_ends
		repeat
			local a = allcounts[i][1]
			local alen = a:len()
			if alen <= restrict_past_first_page then
				table.remove(allcounts, i)
				i = i - 1
			end

			i = i + 1
		until i > #allcounts - 1
	end

	--filter just name
	local finished = {}
	for k,v in ipairs(allcounts) do
		table.insert(finished, v[1])
	end

	--trim to length
	while #finished > entries do
		table.remove(finished)
	end
	return finished
end

function _M.dictionary_from_file(filename)
	return _M.dictionary_from_counts(_M.count_occurences(filename))
end

if standalone then
	local dict
	if #arg > 0 then
		dict = _M.dictionary_from_file(arg[1])
	else
		dict = _M.dictionary_from_file()
	end

	function json_escape(str)
		local chunks = {}
		for i = 1, str:len() do
			local sub = str:sub(i,i)
			local chunk = sub
			if sub == "\\" then
				chunk = "\\\\"
			elseif sub == "\"" then
				chunk = "\\\""
			elseif sub == "\n" then
				chunk = "\\n"
			elseif sub == "\t" then
				chunk = "\\t"
			elseif sub == "\r" then
				chunk = "\\r"
			elseif sub == "\b" then
				chunk = "\\b"
			elseif sub:byte() < 32 then
				chunk = "\\u" .. string.format("%04X", sub:byte())
			end
			--otherwise, we're assuming utf8 and that we split on codepoints, so we're good
			table.insert(chunks, chunk)
		end

		return "\""..table.concat(chunks, "").."\""
	end

	io.write("[")
	for k,v in ipairs(dict) do
		io.write(json_escape(v))
		if k < #dict then
			io.write(",")
		end
	end
	io.write("]\n")
end

return _M
