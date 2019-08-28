import XCTest
import Core
import Parser
@testable import Compiler

/// Shared test helpers.
protocol CommonSymbolTable: ASTCreator { }

extension CommonSymbolTable {

  // MARK: - Create

  internal func createSymbolTable(forExpr expr: Expression,
                                  file: StaticString = #file,
                                  line: UInt         = #line) -> SymbolTable? {
    let ast = self.ast(.expression(expr))
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  internal func createSymbolTable(forExpr kind: ExpressionKind,
                                  file: StaticString = #file,
                                  line: UInt         = #line) -> SymbolTable? {
    let ast = self.ast(.expression(self.expression(kind)))
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  internal func createSymbolTable(forStmt stmt: Statement,
                                  file: StaticString = #file,
                                  line: UInt         = #line) -> SymbolTable? {
    let ast = self.ast(.single([stmt]))
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  internal func createSymbolTable(forStmt kind: StatementKind,
                                  file: StaticString = #file,
                                  line: UInt         = #line) -> SymbolTable? {
    let ast = self.ast(.single([self.statement(kind)]))
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  internal func createSymbolTable(forStmts stmts: [Statement],
                                  file: StaticString = #file,
                                  line: UInt         = #line) -> SymbolTable? {
    let ast = self.ast(.single(stmts))
    return self.createSymbolTable(for: ast, file: file, line: line)
  }

  private func createSymbolTable(for ast: AST,
                                 file: StaticString = #file,
                                 line: UInt         = #line) -> SymbolTable? {
    do {
      let builer = SymbolTableBuilder()
      return try builer.visit(ast)
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Error

  internal func error(forExpr expr: Expression,
                      file: StaticString = #file,
                      line: UInt         = #line) -> CompilerError? {
    let ast = self.ast(.expression(expr))
    return self.error(for: ast, file: file, line: line)
  }

  internal func error(forStmt stmt: Statement,
                      file: StaticString = #file,
                      line: UInt         = #line) -> CompilerError? {
    let ast = self.ast(.single([stmt]))
    return self.error(for: ast, file: file, line: line)
  }

  internal func error(forStmt kind: StatementKind,
                      file: StaticString = #file,
                      line: UInt         = #line) -> CompilerError? {
    let ast = self.ast(.single([self.statement(kind)]))
    return self.error(for: ast, file: file, line: line)
  }

  internal func error(forStmts stmts: [Statement],
                      file: StaticString = #file,
                      line: UInt         = #line) -> CompilerError? {
    let ast = self.ast(.single(stmts))
    return self.error(for: ast, file: file, line: line)
  }

  private func error(for ast: AST,
                     file: StaticString = #file,
                     line: UInt = #line) -> CompilerError? {
    do {
      let builer = SymbolTableBuilder()
      let result = try builer.visit(ast)
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
