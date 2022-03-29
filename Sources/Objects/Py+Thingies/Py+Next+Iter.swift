extension Py {

  // MARK: - Next

  /// next(iterator[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#next)
  public func next(iterator: PyObject, default: PyObject? = nil) -> PyResult {
    switch self.callNext(iterator: iterator) {
    case .value(let r):
      return .value(r)

    case .error(let e):
      if let d = `default`, self.cast.isStopIteration(e.asObject) {
        return .value(d)
      }

      return .error(e)
    }
  }

  private func callNext(iterator: PyObject) -> PyResult {
    if let result = PyStaticCall.__next__(self, object: iterator) {
      return result
    }

    switch self.callMethod(object: iterator, selector: .__next__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      let message = "'\(iterator.typeName)' object is not an iterator"
      return .typeError(self, message: message)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Iter

  /// This is the version of `iter` that you probably want to use!
  /// (as opposed to the one with `sentinel` argument)
  public func iter(object: PyObject) -> PyResult {
    // Check for '__iter__'.
    if let result = PyStaticCall.__iter__(self, object: object) {
      return result
    }

    switch self.callMethod(object: object, selector: .__iter__) {
    case .value(let o):
      return PyResult(o)
    case .missingMethod:
      break
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    // Having '__getitem__' is also acceptable.
    switch self.hasMethod(object: object, selector: .__getitem__) {
    case .value(true):
      let type = self.types.iterator
      let iter = self.memory.newIterator(type: type, sequence: object)
      return PyResult(iter)
    case .value(false):
      let message = "'\(object.typeName)' object is not an iterable"
      return .typeError(self, message: message)
    case .error(let e):
      return .error(e)
    }
  }

  /// This is the builtin version of `iter` (the one with `sentinel`).
  ///
  /// iter(object[, sentinel])
  /// See [this](https://docs.python.org/3/library/functions.html#iter)
  public func iter(object: PyObject, sentinel: PyObject?) -> PyResult {
    guard let sentinel = sentinel else {
      return self.iter(object: object)
    }

    guard self.isCallable(object: object) else {
      return .typeError(self, message: "iter(v, w): v must be callable")
    }

    let type = self.types.callable_iterator
    let result = self.memory.newCallableIterator(type: type,
                                                 callable: object,
                                                 sentinel: sentinel)

    return PyResult(result)
  }

  // MARK: - Has iter

  public func hasIter(object: PyObject) -> Bool {
    switch self.iter(object: object) {
    case .value: return true
    case .error: return false
    }
  }
}
