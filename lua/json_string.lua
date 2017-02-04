local utf8 = require "utf8"

--[[
	json_string.lua

	a throwaway json encoding/decoding library

	takes a lua utf8 string and converts it to text
	that's safe for json

	not particularly idiot-proof
]]--

local json_string = {}

function json_string.encode(str)
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
		elseif sub == "\0" then
			chunk = "\\0"
		elseif sub:byte() < 32 then
			chunk = "\\u" .. string.format("%04X", sub:byte())
		end
		table.insert(chunks, chunk)
	end

	return "\""..table.concat(chunks, "").."\""
end

function json_string.decode(str)
	local chunks = {}
	if utf8.sub(str,1,1) ~= "\"" or utf8.sub(str, -1,-1) ~= "\"" then
		--not a quoted string
		return ""
	end
	str = utf8.sub(str, 2, -2)
	local current = ""
	for sub in utf8.gensub(str, 1) do
		if current == "" then
			if sub == "\\" then
				--begin escape
				current = sub
			else
				--copy through
				table.insert(chunks, sub)
			end
		else
			current = current..sub
			--trivial named escapes
			if sub == "\\\\" then
				chunk = "\\"
			elseif sub == "\\\"" then
				chunk = "\""
			elseif sub == "\\n" then
				chunk = "\n"
			elseif sub == "\\t" then
				chunk = "\t"
			elseif sub == "\\r" then
				chunk = "\r"
			elseif sub == "\\b" then
				chunk = "\b"
			elseif sub == "\\0" then
				chunk = "\0"
			end
			--unicode escape or bad escape
			local ulen = utf8.len(current)
			if ulen > 6 then
				--bail, bad escape
				current = ""
			elseif utf8.sub(current, 1, 2) == "\\u" and ulen == 6 then
				--unicode escape
				table.insert(chunks, utf8.char(tonumber(utf8.sub(current, 2), 16)))
			end
		end
	end
	return table.concat(chunks, "")
end

return json_string
