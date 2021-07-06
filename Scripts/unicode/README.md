# What is this?

This script will extract data from Unicode database and generate code inside the “UnicodeData” module.
It will also generate test cases for more interesting blocks.

It is heavily based on `Tools/unicode/makeunicodedata.py` from CPython.

Example of things not available in standard Swift:
- Bidirectional class - find scalars with bidirectional class `WS`, `B`, or `S` (see [annex #9 - “UNICODE BIDIRECTIONAL ALGORITHM”](https://www.unicode.org/reports/tr9/tr9-41.html) to Unicode standard for details).
- Case folding - find the case-fold mapping for each scalar (see section “3.13 Default Case Algorithms” in [Unicode standard](http://www.unicode.org/versions/Unicode12.1.0)).

# How to run?

Run following in root directory:
> make unicode
