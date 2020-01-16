import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

// sourcery: pytype = ellipsis, default
/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
public class PyEllipsis: PyObject {

  // MARK: - Init

  internal override init() {
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
  internal var reduce: String {
    return "Ellipsis"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let noKwargs = kwargs?.isEmpty ?? true
    guard args.isEmpty && noKwargs else {
      return .typeError("EllipsisType takes no arguments")
    }

    return .value(type.builtins.ellipsis)
  }
}
