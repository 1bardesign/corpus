# Introduction

Corpus is one part small string compression library, and one part codebook generation script. It is available under the MIT license.

It should not be used for general compression, but with a bit of care can make big wins on small strings.

It is currently firmly in the "toy" stage of development, but I'm seeing reasonable ratios for some data, so I'm releasing it for feedback.

# Motivation

I came across [smaz](https://github.com/antirez/smaz/), and wanted to generalise the set-codebook encoding style in a reusable way for the web, particularly for use in games using websockets.

I also wanted to make the compressor "text safe" (UTF-8 in, UTF-8 out), which makes working with the results easier and more safe. As a result, many more dictionary entries than smaz can be used.

This is _not_ a rival for [LZString](https://github.com/pieroxy/lz-string), and especially not a rival for `gzip` and friends.

# Process

__Part One:__ Derivation.

A corpus of data is fed through the derivation script. Substrings of the corpus are sorted by occurance, and then optionally filtered for similarity and then output as UTF-8 json. This process only needs to be done once for a corpus, the dictionary can then be embedded in the application and used for compression and decompression. Multiple dictionaries can also be present in a single application (for compressing XML and JSON separately, for example).

The dictionary can also be hand-derived or edited, naturally - this can be helpful when you have a known protocol that you want to compress.

__Part Two:__ Compression/Decompression

For compression, the string is scanned in sequence for the longest possible dictionary entry - if something is found, a codepoint is emitted that can be translated back into a dictionary lookup for decompression. In case nothing can be found, an escaped literal codepoint or string (as appropriate) is embedded in the compression stream - this causes expansion of either 1 byte (for a literal codepoint) or 1 byte and 1 codepoint (for a literal string).

In the case that the result was unnecessarily expanded overall, the whole input is simply wrapped as a literal string, causing one byte and one codepoint of overhead.

For decompression, the string is scanned in sequence, and either an escape code (for a byte or string) or a dictionary entry is decoded.

# Limitations

Corpus should not be used for compressing strings longer than a few kilobytes; the fallback wrapping is currently unsafe for long strings, and you should be using something "harder" in that case anyway.

js-side, codepoints outside the BMP may cause issues at the moment; this defect can be remedied if there is interest.

# Getting Started

The files under js/ and lua/ should be all you need to get started under each respective language. The packaging could use some work - I'll look at making it npm-sensible

For JS in HTML:
```
<script src="lib/corpus/corpus_compress.js"></script>
<!-- optionally pull in a dictionary -->
<script src="lib/corpus/default_dicts.js"></script>
<script>
	console.log(compress("check out this neat little compressor", english_dict))
</script>
```

For Lua:
```
local corpus_compress = require "corpus_compress"
local dicts = require "corpus_default_dicts"
print(corpus_compress.compress("check out this neat little compressor", dicts.smaz))
```