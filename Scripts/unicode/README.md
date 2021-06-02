# What is this?

Scripts in this directory will extract additional data (not present in Swift) from Unicode database:

- **BidirectionalClass.py** - find scalars with bidirectional class `WS`, `B`, or `S` (see [annex #9 - “UNICODE BIDIRECTIONAL ALGORITHM”](https://www.unicode.org/reports/tr9/tr9-41.html) to Unicode standard for details). This script requires the latest version of “UnicodeData.txt” to be present inside this dir, you can download it at [unicode.org](https://www.unicode.org/Public/UCD/latest/ucd/).

- **CaseFolding.py** - find the case-fold mapping for each scalar (see section “3.13 Default Case Algorithms” in [Unicode standard](http://www.unicode.org/versions/Unicode12.1.0)). This script requires the latest version of “CaseFolding.txt” to be present inside this dir, you can download it at [unicode.org](https://www.unicode.org/Public/UCD/latest/ucd/).

# How to run?

Just run the selected script.
