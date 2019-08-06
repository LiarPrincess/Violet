import Lexer
import Foundation

// FString: https://www.python.org/dev/peps/pep-0498/

// In CPython:
// Python -> ast.c
//  parsestrplus(struct compiling *c, const node *n)

// It is FString, normal rules do not take effect here:
// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

public enum FStringError: Error {
  /// We are starting expr but end of string happened: "abc{" or "abc}"
  case unexpectedEnd
  /// f-string: single '}' is not allowed
  case singleRightBrace
  /// f-string expression part cannot include a backslash
  case backslashInExpression
  /// f-string expression part cannot include '#'
  case commentInExpression
  /// f-string: unterminated string
  case unterminatedString
  /// f-string: mismatched '(', '{', or '['
  case mismatchedParen

  case unimplemented
}

internal protocol FString {
  mutating func append(_ s: String) throws
  mutating func appendFString(_ s: String) throws

  /// For normal strings and f-strings, concatenate them together.
  /// - Note:
  /// - String - no f-strings.
  /// - FormattedValue - just an f-string (with no leading or trailing literals).
  /// - JoinedStr - if there are multiple f-strings or any literals involved.
  mutating func compile() throws -> StringGroup
}

private enum FStringFragment {
  /// String literal (the part NOT between '{' and '}').
  case string(String)
  /// Expression + formatter (the part between '{' and '}').
  case formattedValue(Expression, conversion: ConversionFlag?, spec: String)

  fileprivate func toGroup() -> StringGroup {
    switch self {
    case let .string(s):
      return .string(s)
    case let .formattedValue(v, conversion: c, spec: s):
      return .formattedValue(v, conversion: c, spec: s)
    }
  }
}

internal struct FStringImpl: FString {

  @available(*, deprecated, message: "Ala")
  private func unimplemented() -> FStringError {
    return .unimplemented
  }

  /// Conctenate strings (up until next expression).
  private var lastStr: String?

  /// List of the fragments that will go into result.
  /// If we did not append any fragments the it is just an ordinary string.
  private var fragments = [FStringFragment]()

  // MARK: - FString

  internal mutating func append(_ s: String) throws {
    let value = self.lastStr ?? ""
    self.lastStr = value + s
  }

  internal mutating func appendFString(_ s: String) throws {
    let view = s.unicodeScalars
    var index = view.startIndex

    while index != view.endIndex {
      let literal = try self.consumeLiteral(in: view, advancing: &index)
      try self.append(literal)

      if index != view.endIndex {
        assert(view[index] == "{")

        let fragment = try self.consumeExpr(in: view, advancing: &index)
        self.fragments.append(fragment)
      }
    }
  }

  /// - String - no f-strings.
  /// - FormattedValue - just an f-string (with no leading or trailing literals).
  /// - JoinedStr - if there are multiple f-strings or any literals involved.
  internal mutating func compile() throws -> StringGroup {
    if self.fragments.isEmpty {
      return .string(self.lastStr ?? "")
    }

    // Create a Str node out of last_str, if needed.
    if let s = self.lastStr {
      self.fragments.append(.string(s))
      self.lastStr = nil
    }

    // Note that `f"Elsa"` is JoinedStr! (because of: "any literals involved")
    if self.fragments.count == 1 {
      let first = self.fragments[0]
      if case .formattedValue = first {
        return first.toGroup()
      }
    }

    throw self.unimplemented()
  }

  // MARK: - Consume literal

  /// Consume string literal.
  ///
  /// Will advance index up until:
  /// - end of string
  /// - start of expression (in this case view[index] = '{')
  ///
  /// CPython: `fstring_find_literal`.
  private func consumeLiteral(
    in view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex) throws -> String {

    var result = [UnicodeScalar]()
    while index != view.endIndex {
      let ch = view[index]

      // Violet does not support \N{xxx} escapes (e.g. \N{EULER CONSTANT}).

      switch ch {
      case "{", "}":
        let nextIndex = view.index(after: index)
        guard nextIndex != view.endIndex else {
          // we are starting expr but end of string happened: "abc{" or "abc}"
          throw FStringError.unexpectedEnd
        }

        // if next is also '{' or '}' then it is escape
        let next = view[nextIndex]
        let isEscape = next == ch

        if isEscape {
          result.append(ch)
          view.formIndex(&index, offsetBy: 2) // current {, next {
        } else if ch == "{" { // start of expr
          return String(result)
        } else { // ch == "}", standalone "}" is not allowed, only "}}" is
          throw FStringError.singleRightBrace
        }

      default:
        result.append(ch)
        view.formIndex(after: &index)
      }
    }

    return String(result)
  }

  // MARK: - Consume expr

  /// Consume expression.
  /// Prerequisites: `view[index] = "{"`.
  ///
  /// Will advance index up until:
  /// - end of string
  /// - end of expression (in this case view[index] = '}')
  ///
  /// CPython: `fstring_find_expr`
  private func consumeExpr(
    in view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex) throws -> FStringFragment {

    assert(view[index] == "{")
    view.formIndex(after: &index)

    let exprString = try self.consumeExprValue(in: view, advancing: &index)
    // TODO: Compile exprString -> expr (+ check for empty)

    assert(index == view.endIndex
      || view[index] == "!"
      || view[index] == ":"
      || view[index] == "}"
    )

    /*
     // conversion (todo: to fun + assert)
     if index != view.endIndex && view[index] == "!" {
     view.formIndex(after: &index) // consume !
     guard index != view.endIndex else {
     fatalError() // eof
     }

     let conversion = view[index]
     switch conversion {
     case "s": break
     case "r": break
     case "a": break
     default:
     // f-string: invalid conversion character: expected 's', 'r', or 'a'
     fatalError()
     }

     view.formIndex(after: &index) // consume conversion
     }
     */

    let kind = ExpressionKind.string(.string(exprString))
    let expr = Expression(kind, start: .start, end: .start)
    return .formattedValue(expr, conversion: nil, spec: "")
  }

  private enum QuoteType {
    /** ' */ case single
    /** " */ case double

    fileprivate var scalar: UnicodeScalar {
      switch self {
      case .single: return "'"
      case .double: return "\""
      }
    }
  }

  private enum QuoteCount {
    /** " */ case short
    /** """ */ case long
  }

  private typealias Quote = (type: QuoteType, count: QuoteCount)

  /// Consume first part of the expression.
  ///
  /// Will advance index up until:
  /// - end of string
  /// - end of expression (in this case view[index] = '!', ':' or '}')
  ///
  /// This is basically 1:1 from CPython `fstring_find_expr`.
  /// But still, you can break it if you try long enough.
  private func consumeExprValue(
    in view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex) throws -> String {

    var quote: Quote?
    var nestedDepth = 0 // nesting level for braces/parens/brackets

    let startIndex = index
    whileLoop: while index != view.endIndex {
      switch view[index] {
      case "\\":
        throw FStringError.backslashInExpression

      case "[", "{", "(":
        nestedDepth += 1

      case "]" where nestedDepth != 0,
           "}" where nestedDepth != 0,
           ")" where nestedDepth != 0:
        nestedDepth -= 1

      case "'"  where quote == nil, // string start
           "\"" where quote == nil:

        /// We dont know if it is short (") or long (""") quote.
        quote = try self.getQuoteType(in: view, startingFrom: index)

        if quote?.count == .some(.long) {
          view.formIndex(after: &index) // 1st quote
          view.formIndex(after: &index) // 2nd quote
          // 3rd quote will be advanced after switch
        }

      case quote?.type.scalar: // string end
        guard let q = quote else { fatalError("?") }

        let isEnd = try self.isQuoteEnd(quote: q, view: view, startingFrom: index)
        if isEnd {
          quote = nil

          if q.count == .long {
            view.formIndex(after: &index) // 1st quote
            view.formIndex(after: &index) // 2nd quote
            // 3rd quote will be advanced after switch
          }
        }

      case "#":
        throw FStringError.commentInExpression

      case "!" where nestedDepth == 0:
        let nextIndex = view.index(after: index)

        // '!=' is a special case mentioned in PEP-0498.
        let isNotEqual = nextIndex < view.endIndex && view[nextIndex] == "="
        if !isNotEqual {
          break whileLoop
        }

      case ":" where nestedDepth == 0,
           "}" where nestedDepth == 0:
        break whileLoop

      default:
        break
      }

      view.formIndex(after: &index)
    }

    guard quote == nil else {
      throw FStringError.unterminatedString
    }

    guard nestedDepth == 0 else {
      throw FStringError.mismatchedParen
    }

    let s = view[startIndex..<index]
    return String(s)
  }

  /// Returns 1 for short (") quote and 3 for long (""").
  private func getQuoteType(
    in view: String.UnicodeScalarView,
    startingFrom index: String.UnicodeScalarIndex) throws -> Quote {

    let quote = view[index]
    assert(quote == "'" || quote == "\"")
    let type = quote == "'" ? QuoteType.single : .double

    let index2 = view.index(after: index) // 2nd char (the one after index)
    if index2 == view.endIndex {
      throw FStringError.unterminatedString
    }

    let index3 = view.index(after: index2) // 3rd char
    if index3 == view.endIndex {
      // something like "elsa''" <- '' is at end
      return Quote(type: type, count: .short)
    }

    let isLong = view[index2] == quote && view[index3] == quote
    return Quote(type: type, count: isLong ? .long : .short)
  }

  private func isQuoteEnd(
    quote: Quote,
    view: String.UnicodeScalarView,
    startingFrom index: String.UnicodeScalarIndex) throws -> Bool {

    let scalar = quote.type.scalar
    assert(view[index] == scalar)

    switch quote.count {
    case .long:
      let index2 = view.index(after: index) // 2nd char (the one after index)
      if index2 == view.endIndex {
        throw FStringError.unterminatedString
      }

      let index3 = view.index(after: index2) // 3rd char
      if index3 == view.endIndex {
        throw FStringError.unterminatedString
      }

      return view[index2] == scalar && view[index3] == scalar

    case .short:
      return true
    }
  }
}
