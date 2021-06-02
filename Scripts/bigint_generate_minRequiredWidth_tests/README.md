# What is this?

This script will use Python `int.bit_length` method to generate test cases for our `BigInt.minRequiredWidth`.

Each test case will be a tuple where:
- 1st element is an integer
- 2nd element is a `minRequiredWidth` of this integer

For example:
```py
(0, 0),
(1, 1),
(-1, 1),
(2147483647, 31),
(-2147483647, 31),
("18446744073709551615", 64),
("-18446744073709551615", 64),
("89211263094", 37),
("-89211263094", 37),
```

Those test cases should be placed in `/Tests/BigIntTests/Helpers/MinRequiredWidthTestCases.swift`.

# How to run?

Run following command from the repository root:

> ./Scripts/bigint_generate_minRequiredWidth_tests/main.sh

This will generate `out.swift` file with the result.
