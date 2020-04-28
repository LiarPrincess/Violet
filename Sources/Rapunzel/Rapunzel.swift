// MARK: - Convertible

/// Marks type that can be used in `Rapunzel` (our pretty printing library).
public protocol RapunzelConvertible {
  var doc: Doc { get }
}

extension RapunzelConvertible {
  public func dump() -> String {
    return self.doc.layout()
  }
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
  /// Add indentation to a document (used to create tree-like hierarchy).
  case nest(Int, Doc)
  /// Lift string to `Doc`.
  case text(String)
  /// '\n'
  case line

  public var doc: Doc {
    return self
  }

  // MARK: - Layout

  /// Convert document to string.
  public func layout() -> String {
    // return self.layoutRec(indent: 0)
    return self.layoutTrampoline()
  }

  // MARK: Trampoline

  private enum TrampolineElement {
    case doc(Doc)
    case string(String)
    case increaseIndent(Int)
    case decreaseIndent(Int)
  }

  /// Layout using stack-based trampoline.
  private func layoutTrampoline() -> String {
    var result = ""

    var indent = 0
    var stack = [TrampolineElement.doc(self)]
    while let element = stack.popLast() {
      switch element {
      case let .doc(doc):
        // Remember that stack is LIFO, so we have to add elements in reverse order!
        switch doc {
        case let .concat(lhs, rhs):
          stack.append(.doc(rhs))
          stack.append(.doc(lhs))
        case let .nest(i, d):
          stack.append(.decreaseIndent(i))
          stack.append(.doc(d))
          stack.append(.string(self.createIndent(count: i))) // indent 1st line of 'd'
          stack.append(.increaseIndent(i))
        case let .text(s):
          result.append(s)
        case .line:
          result.append("\n" + self.createIndent(count: indent))
        }
      case let .string(s):
        result.append(s)
      case let .increaseIndent(i):
        indent += i
      case let .decreaseIndent(i):
        indent -= i
      }
    }

    return result
  }

  private func createIndent(count: Int) -> String {
    return String(repeating: " ", count: count)
  }

  // MARK: Recursion

  /// Layout with recursion that will probably blow up your stack.
  private func layoutRec(indent: Int) -> String {
    switch self {
    case let .concat(lhs, rhs):
      return lhs.layoutRec(indent: indent) + rhs.layoutRec(indent: indent)
    case let .nest(i, doc):
      return String(repeating: " ", count: i) + doc.layoutRec(indent: indent + i)
    case let .text(s):
      return s
    case .line:
      return "\n" + String(repeating: " ", count: indent)
    }
  }

  // MARK: - Operators

  public static func <> (lhs: Doc, rhs: Doc) -> Doc {
    return .concat(lhs, rhs)
  }

  public static func <+> (lhs: Doc, rhs: Doc) -> Doc {
    return lhs <> .space <> rhs
  }

  public static func <|> (lhs: Doc, rhs: Doc) -> Doc {
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
  public static let leftSqb = Doc.text("[")
  /// `{`
  public static let leftBrace = Doc.text("{")
  /// `)`
  public static let rightParen = Doc.text(")")
  /// `]`
  public static let rightSqb = Doc.text("]")
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

  /// Block with a title and some lines.
  ///
  /// Use it to produce:
  /// ```
  /// title
  ///   line0
  ///   line1
  /// ```
  public static func block(title: String, indent: Int, lines: [Doc]) -> Doc {
    return Doc.block(title: text(title), indent: indent, lines: lines)
  }

  /// Block with a title and some lines.
  ///
  /// Use it to produce:
  /// ```
  /// title
  ///   line0
  ///   line1
  /// ```
  public static func block(title: Doc, indent: Int, lines: [Doc]) -> Doc {
    return title <|> Doc.nest(indent, lines.stack())
  }

  /// Join documents by inserting `glue` between each pair.
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
