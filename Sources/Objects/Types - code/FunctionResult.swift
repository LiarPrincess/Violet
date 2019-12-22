import Core
import Foundation

internal typealias FunctionResult = PyResultOrNot<PyObject>

internal protocol FunctionResultConvertible {
  func toFunctionResult(in context: PyContext) -> FunctionResult
}

// MARK: - Basic types

extension Bool: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(self ? context.builtins.true : context.builtins.false)
  }
}

extension Int: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(context.builtins.newInt(self))
  }
}

extension UInt8: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(context.builtins.newInt(self))
  }
}

extension BigInt: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(context.builtins.newInt(self))
  }
}

extension String: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(context.builtins.newString(self))
  }
}

extension Data: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(context.builtins.newBytes(self))
  }
}

// MARK: - Collections

extension Array: FunctionResultConvertible
  where Element: FunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    var elements = [PyObject]()
    for e in self {
      switch e.toFunctionResult(in: context) {
      case .value(let v): elements.append(v)
      case .notImplemented: return .notImplemented
      case .error(let e): return .error(e)
      }
    }

    return .value(context.builtins.newList(elements))
  }
}

extension Optional: FunctionResultConvertible
  where Wrapped: FunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    switch self {
    case .some(let v): return v.toFunctionResult(in: context)
    case .none: return .value(context.builtins.none)
    }
  }
}

// MARK: - Result

extension PyResult: FunctionResultConvertible
  where V: FunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    switch self {
    case let .value(v): return v.toFunctionResult(in: context)
    case let .error(e): return .error(e)
    }
  }
}

extension PyResultOrNot: FunctionResultConvertible
  where V: FunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return self.flatMap { $0.toFunctionResult(in: context) }
  }
}

// MARK: - Violet

extension PyObject: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    return .value(self)
  }
}

extension Attributes: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    let builtins = context.builtins

    let args = self.entries.map { entry -> CreateDictionaryArg in
      let key = builtins.newString(entry.key)
      return CreateDictionaryArg(key: key, value: entry.value)
    }

    switch builtins.newDict(args) {
    case let .value(dict):
      return .value(dict)
    case let .error(e):
      return .error(e)
    }
  }
}

extension DirResult: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    let builtins = context.builtins
    let elements = self.sortedValues.map { builtins.newString($0) }
    return .value(builtins.newList(elements))
  }
}
