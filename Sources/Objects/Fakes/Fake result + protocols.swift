import Foundation

public enum PyResult<Wrapped> {

  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold an `error` (meaning a subclass of `BaseException`),
  /// but in this case it is just a local variable, not an object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise an error in VM.
  case error(PyBaseException)

  static func unicodeDecodeError(encoding: PyString.Encoding,
                          data: Data) -> PyResult<Wrapped> {
    fatalError()
  }

  static func unicodeEncodeError(encoding: PyString.Encoding,
                          string: String) -> PyResult<Wrapped> {
    fatalError()
  }

  static func typeError(_ s: String) -> PyResult<Wrapped> {
    fatalError()
  }

  static func lookupError(_ s: String) -> PyResult<Wrapped> {
    fatalError()
  }

  static func unboundLocalError(variableName: String) -> PyResult<Wrapped> {
    fatalError()
  }
}

internal typealias PyFunctionResult = PyResult<PyObject>

public protocol PyFunctionResultConvertible {}
public protocol HasCustomGetMethod {}
public protocol AbstractSequence {}
public protocol AbstractDictViewIterator {}
public protocol AbstractDictView {}
public protocol AbstractSet {}
public protocol AbstractString {}
public protocol AbstractBytes {}
public protocol AbstractBuiltinFunction {}

public struct FunctionWrapper { }
