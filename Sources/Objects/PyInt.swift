import Core

public final class PyInt: PyObject {

  internal var value: BigInt

  fileprivate init(type: PyIntType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }
}

public final class PyIntType: PyType {

  public func new(_ value: BigInt) -> PyInt {
    return PyInt(type: self, value: value)
  }
}
