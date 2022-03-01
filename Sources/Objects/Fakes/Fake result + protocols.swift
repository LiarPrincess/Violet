import Foundation

// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

extension PyResult {

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

public struct FunctionWrapper { }
public protocol HasCustomGetMethod {}
public protocol AbstractSequence {}
public protocol AbstractDictViewIterator {}
public protocol AbstractDictView {}
public protocol AbstractSet {}
public protocol AbstractString {}
public protocol AbstractBytes {}
public protocol AbstractBuiltinFunction {}
