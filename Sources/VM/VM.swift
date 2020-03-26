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

    let config = PyConfig(fileSystem: self.fileSystem)
    Py.initialize(config: config, delegate: self)
  }

  deinit {
    Py.destroy()
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
