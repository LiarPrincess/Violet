/* MARKER
import VioletCore

// In CPython:
// Objects -> object.c

// sourcery: pytype = NotImplementedType, isDefault
/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
public final class PyNotImplemented: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // MARK: - Init

  override internal init() {
    // 'NotImplemented' has only 1 instance and can't be subclassed,
    // so we can just pass the correct type to 'super.init'.
    super.init(type: Py.types.notImplemented)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "NotImplemented"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNotImplemented> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError("NotImplementedType takes no arguments")
    }

    return .value(Py.notImplemented)
  }
}

*/