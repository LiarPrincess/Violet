import Bytecode

// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = function
internal final class PyFunction: PyObject, AttributesOwner {

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
  internal var _name: String
  /// The qualified name
  internal var _qualname: String
  /// The __doc__ attribute, can be anything
  internal let _doc: String?
  /// The __dict__ attribute, a dict or NULL
  internal let _attributes = Attributes()
  /// The __module__ attribute, can be anything
  internal let _module: PyObject
  /// A code object, the __code__ attribute
  internal let _code: PyCode

  internal let _globals: Attributes
  internal let _defaults: PyTuple?
  internal let _kwdefaults: PyDict?
  internal let _closure: PyTuple?

  internal init(_ context: PyContext,
                qualname: String?,
                code: PyCode,
                globals: Attributes) {
    self._name = code._code.name
    self._qualname = qualname ?? code._code.name
    self._code = code

    // __module__: If module name is in globals, use it. Otherwise, use None.
    self._module = globals["__name__"] ?? context.none

    self._globals = globals
    self._defaults = nil
    self._kwdefaults = nil
    self._closure = nil

    switch code._code.constants.first {
    case let .some(.string(s)): self._doc = s
    default: self._doc = nil
    }

    super.init(type: context.types.function)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("<function \(self._qualname) at \(self.ptrString)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Properties

  // sourcery: pyproperty = __name__, setter = setName
  internal func getName() -> String {
    return self._name
  }

  internal func setName(_ value: PyObject) -> PyResult<()> {
    guard let value = value as? PyString else {
      return .error(.typeError("__name__ must be set to a string object"))
    }

    self._name = value.value
    return .value()
  }

  // sourcery: pyproperty = __qualname__, setter = setQualname
  internal func getQualname() -> String {
    return self._qualname
  }

  internal func setQualname(_ value: PyObject) -> PyResult<()> {
    guard let value = value as? PyString else {
      return .error(.typeError("__qualname__ must be set to a string object"))
    }

    self._qualname = value.value
    return .value()
  }

  // sourcery: pyproperty = __code__
  internal func getCode() -> PyCode {
    return self._code
  }

  // sourcery: pyproperty = __doc__
  internal func getDoc() -> String? {
    return self._doc
  }

  // sourcery: pyproperty = __module__
  internal func getModule() -> String {
    if let module = self._module as? PyModule {
      return module.name
    }

    return self.context._str(value: self._module)
  }

  // sourcery: pyproperty = __dict__
  internal func dict() -> Attributes {
    return self._attributes
  }

  // MARK: - Call

  // sourcery: pymethod = __get__
  internal func get(object: PyObject) -> PyResult<PyObject> {
    if object is PyNone {
      return .value(self)
    }

    return .value(PyMethod(context, func: self, zelf: object))
  }
}
