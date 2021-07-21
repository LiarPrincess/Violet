import Foundation
import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  parsestrplus(struct compiling *c, const node *n)

extension Parser {

  // MARK: - Bytes

  internal func bytesPlus() throws -> Expression {
    assert(self.isBytes(self.peek))

    let start = self.peek.start
    var end = self.peek.end
    var data = Data()

    while case let Token.Kind.bytes(b) = self.peek.kind {
      data.append(b)
      end = self.peek.end
      try self.advance()
    }

    if self.isString(self.peek) || self.isFormatString(self.peek) {
      throw self.error(.mixBytesAndNonBytesLiterals)
    }

    return self.builder.bytesExpr(value: data,
                                  context: .load,
                                  start: start,
                                  end: end)
  }

  // MARK: - String

  /// For normal strings and f-strings, concatenate them together.
  /// - Note:
  /// - String - no f-strings.
  /// - FormattedValue - just an f-string (with no leading or trailing literals).
  /// - JoinedStr - if there are multiple f-strings or any literals involved.
  internal func strPlus() throws -> Expression {
    assert(self.isString(self.peek) || self.isFormatString(self.peek))

    let start = self.peek.start
    var end = self.peek.end
    var string = FString(parserDelegate: self.delegate,
                         lexerDelegate: self.lexerDelegate)

    while self.isString(self.peek) || self.isFormatString(self.peek) {
      switch self.peek.kind {
      case let .string(s):
        string.append(s)
      case let .formatString(s):
        do {
          try string.appendFormatString(s)
        } catch let error as FStringError {
          throw self.error(.fStringError(error))
        }
      default:
        // see 'while' condition
        unreachable()
      }

      end = self.peek.end
      try self.advance() // needed?
    }

    if self.isBytes(self.peek) {
      throw self.error(.mixBytesAndNonBytesLiterals)
    }

    let group = try string.compile()
    return self.builder.stringExpr(value: group,
                                   context: .load,
                                   start: start,
                                   end: end)
  }

  // MARK: - Is xxx

  private func isBytes(_ token: Token) -> Bool {
    if case Token.Kind.bytes = token.kind {
      return true
    }
    return false
  }

  private func isString(_ token: Token) -> Bool {
    if case Token.Kind.string = token.kind {
      return true
    }
    return false
  }

  private func isFormatString(_ token: Token) -> Bool {
    if case Token.Kind.formatString = token.kind {
      return true
    }
    return false
  }
}
