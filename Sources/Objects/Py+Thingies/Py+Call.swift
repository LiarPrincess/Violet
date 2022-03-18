import VioletCore

// swiftlint:disable file_length
// cSpell:ignore attrid

// In CPython:
// Objects -> call.c
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Call

  public enum CallResult {
    case value(PyObject)
    /// Object is not callable.
    case notCallable(PyBaseException)
    case error(PyBaseException)

    public var asResult: PyResult<PyObject> {
      switch self {
      case let .value(o):
        return .value(o)
      case let .error(e),
           let .notCallable(e):
        return .error(e)
      }
    }
  }

  /// Call `callable` with a single positional argument.
  public func call(callable: PyObject, arg: PyObject) -> CallResult {
    return self.call(callable: callable, args: [arg], kwargs: nil)
  }

  /// Call `callable` with positional arguments and optional keyword arguments.
  ///
  /// - Parameters:
  ///   - callable: object to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func call(callable: PyObject,
                   args: PyObject,
                   kwargs: PyObject?) -> CallResult {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(self, args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    let kwargsDict: PyDict?
    switch ArgumentParser.unpackKwargsDict(self, kwargs: kwargs) {
    case let .value(o): kwargsDict = o
    case let .error(e): return .error(e)
    }

    return self.call(callable: callable, args: argsArray, kwargs: kwargsDict)
  }

  /// Call `callable` with positional arguments and optional keyword arguments.
  ///
  /// - Parameters:
  ///   - callable: object to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  public func call(callable: PyObject,
                   args: [PyObject] = [],
                   kwargs: PyDict? = nil) -> CallResult {
    if let result = PyStaticCall.__call__(self, object: callable, args: args, kwargs: kwargs) {
      switch result {
      case let .value(result): return .value(result)
      case let .error(e): return .error(e)
      }
    }

    let result = self.callMethod(object: callable,
                                 selector: .__call__,
                                 args: args,
                                 kwargs: kwargs)

    switch result {
    case let .value(o):
      return .value(o)
    case .missingMethod:
      let message = "object of type '\(callable.typeName)' is not callable"
      let error = self.newTypeError(message: message)
      return .notCallable(error.asBaseException)
    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Is callable

  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  public func isCallable(object: PyObject) -> Bool {
    let lookup = object.type.mroLookup(self, name: .__call__)
    return lookup != nil
  }
}

// MARK: - Has method

extension Py {

  public func hasMethod(object: PyObject,
                        selector: IdString) -> PyResult<Bool> {
    let selectorString = self.resolve(id: selector)
    return self.hasMethod(object: object, selector: selectorString)
  }

  public func hasMethod(object: PyObject,
                        selector: PyString) -> PyResult<Bool> {
    let result = self.getMethod(object: object,
                                selector: selector,
                                allowsCallableFromDict: false)

    switch result {
    case .value:
      return .value(true)
    case .notFound:
      return .value(false)
    case .error(let e):
      return .error(e)
    }
  }
}

// MARK: - Get method

internal protocol HasCustomGetMethod {
  func getMethod(_ py: Py,
                 selector: PyString,
                 allowsCallableFromDict: Bool) -> Py.GetMethodResult
}

extension Py {

  public enum GetMethodResult {
    /// Method found (_yay!_), here is its value (_double yay!_).
    case value(PyObject)
    /// Such method does not exist.
    case notFound(PyBaseException)
    /// Raise error in VM.
    case error(PyBaseException)

    internal init(result: PyResult<PyObject>) {
      switch result {
      case let .value(o):
        self = .value(o)
      case let .error(e):
        self = .error(e)
      }
    }
  }

  /// DO NOT USE THIS METHOD!
  /// It is only there for `LOAD_METHOD` instruction.
  /// Use `getMethod` instead.
  ///
  /// (The difference between `loadMethod` and `getMethod` is that `loadMethod`
  /// will also include callable properties from `__dict__`.)
  public func loadMethod(object: PyObject,
                         selector: PyString) -> GetMethodResult {
    return self.getMethod(object: object,
                          selector: selector,
                          allowsCallableFromDict: true)
  }

  /// int
  /// _PyObject_GetMethod(PyObject *obj, PyObject *name, PyObject **method)
  public func getMethod(object: PyObject,
                        selector: PyString,
                        allowsCallableFromDict: Bool = false) -> GetMethodResult {
    if let obj = object as? HasCustomGetMethod {
      return obj.getMethod(self,
                           selector: selector,
                           allowsCallableFromDict: allowsCallableFromDict)
    }

    let staticProperty: PyObject?
    let staticDescriptor: GetDescriptor?

    switch object.type.mroLookup(self, name: selector) {
    case .value(let lookup):
      staticProperty = lookup.object
      staticDescriptor = GetDescriptor(self, object: object, attribute: lookup.object)
    case .notFound:
      staticProperty = nil
      staticDescriptor = nil
    case .error(let e):
      return .error(e)
    }

    if let descr = staticDescriptor, descr.isData {
      let result = descr.call()
      return GetMethodResult(result: result)
    }

    // This basically combines attribute access + method load.
    // Do not bind the result! It is 'just' a callable entry in '__dict__'.
    if allowsCallableFromDict {
      if let dict = self.get__dict__(object: object) {
        switch dict.get(self, key: selector) {
        case .value(let attr): return .value(attr)
        case .notFound: break
        case .error(let e): return .error(e)
        }
      }
    }

    if let descr = staticDescriptor {
      let result = descr.call()
      return GetMethodResult(result: result)
    }

    if let p = staticProperty {
      return .value(p)
    }

    let e = self.newAttributeError(object: object, hasNoAttribute: selector)
    return .notFound(e.asBaseException)
  }

  // MARK: - Call method

  public enum CallMethodResult {
    case value(PyObject)
    /// Such method does not exists.
    case missingMethod(PyBaseException)
    /// Method exists, but it is not callable.
    case notCallable(PyBaseException)
    case error(PyBaseException)

    public var asResult: PyResult<PyObject> {
      switch self {
      case let .value(o):
        return .value(o)
      case let .error(e),
           let .notCallable(e),
           let .missingMethod(e):
        return .error(e)
      }
    }
  }

  /// Call method with a single positional argument.
  public func callMethod(object: PyObject,
                         selector: IdString,
                         arg: PyObject) -> CallMethodResult {
    return self.callMethod(object: object, selector: selector, args: [arg])
  }

  /// Call method with a single positional argument.
  public func callMethod(object: PyObject,
                         selector: PyString,
                         arg: PyObject) -> CallMethodResult {
    return self.callMethod(object: object, selector: selector, args: [arg])
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func callMethod(object: PyObject,
                         selector: IdString,
                         args: PyObject,
                         kwargs: PyObject?) -> CallMethodResult {
    let selectorString = self.resolve(id: selector)
    return self.callMethod(object: object,
                           selector: selectorString,
                           args: args,
                           kwargs: kwargs)
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func callMethod(object: PyObject,
                         selector: PyString,
                         args: PyObject,
                         kwargs: PyObject?) -> CallMethodResult {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(self, args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    switch ArgumentParser.unpackKwargsDict(self, kwargs: kwargs) {
    case let .value(kwargsDict):
      return self.callMethod(object: object,
                             selector: selector,
                             args: argsArray,
                             kwargs: kwargsDict)
    case let .error(e):
      return .error(e)
    }
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  ///
  /// Based on CPython 'LOAD_METHOD' and 'CALL_METHOD'.
  public func callMethod(object: PyObject,
                         selector: IdString,
                         args: [PyObject] = [],
                         kwargs: PyDict? = nil,
                         allowsCallableFromDict: Bool = false) -> CallMethodResult {
    let selectorString = self.resolve(id: selector)
    return self.callMethod(object: object,
                           selector: selectorString,
                           args: args,
                           kwargs: kwargs,
                           allowsCallableFromDict: allowsCallableFromDict)
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  ///
  /// Based on CPython 'LOAD_METHOD' and 'CALL_METHOD'.
  public func callMethod(object: PyObject,
                         selector: PyString,
                         args: [PyObject] = [],
                         kwargs: PyDict? = nil,
                         allowsCallableFromDict: Bool = false) -> CallMethodResult {
    var method: PyObject
    switch self.getMethod(object: object,
                          selector: selector,
                          allowsCallableFromDict: allowsCallableFromDict) {
    case let .value(o):
      method = o
    case let .notFound(e):
      return .missingMethod(e)
    case let .error(e):
      return .error(e)
    }

    // If 'self' was not bound/captured we will manually do it.
    // We could also prepend 'object' to 'args' but this would do more allocations.
    //
    // In CPython:
    // - slot_tp_call(PyObject *self, PyObject *args, PyObject *kwds)
    // - lookup_maybe_method(PyObject *self, _Py_Identifier *attrid …)
    //
    // Examples:
    // >>> o1 = int.__add__ # type attribute -> unbound function
    // >>> o1(1,2)
    // 3
    // >>> o2 = (1).__add__ # object attribute -> bound method
    // >>> o2(1)
    // 2

    if let fn = self.cast.asBuiltinFunction(method) {
      let bound = fn.bind(self, object: object)
      method = bound.asObject
    }

    if let fn = self.cast.asFunction(method) {
      let bound = fn.bind(self, object: object)
      method = bound.asObject
    }

    switch self.call(callable: method, args: args, kwargs: kwargs) {
    case .value(let result):
      return .value(result)
    case .notCallable:
      let message = "attribute of type '\(method.typeName)' is not callable"
      let error = self.newTypeError(message: message)
      return .notCallable(error.asBaseException)
    case .error(let e):
      return .error(e)
    }
  }
}
