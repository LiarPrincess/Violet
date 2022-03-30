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

For every module we will create an implementation `class` to store all of the module properties/functions and then create a `PyModule` instance that refers to them:

```Swift
public final class Sys: PyModuleImplementation {

  internal static let moduleName = "sys"
  internal static let doc = "Things…"

  /// This dict will be used inside our `PyModule` instance.
  internal let __dict__: PyDict
  internal let py: Py

  /// Create `Python` module based on this object.
  internal func createModule() -> PyModule {
    return self.py.newModule(name: Self.moduleName,
                             doc: Self.doc,
                             dict: self.__dict__)
  }

  internal func fill__dict__() {
    let ps1 = self.py.newString(">>> ")
    let ps2 = self.py.newString("... ")
    self.setOrTrap(.ps1, value: ps1)
    self.setOrTrap(.ps2, value: ps2)

    self.setOrTrap(.getrecursionlimit, doc: Self.getRecursionLimitDoc, fn: Self.getrecursionlimit(_:))
    self.setOrTrap(.setrecursionlimit, doc: Self.setRecursionLimitDoc, fn: Self.setrecursionlimit(_:limit:))

    // And so on…
  }
}
```

Then we store both `PyModule` and its implementation on `py`:
```Swift
public struct Py: CustomStringConvertible {
  // sourcery: storedProperty
  /// Python `sys` module.
  public var sys: Sys { self.sysPtr.pointee }
  // sourcery: storedProperty
  /// `self.sys` but as a Python module (`PyModule`).
  public var sysModule: PyModule { self.sysModulePtr.pointee }
}
```

To implement an method we implement it as an `static` function that will interact with module implementation stored on `py`:

```Swift
extension Sys {

  internal static func getrecursionlimit(_ py: Py) -> PyResult {
    let result = py.sys.recursionLimit // <- HERE
    return PyResult(result)
  }

  internal static func setrecursionlimit(_ py: Py, limit: PyObject) -> PyResult {
    if let error = py.sys.setRecursionLimit(limit) {  // <- HERE
      return .error(error)
    }

    return .none(py)
  }

    public func setRecursionLimit(_ limit: PyObject) -> PyBaseException? {
      // Things…
  }
}
```

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
  public func getPS1() -> PyResult {
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
