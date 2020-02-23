internal typealias PyId = PyString

/// Predefined commonly used strings.
///
/// Most of the time used as a key to `__dict__` query.
/// Interned for performance.
/// Kind of similiar to `PyId_` in `CPython`.
internal enum Ids {

  internal static var __name__:    PyId { return self.get("__name__") }
  internal static var __package__: PyId { return self.get("__package__") }
  internal static var __path__:    PyId { return self.get("__path__") }
  internal static var __spec__:    PyId { return self.get("__spec__") }

  private static func get(_ id: String) -> PyId {
    return Py.getInterned(id)
  }
}
