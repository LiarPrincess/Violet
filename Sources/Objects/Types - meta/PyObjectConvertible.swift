import Core

// swiftlint:disable unavailable_function

internal protocol PyObjectConvertible {
  func toPyObject(in context: PyContext) -> PyObject
}

extension BigInt {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return context.int(self)
  }
}

extension Bool {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return self ? context.true : context.false
  }
}

extension Attributes {
  internal func toPyObject(in context: PyContext) -> PyObject {
    fatalError()
  }
}

extension DirResult {
  internal func toPyObject(in context: PyContext) -> PyObject {
    fatalError()
  }
}

extension String {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return context.string(self)
  }
}

extension Array where Element == PyObject {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return context.list(self)
  }
}

//extension Void {
//  internal func toPyObject(in context: PyContext) -> PyObject {
//    return context.none
//  }
//}

extension PyObject {
  internal func toPyObject(in context: PyContext) -> PyObject {
    return self
  }
}

extension PyResult where V: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case .error: fatalError()
    }
  }
}

extension PyResultOrNot where V: PyObjectConvertible {
  internal func toPyObject(in context: PyContext) -> PyObject {
    switch self {
    case let .value(v): return v.toPyObject(in: context)
    case .error, .notImplemented: fatalError()
    }
  }
}
