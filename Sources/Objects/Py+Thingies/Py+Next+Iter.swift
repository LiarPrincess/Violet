extension PyInstance {

  // MARK: - Next

  /// next(iterator[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#next)
  public func next(iterator: PyObject,
                   default: PyObject? = nil) -> PyResult<PyObject> {
    switch self.callNext(iterator: iterator) {
    case .value(let r):
      return .value(r)

    case .error(let e):
      if let d = `default`, e.isStopIteration {
        return .value(d)
      }

      return .error(e)
    }
  }

  private func callNext(iterator: PyObject) -> PyResult<PyObject> {
    if let owner = iterator as? __next__Owner {
      return owner.next()
    }

    switch self.callMethod(object: iterator, selector: .__next__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return . typeError("'\(iterator.typeName)' object is not an iterator")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Iter

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

    switch self.callMethod(object: object, selector: .__iter__) {
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
