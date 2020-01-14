import Core
import Foundation

public enum PyErrorEnum: CustomStringConvertible {
  case typeError(String)
  case valueError(String)
  case indexError(String)
  case attributeError(String)
  case zeroDivisionError(String)
  case overflowError(String)
  case systemError(String)
  case nameError(String)
  case keyError(String)
  case keyErrorForKey(PyObject)
  case stopIteration
  case runtimeError(String)
  case unboundLocalError(variableName: String)
  case deprecationWarning(String)
  case lookupError(String)
  case unicodeDecodeError(FileEncoding, Data)
  case unicodeEncodeError(FileEncoding, String)
  case osError(String)

  public var description: String {
    switch self {
    case .typeError(let msg): return "Type error: '\(msg)'"
    case .valueError(let msg): return "Value error: '\(msg)'"
    case .indexError(let msg): return "Index error: '\(msg)'"
    case .attributeError(let msg): return "Attribute error: '\(msg)'"
    case .zeroDivisionError(let msg): return "ZeroDivision error: '\(msg)'"
    case .overflowError(let msg): return "Overflow error: '\(msg)'"
    case .systemError(let msg): return "System error: '\(msg)'"
    case .nameError(let msg): return "Name error: '\(msg)'"
    case .keyError(let msg): return "Key error: '\(msg)'"
    case .keyErrorForKey: return "Key error for key"
    case .stopIteration: return "Stop iteration"
    case .runtimeError(let msg): return "Runtime error: '\(msg)'"
    case .unboundLocalError(variableName: let v):
      return "UnboundLocalError: local variable '\(v)' referenced before assignment"
    case .deprecationWarning(let msg): return "Deprecation warning: '\(msg)'"
    case .lookupError(let msg): return "Lookup error: '\(msg)'"
    case .unicodeDecodeError(let e, _): return "'\(e)' codec can't decode data"
    case .unicodeEncodeError(let e, _): return "'\(e)' codec can't encode data"
    case .osError(let msg): return "OS error: '\(msg)'"
    }
  }
}
