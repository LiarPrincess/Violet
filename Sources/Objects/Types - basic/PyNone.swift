import Core

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// TODO: Do we need custom '__getattribute__' as RustPython?

// sourcery: pytype = NoneType
/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNone: PyObject {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.none)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "None"
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> PyResult<Bool> {
    return .value(false)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }
}