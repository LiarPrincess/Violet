import Core

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
  internal var stack = [Int]()

  /// Tokens that we have to pop to sync with source.
  internal var pendingTokens = [Token]()
}

extension Lexer {

  internal mutating func calculateIndent() throws {
    let start = self.location
    let indent = self.calculateIndentColumn()

    // Lines with only whitespace and/or comments shouldn't affect indentation
    if self.peek == "#" || self.isNewLine(self.peek) {
      return
    }

    switch self.compareWithCurrentIndent(indent) {
    case .equal:
      break

    case .greater: // Indent - always one
      if self.indents.stack.count + 1 >= maxIndent {
        throw self.error(.tooDeep, location: start)
      }

      let start = SourceLocation(line: self.location.line, column: 0)
      let token = self.token(.indent, start: start)

      self.indents.stack.push(indent)
      self.indents.pendingTokens.push(token)

    case .less: // Dedent - any number, must be consistent
      let location = SourceLocation(line: self.location.line, column: 0)

      while let oldIndent = self.indents.stack.last, oldIndent > indent {
        _ = self.indents.stack.popLast()

        let token = self.token(.dedent, start: location, end: location)
        self.indents.pendingTokens.push(token)
      }

      let oldIndent = self.indents.stack.last ?? defaultIndent
      if oldIndent != indent {
        throw self.error(.dedent, location: location)
      }
    }
  }

  private mutating func calculateIndentColumn() -> Int {
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
    let currentIndent = self.indents.stack.last ?? defaultIndent
    return indent == currentIndent ? .equal :
           indent  > currentIndent ? .greater :
           .less
  }
}
