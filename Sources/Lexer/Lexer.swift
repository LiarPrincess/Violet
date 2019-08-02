import Foundation

// https://docs.python.org/3/reference/lexical_analysis.html

public struct Lexer: LexerType {

  /// Name of the input source.
  public let filename: String

  /// Text input to lex.
  /// Scalars because 'Python reads program text as Unicode code points' (quote
  /// from [doc](https://docs.python.org/3/reference/lexical_analysis.html)\).
  internal var source: UnicodeScalarView

  /// Current position in `self.source`
  internal var sourceIndex: UnicodeScalarIndex

  /// Is at begin of new line?
  internal var isAtBeginOfLine = true

  /// Amount of parentheses: () [] {}.
  internal var nesting = 0

  /// Stack of indents.
  internal var indents = IndentState()

  /// Where are we in the source file?
  internal var location = SourceLocation.start

  /// Used for REPL.
  public init(stdin: String) {
    self.init(filename: "<stdin>", source: stdin)
  }

  /// Used for 'eval/exec'.
  public init(string: String) {
    self.init(filename: "<string>", source: string)
  }

  /// Used when we have an actual file.
  public init(filename: String, source: String) {
    self.filename = filename
    self.source = source.unicodeScalars
    self.sourceIndex = self.source.startIndex
  }

  // MARK: - Traversal

  /// Current character. Use `self.advance` to consume.
  internal var peek: UnicodeScalar? {
    let atEnd = self.sourceIndex == self.source.endIndex
    return atEnd ? nil : self.source[self.sourceIndex]
  }

  /// Character after `self.peek`.
  internal var peekNext: UnicodeScalar? {
    let end = self.source.endIndex
    let index = self.source.index(self.sourceIndex, offsetBy: 1, limitedBy: end)
    return index.flatMap { $0 == end ? nil : self.source[$0] }
  }

  /// Consumes current character.
  @discardableResult
  internal mutating func advance() -> UnicodeScalar? {
    guard self.sourceIndex < self.source.endIndex else {
      return nil
    }

    let consumed = self.peek
    self.source.formIndex(after: &self.sourceIndex)

    if self.isNewLine(consumed) {
      self.location.advanceLine()

      // if we have '\r\n' then consume '\n' as well
      if consumed == CR && self.peek == LF {
        self.source.formIndex(after: &self.sourceIndex)
      }
    } else {
      self.location.advanceColumn()
    }

    return self.peek
  }

  internal mutating func advanceIf(_ expected: UnicodeScalar) -> Bool {
    guard let next = self.peek else {
      return false
    }

    if next == expected {
      self.advance()
      return true
    }

    return false
  }

  // MARK: - Creation helpers (always use them!)

  /// Create token
  internal mutating func token(_ kind: TokenKind,
                               start:  SourceLocation? = nil,
                               end:    SourceLocation? = nil) -> Token {
    let s = start ?? self.location
    let e = end ?? self.location
    return Token(kind, start: s, end: e)
  }

  /// Create lexer warning
  internal mutating func warn(_ warning: LexerWarning,
                              start:     SourceLocation? = nil,
                              end:       SourceLocation? = nil) {
    // uh... oh... well that's embarrassing...
    // your code is perfect and it does not generate any warnings...
  }

  /// Create lexer error
  internal func error(_ kind:   LexerErrorKind,
                      location: SourceLocation? = nil) -> LexerError {
    return LexerError(kind, location: location ?? self.location)
  }

  // MARK: - Helpers

  internal func isWhitespace(_ c: UnicodeScalar) -> Bool {
    return c == " " || c == "\t"
  }

  internal func isNewLine(_ c: UnicodeScalar?) -> Bool {
    return c == CR || c == LF
  }
}
