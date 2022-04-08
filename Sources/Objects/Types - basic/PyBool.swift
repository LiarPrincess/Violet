import BigInt
import VioletCore

// cSpell:ignore boolobject

// In CPython:
// Objects -> boolobject.c
// https://docs.python.org/3.7/c-api/bool.html

extension BigInt {
  internal var isTrue: Bool {
    return !self.isZero
  }
}

// sourcery: pytype = bool, pybase = int, isDefault, isLongSubclass
/// Booleans in Python are implemented as a subclass of integers.
///
/// There are only two booleans, `False` and `True`.
public struct PyBool: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    bool(x) -> bool

    Returns True when the argument x is true, False otherwise.
    The builtins True and False are the only two instances of the class bool.
    The class bool is a subclass of the class int, and cannot be subclassed.
    """

  // 'self.value' property will be automatically generated from 'PyInt' properties.

  internal var isTrue: Bool {
    return self.value.isTrue
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, value: Bool) {
    let valueBigInt: BigInt = value ? 1 : 0
    self.initializeBase(py, type: type, value: valueBigInt)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyBool(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "value", value: zelf.value, includeInDescription: true)
    result.append(name: "isTrue", value: zelf.isTrue, includeInDescription: true)
    return result
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

  private static func toString(_ py: Py, zelf _zelf: PyObject, fnName: String) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let result = zelf.isTrue ? "True" : "False"
    return PyResult(py, interned: result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal static func __and__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__and__",
                                fn: { $0 && $1 },
                                intFn: PyInt.__add__(_:zelf:other:))
  }

  // sourcery: pymethod = __rand__
  internal static func __rand__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rand__",
                                fn: { $1 && $0 },
                                intFn: PyInt.__radd__(_:zelf:other:))
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal static func __or__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__or__",
                                fn: { $0 || $1 },
                                intFn: PyInt.__or__(_:zelf:other:))
  }

  // sourcery: pymethod = __ror__
  internal static func __ror__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__ror__",
                                fn: { $1 || $0 },
                                intFn: PyInt.__ror__(_:zelf:other:))
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal static func __xor__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__xor__",
                                fn: { $0 != $1 },
                                intFn: PyInt.__xor__(_:zelf:other:))
  }

  // sourcery: pymethod = __rxor__
  internal static func __rxor__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rxor__",
                                fn: { $1 != $0 },
                                intFn: PyInt.__rxor__(_:zelf:other:))
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    if let e = ArgumentParser.noKwargsOrError(py, fnName: "bool", kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: "bool",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    if args.isEmpty {
      return PyResult(py, false)
    }

    switch py.isTrueBool(object: args[0]) {
    case let .value(isTrue):
      return PyResult(py, isTrue)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Operations

  // swiftlint:disable function_parameter_count
  private static func binaryOperation(
    _ py: Py,
    zelf _zelf: PyObject,
    other _other: PyObject,
    fnName: String,
    fn: (Bool, Bool) -> Bool,
    intFn: (Py, PyObject, PyObject) -> PyResult
  ) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, _other) else {
      return intFn(py, zelf.asObject, _other)
    }

    let result = fn(zelf.isTrue, other.isTrue)
    return PyResult(py, result)
  }
}
