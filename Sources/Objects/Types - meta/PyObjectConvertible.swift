import Core

// swiftlint:disable unavailable_function

internal protocol PyObjectConvertible {
  func toPyObject(in context: PyContext) -> PyObject
}

extension BigInt: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return context.int(self)
  }
}

extension Bool: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return self ? context.true : context.false
  }
}

extension Attributes: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    fatalError()
  }
}

extension DirResult: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    fatalError()
  }
}

extension String: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return context.string(self)
  }
}

extension Array: PyObjectConvertible where Element: PyObject {
  internal func toPyObject(in context: PyContext) -> PyObject {
    let array = self.map { $0.toPyObject(in: context) }
    return context.list(array)
  }
}

extension PyHash: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return context.int(BigInt(self))
  }
}

extension PyObject: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return self
  }
}

extension PyResult: PyObjectConvertible where V: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case .error: fatalError()
    }
  }
}

extension PyResultOrNot: PyObjectConvertible where V: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case .error, .notImplemented: fatalError()
    }
  }
}
