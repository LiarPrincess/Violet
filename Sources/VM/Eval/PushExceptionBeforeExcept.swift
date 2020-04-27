import VioletObjects

/// Helper for the situation when we want to push current exception on stack.
/// Later we will probably want to pop this exception.
/// This helper will to this in a type-safe way.
internal enum PushExceptionBeforeExcept {

  internal static func push(_ exception: PyBaseException?,
                            on stack: inout ObjectStack) {
    stack.push(exception ?? Self.noExceptionMarker)
  }

  internal enum Pop {
    /// Exception was pushed
    case exception(PyBaseException)
    /// There was no exception (but this is still completely valid!)
    case noException
    /// Something is wrong
    case invalidValue(PyObject)
  }

  internal static func pop(from stack: inout ObjectStack) -> Pop {
    let value = stack.pop()

    if let exception = value as? PyBaseException {
      return .exception(exception)
    }

    if Self.isNoExceptionMarker(value) {
      return .noException
    }

    return .invalidValue(value)
  }

  // MARK: - Marker

  private static var noExceptionMarker: PyObject {
    return Py.none
  }

  private static func isNoExceptionMarker(_ value: PyObject) -> Bool {
    return value is PyNone
  }
}
