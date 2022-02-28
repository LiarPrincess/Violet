public enum PyResult<Wrapped> {

  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold an `error` (meaning a subclass of `BaseException`),
  /// but in this case it is just a local variable, not an object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise an error in VM.
  case error(PyBaseException)
}

internal typealias PyFunctionResult = PyResult<PyObject>

public protocol PyFunctionResultConvertible {}
public protocol HasCustomGetMethod {}
