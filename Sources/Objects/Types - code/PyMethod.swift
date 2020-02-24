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
  public func isEqual(_ other: PyObject) -> CompareResult {
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
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    let funcNameObject =
      self.fn.__dict__.getItem(id: .__qualname__) ??
      self.fn.__dict__.getItem(id: .__name__)

    let funcNameString = funcNameObject as? PyString
    let funcName = funcNameString?.value ?? self.fn.name

    let ptr = self.object.ptrString
    let type = self.object.typeName
    return .value("<bound method \(funcName) of \(type) object at \(ptr)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
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
  public func getFunc() -> PyFunction {
    return self.fn
  }

  // sourcery: pymethod = __self__
  public func getSelf() -> PyObject {
    return self.object
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  public func get(object: PyObject, type: PyObject) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return .value(PyMethod(fn: self.fn, object: object))
  }
}
