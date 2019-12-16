extension Builtins {

  // MARK: - Any

  // sourcery: pymethod: any
  /// any(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#any)
  public func any(iterable: PyObject) -> PyResult<Bool> {
    let iter: PyObject
    switch self.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    while true {
      switch self.next(iterator: iter) {
      case .value(let o):
        switch self.isTrueBool(o) {
        case .value(true):  return .value(true)
        case .value(false): break // check next element
        case .error(let e): return .error(e)
        }
      case .error(.stopIteration):
        return .value(false)
      case .error(let e):
        return .error(e)
      }
    }
  }

  // MARK: - All

  // sourcery: pymethod: all
  /// all(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#all)
  public func all(iterable: PyObject) -> PyResult<Bool> {
    let iter: PyObject
    switch self.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    while true {
      switch self.next(iterator: iter) {
      case .value(let o):
        switch self.isTrueBool(o) {
        case .value(true): break // check next element
        case .value(false): return .value(false)
        case .error(let e): return .error(e)
        }
      case .error(.stopIteration):
        return .value(true)
      case .error(let e):
        return .error(e)
      }
    }
  }

  // MARK: - Sum

  // CPython does this differently.
  private static let sumArgumentsParser = ArgumentParser.createOrFatal(
    arguments: ["", "start"],
    format: "O|O:sum"
  )

  public func sum(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    switch Builtins.sumArgumentsParser.parse(args: args, kwargs: kwargs) {
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

  // sourcery: pymethod: sum
  /// sum(iterable, /, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#sum)
  public func sum(iterable: PyObject, start: PyObject?) -> PyResult<PyObject> {
    // TODO: Add bytes and byte array
    if start is PyString {
      return .typeError("sum() can't sum strings [use ''.join(seq) instead]")
    }

    let iter: PyObject
    switch self.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    var result = start ?? self.newInt(0)
    while true {
      switch self.next(iterator: iter) {
      case .value(let item):
        switch self.add(left: result, right: item) {
        case let .value(x): result = x
        case let .error(e): return .error(e)
        }
      case .error(.stopIteration):
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }
  }
}
