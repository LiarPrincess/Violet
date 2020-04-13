// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Is instance

  /// isinstance(object, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#isinstance)
  public func isInstance(object: PyObject,
                         of typeOrTuple: PyObject) -> PyResult<Bool> {
    if object.type === typeOrTuple {
      return .value(true)
    }

    if let tuple = typeOrTuple as? PyTuple {
      for type in tuple.elements {
        switch self.isInstance(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }
    }

    return self.call__instancecheck__(instance: object, type: typeOrTuple)
  }

  private func call__instancecheck__(instance: PyObject,
                                     type: PyObject) -> PyResult<Bool> {
    if let owner = type as? __instancecheck__Owner {
      let result = owner.isType(of: instance)
      return .value(result)
    }

    switch self.callMethod(object: type, selector: .__instancecheck__, arg: instance) {
    case .value(let o):
      return self.isTrueBool(o)
    case .missingMethod:
      return .typeError("isinstance() arg 2 must be a type or tuple of types")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Is subclass

  /// issubclass(class, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#issubclass)
  public func isSubclass(object: PyObject,
                         of typeOrTuple: PyObject) -> PyResult<Bool> {
    if object.type === typeOrTuple {
      return .value(true)
    }

    if let tuple = typeOrTuple as? PyTuple {
      for type in tuple.elements {
        switch self.isSubclass(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }
    }

    return self.call__subclasscheck__(type: object, super: typeOrTuple)
  }

  private func call__subclasscheck__(type: PyObject,
                                     super: PyObject) -> PyResult<Bool> {
    if let owner = type as? __subclasscheck__Owner {
      return owner.isSubtype(of: `super`)
    }

    switch self.callMethod(object: type, selector: .__subclasscheck__, arg: `super`) {
    case .value(let o):
      return self.isTrueBool(o)
    case .missingMethod:
      return .typeError("issubclass() arg 1 must be a class")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
