// In CPython:
// Python -> _warnings.c

// sourcery: pymodule = _warnings
/// Low-level inferface to warnings functionality.
public final class UnderscoreWarnings {

  internal static let doc = "Low-level inferface to warnings functionality."

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()
}
