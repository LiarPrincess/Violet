import VioletBytecode

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

  // MARK: - Properties

  // sourcery: storedProperty
  /// The `__name__` attribute, a string object
  internal var name: PyString {
    get { self.namePtr.pointee }
    nonmutating set { self.namePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// The qualified name
  internal var qualname: PyString {
    get { self.qualnamePtr.pointee }
    nonmutating set { self.qualnamePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// The `__doc__` attribute
  internal var doc: PyString? {
    get { self.docPtr.pointee }
    nonmutating set { self.docPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// The `__module__` attribute, can be anything
  internal var module: PyObject {
    get { self.modulePtr.pointee }
    nonmutating set { self.modulePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// A code object, the `__code__` attribute
  internal var code: PyCode {
    get { self.codePtr.pointee }
    nonmutating set { self.codePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var globals: PyDict {
    get { self.globalsPtr.pointee }
    nonmutating set { self.globalsPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var defaults: PyTuple? {
    get { self.defaultsPtr.pointee }
    nonmutating set { self.defaultsPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var kwDefaults: PyDict? {
    get { self.kwDefaultsPtr.pointee }
    nonmutating set { self.kwDefaultsPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var closure: PyTuple? {
    get { self.closurePtr.pointee }
    nonmutating set { self.closurePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var annotations: PyDict? {
    get { self.annotationsPtr.pointee }
    nonmutating set { self.annotationsPtr.pointee = newValue }
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           qualname: PyString?,
                           module: PyObject,
                           code: PyCode,
                           globals: PyDict) {
    let name = code.name
    self.initializeBase(py, type: type)
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
    let doc = firstConstant.flatMap { py.cast.asString($0) }
    self.docPtr.initialize(to: doc)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyFunction(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    Self.fillDebug(zelf: zelf, debug: &result)
    return result
  }

  internal static func fillDebug(zelf: PyFunction, debug: inout PyObject.DebugMirror) {
    debug.append(name: "name", value: zelf.name, includeInDescription: true)
    debug.append(name: "qualname", value: zelf.qualname, includeInDescription: true)
    debug.append(name: "module", value: zelf.module)
    debug.append(name: "doc", value: zelf.doc as Any)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let result = "<function \(zelf.qualname.value) at \(zelf.ptr)>"
    return PyResult(py, result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter
  internal static func __name__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__name__")
    }

    let result = zelf.getName()
    return PyResult(result)
  }

  internal func getName() -> PyString {
    return self.name
  }

  internal static func __name__(_ py: Py,
                                zelf _zelf: PyObject,
                                value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__name__")
    }

    guard let value = value else {
      return .none(py)
    }

    guard let valueString = py.cast.asString(value) else {
      return .typeError(py, message: "__name__ must be set to a string object")
    }

    zelf.name = valueString
    return .none(py)
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter
  internal static func __qualname__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__qualname__")
    }

    return PyResult(zelf.qualname)
  }

  internal static func __qualname__(_ py: Py,
                                    zelf _zelf: PyObject,
                                    value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__qualname__")
    }

    guard let value = value else {
      return .none(py)
    }

    guard let valueString = py.cast.asString(value) else {
      return .typeError(py, message: "__qualname__ must be set to a string object")
    }

    zelf.qualname = valueString
    return .none(py)
  }

  // MARK: - Defaults

  // sourcery: pyproperty = __defaults__, setter
  internal static func __defaults__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__defaults__")
    }

    return PyResult(py, zelf.defaults)
  }

  internal static func __defaults__(_ py: Py,
                                    zelf _zelf: PyObject,
                                    value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__defaults__")
    }

    if let e = zelf.setDefaults(py, value: value) {
      return .error(e)
    }

    return .none(py)
  }

  internal func setDefaults(_ py: Py, value: PyObject?) -> PyBaseException? {
    guard let value = value, !py.cast.isNone(value) else {
      self.defaults = nil
      return nil
    }

    guard let tuple = py.cast.asTuple(value) else {
      let error = py.newSystemError(message: "non-tuple default args")
      return error.asBaseException
    }

    self.defaults = tuple
    return nil
  }

  // MARK: - Keyword defaults

  // sourcery: pyproperty = __kwdefaults__, setter
  internal static func __kwdefaults__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__kwdefaults__")
    }

    return PyResult(py, zelf.kwDefaults)
  }

  internal static func __kwdefaults__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__kwdefaults__")
    }

    if let e = zelf.setKeywordDefaults(py, value: value) {
      return .error(e)
    }

    return .none(py)
  }

  internal func setKeywordDefaults(_ py: Py, value: PyObject?) -> PyBaseException? {
    guard let value = value, !py.cast.isNone(value) else {
      self.kwDefaults = nil
      return nil
    }

    guard let dict = py.cast.asDict(value) else {
      let error = py.newSystemError(message: "non-dict keyword only default args")
      return error.asBaseException
    }

    self.kwDefaults = dict
    return nil
  }

  // MARK: - Closure

  // sourcery: pyproperty = __closure__, setter
  internal static func __closure__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__closure__")
    }

    return PyResult(py, zelf.closure)
  }

  /// Note that there is not `Python` setter for closure.
  /// It can be only set from `Swift`.
  internal static func __closure__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__closure__")
    }

    if let e = zelf.setClosure(py, value: value) {
      return .error(e)
    }

    return .none(py)
  }

  internal func setClosure(_ py: Py, value: PyObject?) -> PyBaseException? {
    guard let value = value, !py.cast.isNone(value) else {
      self.closure = nil
      return nil
    }

    guard let tuple = py.cast.asTuple(value) else {
      let message = "expected tuple for closure, got '\(value.typeName)'"
      let error = py.newSystemError(message: message)
      return error.asBaseException
    }

    self.closure = tuple
    return nil
  }

  // MARK: - Globals

  // sourcery: pyproperty = __globals__, setter
  internal static func __globals__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__globals__")
    }

    return PyResult(py, zelf.globals)
  }

  internal static func __globals__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__globals__")
    }

    guard let value = value else {
      return .none(py)
    }

    guard let dict = py.cast.asDict(value) else {
      return .systemError(py, message: "non-dict globals")
    }

    zelf.globals = dict
    return .none(py)
  }

  // MARK: - Annotations

  // sourcery: pyproperty = __annotations__, setter
  internal static func __annotations__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__annotations__")
    }

    return PyResult(py, zelf.annotations)
  }

  internal static func __annotations__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__annotations__")
    }

    if let e = zelf.setAnnotations(py, value: value) {
      return .error(e)
    }

    return .none(py)
  }

  internal func setAnnotations(_ py: Py, value: PyObject?) -> PyBaseException? {
    guard let value = value, !py.cast.isNone(value) else {
      self.annotations = nil
      return nil
    }

    guard let dict = py.cast.asDict(value) else {
      let error = py.newSystemError(message: "non-dict annotations")
      return error.asBaseException
    }

    self.annotations = dict
    return nil
  }

  // MARK: - Code

  // sourcery: pyproperty = __code__, setter
  internal static func __code__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__code__")
    }

    return PyResult(zelf.code)
  }

  internal static func __code__(_ py: Py,
                                zelf _zelf: PyObject,
                                value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__code__")
    }

    guard let value = value else {
      return .none(py)
    }

    guard let code = py.cast.asCode(value) else {
      return .typeError(py, message: "__code__ must be set to a code object")
    }

    let nFree = code.freeVariableCount
    let nClosure = zelf.closure?.count ?? 0

    if nClosure != nFree {
      let name = zelf.name.value
      let message = "\(name)() requires a code object with \(nClosure) free vars, not \(nFree)"
      return .valueError(py, message: message)
    }

    zelf.code = code
    return .none(py)
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter
  internal static func __doc__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    return PyResult(py, zelf.doc)
  }

  internal static func __doc__(_ py: Py,
                               zelf _zelf: PyObject,
                               value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    guard let value = value, !py.cast.isNone(value) else {
      zelf.doc = nil
      return .none(py)
    }

    guard let str = py.cast.asString(value) else {
      return .typeError(py, message: "'__doc__' must be a str not \(value.typeName)")
    }

    zelf.doc = str
    return .none(py)
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter
  internal static func __module__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__module__")
    }

    let moduleObject = zelf.module

    if let module = py.cast.asModule(moduleObject) {
      return module.getName(py)
    }

    let result = py.str(moduleObject)
    return PyResult(result)
  }

  internal static func __module__(_ py: Py,
                                  zelf _zelf: PyObject,
                                  value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__module__")
    }

    if let value = value {
      zelf.module = value
    }

    return .none(py)
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.getDict(py)
    return PyResult(result)
  }

  internal func getDict(_ py: Py) -> PyDict {
    let object = PyObject(ptr: self.ptr)

    guard let result = object.get__dict__(py) else {
      py.trapMissing__dict__(object: self)
    }

    return result
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal static func __get__(_ py: Py,
                               zelf _zelf: PyObject,
                               object: PyObject,
                               type: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__get__")
    }

    if py.isDescriptorStaticMarker(object) {
      return PyResult(zelf)
    }

    let result = zelf.bind(py, object: object)
    return PyResult(result)
  }

  internal func bind(_ py: Py, object: PyObject) -> PyMethod {
    return py.newMethod(fn: self, object: object)
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// static PyObject *
  /// function_call(PyObject *func, PyObject *args, PyObject *kwargs)
  internal static func __call__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__call__")
    }

    // Caller and callee functions should not share the kwargs dictionary.
    var kwargsCopy: PyDict?
    if let kwargs = kwargs {
      kwargsCopy = kwargs.copy(py)
    }

    let argsDefaults = zelf.defaults?.elements ?? []
    let locals = py.newDict()

    let result = py.delegate.eval(py,
                                  name: zelf.name,
                                  qualname: zelf.qualname,
                                  code: zelf.code,
                                  args: args,
                                  kwargs: kwargsCopy,
                                  defaults: argsDefaults,
                                  kwDefaults: zelf.kwDefaults,
                                  globals: zelf.globals,
                                  locals: locals,
                                  closure: zelf.closure)

    return result
  }
}
