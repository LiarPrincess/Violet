import Foundation
import VioletCore

// https://docs.python.org/3/reference/lexical_analysis.html#identifiers
// cSpell:ignore bruf

internal let keywords: [String: Token.Kind] = [
  "and": .and,
  "as": .as,
  "assert": .assert,
  "async": .async,
  "await": .await,
  "break": .break,
  "class": .class,
  "continue": .continue,
  "def": .def,
  "del": .del,
  "elif": .elif,
  "else": .else,
  "except": .except,
  "finally": .finally,
  "for": .for,
  "from": .from,
  "global": .global,
  "if": .if,
  "import": .import,
  "in": .in,
  "is": .is,
  "lambda": .lambda,
  "nonlocal": .nonlocal,
  "not": .not,
  "or": .or,
  "pass": .pass,
  "raise": .raise,
  "return": .return,
  "try": .try,
  "while": .while,
  "with": .with,
  "yield": .yield
]

extension Lexer {

  internal func identifierOrString() throws -> Token {
    assert(self.peek != nil)
    assert(self.isIdentifierStart(self.peek ?? " "))

    let start = self.location
    let startIndex = self.sourceIndex
    var stringPrefix = StringPrefix()

    // we don't know if it is identifier or string in form bruf"xxx"
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
    switch identifier.isValidIdentifier {
    case .yes:
      return
    case .emptyString:
      throw self.error(.invalidCharacterInIdentifier(" "), location: start)
    case let .no(scalar: scalar, column: column):
      let column = start.column + column
      let location = SourceLocation(line: start.line, column: column)
      throw self.error(.invalidCharacterInIdentifier(scalar), location: location)
    }
  }
}
