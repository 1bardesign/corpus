var corpus_dicts = {}

//for simple english (derived then doctored with alnum at start)
corpus_dicts.english = [
	// alnum
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"1","2","3","4","5","6","7","8","9","0",
	// whitespace and indentation
	" ", "\t", "\n",
	"  ", "\t\t", "\n\n",
	"    ", "\t\t\t\t",
	//punctuation
	",", ".", ":", "!", "?", "(", ")", ";", "\"", "'", "-", "/",
	", ", ". ", ": ", "! ", "? ", " (", ") ", "; ", " \"", "\" ", "'s", " - ",
	//derived
	"er","ea","ti","th","or","es",
	"ou","ec","re","ng","la","ta","di","li","pr","co",
	"ma","pa","fi","st","se","tr","ev","ow","in","de",
	"na","nc","so","tu","ni","be","ba","mi","si","os",
	"ca","mo","wh","ov","fo","po","ns","he","su","ex",
	"to","ho","wi","no","sh","pe","fa","sp","ha","we",
	"wa","lo","of","bo","ra","bu","gr","dr","sc","im",
	"do","cl","fe","ru","pu","un","ro","go","ri","hu",
	"vi","bi","sa","fr","it","qu","ki","da","mu","bl",
	"fu","ga","ci","gu","br","ent","tio","t a","ide","pro",
	"ain","ect","est","art","ght","sta","act","eat","tur","the",
	"era","hin","ort","ead","tic","eas","eci","enc","ist","ere",
	"con","are","fin","par","per","for","com","our","out","oth",
	"eri","ffe","oun","hro","ont","oug","cha","ose","eco","pla",
	"pre","hea","sho","orm","esp","ers","abl","nat","ons","ign",
	"duc","car","spe","man","som","thr","lea","cul","cou","off",
	"ysi","any","app","ant","ore","sto","not","str","col","pol",
	"sou","cla","gro","tin","own","get","lwa","exp","ndi","ize",
	"emo","ust","ert","ese","mpa","arl","ssi","ire","ffi","ish",
	"use","oli","ari","anc","imp","ord","mov","stu","win","fir",
	"new","hop","suc","can","pos","acc","tea","cen","but","her",
	"tha","sup","fac","che","nde","nit","arr","erv","tiv","pit",
	"nin","ise","aga","cur","ope","omm","ubl","isc","ili","ost",
	"tim","cho","mbe","ali","aut","oul","ssu","leg","arg","isi",
	"met","cer","sci","pic","may","atio","ther","ever","thin",
	"side","part","ctio","enti","peci","even","rece","arti",
	"ally","some","iona","over","ffer","feel","arly","real",
	"poli","thro","duce","emen","nera","ffic","thou","anag",
	"ilit","rodu","resp","rese","unit","cult","ould","disc",
	"ssio","atte","eren","hysi","inst","inte","alwa","spon",
	"ount","ican","diff","ctor","nmen","ienc","expe","itio",
	"vari","econ","offi","cent","mana","comp","cont","pres",
	"prod","comm","fina","stat","auth","unde","cert","incl",
	"west","stor","thre","acco","grow","succ","agre","chan",
	"popu","nigh","like","atur","agen","rofe","gene","clud",
	"alon","star","clea","acti","perf","move","with","buil",
	"stud","seve","news","othe","reco","wind","pers","play",
	"prob","agai","grou","happ","char","lead","care","coll",
	"prov","than","plan","soci","medi","imag","trad","teac",
	"know","main","late","bill","prof","mode","deve","sing",
	"pain","what","admi","list","miss","trea","thing","speci",
	"ectio","artic","every","respo","natio","ratio","inter",
	"thoug","stand","feren","offic","produ","enera","anage",
	"tiona","roduc","ready","shoul","ditio","posit","rofes",
	"etter","onmen","south","physi","erest","evelo","simpl",
	"spons","iscus","cause","nviro","llion","ironm","ccess",
	"ident","major","enter","iffer","natur","icula","latio",
	"entio","emocr","scien","erson","uthor","econo","nclud",
	"rform","ertai","eason","bilit","popul","devel","build",
	"final","certa","colle","relat","autho","agree","profe",
	"discu","teach","perso","perfo","again","clear","state",
	"polic","somet","under","succe","treat","tural","esent",
	"sourc","ffice","oliti","ocrat","nside","ffect","strat",
	"ultur","opula","membe","ublic","levels",
	"partic","respon","though","manage","fferen","lectio","politi",
	"genera","uccess","ertain","econom","positi","bility","pecial",
	"roduct","vironm","rticul","ronmen","mocrat","dition","evelop",
	"public","presen","icular","terest","differ","includ","cultur",
	"ationa","erform","iscuss","eratio","rofess"
]

//for hexadecimal
corpus_dicts.hex = [
	//singles
	"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f",
	"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F",
	//occasional punct/separators
	" ","-",":",".",
	//pairs
	"00","01","02","03","04","05","06","07","08","09","0a","0b","0c","0d","0e","0f",
	"00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F",
	"10","11","12","13","14","15","16","17","18","19","1a","1b","1c","1d","1e","1f",
	"10","11","12","13","14","15","16","17","18","19","1A","1B","1C","1D","1E","1F",
	"20","21","22","23","24","25","26","27","28","29","2a","2b","2c","2d","2e","2f",
	"20","21","22","23","24","25","26","27","28","29","2A","2B","2C","2D","2E","2F",
	"30","31","32","33","34","35","36","37","38","39","3a","3b","3c","3d","3e","3f",
	"30","31","32","33","34","35","36","37","38","39","3A","3B","3C","3D","3E","3F",
	"40","41","42","43","44","45","46","47","48","49","4a","4b","4c","4d","4e","4f",
	"40","41","42","43","44","45","46","47","48","49","4A","4B","4C","4D","4E","4F",
	"50","51","52","53","54","55","56","57","58","59","5a","5b","5c","5d","5e","5f",
	"50","51","52","53","54","55","56","57","58","59","5A","5B","5C","5D","5E","5F",
	"60","61","62","63","64","65","66","67","68","69","6a","6b","6c","6d","6e","6f",
	"60","61","62","63","64","65","66","67","68","69","6A","6B","6C","6D","6E","6F",
	"70","71","72","73","74","75","76","77","78","79","7a","7b","7c","7d","7e","7f",
	"70","71","72","73","74","75","76","77","78","79","7A","7B","7C","7D","7E","7F",
	"80","81","82","83","84","85","86","87","88","89","8a","8b","8c","8d","8e","8f",
	"80","81","82","83","84","85","86","87","88","89","8A","8B","8C","8D","8E","8F",
	"90","91","92","93","94","95","96","97","98","99","9a","9b","9c","9d","9e","9f",
	"90","91","92","93","94","95","96","97","98","99","9A","9B","9C","9D","9E","9F",
	"a0","a1","a2","a3","a4","a5","a6","a7","a8","a9","aa","ab","ac","ad","ae","af",
	"A0","A1","A2","A3","A4","A5","A6","A7","A8","A9","AA","AB","AC","AD","AE","AF",
	"b0","b1","b2","b3","b4","b5","b6","b7","b8","b9","ba","bb","bc","bd","be","bf",
	"B0","B1","B2","B3","B4","B5","B6","B7","B8","B9","BA","BB","BC","BD","BE","BF",
	"c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","ca","cb","cc","cd","ce","cf",
	"C0","C1","C2","C3","C4","C5","C6","C7","C8","C9","CA","CB","CC","CD","CE","CF",
	"d0","d1","d2","d3","d4","d5","d6","d7","d8","d9","da","db","dc","dd","de","df",
	"D0","D1","D2","D3","D4","D5","D6","D7","D8","D9","DA","DB","DC","DD","DE","DF",
	"e0","e1","e2","e3","e4","e5","e6","e7","e8","e9","ea","eb","ec","ed","ee","ef",
	"E0","E1","E2","E3","E4","E5","E6","E7","E8","E9","EA","EB","EC","ED","EE","EF",
	"f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","fa","fb","fc","fd","fe","ff",
	"F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF",
]

//for json (hand-crafted, good as a base for apis)
corpus_dicts.json = [
	// whitespace and indentation
	" ", "\t", "\n",
	"  ", "\t\t", "\n\n",
	"    ", "\t\t\t\t",
	// alnum (json likely contain strings of any type, rather not bloat them for common ascii case)
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"1","2","3","4","5","6","7","8","9","0",
	// json symbols
	",", "[", "]", "{", "}", "\"", "'", "\\", "/",
	":", ": ", "\":", "\": ", "\": \"", "\":\"",
	"\":{", "\":[", "\": {", "\": [",
	// json basics
	"true","false","null", "[]", "{}",
	"\"\"",
	// escapes
	"\\n", "\\t", "\\r", "\\u", "\\u0", "\\u00", "\\u000",
	// common patterns and extensions
	"-", "*", "::", ";", ".", "!", "&", "?", "@", "=",
	"0x", "00", "ff", "FF", "-1",
	", ", "],[", "], [", "},{", "}, {",
	" []", "[[", "]]", "[{", "}]",
	"\",\"", "\", \"", "\",",
	// common api strings
	"name", "id", "type", "author",
	"data", "message", "msg", "created", "updated", "modified",
	"title", "subject", "channel", "page", "source", "detail",
	"header", "head", "body", "meta", "link", "status", "error",
	"current", "self", "prev", "next", "previous", "attribute",
	"first", "last", "total", "size", "parameter", "param", "request",
	// urls
	"http://", "https://", ".com", ".org", ".net"
];

//for javascript source (from pixi and jquery, then hand-crafted)
corpus_dicts.js = [
	// common letters and short subs (as derived)
	"e","t","r","a","i","n","s","o","l","u",
	"c",".","h","d","p","f","m","re",";","(",
	")","th","b","g","v",",","y","te","on","x",
	"_","w","{","}", "j", "k",
	"E","T","R","A","I","N","S","O","L","U",
	"C",".","H","D","P","F","M",
	"B","G","V", "@",
	"1","2","3","4","5","6","7","8","9","0",
	// whitespace and indentation
	" ", "  ", "    ",
	"\t","\t\t","\t\t\t\t",
	"\n","\r\n",
	// operators
	"+", "-", "/", "*", "=", "+=", "-=", "/=", "*=",
	"<<", ">>", ">>>", "&", "^", "|", "&&","||", "!",
	"<",">", "==", "!=", "===", "!==",
	"%", "is", "in", "++", "--", "?", ":",
	// strings objects and arrays (basic)
	"\"", "\"\"", "'", "'", "[", "]", "[]", "{}", ", ",
	// comments
	"//", "/*", "*/",
	// operators with spaces
	" + ", " - ", " / ", " * ", " = ", " += ", " -= ", " /= ", " *= ",
	" << ", " >> ", " >>> ", " & ", " ^ ", " | ", " && "," || ", " !",
	" < "," > ", " == ", " != ", " === ", " !== ", " ? ", " : ",
	" % ", " is ", " in ",
	// control flow
	"if", "if ", "else", "else if", "else {", "for", "for ", "while", "while ",
	"if(", "if (", " else ", "for(", "for (", "while(", "while (",
	"do", "do ",
	"){", ") {", "()", "();", ") ", " (",
	"break", "continue",
	// language
	"var", "let", "new", "new", "delete",
	"var ", "let ", "new ", "new ", "delete ",
	"this", "return", "function",
	"this.", "return;", "function ",
	"true", "false", "null", "void", "undefined", "\"undefined\"",
	"case", "default", "throw", "try", "catch",
	"typeof", "instanceof", "arguments",
	// math
	"Math", ".floor", ".ceil", ".abs", ".max", ".min",
	// strings objects and arrays (advanced)
	"Array", ".push", ".pop", ".shift", ".unshift", ".length", ".join", "length",
	"String", "toString", ".charAt", ".charCodeAt", ".charAt", ".substr", ".substring",
	"Object", "hasOwnProperty", "assign", "copy", "clone", "OwnProperty",
	"get", "set", ".get", ".set",
	// regex
	"/g", "/gi", "/i",
	// canvas
	"canvas", "context",
	"Canvas", "Context",
	// misc specials
	"document", "window", "event", "Event", "global",
	"http://", "https://", ".com", ".org",
	"Buffer", "error", "Error", ".0f", "|0", "0x",
	"i++", "; i++", "i--", "param",
	"Infinity", "NaN", "isNaN",
	"exports", ".next", ".prev",
	"count", "Count", "byte", "val",
	"[i]", "[j]", "[0]", "index", "$.",
	"for (var ", "for (var i = 0; i < ", ".length; i++"
]

//smaz codebook
/* Copyright (c) 2006-2009, Salvatore Sanfilippo
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
POSSIBILITY OF SUCH DAMAGE.*/

corpus_dicts.smaz = [
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
];
