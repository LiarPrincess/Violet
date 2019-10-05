import Foundation
import Core

// In CPython:
// Objects -> complexobject.c
// https://docs.python.org/3.7/c-api/complex.html

// TODO: Complex
// {"conjugate",       (PyCFunction)complex_conjugate, METH_NOARGS, ... },
// {"__getnewargs__",  (PyCFunction)complex_getnewargs, METH_NOARGS ... },
// {"__format__",      (PyCFunction)complex__format__, METH_VARARGS, ... },
// {"real", T_DOUBLE, offsetof(PyComplexObject, cval.real), READONLY, ... },
// {"imag", T_DOUBLE, offsetof(PyComplexObject, cval.imag), READONLY, ... },
// PyObject_GenericGetAttr,                    /* tp_getattro */

/// This subtype of PyObject represents a Python complex number object.
internal final class PyComplex: PyObject {

  internal let real: Double
  internal let imag: Double

  fileprivate init(type: PyComplexType, real: Double, imag: Double) {
    self.real = real
    self.imag = imag
    super.init(type: type)
  }
}

/// This subtype of PyObject represents a Python complex number object.
internal final class PyComplexType: PyType /*,
  ReprTypeClass, StrTypeClass,
  ComparableTypeClass, HashableTypeClass,
  SignedTypeClass, AbsTypeClass,
  AddTypeClass, SubTypeClass,
  MulTypeClass, PowTypeClass,
  DivTypeClass, DivFloorTypeClass, RemainderTypeClass, DivModTypeClass,
  PyBoolConvertibleTypeClass, PyIntConvertibleTypeClass, PyFloatConvertibleTypeClass */ {

  override internal var name: String { return "complex" }
  override internal var doc: String? { return """
complex(real=0, imag=0)
--

Create a complex number from a real part and an optional imaginary part.

This is equivalent to (real + imag*1j) where imag defaults to 0.
"""
  }

  private var floatType: PyFloatType {
    return self.types.float
  }

  // MARK: - Ctors

  internal func new(real: Double, imag: Double) -> PyComplex {
    return PyComplex(type: self, real: real, imag: imag)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try self.matchType(value)

    if v.real.isZero {
      return String(describing: v.imag) + "j"
    } else {
      let real = String(describing: v.real)
      let sign = v.imag >= 0 ? "+" : ""
      let imag = String(describing: v.imag)
      return "(\(real)\(sign)\(imag)j)"
    }
  }

  internal func str(value: PyObject) throws -> String {
    return try self.repr(value: value)
  }

  // MARK: - Equatable, hashable

  internal func compare(left:  PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> Bool {
    let l = try self.matchType(left)

    switch mode {
    case .equal:
      return try self.isEqual(left: l, right: right)
    case .notEqual:
      let isEqual = try self.isEqual(left: l, right: right)
      return !isEqual
    case .less,
         .lessEqual,
         .greater,
         .greaterEqual:
      throw ComparableNotImplemented(left: left, right: right)
    }
  }

  private func isEqual(left: PyComplex, right: PyObject) throws -> Bool {
    if let r = right as? PyComplex {
      return left.real == r.real && left.imag == r.imag
    }

    if let r = right as? PyFloat {
      return left.real == r.value && left.imag == 0
    }

    if let r = right as? PyInt {
      guard left.imag.isZero else {
        return false
      }

      let real = self.types.float.new(left.real)
      return try self.context.richCompareBool(left: real, right: r, mode: .equal)
    }

    throw ComparableNotImplemented(left: left, right: right)
  }

  internal func hash(value: PyObject) throws -> PyHash {
    let v = try self.matchType(value)

    let hasher = self.context.hasher
    let realHash = hasher.hash(v.real)
    let imagHash = hasher.hash(v.imag)

    var combined = realHash + hasher._PyHASH_IMAG * imagHash
    if combined == -1 {
      combined = -2
    }
    return combined
  }

  // MARK: - Conversion

  internal func bool(value: PyObject) throws -> PyBool {
    let v = try self.matchType(value)
    let bothZero = v.real.isZero && v.imag.isZero
    return self.types.bool.new(!bothZero)
  }

  internal func int(value: PyObject) throws -> PyInt {
    throw PyContextError.complexInvalidToInt
  }

  internal func float(value: PyObject) throws -> PyFloat {
    throw PyContextError.complexInvalidToFloat
  }

  // MARK: - Signed number

  internal func positive(value: PyObject) throws -> PyObject {
    let v = try self.matchType(value)
    return self.new(real: v.real, imag: v.imag)
  }

  internal func negative(value: PyObject) throws -> PyObject {
    let v = try self.matchType(value)
    return self.new(real: -v.real, imag: -v.imag)
  }

  // MARK: - Add, sub

  internal func add(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.matchType(left)
    let r = try self.matchType(right)
    return self.new(real: l.real + r.real, imag: l.imag + r.imag)
  }

  internal func sub(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.matchType(left)
    let r = try self.matchType(right)
    return self.new(real: l.real - r.real, imag: l.imag - r.imag)
  }

  // MARK: - Mul

  internal func mul(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.matchType(left)
    let r = try self.matchType(right)
    let real = l.real * r.real - l.imag * r.imag
    let imag = l.real * r.imag + l.imag * r.real
    return self.new(real: real, imag: imag)
  }

  internal func pow(value: PyObject, exponent: PyObject) throws -> PyObject {
    let a = try self.matchType(value)
    let b = try self.matchType(exponent)

    if b.real.isZero && b.real.isZero {
      return self.new(real: 1, imag: 0)
    }

    if a.real.isZero && a.imag.isZero {
      if b.imag != 0.0 || b.real < 0 {
        throw PyContextError.complexZeroToNegativeOrComplexPower
      }

      return self.new(real: 0, imag: 0)
    }

    let vabs = Foundation.hypot(a.real, a.imag)
    var len = Foundation.pow(vabs, b.real)
    let at = Foundation.atan2(a.imag, a.real)
    var phase = at * b.real

    if !b.imag.isZero {
      len /= Foundation.exp(at * b.imag)
      phase += b.imag * Foundation.log(vabs)
    }

    return self.new(
      real: len * cos(phase),
      imag: len * sin(phase)
    )
  }

  // MARK: - Div

  internal func div(left: PyObject, right: PyObject) throws -> PyObject {
    // We implement the 'incorrect' version because it is simpler
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    let d = r.real * r.real + r.imag * r.imag
    if d.isZero {
      throw PyContextError.complexDivisionByZero
    }

    let real = (l.real * r.real + l.imag * r.imag) / d
    let imag = (l.imag * r.real - l.real * r.imag) / d
    return self.new(real: real, imag: imag)
  }

  internal func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    throw PyContextError.complexInvalidDivFloor
  }

  internal func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    throw PyContextError.complexInvalidModulo
  }

  internal func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    throw PyContextError.complexInvalidDivMod
  }

  // MARK: - Abs

  internal func abs(value: PyObject) throws -> PyObject {
    let v = try self.matchType(value)

    let bothFinite = v.real.isFinite && v.imag.isFinite
    guard bothFinite else {
      if v.real.isInfinite {
        return self.floatType.new(Swift.abs(v.real))
      }

      if v.imag.isInfinite {
        return self.floatType.new(Swift.abs(v.imag))
      }

      return self.floatType.nan
    }

    return self.floatType.new(hypot(v.real, v.imag))
  }

  // MARK: - Helpers

  private func matchType(_ object: PyObject) throws -> PyComplex {
    if let complex = object as? PyComplex {
      return complex
    }

    if let i = self.types.int.extractIntOrNil(object) {
      return self.new(real: Double(i), imag: 0.0)
    }

    if let f = self.types.float.extractDoubleOrNil(object) {
      return self.new(real: f, imag: 0.0)
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
