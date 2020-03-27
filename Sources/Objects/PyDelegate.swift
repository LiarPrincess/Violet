// swiftlint:disable function_parameter_count

/// Basically a `stat`, but without all of the boring stuff.
public struct FileStat {

  /// Permissions.
  let st_mode: UInt16
  /// Modification time as `seconds.nanoseconds`.
  let st_mtime: Double

  public init(st_mode: UInt16, st_mtime: Double) {
    self.st_mode = st_mode
    self.st_mtime = st_mtime
  }
}

/// Access to dynamic (runtime-dependent) data.
public protocol PyDelegate: AnyObject {

  /// Currently executing frame.
  var frame: PyFrame? { get }

  /// The path to the program’s current directory.
  ///
  /// The current directory path is the starting point for any relative paths
  /// you specify.
  ///
  /// For example:
  /// - current directory: /tmp
  /// - relative path: reports/info.txt
  /// - resulting full path: /tmp/reports/info.txt
  ///
  /// (Docs taken from `FileManager.currentDirectoryPath`.)
  var currentWorkingDirectory: String { get }

  /// Open file with given `fd`.
  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Open file at given `path`.
  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType>

  func stat(path: String) -> PyResult<FileStat>

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
