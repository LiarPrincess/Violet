import Core

// In CPython:
// Objects -> call.c
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// Comment from CPython 'Python/ceval.h':
// PyObject_Call(), PyObject_CallFunction() and PyObject_CallMethod()
// are recommended to call a callable object.

public enum CallResult {
  case value(PyObject)
  /// Object is not callable.
  case notCallable(PyErrorEnum)
  case error(PyErrorEnum)
}

public enum CallMethodResult {
  case value(PyObject)
  /// Such method does not exists.
  case missingMethod(PyErrorEnum)
  /// Method exists, but it is not callable.
  case notCallable(PyErrorEnum)
  case error(PyErrorEnum)
}

extension BuiltinFunctions {

  // MARK: - Lookup

  /// Internal API to look for a name through the MRO.
  public func lookup(_ object: PyObject, name: String) -> PyObject? {
    return object.type.lookup(name: name)
  }

  // MARK: - Callable

  // sourcery: pymethod = callable
  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  public func isCallable(_ object: PyObject) -> Bool {
    return object is __call__Owner
      || self.lookup(object, name: "__call__") != nil
  }

  // MARK: - Call

  public func call(callable: PyObject, args: [PyObject]) -> CallResult {
    return self.call(callable: callable, args: args, kwargs: nil)
  }

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

  internal func call(callable: PyObject,
                     arg: PyObject) -> CallResult {
    return self.call(callable: callable, args: [arg], kwargs: nil)
  }

  internal func call(callable: PyObject,
                     args: [PyObject] = [],
                     kwargs: PyDictData? = nil) -> CallResult {
    guard let owner = callable as? __call__Owner else {
      let msg = "object of type '\(callable.typeName)' is not callable"
      return .notCallable(.typeError(msg))
    }

    switch owner.call(args: args, kwargs: kwargs) {
    case .value(let result):
      return .value(result)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Method

  public func callMethod(on object: PyObject,
                         selector: String,
                         args: PyObject,
                         kwargs: PyObject?) -> CallMethodResult {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    switch ArgumentParser.unpackKwargsDict(kwargs: kwargs) {
    case let .value(kwargsDict):
      return self.callMethod(on: object,
                             selector: selector,
                             args: argsArray,
                             kwargs: kwargsDict)
    case let .error(e):
      return .error(e)
    }
  }

  /// Call method with single arg.
  internal func callMethod(on object: PyObject,
                           selector: String,
                           arg: PyObject) -> CallMethodResult {
    return self.callMethod(on: object, selector: selector, args: [arg])
  }

  /// PyObject *
  /// PyObject_CallMethod(PyObject *obj, const char *name, const char *format, ...)
  internal func callMethod(on object: PyObject,
                           selector: String,
                           args: [PyObject] = [],
                           kwargs: PyDictData? = nil) -> CallMethodResult {
    guard let boundMethod = self.lookup(object, name: selector) else {
      let msg = "'\(object.typeName)' object has no attribute '\(selector)'"
      return .missingMethod(.attributeError(msg))
    }

    // Case that is not supported in this method
    // (because it is actually a callable property):
    // >>> class F():
    // ...     def __call__(self, arg): print(arg)
    // >>> class C:
    // ...     def __init__(self, f): self.f = f
    //
    // >>> f = F()
    // >>> c = C(f)
    // >>> c.f(1) <-- we are calling method 'f' on object 'c'
    // 1

    switch self.call(callable: boundMethod, args: args, kwargs: kwargs) {
    case .value(let result):
      return .value(result)
    case .notCallable:
      let msg = "attribute of type '\(boundMethod.typeName)' is not callable"
      return .notCallable(.typeError(msg))
    case .error(let e):
      return .error(e)
    }
  }
}
