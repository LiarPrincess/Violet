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

    if let type = PyCast.asExactlyType(typeOrTuple) {
      let result = type.isType(of: object)
      return .value(result)
    }

    if let tuple = PyCast.asTuple(typeOrTuple) {
      for type in tuple.elements {
        switch self.isInstance(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }

      return .value(false)
    }

    return self.call__instancecheck__(instance: object, type: typeOrTuple)
  }

  private func call__instancecheck__(instance: PyObject,
                                     type: PyObject) -> PyResult<Bool> {
    if let result = Fast.__instancecheck__(type, of: instance) {
      return .value(result)
    }

    switch self.callMethod(object: type,
                           selector: .__instancecheck__,
                           arg: instance) {
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
    if let `super` = PyCast.asExactlyType(typeOrTuple) {
      guard let type = PyCast.asType(object) else {
        return .typeError("issubclass() arg 1 must be a class")
      }

      let result = type.isSubtype(of: `super`)
      return .value(result)
    }

    if let tuple = PyCast.asTuple(typeOrTuple) {
      for type in tuple.elements {
        switch self.isSubclass(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }

      return .value(false)
    }

    return self.call__subclasscheck__(type: object, super: typeOrTuple)
  }

  private func call__subclasscheck__(type: PyObject,
                                     super: PyObject) -> PyResult<Bool> {
    // This method is called on 'super'! Not on object!
    if let result = Fast.__subclasscheck__(`super`, of: type) {
      return result
    }

    switch self.callMethod(object: `super`,
                           selector: .__subclasscheck__,
                           arg: type) {
    case .value(let o):
      return self.isTrueBool(o)
    case .missingMethod:
      return .typeError("issubclass() arg 2 must be a class or tuple of classes")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
