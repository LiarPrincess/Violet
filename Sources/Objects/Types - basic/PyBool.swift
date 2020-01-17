import Core

// In CPython:
// Objects -> boolobject.c
// https://docs.python.org/3.7/c-api/bool.html

extension BigInt {
  internal var isTrue: Bool {
    return self != 0
  }
}

extension Int {
  internal var isTrue: Bool {
    return self != 0
  }
}

// sourcery: pytype = bool, default
/// Booleans in Python are implemented as a subclass of integers.
/// There are only two booleans, Py_False and Py_True.
/// As such, the normal creation and deletion functions don’t apply to booleans.
public class PyBool: PyInt {

  override internal class var doc: String { return """
    bool(x) -> bool

    Returns True when the argument x is true, False otherwise.
    The builtins True and False are the only two instances of the class bool.
    The class bool is a subclass of the class int, and cannot be subclassed
    """
  }

  // MARK: - Init

  internal init(value: Bool) {
    super.init(type: Py.types.bool, value: BigInt(value ? 1 : 0))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  override internal func repr() -> PyResult<String> {
    return .value(self.value.isTrue ? "True" : "False")
  }

  // sourcery: pymethod = __str__
  override internal func str() -> PyResult<String> {
    return self.repr()
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  override internal func and(_ other: PyObject) -> PyResult<PyObject> {
    if let other = other as? PyBool {
      let result = self.value.isTrue && other.value.isTrue
      return .value(Py.newBool(result))
    }

    return super.and(other)
  }

  // sourcery: pymethod = __rand__
  override internal func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  override internal func or(_ other: PyObject) -> PyResult<PyObject> {
    if let other = other as? PyBool {
      let result = self.value.isTrue || other.value.isTrue
      return .value(Py.newBool(result))
    }

    return super.or(other)
  }

  // sourcery: pymethod = __ror__
  override internal func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  override internal func xor(_ other: PyObject) -> PyResult<PyObject> {
    if let other = other as? PyBool {
      let result = self.value.isTrue != other.value.isTrue
      return .value(Py.newBool(result))
    }

    return super.xor(other)
  }

  // sourcery: pymethod = __rxor__
  override internal func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDictData?) -> PyResult<PyObject> {
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

    return Py.isTrue(args[0]).map { $0 as PyObject }
  }
}
