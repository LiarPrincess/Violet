public protocol ASTPass {

  associatedtype PassResult

  mutating func visit(_ ast: AST) throws -> PassResult
}

// MARK: - AnyASTPass

// We cannot use closure-based type erasure, because we want to use structs
// and visit is marked as mutating (and we can't store mutating closures).

private class AnyASTPassBoxBase<PassResult>: ASTPass {

  // swiftlint:disable:next unavailable_function
  fileprivate func visit(_ ast: AST) throws -> PassResult {
    fatalError("Method must be overridden")
  }
}

private final class ASTPassBox<Base: ASTPass>: AnyASTPassBoxBase<Base.PassResult> {

  private var _base: Base

  fileprivate init(_ base: Base) {
    self._base = base
  }

  fileprivate override func visit(_ ast: AST) throws -> Base.PassResult {
    return try self._base.visit(ast)
  }
}

public struct AnyASTPass<PassResult>: ASTPass {

  private let _box: AnyASTPassBoxBase<PassResult>

  public init<P: ASTPass>(_ base: P) where P.PassResult == PassResult {
    self._box = ASTPassBox(base)
  }

  public func visit(_ ast: AST) throws -> PassResult {
    return try self._box.visit(ast)
  }
}
