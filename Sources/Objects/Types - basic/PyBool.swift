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
    The class bool is a subclass of the class int, and cannot be subclassed
    """

  // sourcery: includeInLayout
  internal var value: BigInt { self.valuePtr.pointee }

  internal var isTrue: Bool {
    return self.value.isTrue
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, value: Bool) {
    self.header.initialize(py, type: type)
    self.valuePtr.initialize(to: value ? 1 : 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyBool(ptr: ptr)
    let value = zelf.value
    return "PyBool(type: \(zelf.typeName), flags: \(zelf.flags), value: \(value))"
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    return Self.toString(py, zelf: zelf, fnName: "__repr__")
  }

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    return Self.toString(py, zelf: zelf, fnName: "__str__")
  }

  private static func toString(_ py: Py,
                               zelf: PyObject,
                               fnName: String) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, fnName)
    }

    let result = zelf.isTrue ?
    py.intern(string: "True") :
    py.intern(string: "False")

    return .value(result.asObject)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal static func __and__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult<PyObject> {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__and__",
                                fn: { $0 && $1 },
                                intFn: PyInt.__add__(_:zelf:other:))
  }

  // sourcery: pymethod = __rand__
  internal static func __rand__(_ py: Py,
                                zelf: PyObject,
                                other: PyObject) -> PyResult<PyObject> {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rand__",
                                fn: { $1 && $0 },
                                intFn: PyInt.__radd__(_:zelf:other:))
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal static func __or__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__or__",
                                fn: { $0 || $1 },
                                intFn: PyInt.__or__(_:zelf:other:))
  }

  // sourcery: pymethod = __ror__
  internal static func __ror__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult<PyObject> {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__ror__",
                                fn: { $1 || $0 },
                                intFn: PyInt.__ror__(_:zelf:other:))
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal static func __xor__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult<PyObject> {
    return Self.binaryOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__xor__",
                                fn: { $0 != $1 },
                                intFn: PyInt.__xor__(_:zelf:other:))
  }

  // sourcery: pymethod = __rxor__
  internal static func __rxor__(_ py: Py,
                                zelf: PyObject,
                                other: PyObject) -> PyResult<PyObject> {
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
                               kwargs: PyDict?) -> PyResult<PyObject> {
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
      let result = py.false
      return .value(result.asObject)
    }

    let result = py.isTrue(object: args[0])
    return result.asObject
  }

  // MARK: - Helpers

  private static func binaryOperation(
    _ py: Py,
    zelf: PyObject,
    other: PyObject,
    fnName: String,
    fn: (Bool, Bool) -> Bool,
    intFn: (Py, PyObject, PyObject) -> PyResult<PyObject>
  ) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, fnName)
    }

    guard let other = py.cast.asBool(other) else {
      return intFn(py, zelf.asObject, other)
    }

    let result = fn(zelf.isTrue, other.isTrue)
    return result.toResult(py)
  }

  private static func castZelf(_ py: Py, _ object: PyObject) -> PyBool? {
    return py.cast.asBool(object)
  }

  private static func invalidZelfArgument(_ py: Py,
                                          _ object: PyObject,
                                          _ fnName: String) -> PyResult<PyObject> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: "bool",
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
