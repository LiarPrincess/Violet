import VioletCore

// In CPython:
// Objects -> call.c
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length

extension PyInstance {

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

  /// Call `callable` with single positional argument.
  public func call(callable: PyObject, arg: PyObject) -> CallResult {
    return self.call(callable: callable, args: [arg], kwargs: nil)
  }

  /// Call with positional arguments and optional keyword arguments.
  ///
  /// - Parameters:
  ///   - callable: object to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func call(callable: PyObject,
                   args: PyObject,
                   kwargs: PyObject?) -> CallResult {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    switch ArgumentParser.unpackKwargsDict(kwargs: kwargs) {
    case let .value(kwargsDict):
      return self.call(callable: callable, args: argsArray, kwargs: kwargsDict)
    case let .error(e):
      return .error(e)
    }
  }

  /// Call with positional arguments and optional keyword arguments.
  ///
  /// - Parameters:
  ///   - callable: object to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  public func call(callable: PyObject,
                   args: [PyObject] = [],
                   kwargs: PyDict? = nil) -> CallResult {
    if let result = Fast.__call__(callable, args: args, kwargs: kwargs) {
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
      let msg = "object of type '\(callable.typeName)' is not callable"
      return .notCallable(self.newTypeError(msg: msg))
    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Is callable

  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  public func callable(object: PyObject) -> PyResult<Bool> {
    if object.type.lookup(name: .__call__) != nil {
      return .value(true)
    }

    return .value(false)
  }
}

// MARK: - Has method

extension PyInstance {

  public func hasMethod(object: PyObject,
                        selector: IdString) -> PyResult<Bool> {
    return self.hasMethod(object: object, selector: selector.value)
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
  func getMethod(selector: PyString,
                 allowsCallableFromDict: Bool) -> PyInstance.GetMethodResult
}

extension PyInstance {

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
      return obj.getMethod(selector: selector,
                           allowsCallableFromDict: allowsCallableFromDict)
    }

    let staticProperty: PyObject?
    let staticDescriptor: GetDescriptor?

    switch object.type.lookup(name: selector) {
    case .value(let attr):
      staticProperty = attr
      staticDescriptor = GetDescriptor(object: object, attribute: attr)
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
        switch dict.get(key: selector) {
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

    let e = self.newAttributeError(object: object, hasNoAttribute: selector.value)
    return .notFound(e)
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

  /// Call method with single positional argument.
  public func callMethod(object: PyObject,
                         selector: IdString,
                         arg: PyObject) -> CallMethodResult {
    return self.callMethod(object: object, selector: selector, args: [arg])
  }

  /// Call method with single positional argument.
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
    return self.callMethod(object: object,
                           selector: selector.value,
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
    switch ArgumentParser.unpackArgsTuple(args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    switch ArgumentParser.unpackKwargsDict(kwargs: kwargs) {
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
    return self.callMethod(object: object,
                           selector: selector.value,
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

    if let fn = method as? PyBuiltinFunction {
      method = fn.bind(to: object)
    }
    if let fn = method as? PyFunction {
      method = fn.bind(to: object)
    }

    switch self.call(callable: method, args: args, kwargs: kwargs) {
    case .value(let result):
      return .value(result)
    case .notCallable:
      let msg = "attribute of type '\(method.typeName)' is not callable"
      return .notCallable(self.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }
}
