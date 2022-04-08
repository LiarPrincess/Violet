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

  // sourcery: storedProperty
  internal var real: Double { self.realPtr.pointee }
  // sourcery: storedProperty
  internal var imag: Double { self.imagPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, real: Double, imag: Double) {
    self.initializeBase(py, type: type)
    self.realPtr.initialize(to: real)
    self.imagPtr.initialize(to: imag)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyComplex(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "real", value: zelf.real, includeInDescription: true)
    result.append(name: "imag", value: zelf.imag, includeInDescription: true)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py, zelf: PyComplex, other: PyObject) -> CompareResult {
    let real = zelf.real
    let imag = zelf.imag

    if let other = py.cast.asComplex(other) {
      let result = real == other.real && imag == other.imag
      return .value(result)
    }

    if let otherFloat = py.cast.asFloat(other) {
      guard imag.isZero else {
        return .value(false)
      }

      return FloatCompareHelper.isEqual(py, left: real, right: otherFloat.asObject)
    }

    if let otherInt = py.cast.asInt(other) {
      guard imag.isZero else {
        return .value(false)
      }

      return FloatCompareHelper.isEqual(py, left: real, right: otherInt.asObject)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, op: .__lt__)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, op: .__le__)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, op: .__gt__)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, op: .__ge__)
  }

  private static func compareOperation(_ py: Py,
                                       zelf: PyObject,
                                       op: CompareResult.Operation) -> CompareResult {
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, op)
    }

    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    let realHash = py.hasher.hash(zelf.real)
    let imagHash = py.hasher.hash(zelf.imag)

    // If the imaginary part is 0, imagHash is 0 now,
    // so the following returns realHash unchanged.
    // This is important because numbers of different types that
    // compare equal must have the same hash value, so that
    // hash(x + 0*j) must equal hash(x).

    // Overflows are acceptable (and surprisingly common).
    let imagHashNeg = Hasher.imag &* imagHash
    let result = realHash &+ imagHashNeg
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.toString(py, zelf: zelf, fnName: "__repr__")
  }

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.toString(py, zelf: zelf, fnName: "__str__")
  }

  private static func toString(_ py: Py,
                               zelf _zelf: PyObject,
                               fnName: String) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let real = zelf.real
    let imag = zelf.imag

    // Real part is 0: just output the imaginary part and do not include parens.
    if real.isZero {
      let imagDim = Self.dimensionRepr(imag)
      let result = imagDim + "j"
      return PyResult(py, result)
    }

    let sign = imag >= 0 ? "+" : ""
    let realDim = Self.dimensionRepr(real)
    let imagDim = Self.dimensionRepr(imag)
    let result = "(\(realDim)\(sign)\(imagDim)j)"
    return PyResult(py, result)
  }

  private static func dimensionRepr(_ value: Double) -> String {
    let result = String(describing: value)

    // If it is 'int' then remove '.0'
    if result.ends(with: ".0") {
      let withoutDotZero = result.dropLast(2)
      return withoutDotZero.isEmpty ? "0" : String(withoutDotZero)
    }

    return result
  }

  // MARK: - As bool/int/float

  // sourcery: pymethod = __bool__
  internal static func __bool__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__bool__")
    }

    let bothZero = zelf.real.isZero && zelf.imag.isZero
    let result = !bothZero
    return PyResult(py, result)
  }

  // sourcery: pymethod = __int__
  internal static func __int__(_ py: Py, zelf: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__int__")
    }

    return .typeError(py, message: "can't convert complex to int")
  }

  // sourcery: pymethod = __float__
  internal static func __float__(_ py: Py, zelf: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__float__")
    }

    return .typeError(py, message: "can't convert complex to float")
  }

  // MARK: - Imaginary

  // sourcery: pyproperty = real
  internal static func real(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "real")
    }

    let result = zelf.real
    return PyResult(py, result)
  }

  // sourcery: pyproperty = imag
  internal static func imag(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "imag")
    }

    let result = zelf.imag
    return PyResult(py, result)
  }

  // sourcery: pymethod = conjugate
  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal static func conjugate(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.unaryOperation(py, zelf: zelf, fnName: "conjugate", fn: Self.conjugate(_:))
  }

  private static func conjugate(_ raw: Raw) -> Raw {
    return Raw(real: raw.real, imag: -raw.imag)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  internal static func __pos__(_ py: Py, zelf: PyObject) -> PyResult {
    // 'complex' is immutable, so if we are exactly 'complex' (not an subclass),
    // then we can return ourself. (This saves an allocation).
    if py.cast.isExactlyComplex(zelf.asObject) {
      return PyResult(zelf)
    }

    return Self.unaryOperation(py, zelf: zelf, fnName: "__pos__", fn: Self.pos(_:))
  }

  private static func pos(_ raw: Raw) -> Raw {
    return Raw(real: raw.real, imag: raw.imag)
  }

  // sourcery: pymethod = __neg__
  internal static func __neg__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.unaryOperation(py, zelf: zelf, fnName: "__neg__", fn: Self.neg(_:))
  }

  private static func neg(_ raw: Raw) -> Raw {
    return Raw(real: -raw.real, imag: -raw.imag)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal static func __abs__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__abs__")
    }

    let real = zelf.real
    let imag = zelf.imag

    let result: Double
    switch (real.isFinite, imag.isFinite) {
    case (true, true): result = hypot(zelf.real, zelf.imag)
    case (true, _): result = Swift.abs(imag)
    case (_, true): result = Swift.abs(real)
    case (_, _): result = .nan
    }

    return PyResult(py, result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__add__",
                                fn: Self.add(left:right:))
  }

  // sourcery: pymethod = __radd__
  internal static func __radd__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__radd__",
                                fn: Self.add(left:right:))
  }

  private static func add(left: Raw, right: Raw) -> Raw {
    let real = left.real + right.real
    let imag = left.imag + right.imag
    return Raw(real: real, imag: imag)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal static func __sub__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__sub__",
                                fn: Self.sub(left:right:))
  }

  private static func sub(left: Raw, right: Raw) -> Raw {
    let real = left.real - right.real
    let imag = left.imag - right.imag
    return Raw(real: real, imag: imag)
  }

  // sourcery: pymethod = __rsub__
  internal static func __rsub__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rsub__",
                                fn: Self.rsub(left:right:))
  }

  private static func rsub(left: Raw, right: Raw) -> Raw {
    let real = right.real - left.real
    let imag = right.imag - left.imag
    return Raw(real: real, imag: imag)
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal static func __mul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__mul__",
                                fn: Self.mul(left:right:))
  }

  // sourcery: pymethod = __rmul__
  internal static func __rmul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rmul__",
                                fn: Self.mul(left:right:))
  }

  private static func mul(left: Raw, right: Raw) -> Raw {
    // >>> a = 1 + 2j
    // >>> b = 3 + 4j
    // >>> a * b
    // (-5+10j)
    // because: 1*3 - 2*4 + (1*4 + 2*3)j = 3-8 + (4+3)j = -5 + 10j
    let real = left.real * right.real - left.imag * right.imag
    let imag = left.real * right.imag + left.imag * right.real
    return Raw(real: real, imag: imag)
  }

  // MARK: - Pow

  // sourcery: pymethod = __pow__
  internal static func __pow__(_ py: Py,
                               zelf: PyObject,
                               exp: PyObject,
                               mod: PyObject?) -> PyResult {
    return Self.powOperation(py,
                             zelf: zelf,
                             other: exp,
                             mod: mod,
                             fnName: "__pow__",
                             isZelfBase: true)
  }

  // sourcery: pymethod = __rpow__
  internal static func __rpow__(_ py: Py,
                                zelf: PyObject,
                                base: PyObject,
                                mod: PyObject?) -> PyResult {
    return Self.powOperation(py,
                             zelf: zelf,
                             other: base,
                             mod: mod,
                             fnName: "__rpow__",
                             isZelfBase: false)
  }

  // swiftlint:disable function_parameter_count
  private static func powOperation(_ py: Py,
                                   zelf _zelf: PyObject,
                                   other: PyObject,
                                   mod: PyObject?,
                                   fnName: String,
                                   isZelfBase: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard py.cast.isNilOrNone(mod) else {
      return .valueError(py, message: "complex modulo")
    }

    switch Self.asComplex(py, object: other) {
    case .value(let other):
      let base = isZelfBase ? Raw(zelf) : other
      let exp = isZelfBase ? other : Raw(zelf)
      return Self.pow(py, base: base, exp: exp)

    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .notImplemented(py)
    }
  }

  private static func pow(_ py: Py, base: Raw, exp: Raw) -> PyResult {
    if exp.real.isZero && exp.real.isZero {
      return PyResult(py, real: 1.0, imag: 0.0)
    }

    if base.real.isZero && base.imag.isZero {
      if exp.real < 0.0 || exp.imag != 0.0 {
        return .valueError(py, message: "complex zero to negative or complex power")
      }

      return PyResult(py, real: 0.0, imag: 0.0)
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
    return PyResult(py, real: real, imag: imag)
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  internal static func __truediv__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.truedivOperation(py,
                                 zelf: zelf,
                                 other: other,
                                 fnName: "__truediv__",
                                 isZelfLeft: true)
  }

  // sourcery: pymethod = __rtruediv__
  internal static func __rtruediv__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.truedivOperation(py,
                                 zelf: zelf,
                                 other: other,
                                 fnName: "__rtruediv__",
                                 isZelfLeft: false)
  }

  private static func truedivOperation(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject,
                                       fnName: String,
                                       isZelfLeft: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    switch Self.asComplex(py, object: other) {
    case .value(let other):
      let left = isZelfLeft ? Raw(zelf) : other
      let right = isZelfLeft ? other : Raw(zelf)

      // We implement the 'incorrect' version because it is simpler.
      // See comment in 'Py_complex _Py_c_quot(Py_complex a, Py_complex b)' for details.

      let d = right.real * right.real + right.imag * right.imag
      if d.isZero {
        return .zeroDivisionError(py, message: "complex division by zero")
      }

      let real = (left.real * right.real + left.imag * right.imag) / d
      let imag = (left.imag * right.real - left.real * right.imag) / d
      return PyResult(py, real: real, imag: imag)

    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .notImplemented(py)
    }
  }

  // MARK: - Floor div

  private static let floordivError = "can't take floor of complex number."

  // sourcery: pymethod = __floordiv__
  internal static func __floordiv__(_ py: Py,
                                    zelf: PyObject,
                                    other: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__floordiv__")
    }

    return .typeError(py, message: Self.floordivError)
  }

  // sourcery: pymethod = __rfloordiv__
  internal static func __rfloordiv__(_ py: Py,
                                     zelf: PyObject,
                                     other: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__rfloordiv__")
    }

    return .typeError(py, message: Self.floordivError)
  }

  // MARK: - Mod

  private static let modError = "can't mod complex numbers."

  // sourcery: pymethod = __mod__
  internal static func __mod__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__mod__")
    }

    return .typeError(py, message: Self.modError)
  }

  // sourcery: pymethod = __rmod__
  internal static func __rmod__(_ py: Py,
                                zelf: PyObject,
                                other: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__rmod__")
    }

    return .typeError(py, message: Self.modError)
  }

  // MARK: - Div mod

  private static let divmodError = "can't take floor or mod of complex number."

  // sourcery: pymethod = __divmod__
  internal static func __divmod__(_ py: Py,
                                  zelf: PyObject,
                                  other: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__divmod__")
    }

    return .typeError(py, message: Self.divmodError)
  }

  // sourcery: pymethod = __rdivmod__
  internal static func __rdivmod__(_ py: Py,
                                   zelf: PyObject,
                                   other: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__rdivmod__")
    }

    return .typeError(py, message: Self.divmodError)
  }

  // MARK: - NewArgs

  // sourcery: pymethod = __getnewargs__
  internal static func __getnewargs__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getnewargs__")
    }

    let real = py.newFloat(zelf.real)
    let imag = py.newFloat(zelf.imag)
    return PyResult(py, tuple: real.asObject, imag.asObject)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["real", "imag"],
    format: "|OO:complex"
  )

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    switch Self.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let arg0 = binding.optional(at: 0)
      let arg1 = binding.optional(at: 1)
      return Self.__new__(py, type: type, arg0: arg0, arg1: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func __new__(_ py: Py,
                               type: PyType,
                               arg0: PyObject?,
                               arg1: PyObject?) -> PyResult {
    // Special-case for a identity.
    let arg0Complex = arg0.flatMap(py.cast.asComplex(_:))
    if let complex = arg0Complex, arg1 == nil {
      return .value(complex.asObject)
    }

    let arg0String = arg0.flatMap(py.cast.asString(_:))
    if let str = arg0String {
      guard arg1 == nil else {
        return .typeError(py, message: "complex() can't take second arg if first is a string")
      }

      switch Self.new(fromString: str.value) {
      case let .value(raw): return Self.allocate(py, type: type, value: raw)
      case let .valueError(message): return .valueError(py, message: message)
      }
    }

    let arg1IsString = arg1.flatMap(py.cast.isString(_:)) ?? false
    if arg1IsString {
      return .typeError(py, message: "complex() second arg can't be a string")
    }

    // If we get this far, then the "real" and "imag" parts should
    // both be treated as numbers, and the constructor should return a
    // complex number equal to (real + imag*1j).
    // Note that we do NOT assume the input to already be in canonical
    // form; the "real" and "imag" parts might themselves be complex numbers:
    // >>> complex.__new__(complex, 0, 5j)
    // (-5+0j)

    let a: Raw
    switch PyComplex.new(py, fromNumber: arg0) {
    case let .pyComplex(o): a = Raw(o)
    case let .complex(o): a = o
    case let .error(e): return .error(e)
    }

    let b: Raw
    switch PyComplex.new(py, fromNumber: arg1) {
    case let .pyComplex(o): b = Raw(o)
    case let .complex(o): b = o
    case let .error(e): return .error(e)
    }

    // a + b * j = (a.r + a.i) + (b.r + b.i) * j = (a.r - b.i) + (a.i + b.r)j
    let result = Raw(real: a.real - b.imag, imag: a.imag + b.real)
    return Self.allocate(py, type: type, value: result)
  }

  internal static func isBuiltinComplexType(_ py: Py, type: PyType) -> Bool {
    return type === py.types.complex
  }

  private static func allocate(_ py: Py, type: PyType, value: Raw) -> PyResult {
    // If this is a builtin then try to re-use interned values
    // (do we even have interned complex?)
    let isBuiltin = Self.isBuiltinComplexType(py, type: type)
    let result = isBuiltin ?
      py.newComplex(real: value.real, imag: value.imag) :
      py.memory.newComplex(type: type, real: value.real, imag: value.imag)

    return PyResult(result)
  }

  internal enum ParseStringResult {
    case value(Raw)
    case valueError(String)
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
  internal static func new(fromString arg: String) -> ParseStringResult {
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
    while index != s.endIndex, !isAny(of: "+-j") {
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

  private enum NewFromNumber {
    case pyComplex(PyComplex)
    case complex(Raw)
    case error(PyBaseException)
  }

  private static func new(_ py: Py, fromNumber object: PyObject?) -> NewFromNumber {
    guard let object = object else {
      return .complex(Raw(real: 0.0, imag: 0.0))
    }

    // Call has to be before 'Self.asComplex', because it can override
    switch PyComplex.callComplex(py, object: object) {
    case .value(let o):
      guard let complex = py.cast.asComplex(o) else {
        let message = "__complex__ returned non-Complex (type \(o.typeName))"
        let error = py.newTypeError(message: message)
        return .error(error.asBaseException)
      }

      return .pyComplex(complex)

    case .missingMethod:
      break // try other possibilities
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    if let complex = py.cast.asComplex(object) {
      return .pyComplex(complex)
    }

    switch Self.asComplex(py, object: object) {
    case .value(let raw):
      return .complex(raw)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      break
    }

    let message = "complex() argument must be a string or a number, not '\(object.type)'"
    let error = py.newTypeError(message: message)
    return .error(error.asBaseException)
  }

  private static func callComplex(_ py: Py, object: PyObject) -> Py.CallMethodResult {
    if let result = PyStaticCall.__complex__(py, object: object) {
      switch result {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    return py.callMethod(object: object, selector: .__complex__)
  }

  // MARK: - Operations

  /// Simple light-weight stack-allocated container for `real` and `imag`.
  internal struct Raw {
    internal let real: Double
    internal let imag: Double

    fileprivate init(real: Double, imag: Double) {
      self.real = real
      self.imag = imag
    }

    fileprivate init(_ complex: PyComplex) {
      self.real = complex.real
      self.imag = complex.imag
    }
  }

  private static func unaryOperation(_ py: Py,
                                     zelf _zelf: PyObject,
                                     fnName: String,
                                     fn: (Raw) -> Raw) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let zelfRaw = Raw(zelf)
    let result = fn(zelfRaw)
    return PyResult(py, real: result.real, imag: result.imag)
  }

  private static func binaryOperation(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject,
                                      fnName: String,
                                      fn: (Raw, Raw) -> Raw) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    switch Self.asComplex(py, object: other) {
    case .value(let other):
      let zelfRaw = Raw(zelf)
      let result = fn(zelfRaw, other)
      return PyResult(py, real: result.real, imag: result.imag)
    case .intOverflow(_, let e):
      return .error(e)
    case .notComplex:
      return .notImplemented(py)
    }
  }

  // MARK: - As complex

  internal enum AsComplex {
    case value(Raw)
    case intOverflow(PyInt, PyBaseException)
    case notComplex
  }

  private static func asComplex(_ py: Py, object: PyObject) -> AsComplex {
    if let complex = py.cast.asComplex(object) {
      let result = Raw(complex)
      return .value(result)
    }

    if let float = py.cast.asFloat(object) {
      let result = Self.asComplex(float: float)
      return .value(result)
    }

    if let int = py.cast.asInt(object) {
      switch Self.asComplex(py, int: int) {
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

  internal static func asComplex(_ py: Py, int: PyInt) -> IntAsComplex {
    switch PyInt.asDouble(py, int: int) {
    case let .value(d):
      return .value(Raw(real: d, imag: 0))
    case let .overflow(e):
      return .overflow(e)
    }
  }
}
