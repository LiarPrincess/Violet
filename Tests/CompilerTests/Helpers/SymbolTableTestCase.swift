import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

/// Base class for all of the symbol table tests
internal class SymbolTableTestCase: XCTestCase, ASTCreator {

  internal var builder = ASTBuilder()

  // MARK: - Create

  internal func createSymbolTable(expr: Expression,
                                  file: StaticString = #file,
                                  line: UInt = #line) -> SymbolTable? {
    let ast = self.expressionAST(expression: expr)
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  internal func createSymbolTable(stmt: Statement,
                                  file: StaticString = #file,
                                  line: UInt = #line) -> SymbolTable? {
    let ast = self.interactiveAST(statements: [stmt])
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  internal func createSymbolTable(stmts: [Statement],
                                  file: StaticString = #file,
                                  line: UInt = #line) -> SymbolTable? {
    let ast = self.interactiveAST(statements: stmts)
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  private func createSymbolTable(for ast: AST,
                                 file: StaticString = #file,
                                 line: UInt = #line) -> SymbolTable? {
    do {
      let validator = ASTValidator()
      try validator.validate(ast: ast)

      let builder = SymbolTableBuilder(delegate: nil)
      return try builder.visit(ast: ast)
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Error

  internal func error(forExpr expr: Expression,
                      file: StaticString = #file,
                      line: UInt = #line) -> CompilerError? {
    let ast = self.expressionAST(expression: expr)
    return self.error(for: ast, file: file, line: line)
  }

  internal func error(forStmt stmt: Statement,
                      file: StaticString = #file,
                      line: UInt = #line) -> CompilerError? {
    let ast = self.interactiveAST(statements: [stmt])
    return self.error(for: ast, file: file, line: line)
  }

  internal func error(forStmts stmts: [Statement],
                      file: StaticString = #file,
                      line: UInt = #line) -> CompilerError? {
    let ast = self.interactiveAST(statements: stmts)
    return self.error(for: ast, file: file, line: line)
  }

  private func error(for ast: AST,
                     file: StaticString = #file,
                     line: UInt = #line) -> CompilerError? {
    do {
      let builder = SymbolTableBuilder(delegate: nil)
      let result = try builder.visit(ast: ast)
      XCTAssert(false, "Successful build: \(result)", file: file, line: line)
      return nil
    } catch let error as CompilerError {
      return error
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
