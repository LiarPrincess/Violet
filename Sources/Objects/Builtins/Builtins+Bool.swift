import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  /// Equivalent of 'not v'.
  ///
  /// int PyObject_Not(PyObject *v)
  public func not(_ object: PyObject) -> Bool {
    let isTrue = self.isTrue(object)
    return !isTrue
  }

  /// Test a value used as condition, e.g., in a for or if statement.
  ///
  /// PyObject_IsTrue(PyObject *v)
  public func isTrue(_ object: PyObject) -> Bool {
    if let bool = object as? PyBool {
      return bool.value.isTrue
    }

    if object is PyNone {
      return false
    }

    if let boolOwner = object as? __bool__Owner {
      return boolOwner.asBool()
    }

    if let lenOwner = object as? __len__Owner {
      let len = lenOwner.getLength()
      return len.isTrue
    }

    // TODO: Call user `__bool__`
    return true
  }

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return left === right
  }
}
