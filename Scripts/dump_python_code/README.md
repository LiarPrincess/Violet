# What is this?

This script will dump AST and bytecode for `input.py` file.

# Examples

Input: `1 + 2`

Output:

```
=== AST ===
Module (node)
  body (list)
    Expr (node)
      value (node)
        BinOp (node)
          left (node)
            Num (node)
              n: 1
          op: Add
          right (node)
            Num (node)
              n: 2

=== Code ===
  1           0 LOAD_CONST               0 (3)
              2 RETURN_VALUE
```

(In the above example CPython folded `1 + 2 => 3`, so the bytecode already represents that)

# How to run?

1. Modify `input.py`
2. Run following command from the repository root:

    > python3 ./Scripts/dump_python_code
