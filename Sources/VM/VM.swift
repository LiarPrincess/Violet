import Foundation
import Objects

// swiftlint:disable:next type_name
public final class VM: PyDelegate {

  internal var frames = [PyFrame]()
  internal let fileSystem = FileSystemImpl(bundle: .main, fileManager: .default)

  internal let arguments: Arguments

  /// Currently executed frame.
  ///
  /// Required by `PyDelegate`.
  public var frame: PyFrame? {
    return self.frames.last
  }

  public init(arguments: Arguments, environment: Environment) {
    self.arguments = arguments

    let executablePath = self.fileSystem.executablePath ??
        arguments.raw.first ??
        "Violet"

    let config = PyConfig(
      arguments: arguments,
      environment: environment,
      executablePath: executablePath,
      standardInput: FileDescriptorAdapter(for: .standardInput),
      standardOutput: FileDescriptorAdapter(for: .standardOutput),
      standardError: FileDescriptorAdapter(for: .standardError)
    )

    Py.initialize(
      config: config,
      delegate: self,
      fileSystem: self.fileSystem
    )
  }

  deinit {
    Py.destroy()
  }

  // MARK: - PyDelegate
  // There is also 'eval', but it is in a different file.

  public var currentWorkingDirectory: String {
    return self.fileSystem.currentWorkingDirectory
  }

  public func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    return self.fileSystem.open(fd: fd, mode: mode)
  }

  public func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    return self.fileSystem.open(path: path, mode: mode)
  }

  public func stat(fd: Int32) -> FileStatResult {
    return self.fileSystem.stat(fd: fd)
  }

  public func stat(path: String) -> FileStatResult {
    return self.fileSystem.stat(path: path)
  }
}
