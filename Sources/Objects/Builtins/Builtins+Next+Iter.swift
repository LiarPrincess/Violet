extension Builtins {

  // MARK: - Next

  internal static let nextDoc = """
    next(iterator[, default])

    Return the next item from the iterator. If default is given and the iterator
    is exhausted, it is returned instead of raising StopIteration.
    """

  // sourcery: pymethod = next, doc = nextDoc
  /// next(iterator[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#next)
  public func next(iterator: PyObject,
                   default: PyObject? = nil) -> PyResult<PyObject> {
    switch self.callNext(iterator: iterator) {
    case .value(let r):
      return .value(r)
    case .error(.stopIteration):
      if let d = `default` {
        return .value(d)
      }

      return .error(.stopIteration)
    case .error(let e):
      return .error(e)
    }
  }

  private func callNext(iterator: PyObject) -> PyResult<PyObject> {
    if let owner = iterator as? __next__Owner {
      return owner.next()
    }

    switch self.callMethod(on: iterator, selector: "__next__") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return . typeError("'\(iterator.typeName)' object is not an iterator")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Iter

  internal static let iterDoc = """
    iter(iterable) -> iterator
    iter(callable, sentinel) -> iterator

    Get an iterator from an object.  In the first form, the argument must
    supply its own iterator, or be a sequence.
    In the second form, the callable is called until it returns the sentinel.
    """

  // sourcery: pymethod = iter, doc = iterDoc
  /// iter(object[, sentinel])
  /// See [this](https://docs.python.org/3/library/functions.html#iter)
  public func iter(from object: PyObject,
                   sentinel: PyObject? = nil) -> PyResult<PyObject> {
    if let sentinel = sentinel {
      let result = PyCallableIterator(callable: object, sentinel: sentinel)
      return .value(result)
    }

    if let owner = object as? __iter__Owner {
      let result = owner.iter()
      return .value(result)
    }

    switch self.callMethod(on: object, selector: "__iter__") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .typeError("'\(object.typeName)' object is not an iterable")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  public func hasIter(object: PyObject) -> Bool {
    switch self.iter(from: object) {
    case .value: return true
    case .error: return false
    }
  }
}
