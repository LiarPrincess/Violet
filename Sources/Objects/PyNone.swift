import Core

public final class PyNone: PyObject {
  fileprivate init(type: PyNoneType) {
    super.init(type: type)
  }
}

public final class PyNoneType: PyType,
ReprConvertibleTypeClass, PyBoolConvertibleTypeClass {

  public let name: String  = "NoneType"
  public let base: PyType? = nil
  public let doc:  String? = nil

  public lazy var value = PyNone(type: self)

  public unowned let context: Context

  public init(context: Context) {
    self.context = context
  }

  public func new() -> PyNone {
    return self.value
  }

  public func repr(value: PyObject) throws -> String {
    return "None"
  }

  public func bool(value: PyObject) throws -> PyBool {
    return self.context.false
  }
}
