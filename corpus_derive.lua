local utf8 = require "utf8"

--[[
	corpus_derive.lua

	will derive an effective codebook for a given corpus

	this script will load entire files into memory to avoid
	complications with utf8 code and alignment splitting
	across block-based IO...

	So, for a big corpus, it's more effective to write a bit of
	glue code and accumulate stuff into a shared seen table
	using multiple invocations of count_occurences than
	tossing in a single big file.

	(if you have a stream-based utf8 lua api please share!)
]]--


--------------------
--config
--these vars can also be passed in as a table at runtime
--but are used as defaults in all other cases

--how many entries to collect (codebook size)
local entries = 2048
--how long should the entries be (at maximum)
local entry_maxlength = 6
--the gap between each scan level
--(1 = scan all substrings, 3 = scan subs of length 1, 4, 7...)
local level_step = 1
--the length increase required for a string to appear in each "page"
--past the first; prevents expansion by encoding say, a single character
--with 3 bytes (we can already do that in 2, worst case)
local restrict_per_page = 2
--whether to apply the similarity filter
local do_similarity_filter = true
--whether to consider different lengths in similarity
-- (seems to hurt ratios but the option is there)
local similar_differentlengths = false
-- this is an optimisation - the file will be split every
-- this many codepoints; should be big enough to not affect
-- the statistics much, but small enough that iterating
-- over a block lots of times isn't crazy expensive
local block_size = 512

--fill in defaults
local function fill_in_config(config)
	config = config or {}
	config.entries = config.entries or entries
	config.entry_maxlength = config.entry_maxlength or entry_maxlength
	config.level_step = config.level_step or level_step
	config.levels = math.floor(config.entry_maxlength/config.level_step)
	config.restrict_per_page = config.restrict_per_page or restrict_per_page
	config.do_similarity_filter = config.do_similarity_filter or do_similarity_filter
	config.similar_differentlengths = config.similar_differentlengths or similar_differentlengths
	config.block_size = config.block_size or block_size
	return config
end

--end config
----------------------

local _M = {}
--if we're running standalone, will read from stdin
local standalone = (debug.getinfo(2, "n").name == nil)
--127 minus 3
local first_page_ends = 124

function _M.count_occurences(str, seen, config)
	config = fill_in_config(config)
	seen = seen or {}
	--note - this is not fast :)
	--todo: figure out a way to keep the iterator position and
	--feed it into utf8.sub rather than repeating so much effort
	for block in utf8.gensub(str, config.block_size) do
		local block_len = utf8.len(block)
		for i = 1, block_len do
			for level = 1, config.entry_maxlength, level_step do
				local sub = utf8.sub(block, i, i+level-1)
				if not seen[sub] then
					seen[sub] = 1
				else
					seen[sub] = seen[sub] + 1
				end
			end
		end
	end

	return seen
end

function _M.count_occurences_file(filename, seen, config)
	config = fill_in_config(config)
	local f, err;
	if filename and filename ~= "" then
		f, err = io.open(filename, "rb")
		if not f then
			return nil, "error opening file ("..filename.."): "..err
		end
	else
		f = io.stdin
	end

	local contents = f:read("*all")

	seen = _M.count_occurences(contents, seen, config)

	return seen
end

function _M.dictionary_from_counts(seen, config)
	config = fill_in_config(config)

	--helpers
	function sortpairs(a,b)
		return a[2] > b[2]
	end

	function toosimilar(a, alen, b, blen)
		if config.similar_differentlengths then
			if math.abs(alen - blen) > 1 then
				return false
			end
			local apref = utf8.sub(a, 1, alen-1)
			local asuf = utf8.sub(a, -alen+1)
			local bpref = utf8.sub(b, 1, blen-1)
			local bsuf = utf8.sub(b, -blen+1)

			return apref == bsuf or bpref == asuf or
				asuf == b or bsuf == a or
				apref == b or bpref == a
		else
			if math.abs(alen - blen) > 0 then
				return false
			end
			local apref = utf8.sub(a, 1, alen-1)
			local asuf = utf8.sub(a, -alen+1)
			local bpref = utf8.sub(b, 1, blen-1)
			local bsuf = utf8.sub(b, -blen+1)

			return apref == bsuf or bpref == asuf
		end
	end

	--------------------
	--go!

	--per-level limit
	local seen_limit = math.max(128, config.entries)

	--sort and shred
	local allcounts = {}
	for i = 1,config.levels do
		--copy to sort if the right length
		local counts = {}
		for k,v in pairs(seen) do
			if k:len() == i then
				table.insert(counts, {k,v})
			end
		end

		table.sort(counts, sortpairs)

		while #counts > seen_limit do
			table.remove(counts)
		end

		--copy out
		for k,v in ipairs(counts) do
			table.insert(allcounts, v)
		end
	end

	table.sort(allcounts, sortpairs)

	--filter very similar
	if config.do_similarity_filter then
		local i = 1
		repeat
			local a = allcounts[i][1]
			local alen = utf8.len(a)
			local j = i + 1
			repeat
				local b = allcounts[j][1]
				local blen = utf8.len(b)
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

	--filter redundant seqs
	if #allcounts > first_page_ends then
		local i = first_page_ends
		repeat
			local a = allcounts[i][1]
			local req_len = config.restrict_per_page * (string.len(utf8.char(i + 2)) - 1)
			local alen = string.len(a)
			if alen <= req_len then
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
	while #finished > config.entries do
		table.remove(finished)
	end
	return finished
end

function _M.dictionary_from_string(s, config)
	config = fill_in_config(config)
	return _M.dictionary_from_counts(_M.count_occurences(s, config), config)
end

function _M.dictionary_from_file(filename, config)
	config = fill_in_config(config)
	return _M.dictionary_from_counts(_M.count_occurences_file(filename, config), config)
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
		for sub in utf8.gensub(str, 1) do
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
