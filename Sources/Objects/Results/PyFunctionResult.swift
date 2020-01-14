import Core
import Foundation

/// Return type of a Python function.
internal typealias PyFunctionResult = PyResult<PyObject>

/// Object can be returned from a Python function.
internal protocol PyFunctionResultConvertible {
  func toFunctionResult(in context: PyContext) -> PyFunctionResult
}

// MARK: - Basic types

extension Bool: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(self ? context.builtins.true : context.builtins.false)
  }
}

extension Int: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(context.builtins.newInt(self))
  }
}

extension UInt8: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(context.builtins.newInt(self))
  }
}

extension BigInt: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(context.builtins.newInt(self))
  }
}

extension String: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(context.builtins.newString(self))
  }
}

extension Data: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(context.builtins.newBytes(self))
  }
}

// MARK: - Collections

extension Array: PyFunctionResultConvertible
  where Element: PyFunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    var elements = [PyObject]()
    elements.reserveCapacity(self.count)

    for e in self {
      switch e.toFunctionResult(in: context) {
      case .value(let v): elements.append(v)
      case .error(let e): return .error(e)
      }
    }

    return .value(context.builtins.newList(elements))
  }
}

extension Optional: PyFunctionResultConvertible
  where Wrapped: PyFunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    switch self {
    case .some(let v): return v.toFunctionResult(in: context)
    case .none: return .value(context.builtins.none)
    }
  }
}
