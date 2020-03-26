import Bytecode

// swiftlint:disable function_parameter_count

/// Access to dynamic (runtime-dependent) data.
public protocol PyDelegate: AnyObject {

  /// Currently executing frame.
  var frame: PyFrame? { get }

  /// Open file with given `fileno`.
  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Open file at given `path`.
  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType>

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
