// MARK: - Abstract

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

  static func compare(_ py: Py, current: PyObject, with element: PyObject) -> MinMaxResult
}

extension MinMaxImpl {

  fileprivate static func createParser() -> ArgumentParser {
    return ArgumentParser.createOrTrap(
      arguments: ["key", "default"],
      format: "|$OO:\(Self.fnName)"
    )
  }

  fileprivate static func run(_ py: Py,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult {
    switch Self.argumentParser.bind(py, args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let key = binding.optional(at: 0)
      let default_ = binding.optional(at: 1)

      switch args.count {
      case 0:
        let message = "\(Self.fnName) expected 1 arguments, got 0"
        return .typeError(py, message: message)
      case 1:
        return Self.iterable(py, iterable: args[0], key: key, default: default_)
      default:
        return Self.positional(py, args: args, key: key, default: default_)
      }
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Positional

  private static func positional(_ py: Py,
                                 args: [PyObject],
                                 key: PyObject?,
                                 default: PyObject?) -> PyResult {
    assert(args.count >= 1)

    guard `default` == nil else {
      let message = "Cannot specify a default for \(Self.fnName) "
        + "with multiple positional arguments"
      return .typeError(py, message: message)
    }

    // Return value BEFORE applying 'key':
    // assert max(1, 2, -3, key=abs) == -3

    var result: ObjectPropertyPair?
    for arg in args {
      switch Self.compare(py, current: result, object: arg, key: key) {
      case let .value(r): result = r
      case let .error(e): return .error(e)
      }
    }

    if let r = result {
      return .value(r.object)
    }

    return Self.emptyCollectionError(py)
  }

  // MARK: - Iterable

  private static func iterable(_ py: Py,
                               iterable: PyObject,
                               key: PyObject?,
                               default: PyObject?) -> PyResult {
    let initial: ObjectPropertyPair? = nil
    let acc = py.reduce(iterable: iterable, initial: initial) { acc, object in
      switch Self.compare(py, current: acc, object: object, key: key) {
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

      return Self.emptyCollectionError(py)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  private static func emptyCollectionError(_ py: Py) -> PyResult {
    let message = "\(Self.fnName) arg is an empty sequence"
    let error = py.newValueError(message: message)
    return .error(error.asBaseException)
  }

  private static func compare(_ py: Py,
                              current: ObjectPropertyPair?,
                              object: PyObject,
                              key: PyObject?) -> PyResultGen<ObjectPropertyPair> {
    let property: PyObject
    switch py.selectKey(object: object, key: key) {
    case let .value(e): property = e
    case let .error(e): return .error(e)
    }

    if let current = current {
      switch Self.compare(py, current: current.property, with: property) {
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

  fileprivate static func compare(_ py: Py,
                                  current: PyObject,
                                  with element: PyObject) -> MinMaxResult {
    switch py.isLessBool(left: current, right: element) {
    case .value(true): return .useCurrent
    case .value(false): return .useNew
    case .error(let e): return .error(e)
    }
  }
}

extension Py {

  /// min(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#min)
  internal func min(args: [PyObject], kwargs: PyDict?) -> PyResult {
    return MinImpl.run(self, args: args, kwargs: kwargs)
  }
}

  // MARK: - Max

private enum MaxImpl: MinMaxImpl {

  fileprivate static var fnName = "max"
  fileprivate static var argumentParser = Self.createParser()

  fileprivate static func compare(_ py: Py,
                                  current: PyObject,
                                  with element: PyObject) -> MinMaxResult {
    switch py.isGreaterBool(left: current, right: element) {
    case .value(true): return .useCurrent
    case .value(false): return .useNew
    case .error(let e): return .error(e)
    }
  }
}

extension Py {

  /// max(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#max)
  internal func max(args: [PyObject], kwargs: PyDict?) -> PyResult {
    return MaxImpl.run(self, args: args, kwargs: kwargs)
  }
}
