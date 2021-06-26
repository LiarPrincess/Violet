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
    if let result = Fast.__next__(iterator) {
      return result
    }

    switch self.callMethod(object: iterator, selector: .__next__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .typeError("'\(iterator.typeName)' object is not an iterator")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Iter

  /// This is the version of `iter` that you probably want to use!
  /// (as opposed to the one with `sentinel` argument)
  public func iter(object: PyObject) -> PyResult<PyObject> {
    // Check for '__iter__'.
    if let result = Fast.__iter__(object) {
      return .value(result)
    }

    switch self.callMethod(object: object, selector: .__iter__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      break
    case .error(let e), .notCallable(let e):
      return .error(e)
    }

    // Having '__getitem__' is also acceptable.
    switch self.hasMethod(object: object, selector: .__getitem__) {
    case .value(true):
      let iter = PyMemory.newIterator(sequence: object)
      return .value(iter)
    case .value(false):
      return .typeError("'\(object.typeName)' object is not an iterable")
    case .error(let e):
      return .error(e)
    }
  }

  /// This is the builtin version of `iter` (the one with `sentinel`).
  ///
  /// iter(object[, sentinel])
  /// See [this](https://docs.python.org/3/library/functions.html#iter)
  public func iter(object: PyObject, sentinel: PyObject?) -> PyResult<PyObject> {
    guard let sentinel = sentinel else {
      return self.iter(object: object)
    }

    switch self.callable(object: object) {
    case .value(true):
      break
    case .value(false):
      return .typeError("iter(v, w): v must be callable")
    case .error(let e):
      return .error(e)
    }

    let result = PyMemory.newCallableIterator(callable: object, sentinel: sentinel)
    return .value(result)
  }

  // MARK: - Has iter

  public func hasIter(object: PyObject) -> Bool {
    switch self.iter(object: object) {
    case .value: return true
    case .error: return false
    }
  }
}
