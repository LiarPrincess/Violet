// swiftlint:disable function_parameter_count

/// Access to dynamic (runtime-dependent) data.
public protocol PyDelegateType: AnyObject {

  /// Currently executed frame.
  ///
  /// Used for filling stack traces on exceptions etc.
  func getCurrentlyExecutedFrame(_ py: Py) -> PyFrame?

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
  func getCurrentlyHandledException(_ py: Py) -> PyBaseException?

  /// Compile `source`.
  func compile(_ py: Py,
               source: String,
               filename: String,
               mode: Py.ParserMode,
               optimize: Py.OptimizationLevel) -> PyResultGen<PyCode>

  /// Evaluate given code object.
  func eval(_ py: Py,
            name: PyString?,
            qualname: PyString?,
            code: PyCode,

            args: [PyObject],
            kwargs: PyDict?,
            defaults: [PyObject],
            kwDefaults: PyDict?,

            globals: PyDict,
            locals: PyDict,
            closure: PyTuple?) -> PyResult
}
