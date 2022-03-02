import Foundation
import FileSystem
import VioletCore

/// Result of a `Python` operation.
///
/// It is the truth universally acknowledged that EVERYTHING FAILS.
///
/// On a type-system level:
/// given a type `Wrapped` it will add an `error` possibility to it.
public enum PyResult<Wrapped> {

  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold an `error` (meaning a subclass of `BaseException`),
  /// but in this case it is just a local variable, not an object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise an error in VM.
  case error(PyBaseException)

  public func map<A>(_ f: (Wrapped) -> A) -> PyResult<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  public func flatMap<A>(_ f: (Wrapped) -> PyResult<A>) -> PyResult<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }
}

extension PyResult where Wrapped == PyObject {

  internal static func none(_ py: Py) -> PyResult {
    return .value(py.none.asObject)
  }


  internal static func notImplemented(_ py: Py) -> PyResult {
    return .value(py.notImplemented.asObject)
  }
}
