import Lexer
import Parser
import Compiler
import Bytecode
import Objects

// TODO: Use Objects.Py.compile

extension VM {

  internal func compile(filename: String,
                        source: String,
                        mode: ParserMode) throws -> PyCode {
    let lexer = Lexer(for: source)
    let parser = Parser(mode: mode, tokenSource: lexer)
    let ast = try parser.parse()

    Debug.ast(ast)

    let optimizationLevel = self.configuration.optimize
    let compilerOptions = CompilerOptions(optimizationLevel: optimizationLevel)

    let compiler = try Compiler(ast: ast,
                                filename: filename,
                                options: compilerOptions)

    let codeObject = try compiler.run()
    let code = Py.newCode(code: codeObject)
    Debug.code(code)
    return code
  }
}
