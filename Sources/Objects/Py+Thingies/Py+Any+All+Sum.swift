// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Any

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

  // MARK: - Sum

  /// sum(iterable, /, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#sum)
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
