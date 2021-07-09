import VioletObjects

/// Helper for the situation when we want to push current exception onto the stack.
/// Later we will probably want to pop it.
/// This helper will to this in a type-safe way.
///
/// ```py
/// try:
///   raise ValueError("I am an evil princess!")
/// except:
///   <pushing the currently handled exception onto the stack>
///   <setting 'evil princess' as currently handled exception>
///   pass # executing 'except'
///   <we 'handled' the 'evil princess', now restore previous>
/// ```
///
/// This is also used when we need to unwind from `except`:
/// ```py
/// for princess in ['elsa', 'ariel']:
///   try:
///     raise ValueError("I am an evil princess!")
///   except:
///     <pushing the currently handled exception onto the stack>
///     <setting 'evil princess' as currently handled exception>
///     continue # Our goal is to discard 'evil princess' and restore previous
/// ```
internal enum PushExceptionBeforeExcept {

  // MARK: - Push

  internal static func push(_ exception: PyBaseException?,
                            on stack: inout PyFrame.ObjectStack) {
    stack.push(exception ?? Self.noExceptionMarker)
  }

  // MARK: - Pop

  internal enum Pop {
    /// Exception was pushed
    case exception(PyBaseException)
    /// There was no exception (but this is still completely valid!)
    case noException
    /// Something is wrong
    case invalidValue(PyObject)
  }

  internal static func pop(from stack: inout PyFrame.ObjectStack) -> Pop {
    let value = stack.pop()

    if let exception = PyCast.asBaseException(value) {
      return .exception(exception)
    }

    if Self.isNoExceptionMarker(value) {
      return .noException
    }

    return .invalidValue(value)
  }

  // MARK: - Marker

  /// Number of the values pushed onto the stack
  internal static let countOnStack = 1

  private static var noExceptionMarker: PyObject {
    return Py.none
  }

  private static func isNoExceptionMarker(_ value: PyObject) -> Bool {
    return value is PyNone
  }
}
