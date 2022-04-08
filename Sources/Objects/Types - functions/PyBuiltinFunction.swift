// cSpell:ignore methodobject

// In CPython:
// Objects -> methodobject.c

// sourcery: pytype = builtinFunction, isDefault, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public struct PyBuiltinFunction: PyObjectMixin, AbstractBuiltinFunction {

  // sourcery: storedProperty
  /// The Swift function that will be called.
  internal var function: FunctionWrapper { self.functionPtr.pointee }

  // sourcery: storedProperty
  /// The `__module__` attribute, can be anything.
  internal var module: PyObject? { self.modulePtr.pointee }

  // sourcery: storedProperty
  /// The `__doc__` attribute, or `nil`.
  internal var doc: String? { self.docPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           function: FunctionWrapper,
                           module: PyObject?,
                           doc: String?) {
    self.initializeBase(py, type: type)
    self.functionPtr.initialize(to: function)
    self.modulePtr.initialize(to: module)
    self.docPtr.initialize(to: doc)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyBuiltinFunction(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    let name = zelf.function.name
    result.append(name: "name", value: name, includeInDescription: true)
    result.append(name: "module", value: zelf.module as Any)
    result.append(name: "doc", value: zelf.doc as Any)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__eq__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ne__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__lt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__le__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__gt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ge__(py, zelf: zelf, other: other)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let result = "<built-in function \(zelf.name)>"
    return PyResult(py, interned: result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Properties

  // sourcery: pyproperty = __name__
  internal static func __name__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__name__(py, zelf: zelf)
  }

  // sourcery: pyproperty = __qualname__
  internal static func __qualname__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__qualname__")
    }

    let result = zelf.name
    return PyResult(py, interned: result)
  }

  // sourcery: pyproperty = __doc__
  internal static func __doc__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__doc__(py, zelf: zelf)
  }

  // sourcery: pyproperty = __text_signature__
  internal static func __text_signature__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__text_signature__(py, zelf: zelf)
  }

  // sourcery: pyproperty = __module__
  internal static func __module__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__module__(py, zelf: zelf)
  }

  // sourcery: pyproperty = __self__
  internal static func __self__(_ py: Py, zelf: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__self__")
    }

    return .none(py)
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

  internal func bind(_ py: Py, object: PyObject) -> PyBuiltinMethod {
    return py.newBuiltinMethod(fn: self.function,
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
  internal static func __call__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__call__")
    }

    return zelf.function.call(py, args: args, kwargs: kwargs)
  }
}
