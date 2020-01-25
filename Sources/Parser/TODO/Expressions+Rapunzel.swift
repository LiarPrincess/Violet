/*
import Core
import Rapunzel

// swiftlint:disable vertical_parameter_alignment_on_call
// swiftlint:disable file_length

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

private func trim(_ value: String) -> String {
  let index = value.index(value.startIndex,
                          offsetBy: RapunzelConfig.stringCutoff,
                          limitedBy: value.endIndex)

  switch index {
  case .none:
    return value
  case .some(let i):
    return String(value[...i]) + "..."
  }
}

// MARK: - Expression

extension Expression {

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

// MARK: - TrueExpr

extension TrueExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "TrueExpr")
  }
}

// MARK: - FalseExpr

extension FalseExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "FalseExpr")
  }
}

// MARK: - NoneExpr

extension NoneExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "NoneExpr")
  }
}

// MARK: - EllipsisExpr

extension EllipsisExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "EllipsisExpr")
  }
}

// MARK: - IdentifierExpr

extension IdentifierExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "IdentifierExpr")
  }
}

// MARK: - StringExpr

extension StringExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "StringExpr")
  }
}

// MARK: - IntExpr

extension IntExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "IntExpr")
  }
}

// MARK: - FloatExpr

extension FloatExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "FloatExpr")
  }
}

// MARK: - ComplexExpr

extension ComplexExpr: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Complex",
      lines:
        text("real: \(self.real)"),
        text("imag: \(self.imag)")
    )
  }
}

// MARK: - BytesExpr

extension BytesExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "BytesExpr",
      lines: text("Count: \(data.count)")
    )
  }
}

// MARK: - UnaryOpExpr

extension UnaryOpExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "UnaryOpExpr",
      lines:
        text("Operator: \(self.op)"),
        block(title: "Right", lines: self.right.doc)
    )
  }
}

// MARK: - BinaryOpExpr

extension BinaryOpExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "BinaryOpExpr",
      lines:
        text("Operator: \(op)"),
        block(title: "Left", lines: left.doc),
        block(title: "Right", lines: right.doc)
    )
  }
}

// MARK: - BoolOpExpr

extension BoolOpExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "BoolOpExpr",
      lines:
        text("Operator: \(op)"),
        block(title: "Left", lines: left.doc),
        block(title: "Right", lines: right.doc)
    )
  }
}

// MARK: - CompareExpr

extension CompareExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "CompareExpr",
      lines:
        block(title: "Left", lines: left.doc),
        block(title: "Elements", lines: elements.map { $0.doc })
    )
  }
}

// MARK: - TupleExpr

extension TupleExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "TupleExpr", lines: elements.map { $0.doc })
  }
}

// MARK: - ListExpr

extension ListExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "ListExpr", lines: elements.map { $0.doc })
  }
}

// MARK: - DictionaryExpr

extension DictionaryExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "DictionaryExpr", lines: elements.map { $0.doc })
  }
}

// MARK: - SetExpr

extension SetExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "SetExpr", lines: elements.map { $0.doc })
  }
}

// MARK: - ListComprehensionExpr

extension ListComprehensionExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "ListComprehensionExpr",
      lines: []
    )
  }
}

// MARK: - SetComprehensionExpr

extension SetComprehensionExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "SetComprehensionExpr",
      lines: []
    )
  }
}

// MARK: - DictionaryComprehensionExpr

extension DictionaryComprehensionExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "DictionaryComprehensionExpr",
      lines: []
    )
  }
}

// MARK: - GeneratorExpExpr

extension GeneratorExpExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "GeneratorExpExpr",
      lines: []
    )
  }
}

// MARK: - AwaitExpr

extension AwaitExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "AwaitExpr", lines: self.value.doc)
  }
}

// MARK: - YieldExpr

extension YieldExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "YieldExpr", lines: self.value.doc)
  }
}

// MARK: - YieldFromExpr

extension YieldFromExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(type: "YieldFromExpr", lines: self.value.doc)
  }
}

// MARK: - LambdaExpr

extension LambdaExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "LambdaExpr",
      lines: []
    )
  }
}

// MARK: - CallExpr

extension CallExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "CallExpr",
      lines: []
    )
  }
}

// MARK: - IfExpressionExpr

extension IfExpressionExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "IfExpressionExpr",
      lines: []
    )
  }
}

// MARK: - AttributeExpr

extension AttributeExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "AttributeExpr",
      lines: []
    )
  }
}

// MARK: - SubscriptExpr

extension SubscriptExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "SubscriptExpr",
      lines: []
    )
  }
}

// MARK: - StarredExpr

extension StarredExpr: RapunzelConvertible {
  public var doc: Doc {
    return self.baseDoc(
      type: "StarredExpr",
      lines: []
    )
  }
}

















private func comprehension(title: String,
                           element: Expression,
                           generators: NonEmptyArray<Comprehension>) -> Doc {
  return block(
    title: title,
    lines:
      block(title: "Element", lines: element.doc),
      block(title: "Generators", lines: generators.map { $0.doc })
  )
}

private func comprehension(title: String,
                           key: Expression,
                           value: Expression,
                           generators: NonEmptyArray<Comprehension>) -> Doc {
  return block(
    title: title,
    lines:
      block(title: "Key", lines: key.doc),
      block(title: "Value", lines: value.doc),
      block(title: "Generators", lines: generators.map { $0.doc })
  )
}

// MARK: - StringGroup

extension StringGroup: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .literal(s):
      return text("String: '\(trim(s))'")

    case let .formattedValue(s, conversion, spec):
      return block(
        title: "Formatted string",
        lines:
          s.doc,
          text("Conversion: \(conversion?.description ?? "none")"),
          text("Spec: \(spec?.description ?? "none")")
      )

    case let .joined(elements):
      return block(
        title: "Joined string",
        lines: elements.map { $0.doc }
      )
    }
  }
}

// MARK: - Dictionary

extension DictionaryElement: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .unpacking(expr):
      return block(title: "Unpack", lines: expr.doc)
    case let .keyValue(key: key, value: value):
      return block(
        title: "Key/value",
        lines:
          block(title: "Key", lines: key.doc),
          block(title: "Value", lines: value.doc)
      )
    }
  }
}

// MARK: - Comparison

extension ComparisonElement: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "ComparisonElement",
      lines:
        text("Operator: \(self.op)"),
        block(title: "Right", lines: self.right.doc)
    )
  }
}

// MARK: - Comprehension

extension Comprehension: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Comprehension(start: \(self.start), end: \(self.end))",
      lines:
        text("isAsync: \(self.isAsync)"),
        block(title: "Target", lines: self.target.doc),
        block(title: "Iterable", lines: self.iter.doc),
        self.ifs.isEmpty ?
          text("Ifs: none") :
          block(title: "Ifs", lines: self.ifs.map { $0.doc })
    )
  }
}

// MARK: - Arguments

extension Arguments: RapunzelConvertible {
  public var doc: Doc {
    let args = self.args.isEmpty ?
      text("Args: none") :
      block(title: "Args", lines: self.args.map { $0.doc })

    let defaults = self.defaults.isEmpty ?
      text("Defaults: none") :
      block(title: "Defaults", lines: self.defaults.map { $0.doc })

    let vararg =
      self.vararg == .none ? text("Vararg: none") :
      self.vararg == .unnamed ? text("Vararg: unnamed") :
      block(title: "Vararg", lines: self.vararg.doc)

    let kwargs = self.kwOnlyArgs.isEmpty ?
      text("KwOnlyArgs: none") :
      block(title: "KwOnlyArgs", lines: self.kwOnlyArgs.map { $0.doc })

    let kwargDefaults = self.kwOnlyDefaults.isEmpty ?
      text("KwOnlyDefaults: none") :
      block(title: "KwOnlyDefaults", lines: self.kwOnlyDefaults.map { $0.doc })

    return block(
      title: "Arguments(start: \(self.start), end: \(self.end))",
      lines:
        args,
        defaults,
        vararg,
        kwargs,
        kwargDefaults
    )
  }
}

extension Arg: RapunzelConvertible {
  public var doc: Doc {
    let ann = self.annotation.map { block(title: "Annotation", lines: $0.doc) } ??
      text("Annotation: none")

    return block(
      title: "Arg",
      lines:
        text("Name: \(self.name)"),
        ann
    )
  }
}

extension Vararg: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case .none:
      return text("None")
    case .unnamed:
      return text("Unnamed")
    case .named(let arg):
      return block(title: "Named", lines: arg.doc)
    }
  }
}

// MARK: - Keyword

extension Keyword: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Keyword(start: \(self.start), end: \(self.end))",
      lines:
        block(title: "Kind", lines: self.kind.doc),
        block(title: "Value", lines: self.value.doc)
    )
  }
}

extension KeywordKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case .dictionaryUnpack:
      return text("DictionaryUnpack")
    case .named(let n):
      return text("Named('\(n)')")
    }
  }
}

// MARK: - Slice

extension Slice: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Slice(start: \(self.start), end: \(self.end))",
      lines: self.kind.doc
    )
  }
}

extension SliceKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .slice(lower, upper, step):
      return block(
        title: "Slice",
        lines:
          self.sliceElement(name: "Lower", expr: lower),
          self.sliceElement(name: "Upper", expr: upper),
          self.sliceElement(name: "Step", expr: step)
      )

    case let .extSlice(s):
      return block(title: "ExtSlice", lines: s.map { $0.doc })

    case let .index(i):
      return block(title: "Index", lines: i.doc)
    }
  }

  private func sliceElement(name: String, expr: Expression?) -> Doc {
    switch expr {
    case .none:
      return text("\(name): none")
    case .some(let e):
      return block(title: name, lines: e.doc)
    }
  }
}
*/
