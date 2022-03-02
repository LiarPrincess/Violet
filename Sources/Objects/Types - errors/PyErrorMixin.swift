internal protocol PyErrorMixin: PyObjectMixin {}

extension PyErrorMixin  {

  internal var errorHeader: PyErrorHeader {
    // Assumption: headerOffset = 0, but this should be valid for all of our types.
    return PyErrorHeader(ptr: self.ptr)
  }
}
