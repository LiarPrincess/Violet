// cSpell:ignore namespaceobject

// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = types.SimpleNamespace, default, hasGC, baseType
public class PyNamespace: PyObject {

  internal static let doc: String = """
    A simple attribute-based namespace.

    SimpleNamespace(**kwargs)
    """

  internal let __dict__: PyDict

  override public var description: String {
    return "PyNamespace()"
  }

  // MARK: - Init

  internal init(dict: PyDict) {
    // 'namespace' can't be subclassed,
    // so we can just pass the correct type to 'super.init'.
    self.__dict__ = dict
    super.init(type: Py.types.simpleNamespace)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = PyCast.asNamespace(other) else {
      return .notImplemented
    }

    return self.__dict__.isEqual(other.__dict__)
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
  internal func getDict() -> PyDict {
    return self.__dict__
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
      var values = ""

      for (index, entry) in self.__dict__.elements.enumerated() {
        if index > 0 {
          values.append(", ")
        }

        let keyRepr: String
        switch Py.repr(object: entry.key.object) {
        case let .value(r): keyRepr = r
        case let .error(e): return .error(e)
        }

        let valueRepr: String
        switch Py.repr(object: entry.value) {
        case let .value(r): valueRepr = r
        case let .error(e): return .error(e)
        }

        values.append("\(keyRepr)=\(valueRepr)")
      }

      return .value("\(name)(\(values))")
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

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    guard args.isEmpty else {
      return .typeError("no positional arguments expected")
    }

    guard let kwargs = kwargs else {
      return .value(Py.none)
    }

    switch ArgumentParser.guaranteeStringKeywords(kwargs: kwargs) {
    case .value: break
    case .error(let e): return .error(e)
    }

    switch self.__dict__.update(from: kwargs, onKeyDuplicate: .continue) {
    case .value: break
    case .error(let e): return .error(e)
    }

    return .value(Py.none)
  }
}
