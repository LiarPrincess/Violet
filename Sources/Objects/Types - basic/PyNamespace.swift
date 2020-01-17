// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = types.SimpleNamespace, default, hasGC, baseType
public class PyNamespace: PyObject {

  internal static let doc: String = """
    A simple attribute-based namespace.

    SimpleNamespace(**kwargs)
    """

  internal let attributes: Attributes

  override public var description: String {
    return "PyNamespace()"
  }

  // MARK: - Init

  internal init(attributes: Attributes) {
    self.attributes = attributes
    super.init(type: Py.types.simpleNamespace)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyNamespace else {
      return .notImplemented
    }

    return self.attributes.isEqual(to: other.attributes).asCompareResult
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> Attributes {
    return self.attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let isBuiltin = self.type === Py.types.simpleNamespace
    let name = isBuiltin ? "namespace" : self.typeName

    if self.hasReprLock {
      return .value(name + "(...)")
    }

    return self.withReprLock {
      var list = [String]()
      for entry in self.attributes.entries {
        switch Py.repr(entry.value) {
        case let .value(o): list.append("\(entry.key)=\(o)")
        case let .error(e): return .error(e)
        }
      }

      let listJoined = list.joined(separator: ", ")
      return .value("\(name)(\(listJoined))")
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  internal func setAttribute(name: String, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyNamespace,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    guard args.isEmpty else {
      return .typeError("no positional arguments expected")
    }

    guard let kwargs = kwargs else {
      return .value(Py.none)
    }

    let kwargsDict: [String:PyObject]
    switch ArgumentParser.guaranteeStringKeywords(kwargs: kwargs) {
    case let .value(r): kwargsDict = r
    case let .error(e): return .error(e)
    }

    zelf.attributes.update(values: kwargsDict)
    return .value(Py.none)
  }
}
