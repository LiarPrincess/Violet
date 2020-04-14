import Core
import Parser
import Bytecode
import Foundation

// In CPython:
// Python -> compile.c

public enum CompilerUnimplemented: CustomStringConvertible, Equatable {

  case comprehension
  case async

  public var description: String {
    switch self {
    case .comprehension:
      return "'comprehensions' are currently not implemented."
    case .async:
      return "'async' is currently not implemented."
    }
  }
}

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
    return self.error(.unimplemented(.async))
  }

  private func notImplementedComprehension() -> Error {
    self.error(.unimplemented(.comprehension))
  }
}
