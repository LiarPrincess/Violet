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
        break // no character (meaning eof) -> only identifier is possible
      }

      guard stringPrefix.update(c) else {
        break // not one of the prefixes -> only identifier is possible
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
      self.advance()
    }

    let end = self.location
    let identifier = String(identifierParts)

    if let keyword = keywords[identifier] {
      return self.token(.keyword(keyword), start: start, end: end)
    } else {
      try self.verifyIdentifier(identifier, start: start)
      return self.token(.identifier(identifier), start: start, end: end)
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
                                start:        SourceLocation) throws {

    let scalars = identifier.unicodeScalars

    guard let first = scalars.first else {
      throw self.error(.identifier, start: start)
    }

    // as for underscore: https://codepoints.net/U+005F -> Cmd+F -> XID Start
    guard first == "_" || first.properties.isXIDStart else {
      throw self.error(.identifier, start: start, end: start)
    }

    for (index, char) in scalars.dropFirst().enumerated() {
      // swiftlint:disable:next for_where
      if !char.properties.isXIDContinue {
        let skippedFirst = 1
        let column   = start.column + index + skippedFirst
        let location = SourceLocation(line: start.line, column: column)
        throw self.error(.identifier, start: location, end: location)
      }
    }
  }
}
