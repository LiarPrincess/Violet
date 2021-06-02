# What is this?

Helper for creating unit tests for the compiler.

# Examples

Input:
```py
a = 2
1 + a
```

Output:
```
/// a = 2
/// 1 + a
///
///  0 LOAD_CONST               0 (2)
///  2 STORE_NAME               0 (a)
///  4 LOAD_CONST               1 (1)
///  6 LOAD_NAME                0 (a)
///  8 BINARY_ADD
/// 10 POP_TOP
/// 12 LOAD_CONST               2 (None)
/// 14 RETURN_VALUE
-----------------
.init(.loadConst, "2"),
.init(.storeName, "a"),
.init(.loadConst, "1"),
.init(.loadName, "a"),
.init(.binaryAdd),
.init(.popTop),
.init(.loadConst, "none"),
.init(.return),
```

Part above '-----------------' is test documentation.
Part below contains expected values.


# How to run?

1. Modify `input.py`
2. Run following command from the repository root:

    > python3 ./Scripts/compiler_dump_test
