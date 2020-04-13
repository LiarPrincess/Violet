import Bytecode

// In CPython:
// Objects -> funcobject.c

// swiftlint:disable file_length

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

  /// The `__name__` attribute, a string object
  internal private(set) var name: PyString
  /// The qualified name
  internal private(set) var qualname: PyString
  /// The `__doc__` attribute
  internal private(set) var doc: PyString?
  /// The `__module__` attribute, can be anything
  internal private(set) var module: PyObject
  /// A code object, the `__code__` attribute
  internal private(set) var code: PyCode

  internal private(set) var globals: PyDict
  internal private(set) var defaults: PyTuple?
  internal private(set) var kwDefaults: PyDict?
  internal private(set) var closure: PyTuple?
  internal private(set) var annotations: PyDict?

  /// The `__dict__` attribute, a dict or NULL
  internal let __dict__ = PyDict()

  override public var description: String {
    let name = self.name.value
    let qualname = self.qualname.value
    return "PyFunction(name: '\(name)', qualname: '\(qualname)')"
  }

  // MARK: - Init

  internal init(qualname: String?,
                module: PyObject,
                code: PyCode,
                globals: PyDict) {
    self.name = code.name
    self.qualname = qualname.map(Py.intern) ?? code.name
    self.code = code
    self.module = module

    self.globals = globals
    self.defaults = nil
    self.kwDefaults = nil
    self.closure = nil
    self.annotations = nil

    switch code.constants.first {
    case .some(.string(let s)): self.doc = s
    default: self.doc = nil
    }

    super.init(type: Py.types.function)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    return .value("<function \(self.qualname) at \(self.ptr)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  public func getName() -> PyString {
    return self.name
  }

  public func setName(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .value()
    }

    guard let valueString = value as? PyString else {
      return .typeError("__name__ must be set to a string object")
    }

    self.name = valueString
    return .value()
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter = setQualname
  public func getQualname() -> PyString {
    return self.qualname
  }

  public func setQualname(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .value()
    }

    guard let valueString = value as? PyString else {
      return .typeError("__qualname__ must be set to a string object")
    }

    self.qualname = valueString
    return .value()
  }

  // MARK: - Defaults

  // sourcery: pyproperty = __defaults__, setter = setDefaults
  public func getDefaults() -> PyObject {
    return self.defaults ?? Py.none
  }

  public func setDefaults(_ object: PyObject) -> PyResult<()> {
    if object.isNone {
      self.defaults = nil
      return .value()
    }

    if let tuple = object as? PyTuple {
      self.defaults = tuple
      return .value()
    }

    return .systemError("non-tuple default args")
  }

  // MARK: - Keyword defaults

  // sourcery: pyproperty = __kwdefaults__, setter = setKeywordDefaults
  public func getKeywordDefaults() -> PyObject {
    return self.kwDefaults ?? Py.none
  }

  public func setKeywordDefaults(_ object: PyObject) -> PyResult<()> {
    if object.isNone {
      self.kwDefaults = nil
      return .value()
    }

    guard let dict = object as? PyDict else {
      return .systemError("non-dict keyword only default args")
    }

    self.kwDefaults = dict
    return .value()
  }

  // MARK: - Closure

  // sourcery: pyproperty = __closure__, setter = setClosure
  public func getClosure() -> PyObject {
    return self.closure ?? Py.none
  }

  /// Note that there is not `Python` setter for closure.
  /// It can be only set from `Swift`.
  public func setClosure(_ object: PyObject) -> PyResult<()> {
    if object.isNone {
      self.closure = nil
      return .value()
    }

    if let tuple = object as? PyTuple {
      self.closure = tuple
      return .value()
    }

    return .systemError("expected tuple for closure, got '\(object.typeName)'")
  }

  // MARK: - Globals

  // sourcery: pyproperty = __globals__, setter = setGlobals
  public func getGlobals() -> PyDict {
    return self.globals
  }

  public func setGlobals(_ object: PyObject) -> PyResult<()> {
    if let dict = object as? PyDict {
      self.globals = dict
      return .value()
    }

    return .systemError("non-dict globals")
  }

  // MARK: - Annotations

  // sourcery: pyproperty = __annotations__, setter = setAnnotations
  public func getAnnotations() -> PyObject {
    return self.closure ?? Py.none
  }

  public func setAnnotations(_ object: PyObject) -> PyResult<()> {
    if object.isNone {
      self.annotations = nil
      return .value()
    }

    if let dict = object as? PyDict {
      self.annotations = dict
      return .value()
    }

    return .systemError("non-dict annotations")
  }

  // MARK: - Code

  // sourcery: pyproperty = __code__, setter = setCode
  public func getCode() -> PyCode {
    return self.code
  }

  public func setCode(_ object: PyObject) -> PyResult<()> {
    guard let code = object as? PyCode else {
      return .typeError("__code__ must be set to a code object")
    }

    let nFree = code.freeVariableCount
    let nClosure = self.closure?.data.count ?? 0

    if nClosure != nFree {
      let name = self.name.value
      let msg = "\(name)() requires a code object with \(nClosure) free vars, not \(nFree)"
      return .valueError(msg)
    }

    self.code = code
    return .value()
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter = setDoc
  public func getDoc() -> PyResult<PyObject> {
    guard let doc = self.doc else {
      return .value(Py.none)
    }

    return .value(doc)
  }

  public func setDoc(_ object: PyObject) -> PyResult<()> {
    if object.isNone {
      self.doc = nil
      return .value()
    }

    if let str = object as? PyString {
      self.doc = str
      return .value()
    }

    let t = object.typeName
    return .typeError("'__doc__' must be a str not \(t)")
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter = setModule
  public func getModule() -> PyResult<String> {
    if let module = self.module as? PyModule {
      return module.name
    }

    return Py.strValue(object: self.module)
  }

  public func setModule(_ object: PyObject) -> PyResult<()> {
    self.module = object
    return .value()
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  public func get(object: PyObject, type: PyObject) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return .value(self.bind(to: object))
  }

  public func bind(to object: PyObject) -> PyMethod {
    return PyMethod(fn: self, object: object)
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// static PyObject *
  /// function_call(PyObject *func, PyObject *args, PyObject *kwargs)
  public func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    // Caller and callee functions should not share the kwargs dictionary.
    var kwargsCopy: PyDict?
    if let kwargs = kwargs {
      kwargsCopy = Py.newDict(data: kwargs.data)
    }

    let argsDefaults = self.defaults?.elements ?? []
    let locals = Py.newDict()

    let result = Py.delegate.eval(
      name: self.name,
      qualname: self.qualname,
      code: self.code,

      args: args,
      kwargs: kwargsCopy,
      defaults: argsDefaults,
      kwDefaults: self.kwDefaults,

      globals: self.globals,
      locals: locals,
      closure: self.closure
    )

    return result
  }
}
