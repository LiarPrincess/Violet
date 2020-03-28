// swiftlint:disable function_parameter_count

/// Access to dynamic (runtime-dependent) data.
public protocol PyDelegate: AnyObject {

  /// Currently executing frame.
  var frame: PyFrame? { get }

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
