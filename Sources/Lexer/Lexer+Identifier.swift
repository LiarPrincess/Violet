// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// https://docs.python.org/3/reference/lexical_analysis.html#identifiers

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
      return self.token(.keyword(keyword), start: start)
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
    // Basically 'best efford', because text is hard.

    // This should never happen, how did we even started lexing?
    guard let first = identifier.first else {
      throw self.error(.identifier(" "), start: start)
    }

    // As for the underscore look for 'XID_Start' in:
    // https://unicode.org/cldr/utility/character.jsp?a=005f
    guard first.properties.isXIDStart || first == "_" else {
      throw self.error(.identifier(first), start: start, end: start.next)
    }

    for (index, c) in identifier.dropFirst().enumerated() {
      guard c.properties.isXIDContinue else {
        let skippedFirst = 1
        let column   = start.column + skippedFirst + index
        let location = SourceLocation(line: start.line, column: column)
        throw self.error(.identifier(c), start: location, end: location.next)
      }
    }
  }
}
