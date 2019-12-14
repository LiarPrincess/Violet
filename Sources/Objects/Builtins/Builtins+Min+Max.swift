// MARK: - Shared

private enum MinMaxResult {
  case useCurrent
  case useNew
  case error(PyErrorEnum)
}

/// Shared code for `min/max` implementation.
private protocol MinMaxImpl {
  static var fnName: String { get }
  static var argumentParser: ArgumentParser { get }
  static func compare(current: PyObject, with element: PyObject) -> MinMaxResult
}

extension MinMaxImpl {

  fileprivate static func createParser() -> ArgumentParser {
     return ArgumentParser.createOrFatal(
      arguments: ["key", "default"],
      format: "|$OO:\(Self.fnName)"
    )
  }

  fileprivate static func run(args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyObject> {
    switch Self.argumentParser.parse(args: [], kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 2, "Invalid argument count returned from parser.")
      let key = bind.count >= 1 ? bind[0] : nil
      let dflt = bind.count >= 2 ? bind[1] : nil

      switch args.count {
      case 0:
        return Self.emptyCollectionError()
      case 1:
        return Self.iterable(iterable: args[0], key: key, default: dflt)
      default:
        return Self.positional(args: args, key: key, default: dflt)
      }
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Positional

  private static func positional(args: [PyObject],
                                 key: PyObject?,
                                 default: PyObject?) -> PyResult<PyObject> {
    assert(args.count >= 1)

    guard `default` == nil else {
      return .typeError("Cannot specify a default for \(Self.fnName) "
                      + "with multiple positional arguments")
    }

    var result: PyObject?
    for arg in args {
      switch Self.compare(current: result, object: arg, key: key) {
      case let .value(r): result = r
      case let .error(e): return .error(e)
      }
    }

    if let r = result {
      return .value(r)
    }

    return Self.emptyCollectionError()
  }

  // MARK: - Iterable

  private static func iterable(iterable: PyObject,
                               key: PyObject?,
                               default: PyObject?) -> PyResult<PyObject> {
    let builtins = iterable.builtins

    let iter: PyObject
    switch builtins.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    var result: PyObject?
    while true {
      switch builtins.next(iterator: iter) {
      case .value(let arg):
        switch Self.compare(current: result, object: arg, key: key) {
        case let .value(r): result = r
        case let .error(e): return .error(e)
        }

      case .error(.stopIteration):
        if let r = result {
          return .value(r)
        }

        if let d = `default` {
          return .value(d)
        }

        return Self.emptyCollectionError()

      case .error(let e):
        return .error(e)
      }
    }
  }

  // MARK: - Helpers

  private static func emptyCollectionError() -> PyResult<PyObject> {
    return .valueError("\(Self.fnName) arg is an empty sequence")
  }

  private static func compare(current: PyObject?,
                              object: PyObject,
                              key: PyObject?) -> PyResult<PyObject> {
    let property: PyObject
    switch Self.selectKey(key: key, from: object) {
    case let .value(e): property = e
    case let .error(e): return .error(e)
    }

    if let current = current {
      switch Self.compare(current: current, with: property) {
      case .useCurrent: return .value(current)
      case .useNew: return .value(property)
      case .error(let e): return .error(e)
      }
    } else {
      return .value(property)
    }
  }

  private static func selectKey(key: PyObject?,
                                from object: PyObject) -> PyResult<PyObject> {
    guard let key = key else {
      return .value(object)
    }

    let builtins = key.builtins
    switch builtins.call2(key, arg: object) {
    case .value(let e):
      return .value(e)
    case .notImplemented:
      return .value(builtins.notImplemented)
    case .error(let e),
         .methodIsNotCallable(let e):
      return .error(e)
    }
  }
}

// MARK: - Builtins

extension Builtins {

  // MARK: - Min

  internal static let minDoc = """
    min(iterable, *[, default=obj, key=func]) -> value
    min(arg1, arg2, *args, *[, key=func]) -> value

    With a single iterable argument, return its smallest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the smallest argument.
    """

  private enum MinImpl: MinMaxImpl {

    fileprivate static var fnName = "min"
    fileprivate static var argumentParser = Self.createParser()

    fileprivate static func compare(current: PyObject,
                                    with element: PyObject) -> MinMaxResult {
      let builtins = current.builtins
      switch builtins.isLessBool(left: current, right: element) {
      case .value(true): return .useCurrent
      case .value(false): return .useNew
      case .error(let e): return .error(e)
      }
    }
  }

  // sourcery: pymethod: min, doc = minDoc
  /// min(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#min)
  public func min(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    return ArgumentParser.unpackKwargsDict(kwargs: kwargs)
      .flatMap { MinImpl.run(args: args, kwargs: $0) }
  }

  // MARK: - Max

  internal static let maxDoc = """
    max(iterable, *[, default=obj, key=func]) -> value
    max(arg1, arg2, *args, *[, key=func]) -> value

    With a single iterable argument, return its biggest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the largest argument.
    """

  private enum MaxImpl: MinMaxImpl {

    fileprivate static var fnName = "max"
    fileprivate static var argumentParser = Self.createParser()

    fileprivate static func compare(current: PyObject,
                                    with element: PyObject) -> MinMaxResult {
      let builtins = current.builtins
      switch builtins.isGreaterBool(left: current, right: element) {
      case .value(true): return .useCurrent
      case .value(false): return .useNew
      case .error(let e): return .error(e)
      }
    }
  }

  // sourcery: pymethod: max, doc = maxDoc
  /// max(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#max)
  public func max(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    return ArgumentParser.unpackKwargsDict(kwargs: kwargs)
      .flatMap { MaxImpl.run(args: args, kwargs: $0) }
  }
}
