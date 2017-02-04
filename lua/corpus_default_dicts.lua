local default_dicts = {}

--[[
	corpus_default_dicts.lua

	a small compilation of optional default dictionaries for
	use with certain types of strings.
]]--

--javascript source (from pixi and jquery, then hand-crafted)
default_dicts.js = {
	-- common letters and short subs (as derived)
	"e","t","r","a","i","n","s","o","l","u",
	"c",".","h","d","p","f","m","re",";","(",
	")","th","b","g","v",",","y","te","on","x",
	"_","w","{","}", "j", "k",
	"E","T","R","A","I","N","S","O","L","U",
	"C",".","H","D","P","F","M",
	"B","G","V", "@",
	"1","2","3","4","5","6","7","8","9","0",
	-- whitespace and indentation
	" ", "  ", "    ",
	"\t","\t\t","\t\t\t\t",
	"\n","\r\n",
	-- operators
	"+", "-", "/", "*", "=", "+=", "-=", "/=", "*=",
	"<<", ">>", ">>>", "&", "^", "|", "&&","||", "!",
	"<",">", "==", "!=", "===", "!==",
	"%", "is", "in", "++", "--", "?", ":",
	-- strings objects and arrays (basic)
	"\"", "\"\"", "'", "'", "[", "]", "[]", "{}", ", ",
	-- comments
	"//", "/*", "*/",
	-- operators with spaces
	" + ", " - ", " / ", " * ", " = ", " += ", " -= ", " /= ", " *= ",
	" << ", " >> ", " >>> ", " & ", " ^ ", " | ", " && "," || ", " !",
	" < "," > ", " == ", " != ", " === ", " !== ", " ? ", " : ",
	" % ", " is ", " in ",
	-- control flow
	"if", "if ", "else", "else if", "else {", "for", "for ", "while", "while ",
	"if(", "if (", " else ", "for(", "for (", "while(", "while (",
	"do", "do ",
	"){", ") {", "()", "();", ") ", " (",
	"break", "continue",
	-- language
	"var", "let", "new", "new", "delete",
	"var ", "let ", "new ", "new ", "delete ",
	"this", "return", "function",
	"this.", "return;", "function ",
	"true", "false", "null", "void", "undefined", "\"undefined\"",
	"case", "default", "throw", "try", "catch",
	"typeof", "instanceof", "arguments",
	-- math
	"Math", ".floor", ".ceil", ".abs", ".max", ".min",
	-- strings objects and arrays (advanced)
	"Array", ".push", ".pop", ".shift", ".unshift", ".length", ".join", "length",
	"String", "toString", ".charAt", ".charCodeAt", ".charAt", ".substr", ".substring",
	"Object", "hasOwnProperty", "assign", "copy", "clone", "OwnProperty",
	"get", "set", ".get", ".set",
	-- regex
	"/g", "/gi", "/i",
	-- canvas
	"canvas", "context",
	"Canvas", "Context",
	-- misc specials
	"document", "window", "event", "Event", "global",
	"http://", "https://", ".com", ".org",
	"Buffer", "error", "Error", ".0f", "|0", "0x",
	"i++", "; i++", "i--", "param",
	"Infinity", "NaN", "isNaN",
	"exports", ".next", ".prev",
	"count", "Count", "byte", "val",
	"[i]", "[j]", "[0]", "index", "$.",
	"for (var ", "for (var i = 0; i < ", ".length; i++"
}

--[[
smaz codebook

Copyright (c) 2006-2009, Salvatore Sanfilippo
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    	this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    	this list of conditions and the following disclaimer in the documentation
    	and/or other materials provided with the distribution.
    * Neither the name of Smaz nor the names of its contributors may be used to
    	endorse or promote products derived from this software without specific
    	prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
]]--

default_dicts.smaz = {
	" ", "the", "e", "t", "a", "of", "o", "and", "i", "n", "s", "e ", "r", " th",
	" t", "in", "he", "th", "h", "he ", "to", "\r\n", "l", "s ", "d", " a", "an",
	"er", "c", " o", "d ", "on", " of", "re", "of ", "t ", ", ", "is", "u", "at",
	"   ", "n ", "or", "which", "f", "m", "as", "it", "that", "\n", "was", "en",
	"  ", " w", "es", " an", " i", "\r", "f ", "g", "p", "nd", " s", "nd ", "ed ",
	"w", "ed", "http://", "for", "te", "ing", "y ", "The", " c", "ti", "r ", "his",
	"st", " in", "ar", "nt", ",", " to", "y", "ng", " h", "with", "le", "al", "to ",
	"b", "ou", "be", "were", " b", "se", "o ", "ent", "ha", "ng ", "their", "\"",
	"hi", "from", " f", "in ", "de", "ion", "me", "v", ".", "ve", "all", "re ",
	"ri", "ro", "is ", "co", "f t", "are", "ea", ". ", "her", " m", "er ", " p",
	"es ", "by", "they", "di", "ra", "ic", "not", "s, ", "d t", "at ", "ce", "la",
	"h ", "ne", "as ", "tio", "on ", "n t", "io", "we", " a ", "om", ", a", "s o",
	"ur", "li", "ll", "ch", "had", "this", "e t", "g ", "e\r\n", " wh", "ere",
	" co", "e o", "a ", "us", " d", "ss", "\n\r\n", "\r\n\r", "=\"", " be", " e",
	"s a", "ma", "one", "t t", "or ", "but", "el", "so", "l ", "e s", "s,", "no",
	"ter", " wa", "iv", "ho", "e a", " r", "hat", "s t", "ns", "ch ", "wh", "tr",
	"ut", "/", "have", "ly ", "ta", " ha", " on", "tha", "-", " l", "ati", "en ",
	"pe", " re", "there", "ass", "si", " fo", "wa", "ec", "our", "who", "its", "z",
	"fo", "rs", ">", "ot", "un", "<", "im", "th ", "nc", "ate", "><", "ver", "ad",
	" we", "ly", "ee", " n", "id", " cl", "ac", "il", "</", "rt", " wi", "div",
	"e, ", " it", "whi", " ma", "ge", "x", "e c", "men", ".com"
}


return default_dicts
