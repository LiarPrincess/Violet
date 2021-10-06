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
    - [Traversing with `Py.reduce`](#traversing-with-pyreduce)
    - [IdString](#idstring)

## Initialization

Before we can start using `Py` we have to call `Py.initialize` to set global parameters (this may seem complicated, but you can check the real-life example inside the `VM` module):

```Swift
let arguments = try Arguments(from: CommandLine.arguments)
let environment = Environment(from: ProcessInfo.processInfo.environment)

// `FileDescriptorType` protocol abstracts objects that allow reads/writes
let standardInput: FileDescriptorType = …
let standardOutput: FileDescriptorType = …
let standardError: FileDescriptorType = …

let config = PyConfig(
  arguments: arguments,
  environment: environment,
  executablePath: arguments.raw.first ?? "?",
  standardInput: standardInput,
  standardOutput: standardOutput,
  standardError: standardError
)

// `PyDelegate` is responsible for accessing/manipulating `VM` state, for example:
// - currently executed frame (if any) - used to fill `__traceback__` on exceptions
// - currently handled exception (if any) - used to fill `__context__` on exceptions
// - evaluating code objects - for example when we call `myObject + 1` where `myObject` is an instance of a class with custom `__add__` magic method
let delegate: PyDelegate = …

// 'PyFileSystem' is responsible for: opening files, stat, readdir etc.
let fileSystem: PyFileSystem = …

Py.initialize(
  config: config,
  delegate: delegate,
  fileSystem: fileSystem
)
```

Please note that at any given time only a single `Py` instance can be alive. Calling `Py.initialize` again will fail/crash (hopefully). If you need to re-initialize `Py` during runtime you have to call `Py.destroy` and only then you can call `Py.initialize` again.

This also means that we do not support *V8-style isolates* (different `Py` instances living at the same time). This was done to simplify implementation (otherwise every call would need an additional `context` argument, and now we can just use global).

## Usage

Once we initialized `Py` we can use it to create and interact with Python objects, for example:

```Swift
let two = Py.newInt(2)
let result = Py.add(two, two) // 4 (hopefully)
Py.print(arg: result)
```

## Cleanup

We can cleanup Python context by calling `Py.destroy`. Context will also be destroyed automatically when the process ends (this is the method used by `VM` module).

Please note that cleaning the Python context *does not guarantee* any additional actions (like flushing the IO).

Using `Py` or any associated Python objects after calling `Py.destroy` may or may not work (no guarantee).

## Tips, quirks and idioms

### Creating/reusing Python objects

When creating a Python object look for one of the following:

1. **Property on `Py`** — sometimes you don’t need to create a new object at all, you can just re-use the existing instance. This is most common for immutable types and some special values:

    ```Swift
    // Booleans
    let s = Py.true
    let n = Py.false
    let o = Py.none
    let w = Py.notImplemented
    let w = Py.ellipsis
    // Empty immutable collections
    let h = Py.emptyTuple
    let i = Py.emptyString
    let t = Py.emptyBytes
    let e = Py.emptyFrozenSet
    ```

    This is also where you can find objects representing Python modules:

    ```Swift
    let b = Py.builtinsModule
    let e = Py.sysModule
    let l = Py._impModule
    let l = Py._warningsModule
    let e = Py._osModule
    ```

2. **Property on `Py.types` or `Py.errorTypes`** — if you are looking for `type` object:

    ```Swift
    // Standard types are stored inside 'Py.types':
    let a = Py.types.object
    let r = Py.types.int
    let i = Py.types.code
    // Error types are in 'Py.errorTypes':
    let e = Py.errorTypes.baseException
    let l = Py.errorTypes.typeError
    ```

3. **Static `wrap` method on type** — this option is available only for `builtinFunction`, `staticmethod`, `classmethod` and `property` types. You can use it to “wrap” Swift function and expose it as a Python object:

    ```Swift
    // sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
    public class PyInt: PyObject {
      // sourcery: pymethod = __add__
      public func add(_ other: PyObject) -> PyResult<PyObject> {
        // Whatever…
      }
    }

    // 'asInt' is a method responsible for casting from PyObject to PyInt
    let rapunzel = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: asInt)
    ```

4. **`Py.new` method** — most common way of creating objects. It will try to re-use existing instances if possible.

    ```Swift
    let e = Py.newInt(2) // 2 as int
    let l = Py.newTuple(e, e) // (2, 2) as tuple
    let s = Py.newString("Let it go!") // 'Let it go!' as str
    let a = Py.newTypeError(msg: "Let it go!") // type error (it will create object, but not 'raise' it!)
    ```

5. **`PyMemory.new` method** — this will always allocate a new object. Use it as a last resort if nothing else is available.

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

### Traversing with `Py.reduce`

Traversing iterable Python object should be done with one of the `Py.reduce` functions.

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

`Py.forEach` is also available.

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

They can be used during `__dict__` lookup or method dispatch to avoid creating new `str` instances every time.

Why?

This is crucial for overall performance. Given how often those keys are used even a dictionary (with its `O(1) + massive constants` access) may be too slow.
