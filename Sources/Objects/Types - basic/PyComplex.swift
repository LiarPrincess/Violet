import Foundation
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore complexobject

// In CPython:
// Objects -> complexobject.c
// https://docs.python.org/3.7/c-api/complex.html

// sourcery: pytype = complex, isDefault, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyComplex: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    complex(real=0, imag=0)
    --

    Create a complex number from a real part and an optional imaginary part.

    This is equivalent to (real + imag*1j) where imag defaults to 0.
    """

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyComplexLayout()

  internal var realPtr: Ptr<Double> { self.ptr[Self.layout.realOffset] }
  internal var imagPtr: Ptr<Double> { self.ptr[Self.layout.imagOffset] }
  internal var real: Double { self.realPtr.pointee }
  internal var imag: Double { self.imagPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, real: Double, imag: Double) {
    self.header.initialize(py, type: type)
    self.realPtr.initialize(to: real)
    self.imagPtr.initialize(to: imag)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyComplex(ptr: ptr)
    let typeName = zelf.typeName
    let flags = zelf.flags
    let real = zelf.real
    let imag = zelf.imag
    return "PyComplex(type: \(typeName), flags: \(flags), real: \(real), imag: \(imag))"
  }
}

/* MARKER

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    if let complex = PyCast.asComplex(other) {
      let result = self.real == complex.real && self.imag == complex.imag
      return .value(result)
    }

    if let float = PyCast.asFloat(other) {
      guard self.imag.isZero else {
        return .value(false)
      }

      return FloatCompareHelper.isEqual(left: self.real, right: float)
    }

    if let int = PyCast.asInt(other) {
      guard self.imag.isZero else {
        return .value(false)
      }

      return FloatCompareHelper.isEqual(left: self.real, right: int)
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
  internal func hash() -> PyHash {
    let realHash = Py.hasher.hash(self.real)
    let imagHash = Py.hasher.hash(self.imag)

    // If the imaginary part is 0, imagHash is 0 now,
    // so the following returns realHash unchanged.
    // This is important because numbers of different types that
    // compare equal must have the same hash value, so that
    // hash(x + 0*j) must equal hash(x).

    // Overflows are acceptable (and surprisingly common).
    let imagHashNeg = Hasher.imag &* imagHash
    return realHash &+ imagHashNeg
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    // Real part is 0: just output the imaginary part and do not include parens.
    if self.real.isZero {
      let imag = self.dimensionRepr(self.imag)
      return imag + "j"
    }

    let sign = self.imag >= 0 ? "+" : ""
    let real = self.dimensionRepr(self.real)
    let imag = self.dimensionRepr(self.imag)
    return "(\(real)\(sign)\(imag)j)"
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
  internal func str() -> String {
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
    switch Self.asComplex(object: other) {
    case .value(let r):
      let real = self.real + r.real
      let imag = self.imag + r.imag
      return .value(Py.newComplex(real: real, imag: imag))
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asComplex(object: other) {
    case .value(let r):
      let result = self.sub(left: self.raw, right: r)
      return .value(result)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asComplex(object: other) {
    case .value(let r):
      let result = self.sub(left: r, right: self.raw)
      return .value(result)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
  }

  private func sub(left: Raw, right: Raw) -> PyComplex {
    let real = left.real - right.real
    let imag = left.imag - right.imag
    return Py.newComplex(real: real, imag: imag)
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asComplex(object: other) {
    case .value(let r):
      let result = self.mul(left: self.raw, right: r)
      return .value(result)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asComplex(object: other) {
    case .value(let r):
      let result = self.mul(left: r, right: self.raw)
      return .value(result)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
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

  // sourcery: pymethod = __pow__
  internal func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard PyCast.isNilOrNone(mod) else {
      return .valueError("complex modulo")
    }

    switch Self.asComplex(object: exp) {
    case .value(let exp):
      return self.pow(base: self.raw, exp: exp)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard PyCast.isNilOrNone(mod) else {
      return .valueError("complex modulo")
    }

    switch Self.asComplex(object: base) {
    case .value(let base):
      return self.pow(base: base, exp: self.raw)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
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
    switch Self.asComplex(object: other) {
    case .value(let r):
      return self.truediv(left: self.raw, right: r)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asComplex(object: other) {
    case .value(let r):
      return self.truediv(left: r, right: self.raw)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .value(Py.notImplemented)
    }
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

  // MARK: - NewArgs

  // sourcery: pymethod = __getnewargs__
  internal func getNewArgs() -> PyTuple {
    let r = Py.newFloat(self.real)
    let i = Py.newFloat(self.imag)
    return Py.newTuple(r, i)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["real", "imag"],
    format: "|OO:complex"
  )

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyComplex> {
    switch self.newArguments.bind(args: args, kwargs: kwargs) {
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
                           arg1: PyObject?) -> PyResult<PyComplex> {
    // Special-case for a identity.
    let arg0Complex = arg0.flatMap(PyCast.asComplex(_:))
    if let complex = arg0Complex, arg1 == nil {
      return .value(complex)
    }

    let arg0String = arg0.flatMap(PyCast.asString(_:))
    if let str = arg0String {
      guard arg1 == nil else {
        return .typeError("complex() can't take second arg if first is a string")
      }

      let parsed = PyComplex.parse(str.value)
      return parsed.map { Self.allocate(type: type, real: $0.real, imag: $0.imag) }
    }

    let arg1IsString = arg1.flatMap(PyCast.isString(_:)) ?? false
    if arg1IsString {
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
    let result = Self.allocate(type: type, real: a.real - b.imag, imag: a.imag + b.real)
    return .value(result)
  }

  private static func allocate(type: PyType, real: Double, imag: Double) -> PyComplex {
    // If this is a builtin then try to re-use interned values
    // (do we even have interned complex?)
    let isBuiltin = type === Py.types.complex
    return isBuiltin ?
      Py.newComplex(real: real, imag: imag) :
      PyMemory.newComplex(type: type, real: real, imag: imag)
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

    // Call has to be before 'Self.asComplex', because it can override
    switch PyComplex.callComplex(object) {
    case .value(let o):
      guard let complex = PyCast.asComplex(o) else {
        return .typeError("__complex__ returned non-Complex (type \(o.typeName))")
      }
      return .value(Raw(real: complex.real, imag: complex.imag))
    case .missingMethod:
      break // try other possibilities
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    switch Self.asComplex(object: object) {
    case .value(let r):
      return .value(r)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      break
    }

    let t = object.type
    let msg = "complex() argument must be a string or a number, not '\(t)'"
    return .typeError(msg)
  }

  private static func callComplex(
    _ object: PyObject
  ) -> PyInstance.CallMethodResult {
    if let result = PyStaticCall.__complex__(object) {
      return .value(result)
    }

    return Py.callMethod(object: object, selector: .__complex__)
  }

  // MARK: - As complex

  /// Simple light-weight stack-allocated container for `real` and `imag`.
  internal struct Raw {
    internal let real: Double
    internal let imag: Double
  }

  internal enum AsComplex {
    case value(Raw)
    case intOverflow(PyInt, PyBaseException)
    case notComplex
  }

  private var raw: Raw {
    return Raw(real: self.real, imag: self.imag)
  }

  private static func asComplex(object: PyObject) -> AsComplex {
    if let complex = PyCast.asComplex(object) {
      let result = Raw(real: complex.real, imag: complex.imag)
      return .value(result)
    }

    if let float = PyCast.asFloat(object) {
      let result = Self.asComplex(float: float)
      return .value(result)
    }

    if let int = PyCast.asInt(object) {
      switch Self.asComplex(int: int) {
      case let .value(r):
        return .value(r)
      case let .overflow(e):
        return .intOverflow(int, e)
      }
    }

    return .notComplex
  }

  internal static func asComplex(float: PyFloat) -> Raw {
    return Raw(real: float.value, imag: 0)
  }

  internal enum IntAsComplex {
    case value(Raw)
    case overflow(PyBaseException)
  }

  internal static func asComplex(int: PyInt) -> IntAsComplex {
    switch PyInt.asDouble(int: int) {
    case let .value(d):
      return .value(Raw(real: d, imag: 0))
    case let .overflow(e):
      return .overflow(e)
    }
  }
}

*/
