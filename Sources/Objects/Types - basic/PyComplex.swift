import Foundation
import Core

// In CPython:
// Objects -> complexobject.c
// https://docs.python.org/3.7/c-api/complex.html

// swiftlint:disable file_length

// sourcery: pytype = complex
/// This subtype of PyObject represents a Python complex number object.
public final class PyComplex: PyObject {

  internal static let doc: String = """
    complex(real=0, imag=0)
    --

    Create a complex number from a real part and an optional imaginary part.

    This is equivalent to (real + imag*1j) where imag defaults to 0.
    """

  internal let real: Double
  internal let imag: Double

  // MARK: - Init

  internal init(_ context: PyContext, real: Double, imag: Double) {
    self.real = real
    self.imag = imag
    super.init(type: context.builtins.types.complex)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    if let o = other as? PyComplex {
      return .value(self.real == o.real && self.imag == o.imag)
    }

    if let o = other as? PyFloat {
      return .value(self.real == o.value && self.imag == 0)
    }

    if let o = other as? PyInt {
      return .value(self.imag.isZero && Double(o.value) == self.real)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    let realHash = HashHelper.hash(self.real)
    let imagHash = HashHelper.hash(self.imag)
    return .value(realHash + HashHelper._PyHASH_IMAG * imagHash)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.real.isZero {
      return .value(String(describing: self.imag) + "j")
    }

    let sign = self.imag >= 0 ? "+" : ""
    let real = String(describing: self.real)
    let imag = String(describing: self.imag)
    return .value("(\(real)\(sign)\(imag)j)")
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return self.repr()
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    let bothZero = self.real.isZero && self.imag.isZero
    return !bothZero
  }

  // sourcery: pymethod = __int__
  internal func asInt() -> PyResult<PyInt> {
    return .typeError("can't convert complex to int")
  }

  // sourcery: pymethod = __float__
  internal func asFloat() -> PyResult<PyFloat> {
    return .typeError("can't convert complex to float")
  }

  // sourcery: pymethod = real
  internal func asReal() -> PyObject {
    return self.builtins.newFloat(self.real)
  }

  // sourcery: pymethod = imag
  internal func asImag() -> PyObject {
    return self.builtins.newFloat(self.imag)
  }

  // MARK: - Imaginary

  // sourcery: pymethod = conjugate
  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal func conjugate() -> PyObject {
    return self.builtins.newComplex(real: self.real, imag: -self.imag)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  internal func positive() -> PyObject {
    return self
  }

  // sourcery: pymethod = __neg__
  internal func negative() -> PyObject {
    return self.builtins.newComplex(real: -self.real, imag: -self.imag)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal func abs() -> PyObject {
    let bothFinite = self.real.isFinite && self.imag.isFinite
    guard bothFinite else {
      if self.real.isInfinite {
        return self.builtins.newFloat(Swift.abs(self.real))
      }

      if self.imag.isInfinite {
        return self.builtins.newFloat(Swift.abs(self.imag))
      }

      return self.builtins.newFloat(.nan)
    }

    let result = hypot(self.real, self.imag)
    return self.builtins.newFloat(result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    return .value(
      self.builtins.newComplex(
        real: self.real + other.real,
        imag: self.imag + other.real
      )
    )
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.sub(left: zelf, right: other))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.sub(left: other, right: zelf))
  }

  private func sub(left: RawComplex, right: RawComplex) -> PyComplex {
    return self.builtins.newComplex(
      real: left.real - right.real,
      imag: left.imag - right.real
    )
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.mul(left: zelf, right: other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.mul(left: other, right: zelf))
  }

  private func mul(left: RawComplex, right: RawComplex) -> PyComplex {
    return self.builtins.newComplex(
      real: left.real * right.real - left.imag * right.imag,
      imag: left.real * right.imag + left.imag * right.real
    )
  }

  // MARK: - Pow

  // sourcery: pymethod = __pow__
  internal func pow(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.pow(left: zelf, right: other)
      .flatMap { PyResultOrNot<PyObject>.value($0) }
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.pow(left: other, right: zelf)
      .flatMap { PyResultOrNot<PyObject>.value($0) }
  }

  private func pow(left: RawComplex, right: RawComplex) -> PyResultOrNot<PyComplex> {
    if right.real.isZero && right.real.isZero {
      return .value(self.builtins.newComplex(real: 1.0, imag: 0.0))
    }

    if left.real.isZero && left.imag.isZero {
      if right.real < 0.0 || right.imag != 0.0 {
        return .valueError("complex zero to negative or complex power")
      }

      return .value(self.builtins.newComplex(real: 0.0, imag: 0.0))
    }

    let vabs = Foundation.hypot(left.real, left.imag)
    var len = Foundation.pow(vabs, right.real)
    let at = Foundation.atan2(left.imag, left.real)
    var phase = at * right.real

    if !right.imag.isZero {
      len /= Foundation.exp(at * right.imag)
      phase += right.imag * Foundation.log(vabs)
    }

    return .value(
      self.builtins.newComplex(
        real: len * cos(phase),
        imag: len * sin(phase)
      )
    )
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  internal func trueDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.trueDiv(left: zelf, right: other)
      .flatMap { PyResultOrNot<PyObject>.value($0) }
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtrueDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.trueDiv(left: other, right: zelf)
      .flatMap { PyResultOrNot<PyObject>.value($0) }
  }

  private func trueDiv(left: RawComplex, right: RawComplex) -> PyResultOrNot<PyComplex> {
    // We implement the 'incorrect' version because it is simpler.
    // See comment in 'Py_complex _Py_c_quot(Py_complex a, Py_complex b)' for details.

    let d = right.real * right.real + right.imag * right.imag
    if d.isZero {
      return .zeroDivisionError("complex division by zero")
    }

    return .value(
      self.builtins.newComplex(
        real: (left.real * right.real + left.imag * right.imag) / d,
        imag: (left.imag * right.real - left.real * right.imag) / d
      )
    )
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floorDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return .typeError("can't take floor of complex number.")
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloorDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.floorDiv(other)
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  internal func mod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return .typeError("can't mod complex numbers.")
  }

  // sourcery: pymethod = __rmod__
  internal func rmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mod(other)
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  internal func divMod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return .typeError("can't take floor or mod of complex number.")
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivMod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.divMod(other)
  }

  // MARK: - Helpers

  private struct RawComplex {
    fileprivate let real: Double
    fileprivate let imag: Double
  }

  private func asComplex(_ object: PyObject) -> RawComplex? {
    if let pyFloat = object as? PyFloat {
      return RawComplex(real: pyFloat.value, imag: 0)
    }

    if let pyInt = object as? PyInt {
      return RawComplex(real: Double(pyInt.value), imag: 0)
    }

    return nil
  }
}
