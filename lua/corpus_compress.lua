local utf8 = require "utf8"

local _M = {}

local encoding_literal_byte = 1
local encoding_literal_string = 2
local encoding_dictionary_entry = 3

--todo: just solve the linear equations instead of iterating

--searching for sub patterns
local function find_index_at(s, index, lookup, levels)
	local search = utf8.sub(s, index, index+levels-1)
	for i = levels,1,-1 do
		local sub = utf8.sub(search, 1, i)
		local luv = lookup[sub]
		if luv then
			return luv, i
		end
	end
	return nil, 0
end

local function compress(s, dict)
	--prep tables into lookup
	local lookup = {}
	local levels = 1
	for i,v in ipairs(dict) do
		lookup[v] = i;
		levels = math.max(levels, utf8.len(v))
	end

	local index = 1
	local len = utf8.len(s)
	local output = {}
	while index <= len and #output < len + 2 do
		--search for a match, longest first
		local found, flen = find_index_at(s, index, lookup, levels)
		if found then
			--nice, there's something in the dictionary
			table.insert(output, found + encoding_dictionary_entry - 1)
			index = index + flen
		else
			--dang, it's not, figure out how few bytes we can get away with encoding..
			local bad_bytes = 1
			while not found and bad_bytes < 0xD800 and index + bad_bytes < len do
				found, flen = find_index_at(s, index + bad_bytes + 1, lookup, levels)
				--skip any short dict entries because restarting verbatim encoding has overhead
				if flen <= 2 and bad_bytes > 1 then
					--todo: detect when there's a viable run of small breaks ahead
					found = nil
				end
				bad_bytes = bad_bytes + 1
			end
			if bad_bytes == 1 then
				-- byte verbatim
				table.insert(output, encoding_literal_byte)
				table.insert(output, utf8.byte(s, index))
			else
				-- string verbatim
				table.insert(output, encoding_literal_string)
				table.insert(output, bad_bytes)
				for i = 0, bad_bytes - 1 do
					table.insert(output, utf8.byte(s, index + i))
				end
			end
			index = index + bad_bytes
		end
	end

	if #output < len + 2 then
		--compression achieved
		for i = 1, #output do
			output[i] = utf8.char(output[i])
		end

		return table.concat(output, "")
	else
		--no-win, encode verbatim
		if len > 1 then
			--string
			output = {
				utf8.char(encoding_literal_string),
				utf8.char(len)
			}
		else
			--byte
			output = {
				utf8.char(encoding_literal_byte)
			}
		end
		table.insert(output, s)

		return table.concat(output, "")
	end
end

local function decompress(s, dict)
	local index = 1
	local len = utf8.len(s)
	local output = {}
	local err = nil
	while index <= len do
		local b = utf8.byte(s, index)
		if b == encoding_literal_byte then
			--byte
			table.insert(output, utf8.char(utf8.byte(s, index + 1)))
			index = index + 2
		elseif b == encoding_literal_string then
			--string
			local s_len = utf8.byte(s, index + 1)
			for i=1,s_len do
				table.insert(output, utf8.char(utf8.byte(s, index + 1 + i)))
			end
			index = index + 2 + s_len
		elseif b >= encoding_dictionary_entry then
			--tab entry
			local tabindex = b - encoding_dictionary_entry + 1
			table.insert(output, dict[tabindex])
			index = index + 1
		else
			--null
			table.insert(output, "\0")
			err = "malformed input"
			index = index + 1
		end
	end
	return table.concat(output,""), err
end

--public export

_M.compress = compress
_M.decompress = decompress

return _M
