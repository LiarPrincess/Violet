import Foundation
import Core

// In CPython:
// Objects -> complexobject.c
// https://docs.python.org/3.7/c-api/complex.html

// swiftlint:disable file_length

// sourcery: pytype = complex, default, baseType
/// This subtype of PyObject represents a Python complex number object.
public class PyComplex: PyObject {

  internal static let doc: String = """
    complex(real=0, imag=0)
    --

    Create a complex number from a real part and an optional imaginary part.

    This is equivalent to (real + imag*1j) where imag defaults to 0.
    """

  internal let real: Double
  internal let imag: Double

  override public var description: String {
    return "PyComplex(real: \(real), imag: \(imag))"
  }

  // MARK: - Init

  internal init(real: Double, imag: Double) {
    self.real = real
    self.imag = imag
    super.init(type: Py.types.complex)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, real: Double, imag: Double) {
    self.real = real
    self.imag = imag
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    if let o = PyComplex.asComplex(other) {
      return .value(self.real == o.real && self.imag == o.imag)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    let realHash = Py.hasher.hash(self.real)
    let imagHash = Py.hasher.hash(self.imag)
    return .value(realHash + Hasher.imag * imagHash)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    // Real part is 0: just output the imaginary part and do not include parens.
    if self.real.isZero {
      let imag = self.dimensionRepr(self.imag)
      return .value(imag + "j")
    }

    let sign = self.imag >= 0 ? "+" : ""
    let real = self.dimensionRepr(self.real)
    let imag = self.dimensionRepr(self.imag)
    return .value("(\(real)\(sign)\(imag)j)")
  }

  private func dimensionRepr(_ value: Double) -> String {
    let result = String(describing: value)

    // If it is 'int' then remove '.0'
    if result.ends(with: ".0") {
      let withoutDotZero = result.dropLast(2)
      return withoutDotZero.isEmpty ? "0" : String(withoutDotZero)
    }

    return result
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

  // sourcery: pyproperty = real
  internal func asReal() -> PyObject {
    return Py.newFloat(self.real)
  }

  // sourcery: pyproperty = imag
  internal func asImag() -> PyObject {
    return Py.newFloat(self.imag)
  }

  // MARK: - Imaginary

  // sourcery: pymethod = conjugate
  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal func conjugate() -> PyObject {
    return Py.newComplex(real: self.real, imag: -self.imag)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  internal func getAttribute(name: String) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  internal func positive() -> PyObject {
    return self
  }

  // sourcery: pymethod = __neg__
  internal func negative() -> PyObject {
    return Py.newComplex(real: -self.real, imag: -self.imag)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal func abs() -> PyObject {
    let bothFinite = self.real.isFinite && self.imag.isFinite
    guard bothFinite else {
      if self.real.isInfinite {
        return Py.newFloat(Swift.abs(self.real))
      }

      if self.imag.isInfinite {
        return Py.newFloat(Swift.abs(self.imag))
      }

      return Py.newFloat(.nan)
    }

    let result = hypot(self.real, self.imag)
    return Py.newFloat(result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    let real = self.real + other.real
    let imag = self.imag + other.imag
    return .value(Py.newComplex(real: real, imag: imag))
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    return .value(self.sub(left: self.raw, right: other))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    return .value(self.sub(left: other, right: self.raw))
  }

  private func sub(left: Raw, right: Raw) -> PyComplex {
    let real = left.real - right.real
    let imag = left.imag - right.imag
    return Py.newComplex(real: real, imag: imag)
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    return .value(self.mul(left: self.raw, right: other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    return .value(self.mul(left: other, right: self.raw))
  }

  private func mul(left: Raw, right: Raw) -> PyComplex {
    // >>> a = 1 + 2j
    // >>> b = 3 + 4j
    // >>> a * b
    // (-5+10j)
    // because: 1*3 - 2*4 + (1*4 + 2*3)j = 3-8 + (4+3)j = -5 + 10j
    let real = left.real * right.real - left.imag * right.imag
    let imag = left.real * right.imag + left.imag * right.real
    return Py.newComplex(real: real, imag: imag)
  }

  // MARK: - Pow

  internal func pow(exp: PyObject) -> PyResult<PyObject> {
    return self.pow(exp: exp, mod: nil)
  }

  // sourcery: pymethod = __pow__
  internal func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .valueError("complex modulo")
    }

    guard let exp = PyComplex.asComplex(exp) else {
      return .value(Py.notImplemented)
    }

    return self.pow(base: self.raw, exp: exp)
  }

  internal func rpow(base: PyObject) -> PyResult<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .valueError("complex modulo")
    }

    guard let base = PyComplex.asComplex(base) else {
      return .value(Py.notImplemented)
    }

    return self.pow(base: base, exp: self.raw)
  }

  private func isNilOrNone(_ value: PyObject?) -> Bool {
    return value == nil || value is PyNone
  }

  private func pow(base: Raw, exp: Raw) -> PyResult<PyObject> {
    if exp.real.isZero && exp.real.isZero {
      return .value(Py.newComplex(real: 1.0, imag: 0.0))
    }

    if base.real.isZero && base.imag.isZero {
      if exp.real < 0.0 || exp.imag != 0.0 {
        return .valueError("complex zero to negative or complex power")
      }

      return .value(Py.newComplex(real: 0.0, imag: 0.0))
    }

    let vabs = Foundation.hypot(base.real, base.imag)
    var len = Foundation.pow(vabs, exp.real)
    let at = Foundation.atan2(base.imag, base.real)
    var phase = at * exp.real

    if !exp.imag.isZero {
      len /= Foundation.exp(at * exp.imag)
      phase += exp.imag * Foundation.log(vabs)
    }

    let real = len * cos(phase)
    let imag = len * sin(phase)
    return .value(Py.newComplex(real: real, imag: imag))
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  internal func truediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: self.raw, right: other)
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyComplex.asComplex(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: other, right: self.raw)
  }

  private func truediv(left: Raw, right: Raw) -> PyResult<PyObject> {
    // We implement the 'incorrect' version because it is simpler.
    // See comment in 'Py_complex _Py_c_quot(Py_complex a, Py_complex b)' for details.

    let d = right.real * right.real + right.imag * right.imag
    if d.isZero {
      return .zeroDivisionError("complex division by zero")
    }

    let real = (left.real * right.real + left.imag * right.imag) / d
    let imag = (left.imag * right.real - left.real * right.imag) / d
    return .value(Py.newComplex(real: real, imag: imag))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    return .typeError("can't take floor of complex number.")
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
    return self.floordiv(other)
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  internal func mod(_ other: PyObject) -> PyResult<PyObject> {
    return .typeError("can't mod complex numbers.")
  }

  // sourcery: pymethod = __rmod__
  internal func rmod(_ other: PyObject) -> PyResult<PyObject> {
    return self.mod(other)
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  internal func divmod(_ other: PyObject) -> PyResult<PyObject> {
    return .typeError("can't take floor or mod of complex number.")
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
    return self.divmod(other)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["real", "imag"],
    format: "|OO:complex"
  )

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    switch newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let arg0 = binding.optional(at: 0)
      let arg1 = binding.optional(at: 1)
      return PyComplex.pyNew(type: type, arg0: arg0, arg1: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  private class func pyNew(type: PyType,
                           arg0: PyObject?,
                           arg1: PyObject?) -> PyResult<PyObject> {
    // Special-case for a identity.
    if let complex = arg0 as? PyComplex, arg1 == nil {
      return .value(complex)
    }

    let isBuiltin = type === Py.types.complex
    let alloca = isBuiltin ?
      PyComplex.init(type:real:imag:) :
      PyComplexHeap.init(type:real:imag:)

    if let str = arg0 as? PyString {
      guard arg1 == nil else {
        return . typeError("complex() can't take second arg if first is a string")
      }

      return PyComplex.parse(str.value).map { alloca(type, $0.real, $0.imag) }
    }

    guard arg1 as? PyString == nil else {
      return .typeError("complex() second arg can't be a string")
    }

    // If we get this far, then the "real" and "imag" parts should
    // both be treated as numbers, and the constructor should return a
    // complex number equal to (real + imag*1j).
    // Note that we do NOT assume the input to already be in canonical
    // form; the "real" and "imag" parts might themselves be complex numbers:
    // >>> complex.__new__(complex, 0, 5j)
    // (-5+0j)

    let a: Raw
    switch PyComplex.extractComplex(arg0) {
    case let .value(o): a = o
    case let .error(e): return .error(e)
    }

    let b: Raw
    switch PyComplex.extractComplex(arg1) {
    case let .value(o): b = o
    case let .error(e): return .error(e)
    }

    // a + b * j = (a.r + a.i) + (b.r + b.i) * j = (a.r - b.i) + (a.i + b.r)j
    let result = alloca(type, a.real - b.imag, a.imag + b.real)
    return .value(result)
  }

  /// A valid complex string usually takes one of the three forms:
  /// - `<float>`                  - real part only
  /// - `<float>j`                 - imaginary part only
  /// - `<float><signed-float>j`   - real and imaginary parts
  ///
  /// `<float>` represents any numeric string that's accepted by the
  /// float constructor (including 'nan', 'inf', 'infinity', etc.)
  ///
  /// `<signed-float>` is any string of the form `<float>` whose first
  /// character is '+' or '-'
  internal static func parse(_ arg: String) -> PyResult<Raw> {
    // swiftlint:disable:previous cyclomatic_complexity

    let s = arg.trimmingCharacters(in: .whitespacesAndNewlines)
    if s.isEmpty {
      return .valueError("complex() arg is a malformed string")
    }

    var index = s.startIndex
    func isAny(of chars: String) -> Bool {
      return chars.contains(s[index])
    }

    // Skip first '+-'
    if isAny(of: "+-") {
      s.formIndex(after: &index)
    }

    // Move to next '+-' (which would be end of real part)
    while index != s.endIndex, !isAny(of: "+=j") {
      s.formIndex(after: &index)
    }

    guard let real = Double(s[..<index]) else {
      return .valueError("complex() '\(s)' cannot be interpreted as complex")
    }

    // complex('123') -> (123+0j)
    if index == s.endIndex {
      return .value(Raw(real: real, imag: 0.0))
    }

    // complex('123j') -> 123j
    if s[index] == "j" {
      s.formIndex(after: &index) // consume 'j'
      guard index == s.endIndex else {
        return .valueError("complex() arg is a malformed string")
      }

      return .value(Raw(real: 0.0, imag: real))
    }

    // Go up until 'j' (s[index] is one of '+-')
    let imagStart = index
    while index != s.endIndex, s[index] != "j" {
      s.formIndex(after: &index)
    }

    // Missing 'j'
    if index == s.endIndex {
      return .valueError("complex() arg is a malformed string")
    }

    guard let imag = Double(s[imagStart..<index]) else {
      return .valueError("complex() '\(s)' cannot be interpreted as complex")
    }

    s.formIndex(after: &index) // consume 'j'
    guard index == s.endIndex else {
      return .valueError("complex() arg is a malformed string")
    }

    return .value(Raw(real: real, imag: imag))
  }

  private static func extractComplex(_ object: PyObject?) -> PyResult<Raw> {
    guard let object = object else {
      return .value(Raw(real: 0.0, imag: 0.0))
    }

    // Call has to be before 'PyComplex.asComplex', because it can override
    switch PyComplex.callComplex(object) {
    case .value(let o):
      guard let complex = o as? PyComplex else {
        return .typeError("__complex__ returned non-Complex (type \(o.typeName))")
      }
      return .value(Raw(real: complex.real, imag: complex.imag))
    case .missingMethod:
      break // try other possibilities
    case .error(let e), .notCallable(let e):
      return .error(e)
    }

    if let raw = PyComplex.asComplex(object) {
      return .value(raw)
    }

    let t = object.type
    return .typeError("complex() argument must be a string or a number, not '\(t)'")
  }

  private static func callComplex(_ object: PyObject) -> CallMethodResult {
    if let owner = object as? __complex__Owner {
      return .value(owner.asComplex())
    }

    return Py.callMethod(on: object, selector: "__complex__")
  }

  // MARK: - Helpers

  /// Simple light-weight container for 'real' and 'imag'.
  internal struct Raw {
    internal let real: Double
    internal let imag: Double
  }

  private var raw: Raw {
    return Raw(real: self.real, imag: self.imag)
  }

  private static func asComplex(_ object: PyObject) -> Raw? {
    if let pyComplex = object as? PyComplex {
      return Raw(real: pyComplex.real, imag: pyComplex.imag)
    }

    if let pyFloat = object as? PyFloat {
      return Raw(real: pyFloat.value, imag: 0)
    }

    if let pyInt = object as? PyInt {
      return Raw(real: Double(pyInt.value), imag: 0)
    }

    return nil
  }
}
