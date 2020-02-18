import Foundation
import Lexer
import Parser
import Compiler
import Bytecode
import Objects
import Rapunzel

// swiftlint:disable:next type_name
public class VM: PyDelegate {

  internal let fm = FileManager.default
  internal let configuration: CoreConfiguration

  internal var arguments: Arguments {
    return self.configuration.arguments
  }

  public init(arguments: Arguments, environment: Environment = Environment()) {
    self.configuration = CoreConfiguration(arguments: arguments,
                                           environment: environment)

    let config = PyConfig()
    Py.initialize(config: config, delegate: self)
  }

  deinit {
    Py.destroy()
  }
}
