// MARK: - Shared

private enum MinMaxResult {
  case useCurrent
  case useNew
  case error(PyBaseException)
}

private struct ObjectPropertyPair {
  fileprivate let object: PyObject
  /// `self.object` after applying `key` function.
  fileprivate let property: PyObject
}

/// Shared code for `min/max` implementation.
private protocol MinMaxImpl {
  static var fnName: String { get }
  static var argumentParser: ArgumentParser { get }
  static func compare(current: PyObject, with element: PyObject) -> MinMaxResult
}

extension MinMaxImpl {

  fileprivate static func createParser() -> ArgumentParser {
     return ArgumentParser.createOrTrap(
      arguments: ["key", "default"],
      format: "|$OO:\(Self.fnName)"
    )
  }

  fileprivate static func run(args: [PyObject],
                              kwargs: PyDict?) -> PyResult<PyObject> {
    switch Self.argumentParser.bind(args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let key = binding.optional(at: 0)
      let default_ = binding.optional(at: 1)

      switch args.count {
      case 0:
        return Self.emptyCollectionError()
      case 1:
        return Self.iterable(iterable: args[0], key: key, default: default_)
      default:
        return Self.positional(args: args, key: key, default: default_)
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

    // Return value BEFORE applying 'key':
    // assert max(1, 2, -3, key=abs) == -3

    var result: ObjectPropertyPair?
    for arg in args {
      switch Self.compare(current: result, object: arg, key: key) {
      case let .value(r): result = r
      case let .error(e): return .error(e)
      }
    }

    if let r = result {
      return .value(r.object)
    }

    return Self.emptyCollectionError()
  }

  // MARK: - Iterable

  private static func iterable(iterable: PyObject,
                               key: PyObject?,
                               default: PyObject?) -> PyResult<PyObject> {
    let initial: ObjectPropertyPair? = nil
    let acc = Py.reduce(iterable: iterable, initial: initial) { acc, object in
      switch Self.compare(current: acc, object: object, key: key) {
      case let .value(r): return .setAcc(r)
      case let .error(e): return .error(e)
      }
    }

    switch acc {
    case let .value(result):
      if let r = result {
        return .value(r.object)
      }

      if let d = `default` {
        return .value(d)
      }

      return Self.emptyCollectionError()

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  private static func emptyCollectionError() -> PyResult<PyObject> {
    return .valueError("\(Self.fnName) arg is an empty sequence")
  }

  private static func compare(current: ObjectPropertyPair?,
                              object: PyObject,
                              key: PyObject?) -> PyResult<ObjectPropertyPair> {
    let property: PyObject
    switch Py.selectKey(object: object, key: key) {
    case let .value(e): property = e
    case let .error(e): return .error(e)
    }

    if let current = current {
      switch Self.compare(current: current.property, with: property) {
      case .useCurrent:
        return .value(current)
      case .useNew:
        let pair = ObjectPropertyPair(object: object, property: property)
        return .value(pair)
      case .error(let e):
        return .error(e)
      }
    } else {
      let pair = ObjectPropertyPair(object: object, property: object)
      return .value(pair)
    }
  }
}

// MARK: - Min

private enum MinImpl: MinMaxImpl {

  fileprivate static var fnName = "min"
  fileprivate static var argumentParser = Self.createParser()

  fileprivate static func compare(current: PyObject,
                                  with element: PyObject) -> MinMaxResult {
    switch Py.isLessBool(left: current, right: element) {
    case .value(true): return .useCurrent
    case .value(false): return .useNew
    case .error(let e): return .error(e)
    }
  }
}

extension PyInstance {

  internal static var minDoc: String {
    return """
    min(iterable, *[, default=obj, key=func]) -> value
    min(arg1, arg2, *args, *[, key=func]) -> value

    With a single iterable argument, return its smallest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the smallest argument.
    """
  }

  public func min(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    return ArgumentParser.unpackKwargsDict(kwargs: kwargs)
      .flatMap { self.min(args: args, kwargs: $0) }
  }

  // sourcery: pymethod = min, doc = minDoc
  /// min(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#min)
  internal func min(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    return MinImpl.run(args: args, kwargs: kwargs)
  }
}

  // MARK: - Max

private enum MaxImpl: MinMaxImpl {

  fileprivate static var fnName = "max"
  fileprivate static var argumentParser = Self.createParser()

  fileprivate static func compare(current: PyObject,
                                  with element: PyObject) -> MinMaxResult {
    switch Py.isGreaterBool(left: current, right: element) {
    case .value(true): return .useCurrent
    case .value(false): return .useNew
    case .error(let e): return .error(e)
    }
  }
}

extension PyInstance {

  internal static var maxDoc: String {
    return """
    max(iterable, *[, default=obj, key=func]) -> value
    max(arg1, arg2, *args, *[, key=func]) -> value

    With a single iterable argument, return its biggest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the largest argument.
    """
  }

  public func max(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    return ArgumentParser.unpackKwargsDict(kwargs: kwargs)
      .flatMap { self.max(args: args, kwargs: $0) }
  }

  // sourcery: pymethod = max, doc = maxDoc
  /// max(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#max)
  internal func max(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    return MaxImpl.run(args: args, kwargs: kwargs)
  }
}
