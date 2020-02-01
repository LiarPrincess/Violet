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
  case notCallable(PyBaseException)
  case error(PyBaseException)
}

public enum CallMethodResult {
  case value(PyObject)
  /// Such method does not exists.
  case missingMethod(PyBaseException)
  /// Method exists, but it is not callable.
  case notCallable(PyBaseException)
  case error(PyBaseException)
}

extension BuiltinFunctions {

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
      return .notCallable(self.newTypeError(msg: msg))
    }

    // TODO: What if user wrote their own '__call__'? -> lookup through MRO.

    switch owner.call(args: args, kwargs: kwargs) {
    case .value(let result):
      return .value(result)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Callable

  // sourcery: pymethod = callable
  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  public func isCallable(_ object: PyObject) -> PyResult<Bool> {
    if object is __call__Owner {
      return .value(true)
    }

    return self.hasAttribute(object, name: "__call__")
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
    let boundMethod: PyObject
    switch self.getAttribute(object, name: selector) {
    case let .value(m): boundMethod = m
    case let .error(e): return .error(e)
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
      return .notCallable(self.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }
}
