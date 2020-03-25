// In CPython:
// Python -> Modules -> posixmodule.c

// sourcery: pymodule = _os
public final class UnderscoreOS {

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()
}
