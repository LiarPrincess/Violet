import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Base class for all of the compiler tests
internal class CompileTestCase: XCTestCase, ASTCreator {

  internal var builder = ASTBuilder()

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
                        optimizationLevel: OptimizationLevel = .none,
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.module([stmt]))
    return self.compile(ast: ast,
                        optimizationLevel: optimizationLevel,
                        file: file,
                        line: line)
  }

  internal func compile(stmt kind: StatementKind,
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.module([self.statement(kind)]))
    return self.compile(ast: ast, file: file, line: line)
  }

  internal func compile(stmts: [Statement],
                        file: StaticString = #file,
                        line: UInt         = #line) -> CodeObject? {
    let ast = self.ast(.module(stmts))
    return self.compile(ast: ast, file: file, line: line)
  }

  private func compile(ast: AST,
                       optimizationLevel: OptimizationLevel = .none,
                       file: StaticString = #file,
                       line: UInt         = #line) -> CodeObject? {
    do {
      let options = CompilerOptions(optimizationLevel: optimizationLevel)
      let compiler = try Compiler(ast: ast, filename: "file", options: options)
      return try compiler.run()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Nested code objects

  internal func getCodeObject(parent code: CodeObject,
                              qualifiedName: String,
                              _ message:  String = "",
                              file: StaticString = #file,
                              line: UInt         = #line) -> CodeObject? {
    for case let Constant.code(c) in code.constants
      where c.qualifiedName == qualifiedName {

      return c
    }

    XCTAssertFalse(true, message, file: file, line: line)
    return nil
  }

  // MARK: - Print

  @available(*, deprecated, message: "This should be used only for debug.")
  internal func printInstructions(_ code: CodeObject) {
    for (index, emitted) in code.emittedInstructions.enumerated() {
      let i = Instruction.byteSize * index
      let arg = emitted.arg ?? ""
      print("\(i): \(emitted.kind) \(arg)")
    }
  }
}
