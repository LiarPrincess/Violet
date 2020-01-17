import Bytecode

// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = function, default, hasGC
public class PyFunction: PyObject {

  internal static let doc: String = """
    function(code, globals, name=None, argdefs=None, closure=None)
    --

    Create a function object.

    code
    a code object
    globals
    the globals dictionary
    name
    a string that overrides the name from the code object
    argdefs
    a tuple that specifies the default argument values
    closure
    a tuple that supplies the bindings for free variables
    """

  /// The __name__ attribute, a string object
  internal var name: String
  /// The qualified name
  internal var qualname: String
  /// The __doc__ attribute, can be anything
  internal let doc: String?
  /// The __dict__ attribute, a dict or NULL
  internal let attributes = Attributes()
  /// The __module__ attribute, can be anything
  internal let module: PyObject
  /// A code object, the __code__ attribute
  internal let code: PyCode

  internal let globals: Attributes
  internal let defaults: PyTuple?
  internal let kwdefaults: PyDict?
  internal let closure: PyTuple?

  internal init(qualname: String?,
                code: PyCode,
                globals: Attributes) {
    self.name = code.codeObject.name
    self.qualname = qualname ?? code.codeObject.name
    self.code = code

    // __module__: If module name is in globals, use it. Otherwise, use None.
    self.module = globals["__name__"] ?? Py.none

    self.globals = globals
    self.defaults = nil
    self.kwdefaults = nil
    self.closure = nil

    switch code.codeObject.constants.first {
    case let .some(.string(s)): self.doc = s
    default: self.doc = nil
    }

    super.init(type: Py.types.function)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("<function \(self.qualname) at \(self.ptrString)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  internal func getName() -> String {
    return self.name
  }

  internal func setName(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .value()
    }

    guard let valueString = value as? PyString else {
      return .typeError("__name__ must be set to a string object")
    }

    self.name = valueString.value
    return .value()
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter = setQualname
  internal func getQualname() -> String {
    return self.qualname
  }

  internal func setQualname(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .value()
    }

    guard let valueString = value as? PyString else {
      return .typeError("__qualname__ must be set to a string object")
    }

    self.qualname = valueString.value
    return .value()
  }

  // MARK: - Code

  // sourcery: pyproperty = __code__
  internal func getCode() -> PyCode {
    return self.code
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__
  internal func getDoc() -> PyResult<PyObject> {
    guard let doc = self.doc else {
      return .value(Py.none)
    }

    return .value(Py.newString(doc))
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__
  internal func getModule() -> PyResult<String> {
    if let module = self.module as? PyModule {
      return module.name
    }

    return Py.strValue(self.module)
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> Attributes {
    return self.attributes
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject) -> PyResult<PyObject> {
    if object is PyNone {
      return .value(self)
    }

    return .value(PyMethod(fn: self, object: object))
  }
}
