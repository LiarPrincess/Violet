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
    self.header.initialize(py, type: type)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyEllipsis(ptr: ptr)
    return "PyEllipsis(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard py.cast.isEllipsis(zelf) else {
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
  internal static func __reduce__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard py.cast.isEllipsis(zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__reduce__")
    }

    return PyResult(py, interned: "Ellipsis")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = py.cast.asEllipsis(zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError(py, message: "EllipsisType takes no arguments")
    }

    return PyResult(py.ellipsis)
  }

  // MARK: - Helpers

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult<PyObject> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: "ellipsis",
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
