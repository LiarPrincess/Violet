import Foundation
import Core
import Lexer
import Parser
import Bytecode
import Compiler
import Objects
import VM

do {
  let arguments = Arguments()
  let environment = Environment()

  let vm = VM(arguments: arguments, environment: environment)
  try vm.run()
} catch {
  print(error)
  exit(1)
}
