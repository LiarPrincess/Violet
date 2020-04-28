import VioletCore

// Mostly based on CPython.
// https://docs.python.org/3/reference/lexical_analysis.html#indentation

/// Max indentation level.
private let maxIndent = 100

/// Tab spacing.
private let tabSize = 8

/// Used when indentation stack is empty.
private let defaultIndent = 0

private enum IndentCompare {
  case equal
  case greater
  case less
}

internal struct IndentState {

  /// Start of each indent level.
  /// Each value represents the column on which code starts.
  fileprivate var indentColumns = [Int]()

  /// Tokens that we have to emit to sync with source
  /// (before we can emit any other token).
  ///
  /// Tokens from this property have the highest priority in `self.getToken`.
  /// All of the tokens here will be either indents or dedents
  /// (but we will never mix them).
  fileprivate var pendingTokens = [Token]()

  /// After we finished lexing we may need to produce some artificial 'dedent'
  /// tokens, just to 'bring balance to the force'.
  fileprivate var didCalculateEOFDedents = false
}

extension Lexer {

  // MARK: - Get pending indent token

  internal func getPendingIndentTokens() -> Token? {
    return self.indents.pendingTokens.popLast()
  }

  // MARK: - Calculate indent

  internal func calculateIndent() throws {
    assert(self.indents.pendingTokens.isEmpty, "Emit previous line first!")
    let start = self.location
    let indent = self.calculateIndentColumn()

    // Lines with only whitespace and/or comments shouldn't affect indentation
    if self.peek == "#" || self.isNewLine(self.peek) {
      return
    }

    switch self.compareWithCurrentIndent(indent) {
    case .equal:
      break

    case .greater: // Indent - always one token
      if self.indents.indentColumns.count + 1 >= maxIndent {
        throw self.error(.tooManyIndentationLevels, location: start)
      }

      let start = SourceLocation(line: self.location.line, column: 0)
      let token = self.token(.indent, start: start)

      self.indents.indentColumns.push(indent)
      self.indents.pendingTokens.push(token)

    case .less: // Dedent - any number of tokens, must be consistent
      let location = SourceLocation(line: self.location.line, column: 0)

      while let oldIndent = self.indents.indentColumns.last, oldIndent > indent {
        _ = self.indents.indentColumns.popLast()

        let token = self.token(.dedent, start: location, end: location)
        self.indents.pendingTokens.push(token)
      }

      let oldIndent = self.indents.indentColumns.last ?? defaultIndent
      if oldIndent != indent {
        throw self.error(.noMatchingDedent, location: location)
      }
    }
  }

  private func calculateIndentColumn() -> Int {
    var column = 0

    while true {
      switch self.peek {
      case " ":
        column += 1
        self.advance()
      case "\t":
        column = (column / tabSize + 1) * tabSize
        self.advance()
      default:
        return column
      }
    }
  }

  private func compareWithCurrentIndent(_ indent: Int) -> IndentCompare {
    let currentIndent = self.indents.indentColumns.last ?? defaultIndent
    return indent == currentIndent ? .equal :
           indent > currentIndent ? .greater :
           .less
  }

  // MARK: - Final dedent

  /// After we finished lexing we may need to produce some artificial 'dedent'
  /// tokens, just to 'bring balance to the force'.
  internal func getEOFDedentToken() -> Token? {
    assert(self.isAtEnd)
    assert(self.indents.pendingTokens.isEmpty, "Emit previous line first!")

    if !self.indents.didCalculateEOFDedents {
      self.indents.pendingTokens = self.calculateEOFDedents()
      self.indents.didCalculateEOFDedents = true
    }

    return self.indents.pendingTokens.popLast()
  }

  private func calculateEOFDedents() -> [Token] {
    // Do we even need those dedents?
    guard self.indents.indentColumns.any else {
      return []
    }

    // Add dedent tokens (note that we will be 'popping' from 'result',
    // so we actually have to add them in reverse order).
    // First 'popped' -> last in 'result'.
    var result = [Token]()

    for level in self.indents.indentColumns {
      assert(level != defaultIndent) // That would be weird

      let token = self.token(.dedent)
      result.append(token)
    }

    // Grammar requires 'new line' before dedents
    if self.needsArtificialNewLineBeforeDedents {
      let token = self.token(.newLine)
      result.append(token)
    }

    return result
  }

  private var needsArtificialNewLineBeforeDedents: Bool {
    guard let lastScalar = self.source.last else {
      // Source is empty - we don't need it.
      return false
    }

    // If the last scalar is not 'new line' then we need to add it.
    let isNewLine = self.isNewLine(lastScalar)
    return !isNewLine
  }
}
