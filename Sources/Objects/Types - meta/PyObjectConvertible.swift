import Core

// swiftlint:disable unavailable_function

public protocol PyObjectConvertible {
  func toPyObject(in context: PyContext) -> PyObject
}

extension Int: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return context.int(self)
  }
}

extension BigInt: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return context.int(self)
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
    return context.string(self)
  }
}

extension Array: PyObjectConvertible where Element: PyObject {
  public func toPyObject(in context: PyContext) -> PyObject {
    let array = self.map { $0.toPyObject(in: context) }
    return context.list(array)
  }
}

extension PyHash: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return context.int(BigInt(self))
  }
}

extension PyObject: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    return self
  }
}

extension PyResult: PyObjectConvertible where V: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case .error: fatalError()
    }
  }
}

extension PyResultOrNot: PyObjectConvertible where V: PyObjectConvertible {
  public func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case .error, .notImplemented: fatalError()
    }
  }
}
