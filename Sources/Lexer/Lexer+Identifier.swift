import Foundation

// https://docs.python.org/3/reference/lexical_analysis.html#identifiers

internal let keywords: [String:TokenKind] = [
  "and":      .and,
  "as":       .as,
  "assert":   .assert,
  "async":    .async,
  "await":    .await,
  "break":    .break,
  "class":    .class,
  "continue": .continue,
  "def":      .def,
  "del":      .del,
  "elif":     .elif,
  "else":     .else,
  "except":   .except,
  "false":    .false,
  "finally":  .finally,
  "for":      .for,
  "from":     .from,
  "global":   .global,
  "if":       .if,
  "import":   .import,
  "in":       .in,
  "is":       .is,
  "lambda":   .lambda,
  "none":     .none,
  "nonlocal": .nonlocal,
  "not":      .not,
  "or":       .or,
  "pass":     .pass,
  "raise":    .raise,
  "return":   .return,
  "true":     .true,
  "try":      .try,
  "while":    .while,
  "with":     .with,
  "yield":    .yield
]

extension Lexer {

  internal mutating func identifierOrString() throws -> Token {
    assert(self.peek != nil)
    assert(self.isIdentifierStart(self.peek ?? " "))

    let start = self.location
    let startIndex = self.sourceIndex
    var stringPrefix = StringPrefix()

    /// we don't know if it is identifier or string in form bruf"xxx"
    while true {
      guard let c = self.peek else {
        break // no character (meaning eof) -> only identifier is possible
      }

      guard stringPrefix.update(c) else {
        break // not one of the prefixes -> only identifier is possible
      }

      let next = self.advance()
      if next == "\"" || next == "'" { // quotes are not valid in identifiers
        return try self.string(prefix: stringPrefix, start: start)
      }
    }

    while let c = self.peek, self.isIdentifierContinuation(c) {
      self.advance()
    }

    let scalars = self.source[startIndex..<self.sourceIndex]
    let identifier = String(scalars)

    if let keyword = keywords[identifier] {
      return self.token(keyword, start: start)
    } else {
      try self.verifyIdentifier(scalars, start: start)
      return self.token(.identifier(identifier), start: start)
    }
  }

  internal func isIdentifierStart(_ c: UnicodeScalar) -> Bool {
    // We do more detailed verification after we have collected the whole
    // identifier (this is important for error messages, otherwise we won't
    // even start lexing identifier and throw 'unknown character' exception).
    return ("a" <= c && c <= "z")
        || ("A" <= c && c <= "Z")
        || c == "_"
        || c.value >= 128
  }

  private func isIdentifierContinuation(_ c: UnicodeScalar) -> Bool {
    // We do more detailed verification after we have collected the whole
    // identifier.
    return ("a" <= c && c <= "z")
        || ("A" <= c && c <= "Z")
        || ("0" <= c && c <= "9")
        || c == "_"
        || c.value >= 128
  }

  private func verifyIdentifier(_ identifier: UnicodeScalarView.SubSequence,
                                start: SourceLocation) throws {

    // Throwing single scalar does not make sense (individual scalars don't
    // have meaning). We include its location, but not very precise.
    // Basically everything is 'best efford', because text is hard.

    // This should never happen, how did we even started lexing?
    guard let first = identifier.first else {
      throw self.error(.identifier(" "), location: start)
    }

    // As for the underscore look for 'XID_Start' in:
    // https://unicode.org/cldr/utility/character.jsp?a=005f
    guard first.properties.isXIDStart || first == "_" else {
      throw self.error(.identifier(first), location: start)
    }

    for (index, c) in identifier.dropFirst().enumerated() {
      guard c.properties.isXIDContinue else {
        let skippedFirst = 1
        let column   = start.column + skippedFirst + index
        let location = SourceLocation(line: start.line, column: column)
        throw self.error(.identifier(c), location: location)
      }
    }
  }
}
