var encoding_first_index = 1; //avoid nulls
var encoding_entries = 253;

//todo: just solve the linear equations instead of iterating
function capacity_with_start(start)
{
	return start + 255 * (encoding_entries - start)
}

function calc_start_multibyte_from_len(len)
{
	var start = encoding_entries + 1;
	if (len > encoding_entries)
	{
		do {
			start = start - 1;
		} while(capacity_with_start(start) < len)
	}
	return start;
}

function calc_start_multibyte(dict)
{
	return calc_start_multibyte_from_len(dict.length)
}

function index_to_multibyte(start, index)
{
	if (index < start)
	{
		return [index]
	}
	else
	{
		index = index - start;
		while (index >= 255)
		{
			index = index - 255;
			start = start + 1;
		}
		return [start, index + encoding_first_index];
	}
}

function multibyte_to_index(start, a, b)
{
	if (b == null)
	{
		return a;
	}
	else
	{
		return start + (a - start) * 255 + (b - encoding_first_index);
	}
}

//searching for sub patterns
function find_sub_at(s, index, lookup, levels)
{
	for (var i = levels; i > 0; i--)
	{
		var sub = s.substr(index, i);
		if (sub in lookup)
		{
			return sub
		}
	}
	return null
}

function compress(s, dict)
{
	//prep tables into lookup
	var lookup = {}
	var levels = 1;
	for (var i = 0; i < dict.length; i++)
	{
		var v = dict[i];
		lookup[v] = i;
		levels = Math.max(levels, v.length);
	}

	var start_multibyte = calc_start_multibyte(dict);
	var index = 0;
	var len = s.length;
	var output = [];
	while (index < len)
	{
		//search for a match, longest first
		var found = find_sub_at(s, index, lookup, levels)
		var flen = 0;
		if(found)
		{
			//nice, there's something in the dictionary
			flen = found.length;
			var encoded = index_to_multibyte(start_multibyte, lookup[found] + 1);
			while(encoded.length > 0)
			{
				output.push(encoded.shift())
			}
			index += flen;
		}
		else
		{
			//dang, it's not, figure out how few bytes we can get away with encoding..
			var bad_bytes = 1;
			while (!found && bad_bytes < 255 && index + bad_bytes < len)
			{
				found = find_sub_at(s, index + bad_bytes, lookup, levels);
				if(found != null)
				{
					flen = found.length;
				}

				//skip any short dict entries in this window because restarting verbatim encoding has overhead
				if(flen <= 2 && bad_bytes > 1 && bad_bytes < 8)
				{
					found = null;
				}
				bad_bytes = bad_bytes + 1;
			}
			if(bad_bytes == 1)
			{
				// byte verbatim
				output.push(255);
				output.push(s.charCodeAt(index));
			}
			else
			{
				// string verbatim
				output.push(254);
				output.push(bad_bytes);
				for(var i = 0; i < bad_bytes; i++)
				{
					output.push(s.charCodeAt(index+i));
				}
			}
			index += bad_bytes;
		}
	}

	for (var i = 0; i < output.length; i++)
	{
		output[i] = String.fromCharCode(output[i]);
	}

	return output.join("");
}

function decompress(s, dict)
{
	var start_multibyte = calc_start_multibyte(dict);
	var index = 0;
	var len = s.length;
	var output = [];
	var err = null;
	while (index < len)
	{
		var b = s.charCodeAt(index);
		if (b > 0 && b <= dict.length && b < 254)
		{
			//tab entry
			var tabindex = b;
			if (b < start_multibyte)
			{
				index++;
			}
			else
			{
				tabindex = multibyte_to_index(start_multibyte, b, s.charCodeAt(index + 1));
				index += 2;
			}
			output.push(dict[tabindex-1]);
		}
		else if (b == 254)
		{
			//string
			var s_len = s.charCodeAt(index + 1);
			for (var i = 1; i <= s_len; i++)
			{
				output.push(s.substr(index + 1 + i, 1))
			}
			index += 2 + s_len;
		}
		else if (b == 255)
		{
			//byte
			output.push(s.substr(index + 1, 1))
			index += 2;
		}
		else
		{
			//null
			throw "malformed input"
		}
	}
	return output.join("")
}
