public final class PyBoolType: PyType { }

public final class PyBool: PyObject {
  private let value: Bool

  public init(_ value: Bool) {
    self.value = value
    super.init(type: PyBoolType())
  }
}

public final class PyUnicodeType {

  public init() { }

  public func checkExact(_ value: PyObject) -> Bool {
    return false
  }

  public func check(_ value: PyObject) -> Bool {
    return false
  }

  public func format(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func unicode_concatenate(left: PyObject, right: PyObject) -> PyObject {
    return left
  }
}
