/*
internal indirect enum SimpleDoc {
  /// Empty document. Identity.
  case empty
  /// Text followed by document.
  case text(String, SimpleDoc)
  /// Line break indent and then document.
  case line(Int, SimpleDoc)
}

public indirect enum Doc {
  /// Empty document. Identity.
  case empty
  /// Concatenates two documents (<>).
  case concat(Doc, Doc)
  /// Add indentation to a document.
  case nest(Int, Doc)
  /// Converts a string to the corresponding document.
  case text(String)
  /// Line break.
  case line
  /// Union of the two sets of layouts (<|>).
  /// - Important:
  /// Requires that no first line of a document in `lhs`
  /// is shorter than some first line of a document in `rhs`.
  /// - Warning:
  /// Should not be used directly.
  case _union(Doc, Doc)
}

// MARK: - Operators

infix operator <>: MultiplicationPrecedence
infix operator <|>: AdditionPrecedence

public func <>(lhs: Doc, rhs: Doc) -> Doc {
  return .concat(lhs, rhs)
}

// Never ever make this public
internal func <|>(lhs: Doc, rhs: Doc) -> Doc {
  return ._union(lhs, rhs)
}

// MARK: - Base functions

/// Given a document, representing a set of layouts,
/// group returns the set with one new element added,
/// representing the layout in which everything is compressed on one line.
internal func group(_ doc: Doc) -> Doc {
  return flatten(doc) <|> doc
}

/// Replaces each line break (and its associated indentation)
/// by a single space.
internal func flatten(_ doc: Doc) -> Doc {
  switch doc {
  case .empty:             return .empty
  case let .concat(x, y):  return flatten(x) <> flatten(y)
  case let .nest(_, x):    return flatten(x) // maybe: .nest(i, flatten(x))
  case let .text(s):       return .text(s)
  case .line:              return .text(" ")
  case let ._union(x, _):  return flatten(x)
  }
}

// MARK: - Pretty

/// Chooses the prettiest among a set of layouts.
public func pretty(width: Int, doc: Doc) -> String {
  return layout(best(width: width, column: 0, doc: doc))
}

internal func layout(_ doc: SimpleDoc) -> String {
  switch doc {
  case .empty: return ""
  case let .text(s, x): return s + layout(x)
  case let .line(i, x): return "\n" + String(repeating: " ", count: i) + layout(x)
  }
}

/// Takes a document that may contain unions,
/// and returns prettiest document containing no unions.
private func best(width: Int, column: Int, doc: Doc) -> SimpleDoc {
  return be(width, column, pairs: [(0, doc)])
}

internal typealias IndentSimpleDocPair = (indent: Int, doc: Doc)

private func be<C: Collection>(_ width: Int, _ column: Int, pairs: C) -> SimpleDoc
  where C.Element == IndentSimpleDocPair {

    guard let first = pairs.first else {
      return .empty
    }

    let i = first.indent
    let z = pairs.dropFirst()

    switch first.doc {
    case .empty:
      return be(width, column, pairs: z)
    case let .concat(x, y):
      return be(width, column, pairs: [(i,x), (i,y)] + z)
    case let .nest(j, x):
      return be(width, column, pairs: [(i + j, x)] + z)
    case let .text(s):
      return .text(s, be(width, column + s.count, pairs: z))
    case .line:
      return .line(i, be(width, column, pairs: z))
    case let ._union(x, y):
      let lhs = be(width, column, pairs: [(i, x)] + z)
      let rhs = be(width, column, pairs: [(i, y)] + z)
      return better(width, column, lhs, rhs)
    }
}

private func better(_ width: Int, _ column: Int, _ lhs: SimpleDoc, _ rhs: SimpleDoc) -> SimpleDoc {
  return fits(width - column, lhs) ? lhs : rhs
}

private func fits(_ width: Int, _ doc: SimpleDoc) -> Bool {
  if width < 0 {
    return false
  }

  switch doc {
  case .empty: return true
  case let .text(s, x): return fits(width - s.count, x)
  case .line: return true
  }
}

// MARK: - Convenience

infix operator <+>: MultiplicationPrecedence
infix operator </>: MultiplicationPrecedence

internal func <+>(lhs: Doc, rhs: Doc) -> Doc {
  return lhs <> .text(" ") <> rhs
}

internal func </>(lhs: Doc, rhs: Doc) -> Doc {
  return lhs <> .line <> rhs
}

/// Lays out documents horizontally, with space between each pair.
public func spread(_ docs: [Doc]) -> Doc {
  return docs.reduce(.empty, <+>)
}

/// Lays out documents vertically, with new line between each pair.
public func stack(_ docs: [Doc]) -> Doc {
  return docs.reduce(.empty, </>)
}

/// Opening bracket, an indented portion and a closing bracket.
internal func bracket(_ left:  String,
                      _ doc:   Doc,
                      _ right: String,
                      indent:  Int = 2) -> Doc {
  return group(
    .text(left) <>
      .nest(indent, .line <> doc) <>
      .line <>
      .text(right)
  )
}
*/
