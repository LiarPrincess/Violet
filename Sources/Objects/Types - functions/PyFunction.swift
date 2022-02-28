import VioletBytecode

// swiftlint:disable file_length
// cSpell:ignore funcobject argdefs

// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = function, isDefault, hasGC
// sourcery: instancesHave__dict__
public struct PyFunction: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
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

  // MARK: - Layout

  internal enum Layout {
    internal static let nameOffset = SizeOf.objectHeader
    internal static let nameSize = SizeOf.object

    internal static let qualnameOffset = nameOffset + nameSize
    internal static let qualnameSize = SizeOf.object

    internal static let docOffset = qualnameOffset + qualnameSize
    internal static let docSize = SizeOf.optionalObject

    internal static let moduleOffset = docOffset + docSize
    internal static let moduleSize = SizeOf.object

    internal static let codeOffset = moduleOffset + moduleSize
    internal static let codeSize = SizeOf.object

    internal static let globalsOffset = codeOffset + codeSize
    internal static let globalsSize = SizeOf.object

    internal static let defaultsOffset = globalsOffset + globalsSize
    internal static let defaultsSize = SizeOf.optionalObject

    internal static let kwDefaultsOffset = defaultsOffset + defaultsSize
    internal static let kwDefaultsSize = SizeOf.optionalObject

    internal static let closureOffset = kwDefaultsOffset + kwDefaultsSize
    internal static let closureSize = SizeOf.optionalObject

    internal static let annotationsOffset = closureOffset + closureSize
    internal static let annotationsSize = SizeOf.optionalObject

    internal static let size = annotationsOffset + annotationsSize
  }

  // MARK: - Properties

  private var namePtr: Ptr<PyString> { self.ptr[Layout.nameOffset] }
  private var qualnamePtr: Ptr<PyString> { self.ptr[Layout.qualnameOffset] }
  private var docPtr: Ptr<PyString?> { self.ptr[Layout.docOffset] }
  private var modulePtr: Ptr<PyObject> { self.ptr[Layout.moduleOffset] }
  private var codePtr: Ptr<PyCode> { self.ptr[Layout.codeOffset] }
  private var globalsPtr: Ptr<PyDict> { self.ptr[Layout.globalsOffset] }
  private var defaultsPtr: Ptr<PyTuple?> { self.ptr[Layout.defaultsOffset] }
  private var kwDefaultsPtr: Ptr<PyDict?> { self.ptr[Layout.kwDefaultsOffset] }
  private var closurePtr: Ptr<PyTuple?> { self.ptr[Layout.closureOffset] }
  private var annotationsPtr: Ptr<PyDict?> { self.ptr[Layout.annotationsOffset] }

  /// The `__name__` attribute, a string object
  internal var name: PyString { self.namePtr.pointee }
  /// The qualified name
  internal var qualname: PyString { self.qualnamePtr.pointee }
  /// The `__doc__` attribute
  internal var doc: PyString? { self.docPtr.pointee }
  /// The `__module__` attribute, can be anything
  internal var module: PyObject { self.modulePtr.pointee }
  /// A code object, the `__code__` attribute
  internal var code: PyCode { self.codePtr.pointee }

  internal var globals: PyDict { self.globalsPtr.pointee }
  internal var defaults: PyTuple? { self.defaultsPtr.pointee }
  internal var kwDefaults: PyDict? { self.kwDefaultsPtr.pointee }
  internal var closure: PyTuple? { self.closurePtr.pointee }
  internal var annotations: PyDict? { self.annotationsPtr.pointee }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(type: PyType,
                           qualname: PyString?,
                           module: PyObject,
                           code: PyCode,
                           globals: PyDict) {
    self.header.initialize(type: type)
    self.namePtr.initialize(to: name)
    self.qualnamePtr.initialize(to: qualname ?? name)
    self.modulePtr.initialize(to: module)
    self.codePtr.initialize(to: code)

    self.globalsPtr.initialize(to: globals)

    self.defaultsPtr.initialize(to: nil)
    self.kwDefaultsPtr.initialize(to: nil)
    self.closurePtr.initialize(to: nil)
    self.annotationsPtr.initialize(to: nil)

    let firstConstant = code.constants.first
    let doc = firstConstant.flatMap(PyCast.asString(_:))
    self.docPtr.initialize(to: doc)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFunction(ptr: ptr)
    zelf.header.deinitialize()
    zelf.namePtr.deinitialize()
    zelf.qualnamePtr.deinitialize()
    zelf.docPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.codePtr.deinitialize()
    zelf.globalsPtr.deinitialize()
    zelf.defaultsPtr.deinitialize()
    zelf.kwDefaultsPtr.deinitialize()
    zelf.closurePtr.deinitialize()
    zelf.annotationsPtr.deinitialize()
  }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyFunction(ptr: ptr)
    return "PyFunction(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "<function \(self.qualname.value) at \(self.ptr)>"
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
    if PyCast.isNone(object) {
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
    if PyCast.isNone(object) {
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
    if PyCast.isNone(object) {
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
    if PyCast.isNone(object) {
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
    let nClosure = self.closure?.count ?? 0

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
    if PyCast.isNone(object) {
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

*/
