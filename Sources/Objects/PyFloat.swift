import Foundation
import Core

// In CPython:
// Objects -> floatobject.c

/// PyFloatObject represents a (double precision) floating point number.
public final class PyFloat: PyObject {

  internal let value: Double

  fileprivate init(type: PyFloatType, value: Double) {
    self.value = value
    super.init(type: type)
  }
}

public final class PyFloatType: PyType, ContextOwner,
  ReprConvertibleTypeClass, StrConvertibleTypeClass,
  ComparableTypeClass, HashableTypeClass,

  SignedNumberTypeClass,
  AbsoluteNumberTypeClass,
  AdditiveTypeClass, SubtractiveTypeClass,
  MultiplicativeTypeClass, PowerTypeClass,
  DividableTypeClass, FloorDividableTypeClass, RemainderTypeClass, DivModTypeClass,
  PyBoolConvertibleTypeClass, PyIntConvertibleTypeClass, PyFloatConvertibleTypeClass {

  public let name: String  = "float"
  public let base: PyType? = nil
  public let doc:  String? = """
float(x) -> floating point number

Convert a string or number to a floating point number, if possible.
"""

  public unowned let context: Context

  public init(context: Context) {
    self.context = context
  }

  // MARK: - Ctors

  public func new(_ value: Double) -> PyFloat {
    return PyFloat(type: self, value: value)
  }

  // MARK: - String

  public func repr(value: PyObject) throws -> String {
    let v = try  self.extractDouble(value)
    return String(describing: v)
  }

  public func str(value: PyObject) throws -> String {
    return try self.repr(value: value)
  }

  // MARK: - Equatable, hashable

  public func compare(left: PyObject, right: PyObject, x: Int) throws -> PyObject {
    fatalError()
  }

  public func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    fatalError()
  }

  // MARK: - Conversion

  public func bool(value: PyObject) throws -> PyBool {
    let v = try self.extractDouble(value)
    return v.isZero ? self.context.false : self.context.true
  }

  /// static PyObject * float___trunc___impl(PyObject *self)
  public func int(value: PyObject) throws -> PyInt {
    let v = try self.extractDouble(value)
    return self.context.types.int.new(BigInt(v))
  }

  public func float(value: PyObject) throws -> PyFloat {
    return try self.matchType(value)
  }

  // MARK: - Signed number

  public func positive(value: PyObject) throws -> PyObject {
    return try self.matchType(value)
  }

  public func negative(value: PyObject) throws -> PyObject {
    let v = try self.extractDouble(value)
    return self.new(-v)
  }

  // MARK: - Add, sub

  /// static PyObject* float_add(PyObject *v, PyObject *w)
  public func add(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(l + r)
  }

  /// static PyObject* float_sub(PyObject *v, PyObject *w)
  public func sub(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(l - r)
  }

  // MARK: - Mul

  /// static PyObject* float_mul(PyObject *v, PyObject *w)
  public func mul(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(l * r)
  }

  // MARK: - Div

  /// static PyObject* float_div(PyObject *v, PyObject *w)
  public func div(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)

    if r.isZero {
      throw ObjectError.floatDivisionByZero
    }

    return self.new(l / r)
  }

  /// static PyObject* float_rem(PyObject *v, PyObject *w)
  public func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)

    if r.isZero {
      throw ObjectError.floatModuloZero
    }

    let remainder = l.remainder(dividingBy: r)
    return self.new(remainder)
  }

  /// static PyObject * float_divmod(PyObject *v, PyObject *w)
  public func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)

    if r.isZero {
      throw ObjectError.floatDivModZero
    }

    let remainder = l.remainder(dividingBy: r)

    var quotient = (l - remainder) / r
    if quotient.isZero {
      quotient = Double(signOf: l / r, magnitudeOf: quotient)
    } else {
      quotient.round()
    }

    return self.types.tuple.new(self.new(quotient), self.new(remainder))
  }

  /// static PyObject* float_floor_div(PyObject *v, PyObject *w)
  public func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    let divMod = try self.divMod(left: left, right: right)
    return try self.types.tuple.getItem(divMod, at: 0)
  }

  // MARK: - Abs

  public func abs(value: PyObject) throws -> PyObject {
    let v = try self.extractDouble(value)
    return self.new(Swift.abs(v))
  }

  // MARK: - Power

  /// static PyObject* float_pow(PyObject *v, PyObject *w, PyObject *z)
  public func pow(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractDouble(left)
    let r = try self.extractDouble(right)
    return self.new(Foundation.pow(l, r))
  }

  // MARK: - Helpers

  private func matchType(_ object: PyObject) throws -> PyFloat {
    if let float = object as? PyFloat {
      return float
    }

    throw ObjectError.invalidTypeConversion(object: object, to: self)
  }

  private func extractDouble(_ object: PyObject) throws -> Double {
    if let f = object as? PyFloat {
      return f.value
    }

    if let i = object as? PyInt {
      return Double(i.value)
    }

    throw ObjectError.invalidTypeConversion(object: object, to: self)
  }
}
