import VioletBytecode

// cSpell:ignore classobject

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
  internal let function: PyFunction
  /// The instance it is bound to
  internal let object: PyObject

  override public var description: String {
    let name = self.function.name
    let qualname = self.function.qualname
    return "PyMethod(name: \(name), qualname: \(qualname), object: \(self.object))"
  }

  // MARK: - Init

  internal init(fn: PyFunction, object: PyObject) {
    self.function = fn
    self.object = object
    super.init(type: Py.types.method)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyMethod else {
      return .notImplemented
    }

    switch Py.isEqualBool(left: self.function, right: other.function) {
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
      self.function.__dict__.get(id: .__qualname__) ??
      self.function.__dict__.get(id: .__name__)

    let funcNameString = funcNameObject as? PyString
    let funcName = funcNameString?.value ?? self.function.name.value

    let ptr = self.object.ptr
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
    switch Py.hash(object: self.object) {
    case let .value(h): objectHash = h
    case let .error(e): return .error(e)
    }

    let fnHash: PyHash
    switch Py.hash(object: self.function) {
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

  // sourcery: pymethod = __setattr__
  public func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Getters

  // sourcery: pymethod = __func__
  public func getFunc() -> PyFunction {
    return self.function
  }

  // sourcery: pymethod = __self__
  public func getSelf() -> PyObject {
    return self.object
  }

  // sourcery: pyproperty = __doc__
  public func getDoc() -> PyString? {
    return self.function.getDoc()
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  public func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return .value(PyMethod(fn: self.function, object: object))
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  public func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    let realArgs = [self.object] + args
    return self.function.call(args: realArgs, kwargs: kwargs)
  }
}
