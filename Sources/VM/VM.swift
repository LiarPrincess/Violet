import Foundation
import Lexer
import Parser
import Compiler
import Bytecode
import Objects
import Rapunzel

// swiftlint:disable:next type_name
public final class VM: PyDelegate {

  internal var frames = [PyFrame]()
  internal let fileSystem = FileSystem(manager: FileManager.default)
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
      standardInput: FileDescriptorAdapter(for: .standardInput),
      standardOutput: FileDescriptorAdapter(for: .standardOutput),
      standardError: FileDescriptorAdapter(for: .standardError)
    )
    Py.initialize(config: config, delegate: self)
  }

  deinit {
    Py.destroy()
  }

  // MARK: - PyDelegate

  public func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    return self.fileSystem.open(fileno: fileno, mode: mode)
  }

  public func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    return self.fileSystem.open(file: file, mode: mode)
  }

  // MARK: - Helpers

  internal func read(
    url: URL,
    onError: (URL, String.Encoding) -> Error
  ) throws -> String {
    let encoding = String.Encoding.utf8

    if let data = self.fileSystem.contents(path: url.path),
       let result = String(data: data, encoding: encoding) {
      return result
    }

    throw onError(url, encoding)
  }
}
