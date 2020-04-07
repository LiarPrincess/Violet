import Core
import Parser
import Bytecode
import Foundation

// In CPython:
// Python -> compile.c

// swiftlint:disable unavailable_function

internal typealias Comprehensions = NonEmptyArray<Comprehension>

extension CompilerImpl {

  // MARK: - Comprehension
  // Remember about self.setAppendLocation(ASTNode)!

  public func visit(_ node: ListComprehensionExpr) throws {
    throw self.notImplementedComprehension()
  }

  public func visit(_ node: SetComprehensionExpr) throws {
    throw self.notImplementedComprehension()
  }

  public func visit(_ node: DictionaryComprehensionExpr) throws {
    throw self.notImplementedComprehension()
  }

  public func visit(_ node: GeneratorExpr) throws {
    throw self.notImplementedComprehension()
  }

  // MARK: - Async

  public func visit(_ node: AsyncForStmt) throws {
    throw self.notImplementedAsync()
  }

  public func visit(_ node: AsyncWithStmt) throws {
    throw self.notImplementedAsync()
  }

  public func visit(_ node: AsyncFunctionDefStmt) throws {
    throw self.notImplementedAsync()
  }

  // MARK: - Helpers

  private func notImplementedAsync() -> Error {
    trap("[Compiler] 'async' is currently not implemented.")
  }

  private func notImplementedComprehension() -> Error {
    trap("[Compiler] 'comprehensions' are currently not implemented.")
  }
}
