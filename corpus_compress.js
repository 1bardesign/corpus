var encoding_literal_byte = 1;
var encoding_literal_string = 2;
var encoding_dictionary_entry = 3;

//todo: just solve the linear equations instead of iterating

//searching for sub patterns
function find_index_at(s, index, lookup, levels)
{
	var search = s.substring(index, index + levels);
	for (var i = levels; i > 1; i--)
	{
		var sub = search.substring(0, i);
		var luv = lookup[sub];
		if (luv)
		{
			return luv;
		}
	}
	return null;
}

function compress(s, dict)
{
	//prep tables into lookup
	var lookup = {};
	var levels = 1;
	for (var i = 0; i < dict.length; i++)
	{
		var v = dict[i];
		lookup[v] = i;
		levels = Math.max(levels, v.length)
	}

	var index = 0;
	var len = s.length;
	var output = [];
	while (index < len && output.length < len + 2) //or if straight string is smaller
	{
		//search for a match, longest first
		var found = find_index_at(s, index, lookup, levels);
		if (found != null)
		{
			//nice, there's something in the dictionary
			output.push(found + encoding_dictionary_entry);
			index += dict[found].length;
		}
		else
		{
			//dang, it's not, figure out how few bytes we can get away with encoding..
			var bad_bytes = 1;
			while (!found && bad_bytes < 0xD800 && index + bad_bytes < len)
			{
				found = find_index_at(s, index + bad_bytes + 1, lookup, levels);
				//skip any short dict entries because restarting verbatim encoding has overhead
				if (found != null && dict[found].length <= 2 && bad_bytes > 1)
				{
					//todo: detect when there's a viable run of small breaks ahead
					found = null;
				}
				bad_bytes += 1;
			}
			if (bad_bytes == 1)
			{
				// byte verbatim
				output.push(encoding_literal_byte);
				output.push(s.charCodeAt(index));
			}
			else
			{
				// string verbatim
				output.push(encoding_literal_string);
				output.push(bad_bytes);
				for (var i = 0; i < bad_bytes; i++)
				{
					output.push(s.charCodeAt(index + i));
				}
			}
			index += bad_bytes;
		}
	}

	if(output.length < len + 2)
	{
		for (var i = 0; i < output.length; i++)
		{
			output[i] = String.fromCharCode(output[i])
		}

		return output.join("")
	}
	else //string verbatim
	{
		return [String.fromCharCode(encoding_literal_string), String.fromCharCode(len), s].join("")
	}
}

function decompress(s, dict)
{
	var index = 0;
	var len = s.length;
	var output = [];
	while (index < len)
	{
		var b = s.charCodeAt(index);
		if (b == encoding_literal_byte)
		{
			//byte
			output.push(s.charAt(index + 1));
			index += 2;
		}
		else if (b == encoding_literal_string)
		{
			//string
			var s_len = s.charCodeAt(index + 1);
			output.push(s.substring(index + 2, index + 2 + s_len));
			index += 2 + s_len;
		}
		else if (b >= encoding_dictionary_entry)
		{
			//tab entry
			var tabindex = b - encoding_dictionary_entry;
			output.push(dict[tabindex]);
			index += 1;
		}
		else
		{
			//null
			output.push("\0");
			index += 1;
		}
	}

	return output.join("");
}
