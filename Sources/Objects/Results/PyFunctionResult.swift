import Foundation
import BigInt
import VioletCore

/// Return type of a Python function.
public typealias PyFunctionResult = PyResult<PyObject>

/// Object that can be returned from a Python function.
public protocol PyFunctionResultConvertible {
  var asFunctionResult: PyFunctionResult { get }
}

// MARK: - Basic types

/* MARKER
extension Bool: PyFunctionResultConvertible {
  public var asFunctionResult: PyFunctionResult {
    return .value(Py.newBool(self).asObject)
  }
}

extension Int: PyFunctionResultConvertible {
  public var asFunctionResult: PyFunctionResult {
    return .value(Py.newInt(self).asObject)
  }
}

extension UInt8: PyFunctionResultConvertible {
  public var asFunctionResult: PyFunctionResult {
    return .value(Py.newInt(self).asObject)
  }
}

extension BigInt: PyFunctionResultConvertible {
  public var asFunctionResult: PyFunctionResult {
    return .value(Py.newInt(self).asObject)
  }
}

extension String: PyFunctionResultConvertible {
  public var asFunctionResult: PyFunctionResult {
    return .value(Py.newString(self).asObject)
  }
}

extension Optional: PyFunctionResultConvertible
  where Wrapped: PyFunctionResultConvertible {

  public var asFunctionResult: PyFunctionResult {
    switch self {
    case .some(let v): return v.asFunctionResult
    case .none: return .value(Py.none.asObject)
    }
  }
}
*/
