import Foundation
import VioletCore

// https://docs.python.org/3/reference/lexical_analysis.html

public final class Lexer: LexerType {

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

  /// Did we finish lexing?
  internal var isAtEnd: Bool {
    return self.sourceIndex == self.source.endIndex
  }

  internal weak var delegate: LexerDelegate?

  /// Create lexer that will produce tokens from the source.
  public init(for source: String, delegate: LexerDelegate?) {
    self.source = source.unicodeScalars
    self.sourceIndex = self.source.startIndex
    self.delegate = delegate
  }

  // MARK: - Traversal

  /// Current character. Use `self.advance` to consume.
  internal var peek: UnicodeScalar? {
    return self.isAtEnd ? nil : self.source[self.sourceIndex]
  }

  /// Character after `self.peek`.
  internal var peekNext: UnicodeScalar? {
    if self.isAtEnd {
      return nil
    }

    var indexCopy = self.sourceIndex
    self.source.formIndex(after: &indexCopy)

    let isAtEnd = indexCopy == self.source.endIndex
    return isAtEnd ? nil : self.source[indexCopy]
  }

  /// Consumes current character.
  @discardableResult
  internal func advance() -> UnicodeScalar? {
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

  internal func advanceIf(_ expected: UnicodeScalar) -> Bool {
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
  internal func token(_ kind: Token.Kind,
                      start: SourceLocation? = nil,
                      end: SourceLocation? = nil) -> Token {
    let s = start ?? self.location
    let e = end ?? self.location
    return Token(kind, start: s, end: e)
  }

  /// Report lexer warning
  internal func warn(_ kind: LexerWarning.Kind,
                     location: SourceLocation? = nil) {
    let warning = LexerWarning(kind, location: location ?? self.location)
    self.delegate?.warn(warning: warning)
  }

  /// Create lexer error
  internal func error(_ kind: LexerError.Kind,
                      location: SourceLocation? = nil) -> LexerError {
    return LexerError(kind, location: location ?? self.location)
  }

  /// Create unimplemented lexer error
  internal func unimplemented(_ unimplemented: LexerUnimplemented,
                              location: SourceLocation? = nil) -> LexerError {
    return self.error(.unimplemented(unimplemented), location: location)
  }

  // MARK: - Helpers

  internal func isWhitespace(_ c: UnicodeScalar?) -> Bool {
    return c == " " || c == "\t"
  }

  internal func isNewLine(_ c: UnicodeScalar?) -> Bool {
    return c == CR || c == LF
  }
}
