import Core
import Bytecode
import Foundation

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension BuiltinFunctions {

  // MARK: - Int

  public func newInt<I: BinaryInteger>(_ value: I) -> PyInt {
    return self.newInt(BigInt(value))
  }

  public func newInt(_ value: Int) -> PyInt {
    return Py.getInterned(value) ?? PyInt(value: value)
  }

  public func newInt(_ value: BigInt) -> PyInt {
    return Py.getInterned(value) ?? PyInt(value: value)
  }

  // MARK: - Bool

  public func newBool(_ value: Bool) -> PyBool {
    return value ? Py.true : Py.false
  }

  public func newBool(_ value: BigInt) -> PyBool {
    return self.newBool(value.isTrue)
  }

  // MARK: - Float

  public func newFloat(_ value: Double) -> PyFloat {
    return PyFloat(value: value)
  }

  // MARK: - Complex

  public func newComplex(real: Double, imag: Double) -> PyComplex {
    return PyComplex(real: real, imag: imag)
  }

  // MARK: - String

  public func newString(_ value: String) -> PyString {
    return value.isEmpty ?
      Py.emptyString :
      PyString(value: value)
  }

  public func newString(_ value: CustomStringConvertible) -> PyString {
    let string = String(describing: value)
    return self.newString(string)
  }

  public func newBytes(_ value: Data) -> PyBytes {
    return PyBytes(value: value)
  }

  public func newByteArray(_ value: Data) -> PyByteArray {
    return PyByteArray(value: value)
  }

  // MARK: - Namespace

  public func newNamespace() -> PyNamespace {
    let dict = self.newDict()
    return self.newNamespace(dict: dict)
  }

  public func newNamespace(dict: PyDict) -> PyNamespace {
    return PyNamespace(dict: dict)
  }

  // MARK: - Dict

  /// Returns the **builtin** (!!!!) `__dict__` instance.
  ///
  /// Extreme edge case: object has `__dict__` attribute:
  /// ```py
  /// >>> class C():
  /// ...     def __init__(self):
  /// ...             self.__dict__ = { 'a': 1 }
  /// ...
  /// >>> c = C()
  /// >>> c.__dict__
  /// {'a': 1}
  /// ```
  /// This is actually `dict` stored as '\_\_dict\_\_' in real '\_\_dict\_\_'.
  /// In such situation we return real '\_\_dict\_\_' (not the user property!).
  internal func get__dict__(object: PyObject) -> PyDict? {
    if let owner = object as? __dict__GetterOwner {
      let result = owner.getDict()
      return result
    }

    return nil
  }

  // MARK: - Id

  // sourcery: pymethod = id
  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  public func id(_ object: PyObject) -> PyInt {
    let id = ObjectIdentifier(object)
    return self.newInt(id.hashValue)
  }

  // MARK: - Dir

  internal static var dirDoc: String {
    return """
    dir([object]) -> list of strings

    If called without an argument, return the names in the current scope.
    Else, return an alphabetized list of names comprising (some of) the attributes
    of the given object, and of attributes reachable from it.
    If the object supplies a method named __dir__, it will be used; otherwise
    the default dir() logic is used and returns:
      for a module object: the module's attributes.
      for a class object:  its attributes, and recursively the attributes
        of its bases.
      for any other object: its attributes, its class's attributes, and
        recursively the attributes of its class's base classes.
    """
  }

  // sourcery: pymethod = dir
  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  public func dir(_ object: PyObject?) -> PyResult<PyObject> {
    if let object = object {
      return self.call__dir__(on: object)
    }

    // TODO: Add '_dir_locals(void)' from 'PyObject_Dir(PyObject *obj)'
    trap("'dir()' is not implemented")
  }

  private func call__dir__(on object: PyObject) -> PyFunctionResult {
    if let owner = object as? __dir__Owner {
      let result = owner.dir()
      return result.asFunctionResult
    }

    switch self.callMethod(object: object, selector: .__dir__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .typeError("object does not provide __dir__")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Is abstract method

  public func isAbstractMethod(object: PyObject) -> PyResult<Bool> {
    if let owner = object as? __isabstractmethod__Owner {
      return owner.isAbstractMethod()
    }

    switch self.getAttribute(object, name: .__isabstractmethod__) {
    case let .value(o):
      return self.isTrueBool(o)
    case let .error(e):
      return .error(e)
    }
  }
}
