import Foundation
import Core

// In CPython:
// Objects -> typeobject.c

// TODO: PyBaseObject
// __getattribute__
// __setattr__
// __delattr__
// __init__
// __reduce__
// __reduce_ex__
// __sizeof__

// sourcery: pytype = object
/// Root of the Object hierarchy (kind of important thingie).
internal final class PyBaseObject: PyObject,
  ComparableTypeClass, HashableTypeClass,
  ReprTypeClass, StrTypeClass {

  internal static let doc: String = """
    object()
    --

    The most base type
    """

  // MARK: - Init

  override private init() {
    super.init()
  }

  internal static func initWithoutTypeProperty() -> PyBaseObject {
    return PyBaseObject()
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    return self === other ? .value(true) : .notImplemented
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // MARK: - Hashable

  internal func hash() -> HashableResult {
    let id = ObjectIdentifier(self)
    return .value(self.context.hasher.hash(id))
  }

  // MARK: - String

  internal func repr() -> String {
    switch self.type.module {
    case .builtins:
      return "<\(self.type.name) object at \(self.ptrString)>"
    case let .external(module):
      return "<\(module).\(self.type.name) object at \(self.ptrString)>"
    }
  }

  internal func str() -> String {
    return self.repr()
  }

  // sourcery: pymethod = __format__
  internal func format(spec: PyObject) -> PyResult<String> {
    if let spec = spec as? PyString, spec.value.isEmpty {
      return .value(self.str())
    }

    return .error(
      .typeError(
        "unsupported format string passed to \(self.type.name).__format__"
      )
    )
  }

  // MARK: - Class

  internal func getClass() -> PyType {
    return self.type
  }

  internal func setClass() {
    // TODO: implement this
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal func dir() -> [String:PyObject] {
    var result = [String:PyObject]()

    // Our own dict
    if let dictOwner = self as? DictOwnerTypeClass {
      result.merge(dictOwner.dict, uniquingKeysWith: leaveCurrent)
    }

    // Class dict
    result.merge(self.type.dict, uniquingKeysWith: leaveCurrent)

    for base in self.type.bases {
      result.merge(base.dict, uniquingKeysWith: leaveCurrent)
    }

    return result
  }

  // MARK: - Subclasshook

  // sourcery: pymethod = __subclasshook__
  /// Abstract classes can override this to customize issubclass().
  /// This is invoked early on by abc.ABCMeta.__subclasscheck__().
  /// It should return True, False or NotImplemented.  If it returns
  /// NotImplemented, the normal algorithm is used.  Otherwise, it
  /// overrides the normal algorithm (and the outcome is cached).
  internal func subclasshook() -> PyResultOrNot<PyObject> {
    return .notImplemented
  }

  // MARK: - Init subclass

  // sourcery: pymethod = __init_subclass__
  /// This method is called when a class is subclassed.
  /// The default implementation does nothing.
  /// It may be overridden to extend subclasses.
  internal func initSubclass() -> PyResultOrNot<PyObject> {
    return .value(self.context._none)
  }
}

private func leaveCurrent<Value>(_ current: Value, _ new: Value) -> Value {
  return current
}
