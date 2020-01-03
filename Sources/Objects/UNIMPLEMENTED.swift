internal enum Unimplemented {
  /// For proper implementation see:
  /// static PyObject* create_stdio(PyObject* io, ...)
  internal static let stdioEncoding = FileEncoding.utf8
  /// For proper implementation see:
  /// static PyObject* create_stdio(PyObject* io, ...)
  internal static let stdioErrors = FileErrorHandler.strict
}
