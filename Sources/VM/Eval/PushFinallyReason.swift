import BigInt
import VioletCore
import VioletObjects

/// Helper for `unwind` block and `endFinally` instruction.
/// Basically a way to remember what we were doing before we started `finally`.
///
/// It will work like this (example for `return`):
///
/// ```py
/// try:
///   return 'elsa'
/// finally:
///   <push `return value` (in our example 'elsa')>
///   <push `return marker` onto the stack>
///   pass # executing 'finally'
///   <`endFinally` instruction - we are still returning 'elsa'!>
///   <pop `marker`>
///   <based on marker decide what we need to do>
/// ```
internal enum PushFinallyReason {

  // MARK: - Marker values

  private enum Marker {
    fileprivate static let `return` = BigInt(0)
    fileprivate static let `break` = BigInt(1)
    fileprivate static let `continue` = BigInt(2)
    fileprivate static let exception = BigInt(3)
    fileprivate static let yield = BigInt(4)
    fileprivate static let silenced = BigInt(5)
  }

  // MARK: - Push

  /// Remember what we were doing before we started `finally` block.
  internal enum Push {
    /// We were handling a `return`.
    case `return`(PyObject)
    /// We were unwinding blocks, since we hit `break`.
    case `break`
    /// We were unwinding blocks, since we hit `continue`.
    case `continue`(loopStartLabelIndex: Int)
    /// We were unwinding blocks, since we hit `continue`.
    case continuePy(loopStartLabelIndex: PyInt)
    /// We were handling exception.
    case exception(PyBaseException)
    /// 'yield' operator
    case yield
    /// Exception silenced by 'with'.
    ///
    /// It happens when `__exit__` returns 'truthy' value.
    case silenced
  }

  /// Remember what we were doing before we started `finally` block.
  internal static func push(reason: UnwindReason,
                            on stack: inout PyFrame.ObjectStack) {
    let value: PushFinallyReason.Push = {
      switch reason {
      case .return(let value):
        return .return(value)
      case .break:
        return .break
      case .continue(loopStartLabelIndex: let index):
        return .continue(loopStartLabelIndex: index)
      case .exception(let exception, fillTracebackAndContext: _):
        return .exception(exception)
      case .yield:
        return .yield
      case .silenced:
        return .silenced
      }
    }()

    Self.push(value, on: &stack)
  }

  /// Remember what we were doing before we started `finally` block.
  internal static func push(_ value: Push, on stack: inout PyFrame.ObjectStack) {
    switch value {
    case .return(let value):
      stack.push(value)
      stack.push(Py.newInt(Marker.return))
    case .break:
      stack.push(Py.newInt(Marker.break))
    case .continue(loopStartLabelIndex: let index):
      stack.push(Py.newInt(index)) // int -> PyInt conversion needed
      stack.push(Py.newInt(Marker.continue))
    case .continuePy(loopStartLabelIndex: let index):
      stack.push(index)
      stack.push(Py.newInt(Marker.continue))
    case .exception:
      stack.push(Py.newInt(Marker.exception))
    case .yield:
      stack.push(Py.newInt(Marker.yield))
    case .silenced:
      stack.push(Py.newInt(Marker.silenced))
    }
  }

  // MARK: - Pop

  internal enum Pop {
    /// We were handling a `return`.
    case `return`(PyObject)
    /// We are unwinding blocks, since we hit `break`.
    case `break`
    /// We are unwinding blocks, since we hit `continue`.
    case `continue`(loopStartLabelIndex: Int, asObject: PyInt)
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
  internal static func pop(from stack: inout PyFrame.ObjectStack) -> Pop {
    let marker = stack.pop()

    if let pyInt = PyCast.asInt(marker) {
      switch pyInt.value {
      case Marker.return:
        let value = stack.pop()
        return .return(value)
      case Marker.break:
        return .break
      case Marker.continue:
        let value = stack.pop()
        if let pyInt = PyCast.asInt(value), let int = Int(exactly: pyInt.value) {
          return .continue(loopStartLabelIndex: int, asObject: pyInt)
        }
        trap("Invalid argument (\(value)) for 'continue' after finally block")
      case Marker.exception:
        assert(false)
      case Marker.yield:
        assert(false)
      case Marker.silenced:
        return .silenced
      default:
        break // Try other, but probably 'invalid'
      }
    }

    if let e = PyCast.asBaseException(marker) {
      return .exception(e)
    }

    if marker.isNone {
      return .none
    }

    return .invalid
  }
}
