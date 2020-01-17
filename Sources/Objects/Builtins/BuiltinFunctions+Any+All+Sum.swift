// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension BuiltinFunctions {

  // MARK: - Any

  // sourcery: pymethod = any
  /// any(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#any)
  public func any(iterable: PyObject) -> PyResult<Bool> {
    return self.reduce(iterable: iterable, initial: false) { _, object in
      switch self.isTrueBool(object) {
      case .value(true):  return .finish(true)
      case .value(false): return .goToNextElement
      case .error(let e): return .error(e)
      }
    }
  }

  // MARK: - All

  // sourcery: pymethod = all
  /// all(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#all)
  public func all(iterable: PyObject) -> PyResult<Bool> {
    return self.reduce(iterable: iterable, initial: true) { _, object in
      switch self.isTrueBool(object) {
      case .value(true): return .goToNextElement
      case .value(false): return .finish(false)
      case .error(let e): return .error(e)
      }
    }
  }
}
  // MARK: - Sum

// CPython does this differently.
private let sumArguments = ArgumentParser.createOrTrap(
  arguments: ["", "start"],
  format: "O|O:sum"
)

extension BuiltinFunctions {

  // sourcery: pymethod = sum
  /// sum(iterable, /, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#sum)
  internal func sum(args: [PyObject], kwargs: PyDictData?) -> PyResult<PyObject> {
    switch sumArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(1 <= bind.count && bind.count <= 2,
             "Invalid argument count returned from parser.")

      let iterable = bind[0]
      let start = bind.count >= 2 ? bind[1] : nil
      return self.sum(iterable: iterable, start: start)
    case let .error(e):
      return .error(e)
    }
  }

  public func sum(iterable: PyObject, start: PyObject?) -> PyResult<PyObject> {
    if start is PyString {
      return .typeError("sum() can't sum strings [use ''.join(seq) instead]")
    }

    if start is PyBytes {
      return .typeError("sum() can't sum bytes [use b''.join(seq) instead]")
    }

    if start is PyByteArray {
      return .typeError("sum() can't sum bytearray [use b''.join(seq) instead]")
    }

    let initial = start ?? self.newInt(0)

    return self.reduce(iterable: iterable, initial: initial) { acc, object in
      switch self.add(left: acc, right: object) {
      case let .value(x): return .setAcc(x)
      case let .error(e): return .error(e)
      }
    }
  }
}
