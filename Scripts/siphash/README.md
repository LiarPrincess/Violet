# What is this?

[SipHash](https://131002.net/siphash/) ([wiki](https://en.wikipedia.org/wiki/SipHash)) is a family of pseudorandom functions (a.k.a. keyed hash functions) optimized for speed on short messages. Python uses it to hash `str` and `bytes`.

This script will use reference implementation (`siphash.c` file from [this repository](https://github.com/veorq/SipHash)) to generate tests for our implementation. [I See the Light](https://genius.com/Walt-disney-records-i-see-the-light-lyrics) from [Tangled](https://www.imdb.com/title/tt0398286/) will serve as a test data.

# How to run?

Run following command from the repository root:

> ./Scripts/siphash/main.sh
