/*
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

extension AST {

  fileprivate func baseDoc(type: String, lines: Doc...) -> Doc {
    return self.baseDoc(type: type, lines: lines)
  }

  fileprivate func baseDoc(type: String, lines: [Doc]) -> Doc {
    let title = "\(type)(start: \(self.start), end: \(self.end))"
    return lines.isEmpty ?
      text(title) :
      block(title: title, lines: lines)
  }
}

// MARK: - InteractiveAST

extension InteractiveAST: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "InteractiveAST",
      lines: self.statements.map { $0.doc }
    )
  }
}

// MARK: - ModuleAST

extension ModuleAST: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "ModuleAST",
      lines: self.statements.map { $0.doc }
    )
  }
}

// MARK: - ExpressionAST

extension ExpressionAST: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "ExpressionAST",
      lines: self.expression.doc
    )
  }
}
*/
