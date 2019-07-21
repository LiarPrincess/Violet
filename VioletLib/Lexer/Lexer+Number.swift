// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals

extension Lexer {

  internal mutating func isDecimalDigit(_ c: UnicodeScalar) -> Bool {
    return DecimalNumber.isDigit(c)
  }

  internal mutating func number() throws -> Token {
    assert(self.peek != nil)
    assert(self.isDecimalDigit(self.peek ?? " ")) // never nil (see assert above)

    let start = self.location

    if self.peek == "0" {
      switch self.peekNext {
      case "B", "b":
        _ = self.advance() // 0
        _ = self.advance() // Bb
        return try self.integer(start: start, type: BinaryNumber.self)
      case "O", "o":
        _ = self.advance() // 0
        _ = self.advance() // Oo
        return try self.integer(start: start, type: OctalNumber.self)
      case "X", "x":
        _ = self.advance() // 0
        _ = self.advance() // Xx
        return try self.integer(start: start, type: HexNumber.self)
      default:
        // decimal zero: "0"+ (["_"] "0")*
        return try self.integer(start: start, type: ZeroDecimal.self)
      }
    }

    return try self.decimalIntegerOrFloat()
  }

  private mutating func integer<T: NumberType>(start: SourceLocation,
                                               type:  T.Type) throws -> Token {

    // we have at least 1 digit
    guard let peek = self.peek else { throw self.createError(.eof) }
    guard self.isDigitOrUnderscore(peek, type: type) else {
      let message = "Number should have at least 1 digit."
      throw self.createError(.syntax(message: message))
    }

    var result: PyInt = 0
    let radix = PyInt(type.radix)

    // (["_"] xxxdigit)+
    while var peek = self.peek, self.isDigitOrUnderscore(peek, type: type) {
      if peek == "_" {
        // if next is not digit then '_' it is not a part of the number
        // it is still not correct, but by grammar, not lex
        guard let afterUnderscore = self.peekNext,
              type.isDigit(afterUnderscore) else {
          break
        }

        _ = self.advance() // consume underscore
        peek = afterUnderscore
      }

      let digit = PyInt(type.parseDigit(peek))

      // currently we do not support unlimited integers
      let (v1, o1) = result.multipliedReportingOverflow(by: radix)
      let (v2, o2) = v1.addingReportingOverflow(digit)

      if o1 || o2 {
        throw NotImplemented("\(start) Violet currently does not support " +
          "integers outside of <\(PyInt.min), \(PyInt.max)> range")
      }

      result = v2

      _ = self.advance()
    }

    return Token(.int(result), start: start, end: self.location)
  }

  private func isDigitOrUnderscore<T: NumberType>(_ c: UnicodeScalar,
                                                  type:  T.Type) -> Bool {
    return type.isDigit(c) || c == "_"
  }

  private mutating func decimalIntegerOrFloat() throws -> Token {
    return Token(.amper, start: .start, end: .start)
  }
}
