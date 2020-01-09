import Lexer
import Parser
import Compiler
import Bytecode

extension VM {
  internal func compile(filename: String,
                        source: String,
                        mode: ParserMode) throws -> CodeObject {
    let lexer = Lexer(for: source)
    let parser = Parser(mode: mode, tokenSource: lexer)
    let ast = try parser.parse()

    self.dump(ast)

    let optimizationLevel = self.configuration.optimization
    let compilerOptions = CompilerOptions(optimizationLevel: optimizationLevel)
    let compiler = try Compiler(ast: ast,
                                filename: filename,
                                options: compilerOptions)

    let code = try compiler.run()
    self.dump(code)
    return code
  }
}
