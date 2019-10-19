/// Keyword argument
internal struct Kwarg {
  internal let name: String
  internal let value: PyObject
}

internal struct Args {

  /// Positional arguments
  internal let args: [PyObject]

  /// Keyword arguments
  ///
  /// We need to remember kwargs order.
  /// https://www.python.org/dev/peps/pep-0468/
  internal let kwargs: [Kwarg]

  internal init(args: [PyObject], kwargs: [Kwarg]) {
    self.args = args
    self.kwargs = kwargs
  }
}
