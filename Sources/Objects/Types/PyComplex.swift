import Foundation
import Core

// In CPython:
// Objects -> complexobject.c
// https://docs.python.org/3.7/c-api/complex.html

// TODO: Complex
// @overload
// def __init__(self, s: str) -> None: ...
// @overload
// def __init__(self, s: SupportsComplex) -> None: ...
// __format__
// __getattribute__
// __getnewargs__

// swiftlint:disable file_length

// sourcery: pytype = complex
/// This subtype of PyObject represents a Python complex number object.
internal final class PyComplex: PyObject,
  ReprTypeClass, StrTypeClass,
  ComparableTypeClass, HashableTypeClass,
  BoolConvertibleTypeClass, IntConvertibleTypeClass, FloatConvertibleTypeClass,
  RealConvertibleTypeClass, ImagConvertibleTypeClass, ConjugateTypeClass,
  SignedTypeClass, AbsTypeClass,
  AddTypeClass, RAddTypeClass,
  SubTypeClass, RSubTypeClass,
  MulTypeClass, RMulTypeClass,
  PowTypeClass, RPowTypeClass,
  TrueDivTypeClass, RTrueDivTypeClass,
  FloorDivTypeClass, RFloorDivTypeClass,
  ModTypeClass, RModTypeClass,
  DivModTypeClass, RDivModTypeClass {

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
    super.init(type: context.types.complex)
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
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

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // MARK: - Hashable

  internal func hash() -> HashableResult {
    let hasher = self.context.hasher
    let realHash = hasher.hash(self.real)
    let imagHash = hasher.hash(self.imag)
    return .value(realHash + hasher._PyHASH_IMAG * imagHash)
  }

  // MARK: - String

  internal func repr() -> String {
    if self.real.isZero {
      return String(describing: self.imag) + "j"
    }

    let sign = self.imag >= 0 ? "+" : ""
    let real = String(describing: self.real)
    let imag = String(describing: self.imag)
    return "(\(real)\(sign)\(imag)j)"
  }

  internal func str() -> String {
    return self.repr()
  }

  // MARK: - Convertible

  internal func asBool() -> PyResult<Bool> {
    let bothZero = self.real.isZero && self.imag.isZero
    return .value(!bothZero)
  }

  internal func asInt() -> PyResult<PyInt> {
    return .error(.typeError("can't convert complex to int"))
  }

  internal func asFloat() -> PyResult<PyFloat> {
    return .error(.typeError("can't convert complex to float"))
  }

  internal func asReal() -> PyObject {
    return self.float(self.real)
  }

  internal func asImag() -> PyObject {
    return self.float(self.imag)
  }

  // MARK: - Imaginary

  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal func conjugate() -> PyObject {
    return self.complex(real: self.real, imag: -self.imag)
  }

  // MARK: - Sign

  internal func positive() -> PyObject {
    return self
  }

  internal func negative() -> PyObject {
    return self.complex(real: -self.real, imag: -self.imag)
  }

  // MARK: - Abs

  internal func abs() -> PyObject {
    let bothFinite = self.real.isFinite && self.imag.isFinite
    guard bothFinite else {
      if self.real.isInfinite {
        return self.float(Swift.abs(self.real))
      }

      if self.imag.isInfinite {
        return self.float(Swift.abs(self.imag))
      }

      return self.float(.nan)
    }

    let result = hypot(self.real, self.imag)
    return self.float(result)
  }

  // MARK: - Add

  internal func add(_ other: PyObject) -> AddResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    return .value(
      self.complex(
        real: self.real + other.real,
        imag: self.imag + other.real
      )
    )
  }

  internal func radd(_ other: PyObject) -> AddResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  internal func sub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.sub(left: zelf, right: other))
  }

  internal func rsub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.sub(left: other, right: zelf))
  }

  private func sub(left: RawComplex, right: RawComplex) -> PyComplex {
    return self.complex(
      real: left.real - right.real,
      imag: left.imag - right.real
    )
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.mul(left: zelf, right: other))
  }

  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return .value(self.mul(left: other, right: zelf))
  }

  private func mul(left: RawComplex, right: RawComplex) -> PyComplex {
    return self.complex(
      real: left.real * right.real - left.imag * right.imag,
      imag: left.real * right.imag + left.imag * right.real
    )
  }

  // MARK: - Pow

  internal func pow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.pow(left: zelf, right: other)
      .flatMap { PowResult<PyObject>.value($0) }
  }

  internal func rpow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.pow(left: other, right: zelf)
      .flatMap { PowResult<PyObject>.value($0) }
  }

  private func pow(left: RawComplex, right: RawComplex) -> PowResult<PyComplex> {
    if right.real.isZero && right.real.isZero {
      return .value(self.complex(real: 1.0, imag: 0.0))
    }

    if left.real.isZero && left.imag.isZero {
      if right.real < 0.0 || right.imag != 0.0 {
        return .error(.valueError("complex zero to negative or complex power"))
      }

      return .value(self.complex(real: 0.0, imag: 0.0))
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
      self.complex(
        real: len * cos(phase),
        imag: len * sin(phase)
      )
    )
  }

  // MARK: - True div

  internal func trueDiv(_ other: PyObject) -> TrueDivResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.trueDiv(left: zelf, right: other)
      .flatMap { PowResult<PyObject>.value($0) }
  }

  internal func rtrueDiv(_ other: PyObject) -> TrueDivResult<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = RawComplex(real: self.real, imag: self.imag)
    return self.trueDiv(left: other, right: zelf)
      .flatMap { PowResult<PyObject>.value($0) }
  }

  private func trueDiv(left: RawComplex, right: RawComplex) -> TrueDivResult<PyComplex> {
    // We implement the 'incorrect' version because it is simpler.
    // See comment in 'Py_complex _Py_c_quot(Py_complex a, Py_complex b)' for details.

    let d = right.real * right.real + right.imag * right.imag
    if d.isZero {
      return .error(.zeroDivisionError("complex division by zero"))
    }

    return .value(
      self.complex(
        real: (left.real * right.real + left.imag * right.imag) / d,
        imag: (left.imag * right.real - left.real * right.imag) / d
      )
    )
  }

  // MARK: - Floor div

  internal func floorDiv(_ other: PyObject) -> FloorDivResult<PyObject> {
    return .error(.typeError("can't take floor of complex number."))
  }

  internal func rfloorDiv(_ other: PyObject) -> FloorDivResult<PyObject> {
    return self.floorDiv(other)
  }

  // MARK: - Mod

  internal func mod(_ other: PyObject) -> ModResult<PyObject> {
    return .error(.typeError("can't mod complex numbers."))
  }

  internal func rmod(_ other: PyObject) -> ModResult<PyObject> {
    return self.mod(other)
  }

  // MARK: - Div mod

  internal func divMod(_ other: PyObject) -> DivModResult<PyObject> {
    return .error(.typeError("can't take floor or mod of complex number."))
  }

  internal func rdivMod(_ other: PyObject) -> DivModResult<PyObject> {
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
