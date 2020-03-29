import Foundation
import Objects

// swiftlint:disable:next type_name
public final class VM: PyDelegate {

  internal var frames = [PyFrame]()
  internal let fileSystem = FileSystemImpl(manager: FileManager.default)
  internal let configuration: CoreConfiguration

  internal var arguments: Arguments {
    return self.configuration.arguments
  }

  /// Currently executed frame.
  ///
  /// Required by `PyDelegate`.
  public var frame: PyFrame? {
    return self.frames.last
  }

  public init(arguments: Arguments, environment: Environment) {
    self.configuration = CoreConfiguration(
      arguments: arguments,
      environment: environment
    )

    let config = PyConfig(
      arguments: arguments,
      environment: environment,
      executablePath: self.configuration.executable,
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

  // MARK: - Helpers

  /// Read a file or produce an error using given factory method.
  internal func read(
    url: URL,
    onError: (URL, String.Encoding) -> Error
  ) throws -> String {
    let encoding = String.Encoding.utf8

    switch self.fileSystem.read(path: url.path) {
    case let .value(data):
      if let result = String(data: data, encoding: encoding) {
        return result
      }
    case .error:
      break
    }

    // TODO: Move VM to PyResult, from exceptions.
    fatalError()
  }
}
