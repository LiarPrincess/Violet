import Core

// In CPython:
// Objects -> call.c
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// Comment from CPython 'Python/ceval.h':
// PyObject_Call(), PyObject_CallFunction() and PyObject_CallMethod()
// are recommended to call a callable object.

public struct Arguments {
  public let args: [PyObject]
  public let kwargs: OrderedDictionary<String, PyObject>
}

extension String: PyHashable {
  public func isEqual(to other: String) -> PyResult<Bool> {
    var selfIter = self.unicodeScalars.makeIterator()
    var otherIter = other.unicodeScalars.makeIterator()

    while let selfScalar = selfIter.next(), let otherScalar = otherIter.next() {
      if selfScalar != otherScalar {
        return .value(false)
      }
    }

    let isSelfExhausted = selfIter.next() == nil
    let isOtherExhausted = otherIter.next() == nil
    return .value(isSelfExhausted && isOtherExhausted)
  }
}

internal protocol __call__Owner {
  func call(arguments: Arguments) -> PyResult<PyObject>
}

internal enum CallResult_new { // swiftlint:disable:this type_name
  case value(PyObject)
  // return .attributeError("'\(value.typeName)' object has no attribute 'abc'")
  case noSuchMethod(PyErrorEnum)
  case methodIsNotCallable(PyErrorEnum)
}

extension Builtins {

  /// PyObject *
  /// PyObject_CallMethod(PyObject *obj, const char *name, const char *format, ...)
  internal func callMethod_new(on object: PyObject,
                               selector: String,
                               args: [PyObject]) -> CallResult_new {
    let method: PyObject
    switch self.getMethod(from: object, selector: selector) {
    case let .value(o): method = o
    case let .error(e): return .noSuchMethod(e)
    }

    // TODO: Add `__call__Owner` dispatch.

    let msg = "attribute of type '\(method.typeName)' is not callable"
    return .methodIsNotCallable(.typeError(msg))
  }

  private func getMethod(from object: PyObject,
                         selector: String) -> PyResult<PyObject> {
    // We look up property on object first, and then on type!
    // >>> def f(): return 1
    //
    // >>> class C:
    // ...     def __init__(self):
    // ...             self.abc = f
    //
    // >>> c = C()
    // >>> c.abc()
    // 1

    // In recursive call (when 'getAttribute' calls 'callMethod')
    // `selector` will be '__getattribute__'.
    return self.getAttribute(object, name: selector)
  }
}
