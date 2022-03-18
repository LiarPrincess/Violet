// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - New

  public func newType(name: String,
                      qualname: String,
                      flags: PyType.TypeFlags,
                      base: PyType,
                      mro: MethodResolutionOrder,
                      instanceSizeWithoutTail: Int,
                      staticMethods: PyStaticCall.KnownNotOverriddenMethods,
                      debugFn: @escaping PyType.DebugFn,
                      deinitialize: @escaping PyType.DeinitializeFn) -> PyType {
    let metatype = self.types.type
    return self.memory.newType(self,
                               type: metatype,
                               name: name,
                               qualname: qualname,
                               flags: flags,
                               base: base,
                               bases: mro.baseClasses,
                               mroWithoutSelf: mro.resolutionOrder,
                               subclasses: [],
                               instanceSizeWithoutTail: instanceSizeWithoutTail,
                               staticMethods: staticMethods,
                               debugFn: debugFn,
                               deinitialize: deinitialize)
  }

  // MARK: - Is instance

  /// isinstance(object, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#isinstance)
  public func isInstance(object: PyObject,
                         of typeOrTuple: PyObject) -> PyResult<Bool> {
    let objectType = object.type
    if objectType.ptr === typeOrTuple.ptr {
      return .value(true)
    }

    if let type = self.cast.asExactlyType(typeOrTuple) {
      let result = objectType.isSubtype(of: type)
      return .value(result)
    }

    if let tuple = self.cast.asTuple(typeOrTuple) {
      for type in tuple.elements {
        switch self.isInstance(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }

      return .value(false)
    }

    switch self.call__instancecheck__(instance: object, type: typeOrTuple) {
    case let .value(object):
      return self.isTrueBool(object: object)
    case let .error(e):
      return .error(e)
    }
  }

  private func call__instancecheck__(instance: PyObject,
                                     type: PyObject) -> PyResult<PyObject> {
    if let result = PyStaticCall.__instancecheck__(self, type: type, object: instance) {
      return PyResult(result)
    }

    switch self.callMethod(object: type, selector: .__instancecheck__, arg: instance) {
    case .value(let o):
      return PyResult(o)
    case .missingMethod:
      let message = "isinstance() arg 2 must be a type or tuple of types"
      return .typeError(self, message: message)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Is subclass

  /// issubclass(class, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#issubclass)
  public func isSubclass(object: PyObject,
                         of typeOrTuple: PyObject) -> PyResult<Bool> {
    if let `super` = self.cast.asExactlyType(typeOrTuple) {
      guard let type = self.cast.asType(object) else {
        return .typeError(self, message: "issubclass() arg 1 must be a class")
      }

      let result = type.isSubtype(of: `super`)
      return .value(result)
    }

    if let tuple = self.cast.asTuple(typeOrTuple) {
      for type in tuple.elements {
        switch self.isSubclass(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }

      return .value(false)
    }

    switch self.call__subclasscheck__(type: object, super: typeOrTuple) {
    case let .value(object):
      return self.isTrueBool(object: object)
    case let .error(e):
      return .error(e)
    }
  }

  private func call__subclasscheck__(type: PyObject,
                                     super: PyObject) -> PyResult<PyObject> {
    // This method is called on 'super'! Not on object!
    if let result = PyStaticCall.__subclasscheck__(self, type: `super`, base: type) {
      return PyResult(result)
    }

    switch self.callMethod(object: `super`,
                           selector: .__subclasscheck__,
                           arg: type) {
    case .value(let o):
      return PyResult(o)
    case .missingMethod:
      let message = "issubclass() arg 2 must be a class or tuple of classes"
      return .typeError(self, message: message)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
