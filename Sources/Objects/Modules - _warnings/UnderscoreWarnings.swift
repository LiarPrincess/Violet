// In CPython:
// Python -> _warnings.c

// sourcery: pymodule = _warnings
/// Low-level inferface to warnings functionality.
public final class UnderscoreWarnings {

  internal static let doc = "Low-level inferface to warnings functionality."

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()

  // The priority order for warnings configuration is (highest first):
  // - the BytesWarning filter, if needed ('-b', '-bb')
  // - any '-W' command line options; then
  // - the 'PYTHONWARNINGS' environment variable;
  // TODO: Check this thingie is 'sys.flags'
}
