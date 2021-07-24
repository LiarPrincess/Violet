import Foundation
import BigInt
import VioletCore

/// Return type of a Python function.
internal typealias PyFunctionResult = PyResult<PyObject>

/// Object that can be returned from a Python function.
internal protocol PyFunctionResultConvertible {
  var asFunctionResult: PyFunctionResult { get }
}

// MARK: - Basic types

extension Bool: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(Py.newBool(self))
  }
}

extension Int: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(Py.newInt(self))
  }
}

extension UInt8: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(Py.newInt(self))
  }
}

extension BigInt: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(Py.newInt(self))
  }
}

extension String: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(Py.newString(self))
  }
}

extension Optional: PyFunctionResultConvertible
  where Wrapped: PyFunctionResultConvertible {

  internal var asFunctionResult: PyFunctionResult {
    switch self {
    case .some(let v): return v.asFunctionResult
    case .none: return .value(Py.none)
    }
  }
}
