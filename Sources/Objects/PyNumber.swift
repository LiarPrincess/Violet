public class PyNumberType {

  public init() { }

  // MARK: - Unary

  public func positive(_ number: PyObject) -> PyObject {
    return number
  }

  public func negative(_ number: PyObject) -> PyObject {
    return number
  }

  public func invert(_ number: PyObject) -> PyObject {
    return number
  }

  // MARK: - Arithmetic

  public func power(base: PyObject, exp: PyObject, z: PyObject) -> PyObject {
    return base
  }

  public func multiply(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func matrixMultiply(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func trueDivide(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func floorDivide(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func remainder(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func add(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func subtract(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  // MARK: - Shift

  public func lShift(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func rShift(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  // MARK: - Binary

  public func and(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func xor(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func or(left: PyObject, right: PyObject) -> PyObject {
    return left
  }
}
