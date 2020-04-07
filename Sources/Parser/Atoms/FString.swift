import Core
import Lexer
import Foundation

// FString: https://www.python.org/dev/peps/pep-0498/

// In CPython:
// Python -> ast.c
//  parsestrplus(struct compiling *c, const node *n)

// It is FString, so normal rules do not apply:
// swiftlint:disable file_length
// swiftlint:disable function_body_length

private enum FStringFragment {
  /// String literal (the part NOT between '{' and '}').
  case literal(String)
  /// Expression + formatter (the part between '{' and '}').
  case formattedValue(Expression, conversion: ConversionFlag?, spec: String?)

  fileprivate func compile() -> StringGroup {
    switch self {
    case let .literal(s):
      return .literal(s)
    case let .formattedValue(e, conversion: c, spec: s):
      return .formattedValue(e, conversion: c, spec: s)
    }
  }
}

internal struct FString {

  /// Conctenate strings (up until next expression).
  private var lastStr: String?

  /// List of the fragments that will go into result.
  /// If we did not append any fragments the it is just an ordinary string.
  private var fragments = [FStringFragment]()

  private weak var parserDelegate: ParserDelegate?
  private weak var lexerDelegate: LexerDelegate?

  internal init(parserDelegate: ParserDelegate?,
                lexerDelegate: LexerDelegate?) {
    self.parserDelegate = parserDelegate
    self.lexerDelegate = lexerDelegate
  }

  // MARK: - FString

  /// Literal text not contained in braces, it will be copied to the output.
  /// For example: `"Elsa"`.
  internal mutating func append(_ s: String) {
    let value = self.lastStr ?? ""
    self.lastStr = value + s
  }

  /// “Replacement fields” surrounded by curly braces.
  /// For example: `f"Let it {go}"` (where `go` is replacement).
  internal mutating func appendFormatString(_ s: String) throws {
    let view = s.unicodeScalars
    var index = view.startIndex

    while index != view.endIndex {
      // Literal is optional, because we may start with expr
      // and we can't just add a node!
      if let literal = try self.consumeLiteral(in: view, advancing: &index) {
        self.append(literal)
      }

      if index != view.endIndex {
        assert(view[index] == "{")

        // Commit current literal, we will append expr after it.
        if let s = self.lastStr {
          self.fragments.append(.literal(s))
          self.lastStr = nil
        }

        let fragment = try self.consumeExpr(in: view, advancing: &index)
        self.fragments.append(fragment)

        if index != view.endIndex {
          assert(view[index] == "}")
          view.formIndex(after: &index)
        }
      }
    }
  }

  /// For normal strings and f-strings, concatenate them together.
  /// - Note:
  /// Result is defined as:
  /// - String - no f-strings.
  /// - FormattedValue - just an f-string (with no leading or trailing literals).
  /// - JoinedStr - if there are multiple f-strings or any literals involved.
  internal mutating func compile() throws -> StringGroup {
    // No fstrings? -> simple string.
    if self.fragments.isEmpty {
      return .literal(self.lastStr ?? "")
    }

    // Create a Str node out of last_str, if needed.
    if let s = self.lastStr {
      self.fragments.append(.literal(s))
      self.lastStr = nil
    }

    // Note that `f"Elsa"` is JoinedStr! (because of: "any literals involved")
    if self.fragments.count == 1 {
      let first = self.fragments[0]
      if case .formattedValue = first {
        return first.compile()
      }
    }

    let groups = self.fragments.map { $0.compile() }
    return StringGroup.joined(groups)
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
    advancing index: inout String.UnicodeScalarIndex) throws -> String? {

    var scalars = [UnicodeScalar]()
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
          scalars.append(ch)
          view.formIndex(&index, offsetBy: 2) // current {, next {
        } else if ch == "{" { // start of expr
          return self.createLiteralResult(from: scalars)
        } else { // ch == "}", standalone "}" is not allowed, only "}}" is
          throw FStringError.singleRightBrace
        }

      default:
        scalars.append(ch)
        view.formIndex(after: &index)
      }
    }

    return self.createLiteralResult(from: scalars)
  }

  private func createLiteralResult(from scalars: [UnicodeScalar]) -> String? {
    return scalars.isEmpty ? nil : String(scalars)
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
    view.formIndex(after: &index) // consume '{'

    // We have to eval right now (not later), to output errors in correct order.
    let exprString = try self.consumeExprValue(in: view, advancing: &index)
    let expr = try self.eval(exprString)

    assert(index == view.endIndex
      || view[index] == "!"
      || view[index] == ":"
      || view[index] == "}"
    )

    var conversion: ConversionFlag?
    if index != view.endIndex && view[index] == "!" {
      conversion = try self.consumeExprConversion(in: view, advancing: &index)
    }

    assert(index == view.endIndex
      || view[index] == ":"
      || view[index] == "}"
    )

    var formatSpec: String?
    if index != view.endIndex && view[index] == ":" {
      formatSpec = try self.consumeFormatSpec(in: view, advancing: &index)
    }

    assert(index == view.endIndex || view[index] == "}")

    return .formattedValue(expr, conversion: conversion, spec: formatSpec)
  }

  private func eval(_ s: String) throws -> Expression {
    if s.isEmpty {
      throw FStringError.emptyExpression
    }

    do {
      let lexer = Lexer(for: s, delegate: self.lexerDelegate)
      let parser = Parser(mode: .eval,
                          tokenSource: lexer,
                          delegate: self.parserDelegate,
                          lexerDelegate: self.lexerDelegate)
      let ast = try parser.parse()

      guard let exprAST = ast as? ExpressionAST else {
        trap("Parser in 'eval' mode should return expression.")
      }

      return exprAST.expression
    } catch let error as ParserError {
      throw FStringError.parsingError(error.kind)
    }
  }

  // MARK: - Consume expr - value

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
    /** " */   case short
    /** """ */ case long
  }

  // CPython: char * int, Violet 2 * 2 (we avoid asserts this way)
  private typealias Quote = (type: QuoteType, count: QuoteCount)

  /// Consume first part of the expression.
  ///
  /// Will advance index up until:
  /// - end of string
  /// - end of expression (in this case view[index] = '!', ':' or '}')
  ///
  /// This is almost 1:1 from CPython `fstring_find_expr`.
  /// But still, you can break it if you try long enough.
  private func consumeExprValue(
    in view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex) throws -> String {

    var quote: Quote?
    var nestedDepth = 0 // nesting level for braces/parens/brackets

    let startIndex = index
    whileLoop: while index != view.endIndex {
      let isInsideParen = nestedDepth > 0
      let isInsideString = quote != nil
      let isInsideSomething = isInsideParen || isInsideString

      switch view[index] {
      case "\\":
        throw FStringError.backslashInExpression

      case "[", "{", "(":
        nestedDepth += 1

      case "]" where isInsideParen,
           "}" where isInsideParen,
           ")" where isInsideParen:
        nestedDepth -= 1

      case "'"  where !isInsideString, // string start
           "\"" where !isInsideString:

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

      case "!" where !isInsideSomething:
        let nextIndex = view.index(after: index)

        // '!=' is a special case mentioned in PEP-0498.
        let isNotEqual = nextIndex < view.endIndex && view[nextIndex] == "="
        if !isNotEqual {
          break whileLoop
        }

      case ":" where !isInsideSomething,
           "}" where !isInsideSomething:
        break whileLoop

      default:
        break
      }

      view.formIndex(after: &index)
    }

    guard quote == nil else {
      throw FStringError.unterminatedString
    }

    // f"Let it go, {(let} it go" <- will not trigger it, we got +1 from '(' and
    //                               -1 from '}', it is 'unexpectedEnd' instead
    // f"Let it go, {((let} it go" <- will trigger it
    // This is how CPython works (kind of surprising).
    guard nestedDepth == 0 else {
      throw FStringError.mismatchedParen
    }

    if index == view.endIndex {
      throw FStringError.unexpectedEnd
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

  // MARK: - Consume expr - conversion

  private func consumeExprConversion(
    in view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex) throws -> ConversionFlag {

    assert(view[index] == "!")
    view.formIndex(after: &index) // consume '!'

    if index == view.endIndex {
      throw FStringError.unexpectedEnd
    }

    switch view[index] {
    case "s":
      view.formIndex(after: &index) // consume 's'
      return .str
    case "r":
      view.formIndex(after: &index) // consume 'r'
      return .repr
    case "a":
      view.formIndex(after: &index) // consume 'a'
      return .ascii
    default:
      throw FStringError.invalidConversion(view[index])
    }
  }

  // MARK: - Consume expr - format spec

  private func consumeFormatSpec(
    in view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex) throws -> String {

    assert(view[index] == ":")
    view.formIndex(after: &index) // consume ':'

    if index == view.endIndex {
      throw FStringError.unexpectedEnd
    }

    let startIndex = index
    while index != view.endIndex && view[index] != "}" {
      if view[index] == "{" {
        // if we ever implement this: add validation in ASTValidationPass
        self.trapExpressionInFormatSpecifier()
      }

      view.formIndex(after: &index)
    }

    assert(index == view.endIndex || view[index] == "}")
    return String(view[startIndex..<index])
  }
}
