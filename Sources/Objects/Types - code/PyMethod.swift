import Bytecode

// In CPython:
// Objects -> classobject.c

// sourcery: pytype = method, default, hasGC
/// Function bound to an object.
public class PyMethod: PyObject {

  internal static let doc: String = """
    method(function, instance)

    Create a bound instance method object.
    """

  /// The callable object implementing the method
  internal let fn: PyFunction
  /// The instance it is bound to
  internal let object: PyObject

  override public var description: String {
    let name = self.fn.name
    let qualname = self.fn.qualname
    return "PyMethod(name: \(name), qualname: \(qualname))"
  }

  // MARK: - Init

  internal init(fn: PyFunction, object: PyObject) {
    self.fn = fn
    self.object = object
    super.init(type: Py.types.method)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyMethod else {
      return .notImplemented
    }

    switch Py.isEqualBool(left: self.fn, right: other.fn) {
    case .value(true): break // compare self
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    switch Py.isEqualBool(left: self.object, right: other.object) {
    case .value(let b): return .value(b)
    case .error(let e): return .error(e)
    }
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

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let funcNameObject = self.fn.attributes["__qualname__"] ??
                         self.fn.attributes["__name__"]

    var funcName = self.fn.name
    if let str = funcNameObject as? PyString {
      funcName = str.value
    }

    let ptr = self.object.ptrString
    let type = self.object.typeName
    return .value("<bound method \(funcName) of \(type) object at \(ptr)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    let objectHash: PyHash
    switch Py.hash(self.object) {
    case let .value(h): objectHash = h
    case let .error(e): return .error(e)
    }

    let fnHash: PyHash
    switch Py.hash(self.fn) {
    case let .value(h): fnHash = h
    case let .error(e): return .error(e)
    }

    return .value(objectHash ^ fnHash)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  public func getAttribute(name: String) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // sourcery: pymethod = __setattr__
  public func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  public func setAttribute(name: String, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  public func delAttribute(name: String) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Getters

  // sourcery: pymethod = __func__
  internal func getFunc() -> PyObject {
    return self.fn
  }

  // sourcery: pymethod = __self__
  internal func getSelf() -> PyObject {
    return self.object
  }

  // MARK: - Call

  // sourcery: pymethod = __get__
  internal func get(object: PyObject) -> PyResult<PyObject> {
    // Don't rebind already bound method of a class that's not a base class of cls
    // TODO: Is this correct?
    if object is PyNone {
      return .value(self)
    }

    // Bind it to obj
    return .value(PyMethod(fn: self.fn, object: object))
  }
}
