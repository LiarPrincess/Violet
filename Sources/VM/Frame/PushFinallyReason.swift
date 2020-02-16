import Core
import Objects

/// Helper for `unwind` block and `endFinally` instruction.
/// Basically a way to remember what we were doing before
/// we started `finally` block.
///
/// It will work like this:
///
/// Unwind `finally` block:
/// 1. if we are unwinding because of `return`: push return value
/// 2. push **marker**
/// 3. execute `finally`
///
/// Eventually we will arrive to `endFinally` instruction:
/// 1. pop **marker**
/// 2. based on marker decide what we need to do
internal enum PushFinallyReason {

  // MARK: - Marker values

  private static let `return`  = BigInt(0)
  private static let `break`   = BigInt(1)
  private static let exception = BigInt(2)
  private static let yield     = BigInt(3)
  private static let silenced  = BigInt(4)

  // MARK: - Push

  /// Remember what we were doing before we started `finally` block.
  internal enum Push {
    /// We were handling a `return`.
    case `return`(PyObject)
    /// We were unwinding blocks, since we hit `break`.
    case `break`
    /// We were handling exception.
    case exception(PyBaseException)
    /// 'yield' operator
    case yield
    /// Exception silenced by 'with'
    case silenced
  }

  /// Remember what we were doing before we started `finally` block.
  internal static func push(reason: UnwindReason, on stack: inout ObjectStack) {
    let marker: PushFinallyReason.Push = {
      switch reason {
      case .return(let value): return .return(value)
      case .break: return .break
      case .exception(let e): return .exception(e)
      case .yield: return .yield
      case .silenced: return .silenced
      }
    }()

    PushFinallyReason.push(marker, on: &stack)
  }

  /// Remember what we were doing before we started `finally` block.
  internal static func push(_ value: Push, on stack: inout ObjectStack) {
    switch value {
    case .return(let o):
      stack.push(o)
      stack.push(Py.newInt(PushFinallyReason.return))
    case .break:
      stack.push(Py.newInt(PushFinallyReason.break))
    case .exception:
      stack.push(Py.newInt(PushFinallyReason.exception))
    case .yield:
      stack.push(Py.newInt(PushFinallyReason.yield))
    case .silenced:
      stack.push(Py.newInt(PushFinallyReason.silenced))
    }
  }

  // MARK: - Pop

  internal enum Pop {
    /// We were handling a `return`.
    case `return`(PyObject)
    /// We are unwinding blocks, since we hit `break`.
    case `break`
    /// We were handling exception.
    case exception(PyBaseException)
    /// 'yield' operator
    case silenced
    /// Nothing to do
    case none
    /// Marker is not valid.
    case invalid
  }

  /// CPython: TARGET(END_FINALLY)
  internal static func pop(from stack: inout ObjectStack) -> Pop {
    let marker = stack.pop()

    if let pyInt = marker as? PyInt {
      switch pyInt.value {
      case PushFinallyReason.return:
        let value = stack.pop()
        return .return(value)
      case PushFinallyReason.break:
        return .break
      case PushFinallyReason.exception:
        assert(false)
      case PushFinallyReason.yield:
        assert(false)
      case PushFinallyReason.silenced:
        return .silenced
      default:
        break // Try other, but probably 'invalid'
      }
    }

    if let e = marker as? PyBaseException {
      return .exception(e)
    }

    if marker.isNone {
      return .none
    }

    return .invalid
  }
}
