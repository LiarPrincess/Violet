// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

// sourcery: pymodule = _warnings
/// Basic warning filtering support.
///
/// It is a helper module to speed up interpreter start-up.
public final class UnderscoreWarnings {

  // The priority order for warnings configuration is (highest first):
  // - the BytesWarning filter, if needed ('-b', '-bb')
  // - any '-W' command line options; then
  // - the 'PYTHONWARNINGS' environment variable;
  // TODO: Check this thingie is 'sys.flags'

  internal static let doc = """
    _warnings provides basic warning filtering support.
    It is a helper module to speed up interpreter start-up.
    """

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()
}
