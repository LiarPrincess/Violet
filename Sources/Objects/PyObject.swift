public class PyObject: Equatable, Hashable {

  public init() { }

  // MARK: - Repr

  private static var enteredRepr = Set<PyObject>()

  /// These methods are used to control infinite recursion in repr, str, print, etc.
  /// Container objects that may recursively contain themselves, e.g. builtin
  /// dictionaries and lists, should use `reprEnter()` and `reprLeave()`
  /// to avoid infinite recursion.
  internal func reprEnter() -> Bool {
    return PyObject.enteredRepr.contains(self)
  }

  internal func reprLeave() {
    PyObject.enteredRepr.remove(self)
  }

  public var repr: String {
    return ""
  }

  // MARK: - Equatable, Hashable

  // TODO: Fill
  public static func == (lhs: PyObject, rhs: PyObject) -> Bool {
    return false
  }

  public func hash(into hasher: inout Hasher) { }
}
