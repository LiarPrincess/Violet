import Foundation
import Core

// In CPython:
// Objects -> typeobject.c

// sourcery: pytype = object
/// Root of the Object hierarchy (kind of important thingie).
internal final class PyBaseObject: PyObject,
  GenericNotEqual, GenericGetAttribute, GenericSetAttribute {

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

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> EquatableResult {
    return self === other ? .value(true) : .notImplemented
  }

  // sourcery: pymethod = __ne__
  func isNotEqual(_ other: PyObject) -> EquatableResult {
    return self.genericIsNotEqual(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashableResult {
    let id = ObjectIdentifier(self)
    return .value(self.context.hasher.hash(id))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    switch self.type.getModuleRaw() {
    case .builtins:
      return "<\(self.typeName) object at \(self.ptrString)>"
    case let .external(module):
      return "<\(module).\(self.typeName) object at \(self.ptrString)>"
    }
  }

  // sourcery: pymethod = __str__
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
        "unsupported format string passed to \(self.typeName).__format__"
      )
    )
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal func dir() -> [String:PyObject] {
    var result = [String:PyObject]()

    // Our own dict
    // TODO: This
//    if let dictOwner = self as? DictOwnerTypeClass {
//      result.merge(dictOwner.dict, uniquingKeysWith: leaveCurrent)
//    }

    // Class dict
    let typeDict = self.type._attributes.asDictionary
    result.merge(typeDict, uniquingKeysWith: leaveCurrent)

    for base in self.type._bases {
      let baseDict = base._attributes.asDictionary
      result.merge(baseDict, uniquingKeysWith: leaveCurrent)
    }

    return result
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return self.genericGetAttributeWithDict(name: name, dict: nil)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject) -> PyResult<()> {
    return self.genericSetAttributeWithDict(name: name, value: value, dict: nil)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<()> {
    return self.setAttribute(name: name, value: self.context.none)
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
