import VioletBytecode

// swiftlint:disable file_length
// cSpell:ignore funcobject argdefs

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
  internal let __dict__ = Py.newDict()

  override public var description: String {
    let name = self.name.value
    let qualname = self.qualname.value
    return "PyFunction(name: '\(name)', qualname: '\(qualname)')"
  }

  // MARK: - Init

  internal init(qualname: PyString?,
                module: PyObject,
                code: PyCode,
                globals: PyDict) {
    self.name = code.name
    self.qualname = qualname ?? code.name
    self.code = code
    self.module = module

    self.globals = globals
    self.defaults = nil
    self.kwDefaults = nil
    self.closure = nil
    self.annotations = nil

    let firstConstant = code.constants.first
    self.doc = firstConstant.flatMap(PyCast.asString(_:))

    super.init(type: Py.types.function)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("<function \(self.qualname.value) at \(self.ptr)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  internal func getName() -> PyString {
    return self.name
  }

  internal func setName(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .value()
    }

    guard let valueString = PyCast.asString(value) else {
      return .typeError("__name__ must be set to a string object")
    }

    self.name = valueString
    return .value()
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter = setQualname
  internal func getQualname() -> PyString {
    return self.qualname
  }

  internal func setQualname(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .value()
    }

    guard let valueString = PyCast.asString(value) else {
      return .typeError("__qualname__ must be set to a string object")
    }

    self.qualname = valueString
    return .value()
  }

  // MARK: - Defaults

  // sourcery: pyproperty = __defaults__, setter = setDefaults
  internal func getDefaults() -> PyTuple? {
    return self.defaults
  }

  internal func setDefaults(_ object: PyObject) -> PyResult<Void> {
    if object.isNone {
      self.defaults = nil
      return .value()
    }

    if let tuple = PyCast.asTuple(object) {
      self.defaults = tuple
      return .value()
    }

    return .systemError("non-tuple default args")
  }

  // MARK: - Keyword defaults

  // sourcery: pyproperty = __kwdefaults__, setter = setKeywordDefaults
  internal func getKeywordDefaults() -> PyDict? {
    return self.kwDefaults
  }

  internal func setKeywordDefaults(_ object: PyObject) -> PyResult<Void> {
    if object.isNone {
      self.kwDefaults = nil
      return .value()
    }

    guard let dict = PyCast.asDict(object) else {
      return .systemError("non-dict keyword only default args")
    }

    self.kwDefaults = dict
    return .value()
  }

  // MARK: - Closure

  // sourcery: pyproperty = __closure__, setter = setClosure
  internal func getClosure() -> PyTuple? {
    return self.closure
  }

  /// Note that there is not `Python` setter for closure.
  /// It can be only set from `Swift`.
  internal func setClosure(_ object: PyObject) -> PyResult<Void> {
    if object.isNone {
      self.closure = nil
      return .value()
    }

    if let tuple = PyCast.asTuple(object) {
      self.closure = tuple
      return .value()
    }

    return .systemError("expected tuple for closure, got '\(object.typeName)'")
  }

  // MARK: - Globals

  // sourcery: pyproperty = __globals__, setter = setGlobals
  internal func getGlobals() -> PyDict {
    return self.globals
  }

  internal func setGlobals(_ object: PyObject) -> PyResult<Void> {
    if let dict = PyCast.asDict(object) {
      self.globals = dict
      return .value()
    }

    return .systemError("non-dict globals")
  }

  // MARK: - Annotations

  // sourcery: pyproperty = __annotations__, setter = setAnnotations
  internal func getAnnotations() -> PyDict? {
    return self.annotations
  }

  internal func setAnnotations(_ object: PyObject) -> PyResult<Void> {
    if object.isNone {
      self.annotations = nil
      return .value()
    }

    if let dict = PyCast.asDict(object) {
      self.annotations = dict
      return .value()
    }

    return .systemError("non-dict annotations")
  }

  // MARK: - Code

  // sourcery: pyproperty = __code__, setter = setCode
  internal func getCode() -> PyCode {
    return self.code
  }

  internal func setCode(_ object: PyObject) -> PyResult<Void> {
    guard let code = PyCast.asCode(object) else {
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
  internal func getDoc() -> PyString? {
    return self.doc
  }

  internal func setDoc(_ object: PyObject) -> PyResult<Void> {
    if object.isNone {
      self.doc = nil
      return .value()
    }

    if let str = PyCast.asString(object) {
      self.doc = str
      return .value()
    }

    let t = object.typeName
    return .typeError("'__doc__' must be a str not \(t)")
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter = setModule
  internal func getModule() -> PyResult<PyObject> {
    let moduleObject = self.module

    if let module = PyCast.asModule(moduleObject) {
      return module.getName()
    }

    let str = Py.str(object: moduleObject)
    return str.map { $0 as PyObject }
  }

  internal func setModule(_ object: PyObject) -> PyResult<Void> {
    self.module = object
    return .value()
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return .value(self.bind(to: object))
  }

  internal func bind(to object: PyObject) -> PyMethod {
    return PyMemory.newMethod(fn: self, object: object)
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// static PyObject *
  /// function_call(PyObject *func, PyObject *args, PyObject *kwargs)
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    // Caller and callee functions should not share the kwargs dictionary.
    var kwargsCopy: PyDict?
    if let kwargs = kwargs {
      kwargsCopy = kwargs.copy()
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
