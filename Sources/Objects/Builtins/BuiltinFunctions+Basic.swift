import Core
import Bytecode
import Foundation

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension BuiltinFunctions {

  // MARK: - Int

  public func newInt(_ value: UInt8) -> PyInt {
    return self.newInt(Int(value))
  }

  public func newInt(_ value: UInt32) -> PyInt {
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

  // MARK: - Module

  public func newModule(name: String, doc: String? = nil) -> PyModule {
    let n = Py.getInterned(name)
    let d = doc.map(self.newString)
    return self.newModule(name: n, doc: d)
  }

  public func newModule(name: PyObject, doc: PyObject? = nil) -> PyModule {
    return PyModule(name: name, doc: doc)
  }

  // MARK: - Code

  public func newCode(code: CodeObject) -> PyCode {
    return PyCode(code: code)
  }

  // MARK: - Function

  public func newFunction(qualname: PyObject,
                          code: PyObject,
                          globals: PyDict) -> PyResult<PyFunction> {
    guard let codeValue = code as? PyCode else {
      let t = code.typeName
      return .typeError("function() code must be code, not \(t)")
    }

    let qualnameValue: String?
    if qualname is PyNone {
      qualnameValue = nil
    } else if let q = qualname as? PyString {
      qualnameValue = q.value
    } else {
      let t = qualname.typeName
      return .typeError("function() qualname must be None or string, not \(t)")
    }

    let result = self.newFunction(qualname: qualnameValue,
                                  code: codeValue,
                                  globals: globals)

    return .value(result)
  }

  public func newFunction(qualname: String?,
                          code: PyCode,
                          globals: PyDict) -> PyFunction {
    let module = globals.get(id: .__name__) ?? Py.none

    return PyFunction(
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )
  }

  // MARK: - Method

  public func newMethod(fn: PyObject, object: PyObject) -> PyResult<PyMethod> {
    guard let f = fn as? PyFunction else {
      return .typeError("method() func must be function, not \(fn.typeName)")
    }

    return self.newMethod(fn: f, object: object)
  }

  public func newMethod(fn: PyFunction, object: PyObject) -> PyMethod {
    return PyMethod(fn: fn, object: object)
  }

  // MARK: - Cell

  public func newCell(content: PyObject?) -> PyCell {
    return PyCell(content: content)
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
  public func get__dict__(object: PyObject) -> PyDict? {
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

    switch self.callMethod(on: object, selector: .__dir__) {
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
