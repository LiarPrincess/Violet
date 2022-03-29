// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// cSpell:ignore attrid

extension Py {

  // MARK: - New

  // swiftlint:disable:next function_parameter_count
  public func newType(name: String,
                      qualname: String,
                      flags: PyType.Flags,
                      base: PyType,
                      mro: MethodResolutionOrder,
                      instanceSizeWithoutTail: Int,
                      staticMethods: PyStaticCall.KnownNotOverriddenMethods,
                      debugFn: @escaping PyType.DebugFn,
                      deinitialize: @escaping PyType.DeinitializeFn) -> PyType {
    let metatype = self.types.type
    return self.memory.newType(type: metatype,
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

  // MARK: - Properties

  public func getName(type: PyType) -> String {
    return type.getNameString()
  }

  // MARK: - MRO

  public enum LookupResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  /// Look for a name through `object.type` MRO.
  ///
  /// _PyObject_LookupSpecial(PyObject *self, _Py_Identifier *attrid)
  public func mroLookup(object: PyObject, name: IdString) -> LookupResult {
    let type = object.type
    guard let lookup = type.mroLookup(self, name: name) else {
      return .notFound
    }

    if let descr = GetDescriptor(self, object: object, attribute: lookup.object) {
      switch descr.call() {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    return .value(lookup.object)
  }

  // MARK: - Is instance

  /// isinstance(object, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#isinstance)
  public func isInstance(object: PyObject, of typeOrTuple: PyObject) -> PyResultGen<Bool> {
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

  private func call__instancecheck__(instance: PyObject, type: PyObject) -> PyResult {
    if let result = PyStaticCall.__instancecheck__(self, type: type, object: instance) {
      return result
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
  public func isSubclass(object: PyObject, of typeOrTuple: PyObject) -> PyResultGen<Bool> {
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

  private func call__subclasscheck__(type: PyObject, super: PyObject) -> PyResult {
    // This method is called on 'super'! Not on object!
    if let result = PyStaticCall.__subclasscheck__(self, type: `super`, base: type) {
      return result
    }

    switch self.callMethod(object: `super`, selector: .__subclasscheck__, arg: type) {
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
