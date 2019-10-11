import Core

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// TODO: None
// __eq__
// __ne__
// __str__
// __repr__
// __lt__
// __le__
// __gt__
// __ge__
// __bool__
// __class__
// __delattr__
// __dir__
// __doc__
// __format__
// __getattribute__
// __hash__
// __init__
// __init_subclass__
// __new__
// __reduce__
// __reduce_ex__
// __setattr__
// __sizeof__
// __subclasshook__
// TODO: Do we need custom '__getattribute__' as RustPython?

// sourcery: pytype = NoneType
/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNone: PyObject, ReprTypeClass, BoolConvertibleTypeClass {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.none)
  }

  // MARK: - String

  internal func repr() -> String {
    return "None"
  }

  // MARK: - Convertible

  internal func asBool() -> PyResult<Bool> {
    return .value(false)
  }
}
