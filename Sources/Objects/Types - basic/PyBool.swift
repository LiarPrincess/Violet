import BigInt
import VioletCore

// cSpell:ignore boolobject

// In CPython:
// Objects -> boolobject.c
// https://docs.python.org/3.7/c-api/bool.html

// !!! IMPORTANT !!!
// 'PyBool' is a special (and unusual) place where we override 'pymethod' from 'PyInt'
// But we can't do that because Swift would always call the
// overridden function (even if we did 'PyInt.fn(boolInstance)').
// So, we have to introduce separate selectors for each override.

extension BigInt {
  internal var isTrue: Bool {
    return !self.isZero
  }
}

// sourcery: pytype = bool, default
/// Booleans in Python are implemented as a subclass of integers.
/// There are only two booleans, Py_False and Py_True.
/// As such, the normal creation and deletion functions don’t apply to booleans.
public class PyBool: PyInt {

  // sourcery: pytypedoc
  internal static let boolDoc = """
    bool(x) -> bool

    Returns True when the argument x is true, False otherwise.
    The builtins True and False are the only two instances of the class bool.
    The class bool is a subclass of the class int, and cannot be subclassed
    """

  override public var description: String {
    return "PyBool(\(self.value.isTrue))"
  }

  // MARK: - Init

  internal init(value: Bool) {
    // 'bool' has only 2 instances and can't be subclassed,
    // so we can just pass the correct type to 'super.init'.
    super.init(type: Py.types.bool, value: BigInt(value ? 1 : 0))
  }

  // MARK: - String

  override public func repr() -> PyResult<String> {
    return Self.repr(bool: self)
  }

  // sourcery: pymethod = __repr__
  internal static func repr(bool zelf: PyBool) -> PyResult<String> {
    // Why static? See comment at the top of this file.
    let result = zelf.value.isTrue ? "True" : "False"
    return .value(result)
  }

  override public func str() -> PyResult<String> {
    return Self.str(bool: self)
  }

  // sourcery: pymethod = __str__
  internal static func str(bool zelf: PyBool) -> PyResult<String> {
    // Why static? See comment at the top of this file.
    return Self.repr(bool: zelf)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  override public func getClass() -> PyType {
    return self.type
  }

  // MARK: - And

  override public func and(_ other: PyObject) -> PyResult<PyObject> {
    return Self.and(bool: self, other: other)
  }

  // sourcery: pymethod = __and__
  internal static func and(bool zelf: PyBool,
                           other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of this file.
    if let other = PyCast.asBool(other) {
      let result = zelf.value.isTrue && other.value.isTrue
      return .value(Py.newBool(result))
    }

    return Self.and(int: zelf, other: other)
  }

  override public func rand(_ other: PyObject) -> PyResult<PyObject> {
    return Self.rand(bool: self, other: other)
  }

  // sourcery: pymethod = __rand__
  internal static func rand(bool zelf: PyBool,
                            other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of this file.
    return Self.and(bool: zelf, other: other)
  }

  // MARK: - Or

  override public func or(_ other: PyObject) -> PyResult<PyObject> {
    return Self.or(bool: self, other: other)
  }

  // sourcery: pymethod = __or__
  internal static func or(bool zelf: PyBool,
                          other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of this file.
    if let other = PyCast.asBool(other) {
      let result = zelf.value.isTrue || other.value.isTrue
      return .value(Py.newBool(result))
    }

    return Self.or(int: zelf, other: other)
  }

  override public func ror(_ other: PyObject) -> PyResult<PyObject> {
    return Self.ror(bool: self, other: other)
  }

  // sourcery: pymethod = __ror__
  internal static func ror(bool zelf: PyBool,
                           other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of this file.
    return Self.or(bool: zelf, other: other)
  }

  // MARK: - Xor

  override public func xor(_ other: PyObject) -> PyResult<PyObject> {
    return Self.xor(bool: self, other: other)
  }

  // sourcery: pymethod = __xor__
  internal static func xor(bool zelf: PyBool,
                           other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of this file.
    if let other = PyCast.asBool(other) {
      let result = zelf.value.isTrue != other.value.isTrue
      return .value(Py.newBool(result))
    }

    return Self.xor(int: zelf, other: other)
  }

  override public func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return Self.rxor(bool: self, other: other)
  }

  // sourcery: pymethod = __rxor__
  internal static func rxor(bool zelf: PyBool,
                            other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of this file.
    return Self.xor(bool: zelf, other: other)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyBoolNew(type: PyType,
                                 args: [PyObject],
                                 kwargs: PyDict?) -> PyResult<PyBool> {
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
