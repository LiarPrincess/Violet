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
internal final class PyNotImplementedType: PyType /* , ReprTypeClass */ {

  override internal var name: String { return "NotImplementedType" }

  internal lazy var value = PyNotImplemented(type: self)

//  internal func repr(value: PyObject) throws -> String {
//    return "NotImplemented"
//  }
}
