import VioletCore

// cSpell:ignore sliceobject

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

// sourcery: pytype = ellipsis, default
/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
public class PyEllipsis: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  override public var description: String {
    return "PyEllipsis()"
  }

  // MARK: - Init

  override internal init() {
    // 'ellipsis' has only 1 instance and can't be subclassed,
    // so we can just pass the correct type to 'super.init'.
    super.init(type: Py.types.ellipsis)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("Ellipsis")
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
