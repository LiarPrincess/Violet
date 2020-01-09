import Foundation
import Lexer
import Parser
import Compiler
import Bytecode
import Objects
import Rapunzel

// swiftlint:disable:next type_name
public class VM: PyContextDelegate {

  internal let fm = FileManager.default
  internal let configuration: CoreConfiguration

  internal var arguments: Arguments {
    return self.configuration.arguments
  }

  internal private(set) lazy var context: PyContext = {
    let conf = PyContextConfig()
    return PyContext(config: conf, delegate: self)
  }()

  internal var builtins: Builtins {
    return self.context.builtins
  }

  internal var sys: Sys {
    return self.context.sys
  }

  public init(arguments: Arguments, environment: Environment = Environment()) {
    self.configuration = CoreConfiguration(arguments: arguments, environment: environment)
  }

  // MARK: - Dump

  internal func dump(_ ast: AST) {
    print(ast.dump())
  }

  internal func dump(_ code: CodeObject) {
    print("'debug(_ code: CodeObject)' is not yet implemented")
    exit(0)
  }
}
