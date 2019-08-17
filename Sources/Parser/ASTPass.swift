public protocol ASTPass: AnyObject {

  associatedtype PassResult

  func visit(_ ast: AST) throws -> PassResult
}

public final class AnyASTPass<PassResult>: ASTPass {

  private let _visit: (AST) throws -> PassResult

  public init<P: ASTPass>(_ inner: P) where P.PassResult == PassResult {
    self._visit = inner.visit
  }

  public func visit(_ ast: AST) throws -> PassResult {
    return try self._visit(ast)
  }
}
