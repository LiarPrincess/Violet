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
internal enum FinallyMarker {

  // MARK: - Marker values

  // Feel free to use any `PyObject` you want.
  private static var `return`: PyObject { return Py.none }
  private static var `break`: PyObject { return Py.ellipsis }
  private static var exception: PyObject { return Py.notImplemented }

  // MARK: - Push

  /// Remember what we were doing before we started `finally` block.
  internal enum Push {
    /// We were handling a `return`.
    case `return`(PyObject)
    /// We are unwinding blocks, since we hit `break`.
    case `break`
    /// We were handling exception.
    case exception(PyBaseException)
  }

  /// Remember what we were doing before we started `finally` block.
  internal static func push(_ value: Push, on stack: ObjectStack) {
    switch value {
    case .return(let o):
      stack.push(o)
      stack.push(FinallyMarker.return)
    case .break:
      stack.push(FinallyMarker.break)
    case .exception(let e):
      stack.push(e)
      stack.push(FinallyMarker.exception)
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
    /// Marker is not valid.
    case invalid
  }

  internal static func pop(from stack: ObjectStack) -> Pop {
    let marker = stack.pop()

    if marker === FinallyMarker.return {
      let value = stack.pop()
      return .return(value)
    }

    if marker === FinallyMarker.break {
      return .break
    }

    if marker === FinallyMarker.exception {
      guard let exception = stack.pop() as? PyBaseException else {
        let msg = "'finally' pops bad exception"
        return .exception(Py.newSystemError(msg: msg))
      }

      return .exception(exception)
    }

    return .invalid
  }
}
