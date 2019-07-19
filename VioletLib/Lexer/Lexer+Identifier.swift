// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private struct StringFlags {
  fileprivate var b = false
  fileprivate var r = false
  fileprivate var u = false
  fileprivate var f = false

  fileprivate mutating func update(_ c: UnicodeScalar) -> Bool {
    if !(self.b || self.u || self.f) && (c == "b" || c == "B") {
      self.b = true
      return true
    }

    if !(self.b || self.u || self.r || self.f) && (c == "u" || c == "U") {
      self.u = true
      return true
    }

    if !(self.r || self.u) && (c == "r" || c == "R") {
      self.r = true
      return true
    }

    if !(self.f || self.b || self.u) && (c == "f" || c == "F") {
      self.f = true
      return true
    }

    return false
  }
}

// See: https://docs.python.org/3/reference/lexical_analysis.html#identifiers
extension Lexer {

  internal mutating func identifierOrString() -> Token {
    // state: self.peek == isIdentifierStart,
    // but we still don't know if it is identifier or string in form bruf"xxx"

    var flags = StringFlags()
    var identifierParts = [UnicodeScalar]()
    let start = self.location

    while true {
      guard let c = self.peek else {
        break // no character (eof)? -> only identifier is possible
      }

      guard flags.update(c) else {
        break // not one of the flags? -> only identifier is possible
      }

      // still undecided. identifier or string?
      identifierParts.append(c)

      let next = self.advance()
      if next == "\"" || next == "'" { // quotes are not valid identifiers
        return self.string(flags: flags)
      }
    }

    while let c = self.peek, self.isIdentifierContinuation(c) {
      identifierParts.append(c)
      _ = self.advance()
    }

    let end = self.location
    let identifier = String(String.UnicodeScalarView(identifierParts))

    if let keyword = keywords[identifier] {
      return Token(keyword, start: start, end: end)
    } else {
      self.verifyIdentifier(identifier, start: start, end: end)
      return Token(.identifier(identifier), start: start, end: end)
    }
  }

  private mutating func string(flags: StringFlags) -> Token {
    return Token(.amper, start: .start, end: .start)
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

  internal func isIdentifierContinuation(_ c: UnicodeScalar) -> Bool {
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
                                end:          SourceLocation) {

    // TODO: Add 'verifyIdentifier' exceptions

    let scalars = identifier.unicodeScalars
    guard scalars.any else {
      return // error
    }

    var index = scalars.startIndex

    // as for underscore: https://codepoints.net/U+005F -> Cmd+F -> XID Start
    let first = scalars[index]
    guard first == "_" || first.properties.isXIDStart else {
      return // error
    }

    // go to 2nd character
    index = scalars.index(after: index)

    while index != scalars.endIndex {
      let c = scalars[index]
      guard c.properties.isXIDContinue else {
        return // error
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
