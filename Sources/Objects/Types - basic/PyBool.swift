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
  // Why 'Bool' suffix? See comment at the top of this file.
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

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyBool(ptr: ptr)
    let value = zelf.value
    return "PyBool(type: \(zelf.typeName), flags: \(zelf.flags), value: \(value))"
  }
}

/* MARKER

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func reprBool() -> String {
    // Why 'Bool' suffix? See comment at the top of this file.
    return self.isTrue ? "True" : "False"
  }

  // sourcery: pymethod = __str__
  internal func strBool() -> String {
    // Why 'Bool' suffix? See comment at the top of this file.
    return self.isTrue ? "True" : "False"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClassBool() -> PyType {
    // Why 'Bool' suffix? See comment at the top of this file.
    return self.type
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func andBool(_ other: PyObject) -> PyResult<PyObject> {
    // Why 'Bool' suffix? See comment at the top of this file.
    if let other = PyCast.asBool(other) {
      let result = self.isTrue && other.isTrue
      return .value(Py.newBool(result))
    }

    // Call method from 'int'
    return self.and(other)
  }

  // sourcery: pymethod = __rand__
  internal func randBool(_ other: PyObject) -> PyResult<PyObject> {
    // Why 'Bool' suffix? See comment at the top of this file.
    return self.andBool(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func orBool(_ other: PyObject) -> PyResult<PyObject> {
    // Why 'Bool' suffix? See comment at the top of this file.
    if let other = PyCast.asBool(other) {
      let result = self.isTrue || other.isTrue
      return .value(Py.newBool(result))
    }

    // Call method from 'int'
    return self.or(other)
  }

  // sourcery: pymethod = __ror__
  internal func rorBool(_ other: PyObject) -> PyResult<PyObject> {
    // Why 'Bool' suffix? See comment at the top of this file.
    return self.orBool(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xorBool(_ other: PyObject) -> PyResult<PyObject> {
    // Why 'Bool' suffix? See comment at the top of this file.
    if let other = PyCast.asBool(other) {
      let result = self.isTrue != other.isTrue
      return .value(Py.newBool(result))
    }

    // Call method from 'int'
    return self.xor(other)
  }

  // sourcery: pymethod = __rxor__
  internal func rxorBool(_ other: PyObject) -> PyResult<PyObject> {
    // Why 'Bool' suffix? See comment at the top of this file.
    return self.xorBool(other)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNewBool(type: PyType,
                                 args: [PyObject],
                                 kwargs: PyDict?) -> PyResult<PyBool> {
    // Why 'Bool' suffix? See comment at the top of this file.

    if let e = ArgumentParser.noKwargsOrError(fnName: "bool", kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "bool",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    if args.isEmpty {
      return .value(Py.false)
    }

    return Py.isTrue(object: args[0])
  }
}

*/
