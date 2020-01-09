import Core
import Rapunzel

// MARK: - Helpers

private func text<S: CustomStringConvertible>(_ value: S) -> Doc {
  return .text(String(describing: value))
}

private func block(title: String, lines: Doc...) -> Doc {
  return block(title: title, lines: lines)
}

private func block(title: String, lines: [Doc]) -> Doc {
  return .block(title: title,
                indent: RapunzelConfig.indent,
                lines: lines)
}

// MARK: - AST

extension AST: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "AST(start: \(self.start), end: \(self.end))",
      lines: self.kind.doc
    )
  }
}

// MARK: - ASTKind

extension ASTKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case .interactive(let stmts):
      return block(title: "Interactive", lines: stmts.map { $0.doc })
    case .module(let stmts):
      return block(title: "Module", lines: stmts.map { $0.doc })
    case .expression(let expr):
      return block(title: "Expression", lines: expr.doc)
    }
  }
}
