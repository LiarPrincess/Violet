import VioletCore

// cSpell:ignore sliceobject

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

// sourcery: pytype = ellipsis, isDefault
/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
public struct PyEllipsis: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType) {
    self.initializeBase(py, type: type)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyEllipsis(ptr: ptr)
    return PyObject.DebugMirror(object: zelf)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__repr__")
    }

    return PyResult(py, interned: "Ellipsis")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Reduce

  // sourcery: pymethod = __reduce__
  internal static func __reduce__(_ py: Py, zelf: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__reduce__")
    }

    return PyResult(py, interned: "Ellipsis")
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

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError(py, message: "EllipsisType takes no arguments")
    }

    return PyResult(py.ellipsis)
  }
}
