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

  // MARK: - Init

  internal init(_ context: PyContext, real: Double, imag: Double) {
    self.real = real
    self.imag = imag
    super.init(type: context.builtins.types.complex)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, real: Double, imag: Double) {
    self.real = real
    self.imag = imag
    super.init(type: type)
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
    let realHash = self.hasher.hash(self.real)
    let imagHash = self.hasher.hash(self.imag)
    return .value(realHash + Hasher.imag * imagHash)
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
    return AttributeHelper.getAttribute(from: self, name: name)
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

    let zelf = Raw(real: self.real, imag: self.imag)
    return .value(self.sub(left: zelf, right: other))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = Raw(real: self.real, imag: self.imag)
    return .value(self.sub(left: other, right: zelf))
  }

  private func sub(left: Raw, right: Raw) -> PyComplex {
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

    let zelf = Raw(real: self.real, imag: self.imag)
    return .value(self.mul(left: zelf, right: other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = Raw(real: self.real, imag: self.imag)
    return .value(self.mul(left: other, right: zelf))
  }

  private func mul(left: Raw, right: Raw) -> PyComplex {
    return self.builtins.newComplex(
      real: left.real * right.real - left.imag * right.imag,
      imag: left.real * right.imag + left.imag * right.real
    )
  }

  // MARK: - Pow

  internal func pow(exp: PyObject) -> PyResultOrNot<PyObject> {
    return self.pow(exp: exp, mod: nil)
  }

  // sourcery: pymethod = __pow__
  internal func pow(exp: PyObject, mod: PyObject?) -> PyResultOrNot<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .valueError("complex modulo")
    }

    guard let exp = self.asComplex(exp) else {
      return .notImplemented
    }

    let zelf = Raw(real: self.real, imag: self.imag)
    return self.pow(base: zelf, exp: exp)
  }

  internal func rpow(base: PyObject) -> PyResultOrNot<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(base: PyObject, mod: PyObject?) -> PyResultOrNot<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .valueError("complex modulo")
    }

    guard let base = self.asComplex(base) else {
      return .notImplemented
    }

    let zelf = Raw(real: self.real, imag: self.imag)
    return self.pow(base: base, exp: zelf)
  }

  private func isNilOrNone(_ value: PyObject?) -> Bool {
    return value == nil || value is PyNone
  }

  private func pow(base: Raw, exp: Raw) -> PyResultOrNot<PyObject> {
    if exp.real.isZero && exp.real.isZero {
      return .value(self.builtins.newComplex(real: 1.0, imag: 0.0))
    }

    if base.real.isZero && base.imag.isZero {
      if exp.real < 0.0 || exp.imag != 0.0 {
        return .valueError("complex zero to negative or complex power")
      }

      return .value(self.builtins.newComplex(real: 0.0, imag: 0.0))
    }

    let vabs = Foundation.hypot(base.real, base.imag)
    var len = Foundation.pow(vabs, exp.real)
    let at = Foundation.atan2(base.imag, base.real)
    var phase = at * exp.real

    if !exp.imag.isZero {
      len /= Foundation.exp(at * exp.imag)
      phase += exp.imag * Foundation.log(vabs)
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
  internal func truediv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = Raw(real: self.real, imag: self.imag)
    return self.truediv(left: zelf, right: other)
      .flatMap { PyResultOrNot<PyObject>.value($0) }
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtruediv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asComplex(other) else {
      return .notImplemented
    }

    let zelf = Raw(real: self.real, imag: self.imag)
    return self.truediv(left: other, right: zelf)
      .flatMap { PyResultOrNot<PyObject>.value($0) }
  }

  private func truediv(left: Raw, right: Raw) -> PyResultOrNot<PyComplex> {
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
  internal func floordiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return .typeError("can't take floor of complex number.")
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloordiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.floordiv(other)
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
  internal func divmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return .typeError("can't take floor or mod of complex number.")
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.divmod(other)
  }

  // MARK: - Python new

  private static let newArgumentsParser = ArgumentParser.createOrFatal(
    arguments: ["real", "imag"],
    format: "|OO:complex"
  )

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    switch newArgumentsParser.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 2, "Invalid argument count returned from parser.")
      let arg0 = bind.count >= 1 ? bind[0] : nil
      let arg1 = bind.count >= 2 ? bind[1] : nil
      return PyComplex.pyNew(type: type, arg0: arg0, arg1: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  private class func pyNew(type: PyType,
                           arg0: PyObject?,
                           arg1: PyObject?) -> PyResult<PyObject> {
    // Special-case for a single argument when type(arg) is complex.
    if let complex = arg0 as? PyComplex, arg1 == nil {
      return .value(complex)
    }

    let isBuiltin = type === type.builtins.complex
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

  internal struct Raw {
    internal let real: Double
    internal let imag: Double
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
    // swiftlint:disable:previous cyclomatic_complexity function_body_length

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

    print("imag", s[imagStart..<index])
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

    switch PyComplex.callComplex(object) {
    case .value(let o):
      guard let complex = o as? PyComplex else {
        return .typeError("__complex__ returned non-Complex (type \(o.typeName))")
      }
      return .value(Raw(real: complex.real, imag: complex.imag))
    case .notImplemented:
      break // try other possibilities
    case .error(let e):
      return .error(e)
    }

    if let int = object as? PyInt {
      return .value(Raw(real: Double(int.value), imag: 0.0))
    }

    if let float = object as? PyFloat {
      return .value(Raw(real: float.value, imag: 0.0))
    }

    let t = object.type
    return .typeError("complex() argument must be a string or a number, not '\(t)'")
  }

  private static func callComplex(_ object: PyObject) -> PyResultOrNot<PyObject> {
    if let owner = object as? __complex__Owner {
      return owner.asComplex().map { $0 as PyObject }.asResultOrNot
    }

    switch object.builtins.callMethod(on: object, selector: "__complex__") {
    case .value(let o):
      return .value(o)
    case .notImplemented, .missingMethod:
      return .notImplemented
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  private func asComplex(_ object: PyObject) -> Raw? {
    if let pyFloat = object as? PyFloat {
      return Raw(real: pyFloat.value, imag: 0)
    }

    if let pyInt = object as? PyInt {
      return Raw(real: Double(pyInt.value), imag: 0)
    }

    return nil
  }
}
