// cSpell:ignore methodobject

// In CPython:
// Objects -> methodobject.c

// sourcery: pytype = builtinMethod, isDefault, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public struct PyBuiltinMethod: PyObjectMixin, AbstractBuiltinFunction {

  // MARK: - Properties

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyBuiltinMethodLayout()

  internal var functionPtr: Ptr<FunctionWrapper> { self.ptr[Self.layout.functionOffset] }
  internal var objectPtr: Ptr<PyObject> { self.ptr[Self.layout.objectOffset] }
  internal var modulePtr: Ptr<PyObject?> { self.ptr[Self.layout.moduleOffset] }
  internal var docPtr: Ptr<String?> { self.ptr[Self.layout.docOffset] }

  /// The Swift function that will be called.
  internal var function: FunctionWrapper { self.functionPtr.pointee }
  /// Instance bound to (`__self__`).
  internal var object: PyObject { self.objectPtr.pointee }
  /// The `__module__` attribute, can be anything.
  internal var module: PyObject? { self.modulePtr.pointee }
  /// The `__doc__` attribute, or `nil`.
  internal var doc: String? { self.docPtr.pointee }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(type: PyType,
                           function: FunctionWrapper,
                           object: PyObject,
                           module: PyObject?,
                           doc: String?) {
    self.header.initialize(type: type)
    self.functionPtr.initialize(to: function)
    self.objectPtr.initialize(to: object)
    self.modulePtr.initialize(to: module)
    self.docPtr.initialize(to: doc)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyBuiltinMethod(ptr: ptr)
    return "PyBuiltinMethod(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqual(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self._isLess(other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self._isLessEqual(other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self._isGreater(other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self._isGreaterEqual(other)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    if PyCast.isModule(self.object) {
      return "<built-in method \(self.name)>"
    }

    let ptr = self.object.ptr
    let type = self.object.typeName
    return "<built-in method \(self.name) of \(type) object at \(ptr)>"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return self._getAttribute(name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__
  internal func getName() -> String {
    return self.name
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__
  internal func getQualname() -> String {
    // If __self__ is a module or nil, return __name__, for example:
    // >>> len.__qualname__
    // 'len'
    if PyCast.isModule(self.object) {
      return self.name
    }

    // If __self__ is a type, return m.__self__.__qualname__ + '.' + m.__name__
    // >>> dict.fromkeys.__qualname__ # 'dict' is a type, so use it!
    // 'dict.fromkeys'
    var type = self.object.type
    if let ifObjectIsTypeThenUseItAsType = PyCast.asType(self.object) {
      type = ifObjectIsTypeThenUseItAsType
    }

    // Return type(m.__self__).__qualname__ + '.' + m.__name__
    // >>> [].append.__qualname__
    // 'list.append'
    let typeQualname = type.getQualnameString()
    return typeQualname + "." + self.name
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__
  internal func getDoc() -> String? {
    return self._getDoc()
  }

  // MARK: - TextSignature

  // sourcery: pyproperty = __text_signature__
  internal func getTextSignature() -> String? {
    return self._getTextSignature()
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__
  internal func getModule() -> PyResult<PyObject> {
    return self._getModule()
  }

  // MARK: - Self

  // sourcery: pyproperty = __self__
  internal func getSelf() -> PyObject {
    return self.object
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    let result = PyMemory.newBuiltinMethod(fn: self.function,
                                           object: object,
                                           module: self.module,
                                           doc: self.doc)

    return .value(result)
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// PyObject *
  /// PyCFunction_Call(PyObject *func, PyObject *args, PyObject *kwargs)
  /// _PyMethodDef_RawFastCallDict(PyMethodDef *method,
  ///                              PyObject *self,
  ///                              PyObject *const *args, Py_ssize_t nargs,
  ///                              PyObject *kwargs)
  /// static PyObject *
  /// slot_tp_call(PyObject *self, PyObject *args, PyObject *kwds)
  /// PyObject *
  /// _PyObject_Call_Prepend(PyObject *callable,
  ///                        PyObject *obj, PyObject *args, PyObject *kwargs)
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    let realArgs = [self.object] + args
    return self.function.call(args: realArgs, kwargs: kwargs)
  }
}

*/
