/// Some places refer to modules that we do not have implemented.
/// We will put all of the assumed values here.
internal enum Unimplemented {

  /// For proper implementation see:
  /// static PyObject* create_stdio(PyObject* io, ...)
  internal static let stdioEncoding = PyString.Encoding.utf8
  /// For proper implementation see:
  /// static PyObject* create_stdio(PyObject* io, ...)
  internal static let stdioErrors = PyString.ErrorHandling.strict

  /// In every place that assumes no threads we will assert on this variable.
  ///
  /// 1. Remove it to get compiler errors.
  /// 2. Fix errors.
  /// 3. Profit (everything works).
  internal static let weDoNotHaveThreads = true

  /// Python `locale` module.
  internal enum locale { // swiftlint:disable:this type_name

    /// Hardcoded 'UTF-8'.
    ///
    /// ```
    /// >>> import locale
    /// >>> locale.getpreferredencoding()
    /// 'UTF-8'
    /// ```
    internal static let getpreferredencoding = PyString.Encoding.utf8
  }
}
