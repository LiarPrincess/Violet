/* MARKER
// swiftlint:disable function_parameter_count

/// Access to dynamic (runtime-dependent) data.
public protocol PyDelegate: AnyObject {

  /// Currently executing frame.
  var frame: PyFrame? { get }

  /// Currently handled exception.
  ///
  /// If exception was raised when another exception was beeing handled then
  /// the new one has `__context__` set to old exception.
  /// (In terms of API: use `e.getContext()` to get to the old exception)
  ///
  /// For example:
  /// 1. We were handling `e1`
  /// 2. During that `e2` was raised
  /// In such case `currentlyHandledException` is set to `e2`, but you can
  /// get to `e1` by using `e2.__context__` (`e2.getContext()` in Swift).
  ///
  /// Tip 1. If `currentlyHandledException` is `nil` then we are currently
  /// not handling any exceptions
  /// Tip 2. To get to the first raised exception follow `getContext()` path
  /// until you get to the exception which has `getContext()` set to `nil`.
  ///
  /// CPython: `PyThreadState.exc_info`
  var currentlyHandledException: PyBaseException? { get }

  /// Evaluate given code object.
  func eval(name: PyString?,
            qualname: PyString?,
            code: PyCode,

            args: [PyObject],
            kwargs: PyDict?,
            defaults: [PyObject],
            kwDefaults: PyDict?,

            globals: PyDict,
            locals: PyDict,
            closure: PyTuple?) -> PyResult<PyObject>
}

*/