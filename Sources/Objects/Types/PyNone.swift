import Core

/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNone: PyObject {
  fileprivate init(type: PyNoneType) {
    super.init(type: type)
  }
}

/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNoneType: PyType /* ,
  ReprTypeClass, PyBoolConvertibleTypeClass */ {

  override internal var name: String { return "NoneType" }

  internal lazy var value = PyNone(type: self)

  internal func repr(value: PyObject) throws -> String {
    return "None"
  }

  internal func bool(value: PyObject) throws -> PyBool {
    return self.types.bool.false
  }
}
