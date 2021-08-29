# Modules

Minimal Python implementation consists of following modules:
- **[builtins](https://docs.python.org/3/library/builtins.html#module-builtins)** — global functions, exceptions and other objects, see [docs.python.org/Built-in Functions](https://docs.python.org/3/library/functions.html#built-in-funcs) and [docs.python.org/Built-in Constants](https://docs.python.org/3/library/constants.html#built-in-consts) for more information.
- **[sys](https://docs.python.org/3/library/sys.html)** — system-specific parameters and functions. Provides access to some variables used or maintained by the interpreter and to functions that interact strongly with the interpreter.
- **[importlib](https://docs.python.org/3/library/importlib.html)** — provides the implementation of the `import` statement.
- **_imp** — (extremely) low-level import machinery used by `importlib`.
- **_os** — low level `os` module that contains functions like: `getcwd`, `fspath`, `stat`, `listdir`. It is used by `importlib`, so that it can interact with filesystem.
- **_warnings** — basic low-level warnings functionality. Similar to [warnings module](https://docs.python.org/3/library/warnings.html#module-warnings), but not as robust.

From all of those modules only the `importlib` is implemented in Python, all of the others are pure Swift. This file deals with the representation of those “pure Swift” modules.

## Requirements

- Module must be representable as Python object available to users, for example:

      ```py
      >>> import sys
      >>> sys
      <module 'sys' (built-in)>
      >>> type(sys)
      <class 'module'>
      ```
     
  
- Module must be able to store state outside of their `__dict__` property — this is really useful because we will want to hide our implementation details from end-users.

## Implementation

The obvious answer would be to create a subclass of `PyModule` class for every implemented module. Unfortunately this has a conceptual problem where a class contains methods from both `PyModule` and from specific implementation.

The better way is to create a separate class to store all of the module properties/functions and then create a `PyModule` instance that refers to them. To do this we will pre-specialize function to module implementation object (by partial application) and then store it inside `PyModule.__dict__` as a Python object:

```Swift
public final class Sys {

  /// sys.setrecursionlimit(limit)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setrecursionlimit).
  public func setRecursionLimit(limit: PyObject) -> PyResult<PyNone> {
    // Logic needed to set 'self.recursionLimit'…
  }
}
```

Now we can extract `Sys.setRecursionLimit(limit:)`:

```Swift
// original :: (self: Sys) -> (limit: PyObject) -> PyResult<PyNone>
let original = Sys.setRecursionLimit(limit:)
```

This is kinda weird, but it means: *given an instance of `Sys` (as denoted by `(self: Sys)`) I will give you a function from `(limit: PyObject)` to `PyResult<PyNone>`”*:

```Swift
let sys = Sys()
// specialized :: (limit: PyObject) -> PyResult<PyNone>
let specialized = original(sys)
```

This is exactly the type that should be stored as `setrecursionlimit` inside in Python `sys` module. Now we just need to wrap it inside `builtinFunction` object and put it inside `__dict__`.

## PyModuleImplementation

Ok, so now we have the module implementation objects that we will use to create actual `PyModules`.
Thing is: we have a lot of the modules to implement and a lot of the code would be duplicated.
To solve this we introduced `PyModuleImplementation` protocol that contains common methods for all of the implementation objects.

The most common duplication would be getting and setting objects inside module `__dict__`. To simplify this we will use `associatedtype Properties: CustomStringConvertible` where `String` representation is the `__dict__` key.

```Swift
public final class Sys: PyModuleImplementation {

  internal struct Properties: CustomStringConvertible {
    internal static let ps1 = Properties(value: "ps1")
    internal static let tracebacklimit = Properties(value: "tracebacklimit")

    private let value: String
  }

  private func fill__dict__() {
    self.setOrTrap(.ps1, to: Py.newString(">>> "))
    self.setOrTrap(.tracebacklimit, to: Py.newInt(1_000))
  }

  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// String specifying the primary prompt of the interpreter.
  public func getPS1() -> PyResult<PyObject> {
    return self.get(.ps1)
  }

  public func setPS1(to value: PyObject) -> PyBaseException? {
    return self.set(.ps1, to: value)
  }

  // It can also handle type casting from 'PyObject' to 'PyInt':

  /// sys.tracebacklimit
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.tracebacklimit).
  public func getTracebackLimit() -> PyResult<PyInt> {
    return self.getInt(.tracebacklimit)
  }
}
```
