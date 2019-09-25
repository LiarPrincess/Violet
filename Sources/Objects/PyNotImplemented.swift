import Core

/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
public final class PyNotImplemented: PyObject {
  fileprivate init(type: PyNotImplementedType) {
    super.init(type: type)
  }
}

public final class PyNotImplementedType: PyType, ReprConvertibleTypeClass {

  public let name: String  = "NotImplementedType"
  public let base: PyType? = nil
  public let doc:  String? = nil

  public lazy var value = PyNotImplemented(type: self)

  public func new() -> PyNotImplemented {
    return self.value
  }

  public func repr(value: PyObject) throws -> String {
    return "NotImplemented"
  }
}
