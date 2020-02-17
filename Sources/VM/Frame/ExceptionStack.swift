import Objects

/// In CPython part of `PyThreadState`.
internal struct ExceptionStack {

  /// Exception that is currently being handled.
  ///
  /// CPython: `_PyErr_StackItem *exc_info`
  internal var current: PyBaseException?
}
