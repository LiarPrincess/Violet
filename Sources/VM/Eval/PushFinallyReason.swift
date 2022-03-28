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

  internal typealias ObjectStack = PyFrame.ObjectStackProxy

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
  internal static func push(_ py: Py, stack: ObjectStack, reason: UnwindReason) {
    let value: PushFinallyReason.Push
    switch reason {
    case .return(let object):
      value = .return(object)
    case .break:
      value = .break
    case .continue(loopStartLabelIndex: let index):
      value = .continue(loopStartLabelIndex: index)
    case .exception(let exception, fillTracebackAndContext: _):
      value = .exception(exception)
    case .yield:
      value = .yield
    case .silenced:
      value = .silenced
    }

    Self.push(py, stack: stack, value: value)
  }

  /// Remember what we were doing before we started `finally` block.
  internal static func push(_ py: Py, stack: ObjectStack, value: Push) {
    switch value {
    case .return(let object):
      stack.push(object)
      stack.push(Self.toObject(py, marker: Marker.return))
    case .break:
      stack.push(Self.toObject(py, marker: Marker.break))
    case .continue(loopStartLabelIndex: let index):
      let indexPy = py.newInt(index) // int -> PyInt conversion needed
      stack.push(indexPy.asObject)
      stack.push(Self.toObject(py, marker: Marker.continue))
    case .continuePy(loopStartLabelIndex: let index):
      stack.push(index.asObject)
      stack.push(Self.toObject(py, marker: Marker.continue))
    case .exception:
      stack.push(Self.toObject(py, marker: Marker.exception))
    case .yield:
      stack.push(Self.toObject(py, marker: Marker.yield))
    case .silenced:
      stack.push(Self.toObject(py, marker: Marker.silenced))
    }
  }

  private static func toObject(_ py: Py, marker: BigInt) -> PyObject {
    let int = py.newInt(marker)
    return int.asObject
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
  internal static func pop(_ py: Py, stack: ObjectStack) -> Pop {
    let marker = stack.pop()

    if let pyInt = py.cast.asInt(marker) {
      switch pyInt.value {
      case Marker.return:
        let object = stack.pop()
        return .return(object)
      case Marker.break:
        return .break
      case Marker.continue:
        let object = stack.pop()
        if let pyInt = py.cast.asInt(object), let int = Int(exactly: pyInt.value) {
          return .continue(loopStartLabelIndex: int, asObject: pyInt)
        }
        trap("Invalid argument (\(object)) for 'continue' after finally block")
      case Marker.exception:
        VM.unimplemented()
      case Marker.yield:
        VM.unimplemented()
      case Marker.silenced:
        return .silenced
      default:
        break // Try other, but probably 'invalid'
      }
    }

    if let e = py.cast.asBaseException(marker) {
      return .exception(e)
    }

    if py.cast.isNone(marker) {
      return .none
    }

    return .invalid
  }
}
