// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Mostly taken from CPython.
// Basically rewritting C in Swift, because indents are soooo crucial.

// TODO: test it with: https://docs.python.org/2.5/ref/indentation.html

internal struct IndentState {

  /// Start of each indent level.
  internal var stack = [Int]()

  /// Tokens that we have to pop to sync with source.
  internal var pendingTokens = [Token]()
}

/// Max indentation level.
private let maxIndent = 100

/// Tab spacing.
private let tabSize = 8

extension Lexer {

  internal mutating func calculateIndent() {
    let indent = self.calculateIndentColumn()

    // TODO: hendle comments and new lines in indent
    if self.peek == "#" || self.peek == "\n" { }

    switch self.compareWithCurrentIndent(indent) {
    case .equal:
      break

    case .greater: // Indent -- always one
      if self.indents.stack.count + 1 >= maxIndent {
        // TODO: Indent - error when >= maxIndent
      }

      let startColumn = self.indents.stack.last ?? 0
      let start = SourceLocation(line: self.location.line, column: startColumn)
      let token = Token(.indent, start: start, end: self.location)

      self.indents.stack.push(indent)
      self.indents.pendingTokens.push(token)

    case .less: // Dedent -- any number, must be consistent
      while let oldIndent = self.indents.stack.last, oldIndent > indent {
        _ = self.indents.stack.popLast()

        let previous = self.indents.stack.last ?? 0
        let start = SourceLocation(line: self.location.line, column: previous)
        let end   = SourceLocation(line: self.location.line, column: oldIndent)
        let token = Token(.dedent, start: start, end: end)
        self.indents.pendingTokens.push(token)
      }

      let oldIndent = self.indents.stack.last ?? 0
      if oldIndent != indent {
        // TODO: Dedent - error when inconsistent
      }
    }
  }

  private mutating func calculateIndentColumn() -> Int {
    var column = 0

    while true {
      switch self.peek {

      case " ":
        column += 1
        _ = self.advance()

      case "\t":
        column = (column / tabSize + 1) * tabSize
        _ = self.advance()

      default:
        return column
      }
    }
  }

  private enum IndentCompare {
    case equal
    case greater
    case less
  }

  private func compareWithCurrentIndent(_ indent: Int) -> IndentCompare {
    let currentIndent = self.indents.stack.last ?? 0
    return indent == currentIndent ? .equal :
           indent  > currentIndent ? .greater :
           .less
  }
}
