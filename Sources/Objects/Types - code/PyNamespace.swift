// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = types.SimpleNamespace
public final class PyNamespace: PyObject, AttributesOwner {

  public static let doc: String = """
    A simple attribute-based namespace.

    SimpleNamespace(**kwargs)
    """

  internal let _attributes = Attributes()

  internal init(_ context: PyContext, name: PyObject, doc: PyObject? = nil) {
    super.init(type: context.types.namespace)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyNamespace else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PyNamespace) -> Bool {
    return self._attributes == other._attributes
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func dict() -> Attributes {
    return self._attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    // TODO: name = (Py_TYPE(ns) == &_PyNamespace_Type) ? "namespace" : ns->ob_type->tp_name;
    let name = "namespace"

    if self.hasReprLock {
      return name + "(...)"
    }

    return self.withReprLock {
      var list = [String]()
      for key in self._attributes.keys.sorted() {
        guard let value = self._attributes[key] else {
          continue // just, so that Swift does not shout at us
        }

        let valueString = self.context._repr(value: value)
        list.append("\(key)=\(valueString)")
      }

      let listJoined = list.joined(separator: ", ")
      return "\(name)(\(listJoined))"
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(zelf: self, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
      return AttributeHelper.delAttribute(zelf: self, name: name)
  }
}
