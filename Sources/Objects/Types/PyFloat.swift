import Foundation
import Core

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html

// TODO: Float
// PyObject* PyFloat_FromString(PyObject *str)
// PyObject_GenericGetAttr,                    /* tp_getattro */
// FLOAT_CONJUGATE_METHODDEF
// FLOAT___TRUNC___METHODDEF
// FLOAT___ROUND___METHODDEF
// FLOAT_AS_INTEGER_RATIO_METHODDEF
// FLOAT_FROMHEX_METHODDEF
// FLOAT_HEX_METHODDEF
// FLOAT_IS_INTEGER_METHODDEF
// FLOAT___GETNEWARGS___METHODDEF
// FLOAT___GETFORMAT___METHODDEF
// FLOAT___SET_FORMAT___METHODDEF
// FLOAT___FORMAT___METHODDEF
// {"real", float_getreal, (setter)NULL, "the real part of a complex number", NULL},
// {"imag", float_getimag, (setter)NULL, "the imaginary part of a complex number", NULL},

/// This subtype of PyObject represents a Python floating point object.
internal final class PyFloat: PyObject {

  internal let value: Double

  fileprivate init(type: PyFloatType, value: Double) {
    self.value = value
    super.init(type: type)
  }
}

/// This subtype of PyObject represents a Python floating point object.
internal final class PyFloatType: PyType,
  ReprTypeClass, StrTypeClass,
  ComparableTypeClass, HashableTypeClass,

  SignedTypeClass,
  AbsTypeClass,
  AddTypeClass, SubTypeClass,
  MulTypeClass, PowTypeClass,
  DivTypeClass, DivFloorTypeClass, RemainderTypeClass, DivModTypeClass,
  PyBoolConvertibleTypeClass, PyIntConvertibleTypeClass, PyFloatConvertibleTypeClass {

  internal let name: String  = "float"
  internal let base: PyType? = nil
  internal let doc:  String? = """
float(x) -> floating point number

Convert a string or number to a floating point number, if possible.
"""

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  // MARK: - Ctors

  internal func new(_ value: Double) -> PyFloat {
    return PyFloat(type: self, value: value)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try  self.extractDouble(value)
    return String(describing: v)
  }

  internal func str(value: PyObject) throws -> String {
    return try self.repr(value: value)
  }

  // MARK: - Equatable, hashable

  func compare(left: PyObject, right: PyObject, mode: CompareMode) throws -> PyObject {
    fatalError()
  }

  internal func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    fatalError()
  }

  // MARK: - Conversion

  internal func bool(value: PyObject) throws -> PyBool {
    let v = try self.extractDouble(value)
    return self.context.types.bool.new(!v.isZero)
  }

  /// static PyObject * float___trunc___impl(PyObject *self)
  internal func int(value: PyObject) throws -> PyInt {
    let v = try self.extractDouble(value)
    return self.context.types.int.new(BigInt(v))
  }

  internal func float(value: PyObject) throws -> PyFloat {
    return try self.matchType(value)
  }

  // MARK: - Signed number

  internal func positive(value: PyObject) throws -> PyObject {
    return try self.matchType(value)
  }

  internal func negative(value: PyObject) throws -> PyObject {
    let v = try self.extractDouble(value)
    return self.new(-v)
  }

  // MARK: - Add, sub

  /// static PyObject* float_add(PyObject *v, PyObject *w)
  internal func add(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(l + r)
  }

  /// static PyObject* float_sub(PyObject *v, PyObject *w)
  internal func sub(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(l - r)
  }

  // MARK: - Mul

  /// static PyObject* float_mul(PyObject *v, PyObject *w)
  internal func mul(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(l * r)
  }

  // MARK: - Div

  /// static PyObject* float_div(PyObject *v, PyObject *w)
  internal func div(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)

    if r.isZero {
      throw PyContextError.floatDivisionByZero
    }

    return self.new(l / r)
  }

  /// static PyObject* float_rem(PyObject *v, PyObject *w)
  internal func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)

    if r.isZero {
      throw PyContextError.floatModuloZero
    }

    let remainder = l.remainder(dividingBy: r)
    return self.new(remainder)
  }

  /// static PyObject * float_divmod(PyObject *v, PyObject *w)
  internal func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)

    if r.isZero {
      throw PyContextError.floatDivModZero
    }

    let remainder = l.remainder(dividingBy: r)

    var quotient = (l - remainder) / r
    if quotient.isZero {
      quotient = Double(signOf: l / r, magnitudeOf: quotient)
    } else {
      quotient.round()
    }

    return self.context.types.tuple.new(self.new(quotient), self.new(remainder))
  }

  /// static PyObject* float_floor_div(PyObject *v, PyObject *w)
  internal func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    let divMod = try self.divMod(left: left, right: right)
    return try self.context.types.tuple.item(owner: divMod, at: 0)
  }

  // MARK: - Abs

  internal func abs(value: PyObject) throws -> PyObject {
    let v = try self.extractDouble(value)
    return self.new(Swift.abs(v))
  }

  // MARK: - Power

  /// static PyObject* float_pow(PyObject *v, PyObject *w, PyObject *z)
  internal func pow(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(Foundation.pow(l, r))
  }

  // MARK: - Helpers

  private func matchType(_ object: PyObject) throws -> PyFloat {
    if let float = object as? PyFloat {
      return float
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }

  private func extractDouble(_ object: PyObject) throws -> Double {
    if let f = object as? PyFloat {
      return f.value
    }

    if let i = object as? PyInt {
      return Double(i.value)
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
