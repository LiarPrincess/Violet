import Core

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = callable_iterator, default, hasGC
internal class PyCallableIterator: PyObject {

  internal let callable: PyObject
  internal let sentinel: PyObject

  // MARK: - Init

  internal init(callable: PyObject, sentinel: PyObject) {
    self.callable = callable
    self.sentinel = sentinel
    super.init(type: callable.builtins.types.callable_iterator)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    switch self.builtins.call(callable: self.callable) {
    case let .value(o):
      // If we are equal to 'self.sentinel' then we have to stop
      switch self.builtins.isEqualBool(left: o, right: self.sentinel) {
      case .value(true): return .error(.stopIteration)
      case .value(false): return .value(o)
      case .error(let e): return .error(e)
      }
    case .error(let e), .notCallable(let e):
      // This also handles 'StopIteration'
      return .error(e)
    }
  }
}
