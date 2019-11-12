import Core

// swiftlint:disable unavailable_function

public protocol PyObjectConvertible {
  func toPyObject(in context: PyContext) -> PyObject
}

extension Int: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return context.builtins.newInt(self)
  }
}

extension BigInt: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return context.builtins.newInt(self)
  }
}

extension Bool: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return self ? context.true : context.false
  }
}

extension Attributes: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    fatalError()
  }
}

extension DirResult: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    fatalError()
  }
}

extension Optional: PyObjectConvertible where Wrapped: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .some(v):
      return v.toPyObject(in: context)
    default:
      return context.none
    }
  }
}

extension String: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return context.builtins.newString(self)
  }
}

extension Array: PyObjectConvertible where Element: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    let array = self.map { $0.toPyObject(in: context) }
    return context.list(array)
  }
}

extension PyObject: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return self
  }
}

extension PyErrorEnum: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    // TODO: Put error in TLS
    fatalError()
  }
}

extension PyResult: PyObjectConvertible where V: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case let .error(e): return e.toPyObject(in: context)
    }
  }
}

extension PyResultOrNot: PyObjectConvertible where V: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case let .error(e): return e.toPyObject(in: context)
    case .notImplemented: return context.notImplemented
    }
  }
}
