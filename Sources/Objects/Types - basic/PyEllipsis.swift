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

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyEllipsisLayout()

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType) {
    self.header.initialize(type: type)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyEllipsis(ptr: ptr)
    return "PyEllipsis(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER
  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "Ellipsis"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Reduce

  // sourcery: pymethod = __reduce__
  internal func reduce() -> String {
    return "Ellipsis"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyEllipsis> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError("EllipsisType takes no arguments")
    }

    return .value(Py.ellipsis)
  }
}

*/
