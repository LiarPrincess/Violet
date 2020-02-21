import Bytecode

// swiftlint:disable function_parameter_count

public protocol PyDelegate: AnyObject {
  /// Extension point for opening files.
  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Extension point for opening files.
  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType>

  // TODO: closure
  /// Evaluate given code object.
  func eval(name: String?,
            qualname: String?,
            code: CodeObject,

            args: [PyObject],
            kwArgs: Attributes?,
            defaults: [PyObject],
            kwDefaults: Attributes?,

            globals: Attributes,
            locals: Attributes) -> PyResult<PyObject>
}
