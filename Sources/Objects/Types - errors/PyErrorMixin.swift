public protocol PyErrorMixin: PyObjectMixin {}

extension PyErrorMixin {

  /// [Convenience] Convert this object to `PyBaseException`.
  public var asBaseException: PyBaseException {
    return PyBaseException(ptr: self.ptr)
  }
}
