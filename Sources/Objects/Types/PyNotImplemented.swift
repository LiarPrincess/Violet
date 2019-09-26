import Core

/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
internal final class PyNotImplemented: PyObject {
  fileprivate init(type: PyNotImplementedType) {
    super.init(type: type)
  }
}

/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
internal final class PyNotImplementedType: PyType, ReprTypeClass {

  internal let name: String  = "NotImplementedType"
  internal let base: PyType? = nil
  internal let doc:  String? = nil

  internal lazy var value = PyNotImplemented(type: self)

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  internal func new() -> PyNotImplemented {
    return self.value
  }

  internal func repr(value: PyObject) throws -> String {
    return "NotImplemented"
  }
}
