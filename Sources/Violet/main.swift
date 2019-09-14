import Foundation
import SPMUtility
import Core
import Lexer
import Parser
import Bytecode
import Compiler
import VM

do {
  let parser = OptionsParser()
  let arguments = Array(CommandLine.arguments.dropFirst())
  let options = try parser.parse(arguments: arguments)

  print("Arguments")
  for a in arguments {
    print(" ", a)
  }

  print("Options")
  print("  command:", options.command ?? "nil")
  print("  module:", options.module ?? "nil")
  print("  script:", options.script ?? "nil")
  print("  version:", options.version)
  print("  debug:", options.debug)
  print("  byteCompare:", options.byteCompare)
  print("  enterInteractiveAfterExecuting:", options.enterInteractiveAfterExecuting)
  print("  optimization:", options.optimization)
  print("  quiet:", options.quiet)
  print("  help:", options.help)
  print("  warnings:", options.warnings)
} catch {
  print(error)
  exit(1)
}
