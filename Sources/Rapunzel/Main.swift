// MARK: - Convertible

/// Marks type that can be used in `Rapunzel` (our pretty printing library).
public protocol RapunzelConvertible {
  var doc: Doc { get }
}

// MARK: - Doc

infix operator <>: MultiplicationPrecedence
infix operator <+>: MultiplicationPrecedence
infix operator <|>: MultiplicationPrecedence

/// Document algebra with `concat` operation and `empty` as a unit.
/// Use `text` to lift `String` into a `Doc`.
public indirect enum Doc: RapunzelConvertible {

  /// Concatenates two documents (also available as `<>` operator).
  case concat(Doc, Doc)
  /// Add indentation to a document.
  case nest(Int, Doc)
  /// Lifts a string to the corresponding document.
  case text(String)
  /// '\n'
  case line

  public var doc: Doc {
    return self
  }

  /// Convert document to string.
  public func layout() -> String {
    return self.layout(indent: 0)
  }

  private func layout(indent: Int) -> String {
    switch self {
    case let .concat(lhs, rhs):
      return lhs.layout(indent: indent) + rhs.layout(indent: indent)

    case let .nest(i, doc):
      return String(repeating: " ", count: i) + doc.layout(indent: indent + i)

    case let .text(s):
      return s

    case .line:
      return "\n" + String(repeating: " ", count: indent)
    }
  }

  // MARK: - Operators

  public static func <>(lhs: Doc, rhs: Doc) -> Doc {
    return .concat(lhs, rhs)
  }

  public static func <+>(lhs: Doc, rhs: Doc) -> Doc {
    return lhs <> .space <> rhs
  }

  public static func <|>(lhs: Doc, rhs: Doc) -> Doc {
    return lhs <> .line <> rhs
  }

  // MARK: - Common documents

  /// Empty document. Identity.
  public static let empty = Doc.text("")

  /// `' '`
  public static let space = Doc.text(" ")
  /// `.`
  public static let dot = Doc.text(".")
  /// `:`
  public static let colon = Doc.text(":")
  /// `,`
  public static let comma = Doc.text(",")
  /// `;`
  public static let semicolon = Doc.text(";")

  /// `(`
  public static let leftParen = Doc.text("(")
  /// `[`
  public static let leftSqb   = Doc.text("[")
  /// `{`
  public static let leftBrace = Doc.text("{")
  /// `)`
  public static let rightParen = Doc.text(")")
  /// `]`
  public static let rightSqb   = Doc.text("]")
  /// `}`
  public static let rightBrace = Doc.text("}")

  // MARK: - Common layout

  /// Lays out documents horizontally, with space between each pair.
  public static func spread(_ docs: Doc...) -> Doc {
    return self.spread(docs)
  }

  /// Lays out documents horizontally, with space between each pair.
  public static func spread<S: Sequence>(_ docs: S) -> Doc where S.Element == Doc {
    return Doc.join(docs, with: .space)
  }

  /// Lays out documents vertically, with new line between each pair.
  public static func stack(_ docs: Doc...) -> Doc {
    return self.stack(docs)
  }

  /// Lays out documents vertically, with new line between each pair.
  public static func stack<S: Sequence>(_ docs: S) -> Doc where S.Element == Doc {
    return Doc.join(docs, with: .line)
  }

  public static func join<S: Sequence>(_ docs: S,
                                       with glue: Doc) -> Doc where S.Element == Doc {
    var result: Doc?

    for doc in docs {
      if let acc = result {
        result = acc <> glue <> doc
      } else {
        result = doc
      }
    }

    return result ?? .empty
  }
}

// MARK: - Extensions

extension String: RapunzelConvertible {
  public var doc: Doc {
    return .text(self)
  }
}

extension Sequence where Element: RapunzelConvertible {

  /// Lazy to avoid allocating `Array` just to reduce it later.
  private var docs: LazyMapSequence<Self, Doc> {
    return self.lazy.map { $0.doc }
  }

  /// Lays out documents horizontally, with space between each pair.
  public func spread() -> Doc {
    return Doc.spread(self.docs)
  }

  /// Lays out documents vertically, with new line between each pair.
  public func stack() -> Doc {
    return Doc.stack(self.docs)
  }
}
