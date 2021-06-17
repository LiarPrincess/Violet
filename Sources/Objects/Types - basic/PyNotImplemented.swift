import VioletCore

// In CPython:
// Objects -> object.c

// sourcery: pytype = NotImplementedType, default
/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
public class PyNotImplemented: PyObject {

  override public var description: String {
    return "PyNotImplemented()"
  }

  // MARK: - Init

  override internal init() {
    // 'NotImplemented' has only 1 instance and can't be subclassed,
    // so we can just pass the correct type to 'super.init'.
    super.init(type: Py.types.notImplemented)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("NotImplemented")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Reduce

  internal var reduce: String {
    return "NotImplemented"
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNotImplemented> {
    let noKwargs = kwargs?.data.isEmpty ?? true
    guard args.isEmpty && noKwargs else {
      return .typeError("NotImplementedType takes no arguments")
    }

    return .value(Py.notImplemented)
  }
}
