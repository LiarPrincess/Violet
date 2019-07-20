// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// See:
// https://docs.python.org/3/reference/lexical_analysis.html#identifiers

extension Lexer {

  internal mutating func identifierOrString() throws -> Token {
    assert(self.peek != nil)
    assert(self.isIdentifierStart(self.peek))

    var stringPrefix = StringPrefix()
    var identifierParts = [UnicodeScalar]()
    let start = self.location

    /// we don't know if it is identifier or string in form bruf"xxx"
    while true {
      guard let c = self.peek else {
        break // no character (meaning eof)? -> only identifier is possible
      }

      guard stringPrefix.update(c) else {
        break // not one of the prefixes? -> only identifier is possible
      }

      // still undecided
      identifierParts.append(c)

      let next = self.advance()
      if next == "\"" || next == "'" { // quotes are not valid identifiers
        return try self.string(prefix: stringPrefix, start: start)
      }
    }

    while let c = self.peek, self.isIdentifierContinuation(c) {
      identifierParts.append(c)
      _ = self.advance()
    }

    let end = self.location
    let identifier = String(identifierParts)

    if let keyword = keywords[identifier] {
      return Token(keyword, start: start, end: end)
    } else {
      try self.verifyIdentifier(identifier, start: start, end: end)
      return Token(.identifier(identifier), start: start, end: end)
    }
  }

  internal func isIdentifierStart(_ c: UnicodeScalar?) -> Bool {
    // We do more detailed verification after we have collected the whole
    // identifier (this is important for error messages, otherwise we won't
    // even start lexing identifier and throw 'unknown character' exception).

    guard let c = c else { return false }
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

  private func verifyIdentifier(_ identifier: String,
                                start:        SourceLocation,
                                end:          SourceLocation) throws {

    let scalars = identifier.unicodeScalars
    guard scalars.any else {
      throw self.createError(.identifier)
    }

    var index = scalars.startIndex

    // as for underscore: https://codepoints.net/U+005F -> Cmd+F -> XID Start
    let first = scalars[index]
    guard first == "_" || first.properties.isXIDStart else {
      throw self.createError(.identifier)
    }

    // go to 2nd character
    index = scalars.index(after: index)

    while index != scalars.endIndex {
      let c = scalars[index]
      guard c.properties.isXIDContinue else {
        throw self.createError(.identifier)
      }

      index = scalars.index(after: index)
    }
  }
}

private let keywords: [String:TokenKind] = [
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
  "ellipsis": .ellipsis,
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
