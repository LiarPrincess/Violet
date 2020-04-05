// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

// sourcery: pymodule = _warnings
/// Basic warning filtering support.
///
/// It is a helper module to speed up interpreter start-up.
public final class UnderscoreWarnings {

  internal static let doc = """
    _warnings provides basic warning filtering support.
    It is a helper module to speed up interpreter start-up.
    """

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()
}
