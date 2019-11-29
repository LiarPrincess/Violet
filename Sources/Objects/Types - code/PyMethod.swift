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

  internal init(_ context: PyContext, fn: PyFunction, object: PyObject) {
    self.fn = fn
    self.object = object
    super.init(type: context.builtins.types.method)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyMethod else {
      return .notImplemented
    }

    switch self.builtins.isEqualBool(left: self.fn, right: other.fn) {
    case .value(true): break // compare self
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    switch self.builtins.isEqualBool(left: self.object, right: other.object) {
    case .value(let b): return .value(b)
    case .error(let e): return .error(e)
    }
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
  internal func hash() -> PyResultOrNot<PyHash> {
    let objectHash: PyHash
    switch self.builtins.hash(self.object) {
    case let .value(h): objectHash = h
    case let .error(e): return .error(e)
    }

    let fnHash: PyHash
    switch self.builtins.hash(self.fn) {
    case let .value(h): fnHash = h
    case let .error(e): return .error(e)
    }

    return .value(objectHash ^ fnHash)
  }

  // MARK: - Attributes

  internal static let getAttributeDoc = """
    method(function, instance)

    Create a bound instance method object.
    """

  // sourcery: pymethod = __getattribute__, doc = getAttributeDoc
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    guard let nameString = name as? PyString else {
      return .typeError("attribute name must be string, not '\(name.typeName)'")
    }

    if let descr = self.type.lookup(name: nameString.value),
       let f = descr.type as? __get__Owner {
      return f.get(object: self.type)
    }

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
    return .value(PyMethod(context, fn: self.fn, object: object))
  }
}
