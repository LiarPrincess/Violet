import Core

// In CPython:
// Objects -> call.c
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// Comment from CPython 'Python/ceval.h':
// PyObject_Call(), PyObject_CallFunction() and PyObject_CallMethod()
// are recommended to call a callable object.

public enum CallResult_new { // swiftlint:disable:this type_name
  case value(PyObject)
  case notImplemented
  case noSuchMethod(PyErrorEnum)
  case methodIsNotCallable(PyErrorEnum)
  case error(PyErrorEnum)
}

extension Builtins {

  /// Internal API to look for a name through the MRO.
  public func lookup(_ object: PyObject, name: String) -> PyObject? {
    return object.type.lookup(name: name)
  }

  /// PyObject *
  /// PyObject_CallMethod(PyObject *obj, const char *name, const char *format, ...)
  public func callMethod_new(on object: PyObject,
                             selector: String,
                             args: [PyObject],
                             kwargs: PyObject) -> CallResult_new {
    guard let method = object.type.lookup(name: selector) else {
      let msg = "'\(object.typeName)' object has no attribute '\(selector)'"
      return .noSuchMethod(.attributeError(msg))
    }

    let realArgs = PyTuple(self.context, elements: [object] + args)

    if let owner = method as? __call__Owner {
      switch owner.call(args: realArgs, kwargs: kwargs) {
      case .value(let result): return .value(result)
      case .notImplemented: return .notImplemented
      case .error(let e): return .error(e)
      }
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

    let msg = "attribute of type '\(method.typeName)' is not callable"
    return .methodIsNotCallable(.typeError(msg))
  }
}
