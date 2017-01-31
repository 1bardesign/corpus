local _M = {}

local encoding_first_index = 1 --avoid nulls
local encoding_entries = 253

--todo: just solve the linear equations instead of iterating
local function capacity_with_start(start)
	return start + 255 * (encoding_entries - start)
end

local function calc_start_multibyte_from_len(len)
	local start = encoding_entries + 1
	if len > encoding_entries then
		repeat
			start = start - 1
		until capacity_with_start(start) >= len
	end
	return start
end

local function calc_start_multibyte(dict)
	return calc_start_multibyte_from_len(#dict)
end

local function index_to_multibyte(start, index)
	if index < start then
		return index, nil
	else
		index = index - start
		while index >= 255 do
			index = index - 255
			start = start + 1
		end
		return start, index + encoding_first_index
	end
end

local function multibyte_to_index(start, a, b)
	if b == nil then
		return a
	else
		return start + (a - start) * 255 + (b - encoding_first_index)
	end
end

--searching for sub patterns
local function find_index_at(s, index, lookup, levels)
	for i = levels,1,-1 do
		local sub = s:sub(index, index+i-1)
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
		levels = math.max(levels, v:len())
	end

	local start_multibyte = calc_start_multibyte(dict)
	local index = 1
	local len = s:len()
	local output = {}
	while index <= len do
		--search for a match, longest first
		local found, flen = find_index_at(s, index, lookup, levels)
		if found then
			--nice, there's something in the dictionary
			local a, b = index_to_multibyte(start_multibyte, found)
			table.insert(output, a)
			if b then
				table.insert(output, b)
			end
			index = index + flen
		else
			--dang, it's not, figure out how few bytes we can get away with encoding..
			local bad_bytes = 1
			while not found and bad_bytes < 255 and index + bad_bytes < len do
				found, flen = find_index_at(s, index + bad_bytes + 1, lookup, levels)
				--skip any short dict entries because restarting verbatim encoding has overhead
				if flen <= 2 and bad_bytes > 1 and bad_bytes < 8 then
					found = nil
				end
				bad_bytes = bad_bytes + 1
			end
			if bad_bytes == 1 then
				-- byte verbatim
				table.insert(output, 255)
				table.insert(output, s:byte(index))
			else
				-- string verbatim
				table.insert(output, 254)
				table.insert(output, bad_bytes)
				for i=0,bad_bytes-1 do
					table.insert(output, s:byte(index+i))
				end
			end
			index = index + bad_bytes
		end
	end

	for i = 1,#output do
		output[i] = string.char(output[i])
	end

	return table.concat(output, "")
end

local function decompress(s, dict)
	local start_multibyte = calc_start_multibyte(dict)
	local index = 1
	local len = s:len()
	local output = {}
	local err = nil
	while index <= len do
		local b = s:byte(index)
		if b > 0 and b <= #dict and b < 254 then
			--tab entry
			local tabindex = b
			if b < start_multibyte then
				index = index + 1
			else
				tabindex = multibyte_to_index(start_multibyte, b, s:byte(index + 1))
				index = index + 2
			end
			table.insert(output, dict[tabindex])
		elseif b == 254 then
			--string
			local s_len = s:byte(index + 1)
			for i=1,s_len do
				table.insert(output, string.char(s:byte(index + 1 + i)))
			end
			index = index + 2 + s_len
		elseif b == 255 then
			--byte
			table.insert(output, string.char(s:byte(index + 1)))
			index = index + 2
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

--private export
local friend = {}
friend.multibyte_to_index = multibyte_to_index
friend.index_to_multibyte = index_to_multibyte
friend.calc_start_multibyte = calc_start_multibyte
friend.calc_start_multibyte_from_len = calc_start_multibyte_from_len
friend.capacity_with_start = capacity_with_start
friend.find_index_at = find_index_at

_M.friend = friend

return _M
