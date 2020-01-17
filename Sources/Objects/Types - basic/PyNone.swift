import Core

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// TODO: Do we need custom '__getattribute__' as RustPython? (see descriptors)

// sourcery: pytype = NoneType, default
/// The Python None object, denoting lack of value. This object has no methods.
public class PyNone: PyObject {

  override public var description: String {
    return "PyNone()"
  }

  // MARK: - Init

  override internal init() {
    super.init(type: Py.types.none)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("None")
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    return false
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let noKwargs = kwargs?.isEmpty ?? true
    guard args.isEmpty && noKwargs else {
      return .typeError("NoneType takes no arguments")
    }

    return .value(Py.none)
  }
}
