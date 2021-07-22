import VioletCore
import Rapunzel

public final class ASTPrinter: ASTVisitor, StatementVisitor, ExpressionVisitor {

  public typealias ASTResult = Doc
  public typealias StatementResult = Doc
  public typealias ExpressionResult = Doc

  private static let indent = 2
  /// We will trim strings after certain number of characters.
  private static let stringCutoff = 60

  // MARK: - AST

  internal func astBase(ast: AST, lines: [Doc]) -> Doc {
    let type = self.typeName(of: ast)
    let title = "\(type)(start: \(ast.start), end: \(ast.end))"
    return self.block(title: title, lines: lines)
  }

  public func visit(_ node: AST) -> Doc {
    // swiftlint:disable:next force_try
    return try! node.accept(self)
  }

  public func visit(_ node: InteractiveAST) -> Doc {
    return self.astBase(
      ast: node,
      lines: node.statements.map(self.visit)
    )
  }

  public func visit(_ node: ModuleAST) -> Doc {
    return self.astBase(
      ast: node,
      lines: node.statements.map(self.visit)
    )
  }

  public func visit(_ node: ExpressionAST) -> Doc {
    return self.astBase(
      ast: node,
      lines: [self.visit(node.expression)]
    )
  }

  // MARK: - Helpers

  internal func typeName(of object: Any) -> String {
    return String(describing: type(of: object))
  }

  internal func text<S: CustomStringConvertible>(_ value: S) -> Doc {
    return .text(String(describing: value))
  }

  internal func block(title: String, lines: Doc...) -> Doc {
    return self.block(title: title, lines: lines)
  }

  internal func block(title: String, lines: [Doc]) -> Doc {
    return .block(title: title,
                  indent: ASTPrinter.indent,
                  lines: lines)
  }

  internal func trim(_ value: String) -> String {
    let str = value.replacingOccurrences(of: "\n", with: "\\n")
    let cutoffIndex = str.index(str.startIndex,
                                offsetBy: ASTPrinter.stringCutoff,
                                limitedBy: str.endIndex)
    switch cutoffIndex {
    case .none:
      return value
    case .some(let i):
      return String(str[...i]) + "..."
    }
  }
}
