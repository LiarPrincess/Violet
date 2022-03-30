# Argument parser

`ArgumentParser` is a structure responsible for binding runtime parameters (`args` and `kwargs`) to function signature.

Please note that if all of the function arguments are positional (which is true in 90% of the cases) we can just write a standard Swift method with `sourcery: pymethod = name` attribute. `ArgumentParser` is only used when a function has a keyword argument(s).

It is *heavily inspired* by CPython `typedef struct _PyArg_Parser`. For example, this is how `int.__new__` argument description looks in Violet:

```Swift
private static let newArguments = ArgumentParser.createOrTrap(
  arguments: ["", "base"],
  format: "|OO:int"
)
```

And this is CPython:

```C
static const char * const _keywords[] = {"", "base", NULL};
static _PyArg_Parser _parser = {"|OO:int", _keywords, 0};
```

## Full syntax

- **arguments** — keyword argument names. Positional arguments should use empty string.
- **format** — argument format:
    - `O` — Python object
    - `|` — end of the required arguments (`minArgCount`)
    - `$` — end of the positional arguments (`maxPositionalArgCount`)
    - `:` — end of the argument format, what follows is a function name

## Example

Going back to `int.__new__`:

```Swift
private static let newArguments = ArgumentParser.createOrTrap(
  arguments: ["", "base"],
  format: "|OO:int"
)
```

This means:

- 1st argument is a positional argument without name (1st entry in `arguments`)
- 2nd argument is a keyword argument called `base` (2nd entry in `arguments`)
- both arguments are Python objects (`format` has `OO`)
- none of the arguments is required (`format` starts with `|`)
- function name is `int` (part of the `format` after `:`)

## Call site

This is how you would use parsed arguments:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public struct PyInt: PyObjectMixin {

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["", "base"],
    format: "|OO:int"
  )

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    switch Self.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let base = binding.optional(at: 1)
      // Things…
    case let .error(e):
      return .error(e)
    }
  }
}
```
