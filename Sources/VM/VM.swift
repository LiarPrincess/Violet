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
  internal let fileManager = FileManager.default
  internal let configuration: CoreConfiguration

  internal var arguments: Arguments {
    return self.configuration.arguments
  }

  public init(arguments: Arguments, environment: Environment) {
    self.configuration = CoreConfiguration(
      arguments: arguments,
      environment: environment
    )

    let config = PyConfig()
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

    if let data = self.fileManager.contents(atPath: url.path),
       let result = String(data: data, encoding: encoding) {
      return result
    }

    throw onError(url, encoding)
  }
}
