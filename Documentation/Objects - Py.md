<!-- cSpell:ignore creatingreusing descriptorhandle pyreduce -->

# Py

`Py` represents a Python context.
Conceptually it is the owner of all of the Python objects.

- [Py](#py)
  - [Initialization](#initialization)
  - [Usage](#usage)
  - [Cleanup](#cleanup)
  - [Tips, quirks and idioms](#tips-quirks-and-idioms)
    - [Creating/reusing Python objects](#creatingreusing-python-objects)
    - [Custom file descriptor/handle type](#custom-file-descriptorhandle-type)
    - [Traversing with `py.reduce`](#traversing-with-pyreduce)
    - [IdString](#idstring)

## Initialization

Before we can start using `Py` we have to initialize it with certain global parameters. This may seem complicated, but you can check the real-life example inside the `VM` module.

```Swift
let arguments = try Arguments(from: CommandLine.arguments)
let environment = Environment(from: ProcessInfo.processInfo.environment)

// `PyFileDescriptorType` protocol abstracts objects that allow reads/writes
let standardInput: PyFileDescriptorType = …
let standardOutput: PyFileDescriptorType = …
let standardError: PyFileDescriptorType = …

let config = PyConfig(
  arguments: arguments,
  environment: environment,
  executablePath: arguments.raw.first ?? "?",
  standardInput: standardInput,
  standardOutput: standardOutput,
  standardError: standardError
)

// `PyDelegateType` is responsible for accessing/manipulating `VM` state, for example:
// - currently executed frame (if any) - used to fill `__traceback__` on exceptions
// - currently handled exception (if any) - used to fill `__context__` on exceptions
// - evaluating code objects - for example when we call `myObject + 1` where `myObject` is an instance of a class with custom `__add__` magic method
let delegate: PyDelegateType = …

// 'PyFileSystemType' is responsible for: opening files, stat, readdir etc.
let fileSystem: PyFileSystemType = …

let py = Py(config: config, delegate: delegate, fileSystem: fileSystem)
```

## Usage

Once we initialized `Py` we can use it to create and interact with Python objects, for example:

```Swift
let two = py.newInt(2)
let result = py.add(two, two) // 4 (hopefully)
py.print(arg: result)
```

## Cleanup

We can cleanup Python context by calling `py.destroy`. Context will also be destroyed automatically when the process ends.

Please note that cleaning the Python context *does not guarantee* any additional actions (like flushing the IO).

Using `Py` or any associated Python objects after calling `py.destroy` may or may not work (no guarantee).

## Tips, quirks and idioms

### Creating/reusing Python objects

When creating a Python object look for one of the following:

1. **Property on `py`** — sometimes you don’t need to create a new object at all, you can just re-use the existing instance. This is most common for immutable types and some special values:

    ```Swift
    // Booleans
    let s = py.true
    let n = py.false
    let o = py.none
    let w = py.notImplemented
    let w = py.ellipsis
    // Empty immutable collections
    let h = py.emptyTuple
    let i = py.emptyString
    let t = py.emptyBytes
    let e = py.emptyFrozenSet
    ```

    This is also where you can find objects representing Python modules:

    ```Swift
    let b = py.builtinsModule
    let e = py.sysModule
    let l = py._impModule
    let l = py._warningsModule
    let e = py._osModule
    ```

2. **Property on `py.types` or `py.errorTypes`** — if you are looking for `type` object:

    ```Swift
    // Standard types are stored inside 'py.types':
    let a = py.types.object
    let r = py.types.int
    let i = py.types.code
    // Error types are in 'py.errorTypes':
    let e = py.errorTypes.baseException
    let l = py.errorTypes.typeError
    ```

4. **`py.new` method** — most common way of creating objects. It will try to re-use existing instances if possible.

    ```Swift
    let e = py.newInt(2) // 2 as int
    let l = py.newTuple(elements: e.asObject, e.asObject) // (2, 2) as tuple
    let s = py.newString("Let it go!") // 'Let it go!' as str
    let a = py.newTypeError(message: "Let it go!") // type error (it will create object, but not 'raise' it!)
    ```

4. **`py.memory.new` method** — this will always allocate a new object. Use it as a last resort if nothing else is available.

### Custom file descriptor/handle type

Interesting thing about the Python language (without additional modules) is that even though it allows for file manipulation (for example via `open` builtin function) it has no type to represent an actual file:

```py
>>> import sys
>>> sys.stdin
<_io.TextIOWrapper name='<stdin>' mode='r' encoding='utf-8'>

>>> f = open('./elsa.txt', 'w')
>>> type(f)
<class '_io.TextIOWrapper'>
```

In both cases `_io.TextIOWrapper` is used. While we could implement the `_io` module, it would be way too much work for our simple needs (it is not just the `TextIOWrapper` type that is needed, in fact, we would have to implement the whole class hierarchy).

Instead, we just created a simple `TextFile` type and placed it inside `builtins` module.

### Traversing with `py.reduce`

Traversing iterable Python object should be done with one of the `py.reduce` functions.

This is important because if we wanted to implement this on every occasion we would have to duplicate code that deals with following situations:
- object may not be iterable (missing `__iter__` or `__getitem__`)
- calling `__next__` on `__iter__` may raise error
- this error may be `StopIteration` (which is “ok”)

For example, this is how you can implement `builtins.any` function with `Py.reduce`:

```Swift
/// any(iterable)
/// See [this](https://docs.python.org/3/library/functions.html#any)
public func any(iterable: PyObject) -> PyResult<Bool> {
  return self.reduce(iterable: iterable, initial: false) { _, object in
    switch self.isTrueBool(object) {
    case .value(true): return .finish(true)
    case .value(false): return .goToNextElement
    case .error(let e): return .error(e)
    }
  }
}
```

`py.forEach` and `py.toArray` are also available.

### IdString

`IdStrings` are predefined commonly used `__dict__` keys, similar to `_Py_IDENTIFIER` in `CPython`.

For example:

```Swift
IdString.__abs__
IdString.__add__
IdString.__and__
IdString.__class__
IdString.__dict__
```

To convert `IdString` to `PyString` use `py.resolve(id: IdString)`.

They can be used during `__dict__` lookup or method dispatch to avoid creating new `str` instances every time.

Why?

This is crucial for overall performance. Given how often those keys are used even a dictionary (with its `O(1) + massive constants` access) may be too slow.
