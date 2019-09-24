// Method table for single type.
public class PyType {

  // MARK: - Repr

  // TODO: Performance (move it to PyObject as bit?)
  private static var enteredRepr = [PyObject]()

  /// These methods are used to control infinite recursion in repr, str, print, etc.
  /// Container objects that may recursively contain themselves, e.g. builtin
  /// dictionaries and lists, should use `reprEnter()` and `reprLeave()`
  /// to avoid infinite recursion.
  internal func reprEnter(object: PyObject) -> Bool {
    return PyType.enteredRepr
      .reversed()
      .contains { $0 === object }
  }

  internal func reprLeave(object: PyObject) {
    PyType.enteredRepr.removeAll { $0 === object }
  }
}
