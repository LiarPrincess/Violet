import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Base class for all of the compiler tests
internal class CompileTestCase: XCTestCase, ASTCreator {

  internal var builder = ASTBuilder()

  // MARK: - Compile

  internal func compile(expr: Expression,
                        file: StaticString = #file,
                        line: UInt = #line) -> CodeObject? {
    let ast = self.expressionAST(expression: expr)
    return self.compile(ast: ast, file: file, line: line)
  }

  internal func compile(stmt: Statement,
                        optimizationLevel: Compiler.OptimizationLevel = .none,
                        file: StaticString = #file,
                        line: UInt = #line) -> CodeObject? {
    let ast = self.moduleAST(statements: [stmt])
    return self.compile(ast: ast,
                        optimizationLevel: optimizationLevel,
                        file: file,
                        line: line)
  }

  internal func compile(stmts: [Statement],
                        file: StaticString = #file,
                        line: UInt = #line) -> CodeObject? {
    let ast = self.moduleAST(statements: stmts)
    return self.compile(ast: ast, file: file, line: line)
  }

  private func compile(ast: AST,
                       optimizationLevel: Compiler.OptimizationLevel = .none,
                       file: StaticString = #file,
                       line: UInt = #line) -> CodeObject? {
    do {
      let validator = ASTValidator()
      try validator.validate(ast: ast)

      let options = Compiler.Options(optimizationLevel: optimizationLevel)
      let compiler = Compiler(filename: "file",
                              ast: ast,
                              options: options,
                              delegate: nil)
      return try compiler.run()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
