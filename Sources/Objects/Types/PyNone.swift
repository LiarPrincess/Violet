import Core

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

/// The Python None object, denoting lack of value. This object has no methods.
internal final class PyNone: PyObject, ReprTypeClass, BoolConvertibleTypeClass {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.none)
  }

  // MARK: - String

  internal var repr: String {
    return "None"
  }

  // MARK: - Convertible

  internal var asBool: PyResult<Bool> {
    return .value(false)
  }
}

internal final class PyNoneType: PyType {
  // TODO: Do we need custom '__getattribute__' as RustPython?
//  override internal var name: String { return "NoneType" }
}
