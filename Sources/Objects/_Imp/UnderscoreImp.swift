import Core

// In CPython:
// Python -> import.c

// sourcery: pymodule = _imp
/// (Extremely) low-level import machinery bits as used by importlib and imp.
/// Nuff said...
public final class UnderscoreImp {

  internal static let doc = """
    (Extremely) low-level import machinery bits as used by importlib and imp.
    """

  // MARK: - Exec

  /// static int
  /// exec_builtin_or_dynamic(PyObject *mod)
  internal func execBuiltinOrDynamic(module: PyModule) -> PyResult<PyNone> {
    self.unimplemented()
  }

  // MARK: - Unimplemented

  internal func unimplemented(fn: String = #function) -> Never {
    trap("'\(fn)' is not implemented")
  }
}
