internal enum Unimplemented {

  /// For proper implementation see:
  /// static PyObject* create_stdio(PyObject* io, ...)
  internal static let stdioEncoding = FileEncoding.utf8
  /// For proper implementation see:
  /// static PyObject* create_stdio(PyObject* io, ...)
  internal static let stdioErrors = FileErrorHandler.strict

  /// Python `locale` module.
  internal enum locale { // swiftlint:disable:this type_name

    /// Hardcoded 'UTF-8'.
    ///
    ///```
    /// >>> import locale
    /// >>> locale.getpreferredencoding()
    /// 'UTF-8'
    ///```
    internal static let getpreferredencoding = FileEncoding.utf8
  }
}
