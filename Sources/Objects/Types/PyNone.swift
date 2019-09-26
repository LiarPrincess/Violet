import Core

/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNone: PyObject {
  fileprivate init(type: PyNoneType) {
    super.init(type: type)
  }
}

/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNoneType: PyType,
ReprTypeClass, PyBoolConvertibleTypeClass {

  internal let name: String  = "NoneType"
  internal let base: PyType? = nil
  internal let doc:  String? = nil

  internal lazy var value = PyNone(type: self)

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  internal func new() -> PyNone {
    return self.value
  }

  internal func repr(value: PyObject) throws -> String {
    return "None"
  }

  internal func bool(value: PyObject) throws -> PyBool {
    return self.context.types.bool.false
  }
}
