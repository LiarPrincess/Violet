// cSpell:ignore methodobject

// In CPython:
// Objects -> methodobject.c

// sourcery: pytype = builtinFunction, isDefault, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public struct PyBuiltinFunction: PyObjectMixin, AbstractBuiltinFunction {

  // MARK: - Layout

  internal enum Layout {
    internal static let functionOffset = SizeOf.objectHeader
    internal static let functionSize = SizeOf.functionWrapper

    internal static let moduleOffset = functionOffset + functionSize
    internal static let moduleSize = SizeOf.optionalObject

    internal static let docOffset = moduleOffset + moduleSize
    internal static let docSize = SizeOf.optionalString

    internal static let size = docOffset + docSize
  }

  // MARK: - Properties

  private var functionPtr: Ptr<FunctionWrapper> { self.ptr[Layout.functionOffset] }
  private var modulePtr: Ptr<PyObject?> { self.ptr[Layout.moduleOffset] }
  private var docPtr: Ptr<String?> { self.ptr[Layout.docOffset] }

  /// The Swift function that will be called.
  internal var function: FunctionWrapper { self.functionPtr.pointee }
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

  // swiftlint:disable:next function_parameter_count
  internal func initialize(type: PyType,
                           function: FunctionWrapper,
                           module: PyObject?,
                           doc: String?) {
    self.header.initialize(type: type)
    self.functionPtr.initialize(to: function)
    self.modulePtr.initialize(to: module)
    self.docPtr.initialize(to: doc)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBuiltinFunction(ptr: ptr)
    zelf.header.deinitialize()
    zelf.functionPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()
  }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyBuiltinFunction(ptr: ptr)
    return "PyBuiltinFunction(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    return "<built-in function \(self.name)>"
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
    return self.name
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
    return Py.none
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    let bound = self.bind(to: object)
    return .value(bound)
  }

  internal func bind(to object: PyObject) -> PyBuiltinMethod {
    return PyMemory.newBuiltinMethod(fn: self.function,
                                     object: object,
                                     module: self.module,
                                     doc: self.doc)
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
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    return self.function.call(args: args, kwargs: kwargs)
  }
}

*/
