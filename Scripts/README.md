# What is this?

Various scripts responsible for: code generation, dumping CPython state (AST, code objects), finding unimplemented Python methods etc. Each script has its own documentation that tells you how to run it.

# Scripts

Most important:

- **dump_python_code** - will dump AST and bytecode for `input.py` file (feel free to modify the `input.py`).
- **unimplemented_builtins** - lists all of the unimplemented methods from builtins module.

Other:

- **bigint_generate_cow_tests** - will generate copy-on-write (COW) tests for our `BigInt` implementation.
- **bigint_generate_minRequiredWidth_tests** - will use Python `int.bit_length` method to generate test cases for our `BigInt.minRequiredWidth`.
- **bigint_generate_node_tests** - will use [Node.js](https://nodejs.org/en/) to generate tests for our `BigInt`.

- **ariel_output** - output files from running `Ariel` on the whole `Violet` database.
- **compiler_dump_test** - helper for creating unit tests for compiler.
- **float_from_hex** - helper for our implementation of `float.fromhex`.
- **module_generate_empty_definition** - generates Swift code for module functions using module html documentation from Python website.
- **builtins_generate_binary_operations_code** - generate code for Python binary operators.
- **siphash** - things related to [SipHash](https://131002.net/siphash/) ([wiki](https://en.wikipedia.org/wiki/SipHash)) - family of pseudorandom functions (a.k.a. keyed hash functions) optimized for speed on short messages.
- **sort_swift_imports** - sorts imports in `.swift` files in this repository.
- **unicode** - extract additional data (not present in Swift) from Unicode database and make it available inside Violet
