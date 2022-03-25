import VioletObjects

extension Py {
  fileprivate var noExceptionMarker: PyObject {
    return self.none.asObject
  }

  fileprivate func isNoExceptionMarker(_ object: PyObject) -> Bool {
    return self.cast.isNone(object)
  }
}

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

  /// Number of the values pushed onto the stack
  internal static let countOnStack = 1

  internal typealias ObjectStack = PyFrame.ObjectStackProxy

  // MARK: - Push

  internal static func push(_ py: Py, stack: ObjectStack, exception: PyBaseException?) {
    if let e = exception {
      stack.push(e.asObject)
    } else {
      stack.push(py.noExceptionMarker)
    }
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

  internal static func pop(_ py: Py, stack: ObjectStack) -> Pop {
    let value = stack.pop()

    if let exception = py.cast.asBaseException(value) {
      return .exception(exception)
    }

    if py.isNoExceptionMarker(value) {
      return .noException
    }

    return .invalidValue(value)
  }
}
