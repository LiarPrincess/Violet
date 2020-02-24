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
    let n = self.newString(name)
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
      let msg = "function() qualname must be None or string, not \(t)"
      return .typeError(msg)
    }

    let result = self.newFunction(qualname: qualnameValue,
                                  code: codeValue,
                                  globals: globals)

    return .value(result)
  }

  public func newFunction(qualname: String?,
                          code: PyCode,
                          globals: PyDict) -> PyFunction {
    let module = globals.getItem(id: Ids.name) ?? Py.none

    return PyFunction(
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )
  }
}

// MARK: - Dict

public enum Get__dict__Result {
  case value(PyDict)
  case noDict
  case error(PyBaseException)
}

extension BuiltinFunctions {

  // TODO: This should return 'PyDict'
  public func get__dict__(object: PyObject) -> Get__dict__Result {
    if let owner = object as? __dict__GetterOwner {
      return .value(owner.getDict())
    }

    switch self.getAttribute(object, name: Ids.__dict__) {
    case let .value(object):
      guard let dict = object as? PyDict else {
        let msg = "'__dict__' returned non-dict type '\(object.typeName)'"
        let e = self.newTypeError(msg: msg)
        return .error(e)
      }

      return .value(dict)

    case let .error(e):
      if e.isAttributeError {
        return .noDict
      }

      return .error(e)
    }
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

    switch self.callMethod(on: object, selector: "__dir__") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .typeError("object does not provide __dir__")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
