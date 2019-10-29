import Bytecode

// In CPython:
// Objects -> classobject.c

// sourcery: pytype = method
/// Function bound to an object.
internal final class PyMethod: PyObject {

  internal static let doc: String = """
    method(function, instance)

    Create a bound instance method object.
    """

  /// The callable object implementing the method
  internal let _func: PyFunction
  /// The instance it is bound to
  internal let _self: PyObject

  internal init(_ context: PyContext, func fn: PyFunction, zelf: PyObject) {
    self._func = fn
    self._self = zelf
    super.init(type: context.types.method)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyMethod else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PyMethod) -> Bool {
    let isFuncEqual = self.context.isEqual(left: self._func, right: other._func)
    guard case PyResultOrNot.value(true) = isFuncEqual else {
      return false
    }

    let isSelfEqual = self.context.isEqual(left: self._self, right: other._self)
    guard case PyResultOrNot.value(true) = isSelfEqual else {
      return false
    }

    return true
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
  internal func repr() -> String {
    let funcNameObject = self._func._attributes["__qualname__"] ??
                         self._func._attributes["__name__"]

    var funcName = self._func._name
    if let str = funcNameObject as? PyString {
      funcName = str.value
    }

    let ptr = self._self.ptrString
    let type = self._self.typeName
    return "<bound method \(funcName) of \(type) object at \(ptr)>"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    let selfHash = self.context.hash(value: self._self)
    let funcHash = self.context.hash(value: self._func)
    return .value(selfHash ^ funcHash)
  }

  // MARK: - Attributes

  internal static let getAttributeDoc = """
    method(function, instance)

    Create a bound instance method object.
    """

  // sourcery: pymethod = __getattribute__, doc = getAttributeDoc
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    if let descr = self.type.lookup(name: nameString.value),
       let f = descr.type as? __get__Owner {
      return f.get(object: self.type)
    }

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

  // MARK: - Getters

  // sourcery: pymethod = __func__
  internal func getFunc() -> PyObject {
    return self._func
  }

  // sourcery: pymethod = __self__
  internal func getSelf() -> PyObject {
    return self._self
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
    return .value(PyMethod(context, func: self._func, zelf: object))
  }
}
