import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

public enum CompilerUnimplemented: CustomStringConvertible, Equatable {

  case comprehension
  case async
  /// PEP-563
  ///
  /// This asks us to provide AST -> Python code transformation:
  /// ```
  /// The string form is obtained from the AST during the compilation step,
  /// which means that the string form might not preserve the exact formatting
  /// of the source.
  /// ```
  case postponedAnnotationsEvaluation_PEP563

  public var description: String {
    switch self {
    case .comprehension:
      return "'comprehensions' are currently not implemented."
    case .async:
      return "'async' is currently not implemented."
    case .postponedAnnotationsEvaluation_PEP563:
      let pep = "PEP 563 (postponed evaluation of annotations)"
      return "\(pep) is currently not implemented."
    }
  }
}

extension CompilerImpl {

  // MARK: - Comprehension

  // Remember about self.setAppendLocation(ASTNode)!

  internal func visit(_ node: ListComprehensionExpr) throws {
    throw self.notImplementedComprehension()
  }

  internal func visit(_ node: SetComprehensionExpr) throws {
    throw self.notImplementedComprehension()
  }

  internal func visit(_ node: DictionaryComprehensionExpr) throws {
    throw self.notImplementedComprehension()
  }

  internal func visit(_ node: GeneratorExpr) throws {
    throw self.notImplementedComprehension()
  }

  // MARK: - Async

  internal func visit(_ node: AsyncForStmt) throws {
    throw self.notImplementedAsync()
  }

  internal func visit(_ node: AsyncWithStmt) throws {
    throw self.notImplementedAsync()
  }

  internal func visit(_ node: AsyncFunctionDefStmt) throws {
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
