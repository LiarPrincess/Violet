import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Shared test helpers.
protocol CommonCompiler: ASTCreator { }

extension CommonCompiler {

  // MARK: - Compile

  internal func compile(expr: Expression,
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.expression(expr))
    return self.compile(ast: ast, file: file, line: line)
  }

  internal func compile(expr kind: ExpressionKind,
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.expression(self.expression(kind)))
    return self.compile(ast: ast, file: file, line: line)
  }

  internal func compile(stmt: Statement,
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.single([stmt]))
    return self.compile(ast: ast, file: file, line: line)
  }

  internal func compile(stmt kind: StatementKind,
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.single([self.statement(kind)]))
    return self.compile(ast: ast, file: file, line: line)
  }

  internal func compile(stmts: [Statement],
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.single(stmts))
    return self.compile(ast: ast, file: file, line: line)
  }

  private func compile(ast: AST,
                       file: StaticString = #file,
                       line: UInt         = #line) -> CodeObject? {
    do {
      let options = CompilerOptions(optimizationLevel: 0)
      let compiler = try Compiler(ast: ast, options: options)
      return try compiler.run()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Print

  @available(*, deprecated, message: "This should be used only for debug.")
  internal func printInstructions(_ code: CodeObject) {
    for (index, emitted) in code.emittedInstructions.enumerated() {
      let arg = emitted.arg ?? ""
      print("\(index): \(emitted.kind) \(arg)")
    }
  }
}
