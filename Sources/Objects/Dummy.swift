public class PyBoolType: PyType { }

public class PyBool: PyObject {
  private let value: Bool

  public init(_ value: Bool) {
    self.value = value
    super.init(type: PyBoolType())
  }
}

public class PyUnicodeType {

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

public final class PyNumberType {

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

  /// PyObject * PyNumber_Add(PyObject *v, PyObject *w)
  public func add(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  /// Calling scheme used for binary operations.
  ///
  /// Order operations are tried until either a valid result or error:
  /// `w.op(v,w)[*], v.op(v,w), w.op(v,w)`.
  ///
  /// [*] only when `v->ob_type != w->ob_type`
  /// and `w->ob_type` is a subclass of `v->ob_type`.
  private func binaryOp1(left: PyObject, right: PyObject) {

  }

  public func subtract(left: PyObject, right: PyObject) -> PyObject {
    return left
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

  public func power(base: PyObject, exp: PyObject, z: PyObject) -> PyObject {
    return base
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
