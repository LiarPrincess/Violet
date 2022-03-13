public protocol PyErrorMixin: PyObjectMixin {}

extension PyErrorMixin {

  internal var errorHeader: PyErrorHeader {
    // Assumption: headerOffset = 0, but this should be valid for all of our types.
    return PyErrorHeader(ptr: self.ptr)
  }

  internal var args: PyTuple {
    get { self.errorHeader.args }
    nonmutating set { self.errorHeader.args = newValue }
  }

  internal var traceback: PyTraceback? {
    get { self.errorHeader.traceback }
    nonmutating set { self.errorHeader.traceback = newValue }
  }

  /// `raise from xxx`.
  internal var cause: PyBaseException? {
    get { self.errorHeader.cause }
    nonmutating set { self.errorHeader.cause = newValue }
  }

  /// Another exception during whose handling this exception was raised.
  internal var context: PyBaseException? {
    get { self.errorHeader.context }
    nonmutating set { self.errorHeader.context = newValue }
  }

  /// Should we use `self.cause` or `self.context`?
  ///
  /// If we have `cause` then probably `cause`, otherwise `context`.
  internal var suppressContext: Bool {
    get { self.errorHeader.suppressContext }
    nonmutating set { self.errorHeader.suppressContext = newValue }
  }

  /// [Convenience] Convert this object to `PyObject`.
  public var asBaseException: PyBaseException { PyBaseException(ptr: self.ptr) }
}
