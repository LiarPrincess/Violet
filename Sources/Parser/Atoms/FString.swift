import Foundation
import VioletCore
import VioletLexer

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
  case formattedValue(Expression, conversion: StringExpr.Conversion?, spec: String?)

  fileprivate func compile() -> StringExpr.Group {
    switch self {
    case let .literal(s):
      return .literal(s)
    case let .formattedValue(e, conversion: c, spec: s):
      return .formattedValue(e, conversion: c, spec: s)
    }
  }
}

internal struct FString {

  /// Concatenate strings (up until next expression).
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
      if let literal = try self.consumeLiteral(view: view, advancing: &index) {
        self.append(literal)
      }

      if index != view.endIndex {
        assert(view[index] == "{")

        // Commit current literal, we will append expr after it.
        if let s = self.lastStr {
          self.fragments.append(.literal(s))
          self.lastStr = nil
        }

        let fragment = try self.consumeExpr(view: view, advancing: &index)
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
  internal mutating func compile() throws -> StringExpr.Group {
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
    return StringExpr.Group.joined(groups)
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
    view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex
  ) throws -> String? {

    var scalars = [UnicodeScalar]()
    while index != view.endIndex {
      let ch = view[index]

      // Violet does not support \N{xxx} escapes (e.g. \N{EULER CONSTANT}).

      switch ch {
      case "{",
           "}":
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
    view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex
  ) throws -> FStringFragment {

    assert(view[index] == "{")
    view.formIndex(after: &index) // consume '{'

    // We have to eval right now (not later), to output errors in correct order.
    let exprString = try self.consumeExprValue(view: view, advancing: &index)
    let expr = try self.eval(source: exprString)

    assert(index == view.endIndex
      || view[index] == "!"
      || view[index] == ":"
      || view[index] == "}"
    )

    var conversion: StringExpr.Conversion?
    if index != view.endIndex && view[index] == "!" {
      conversion = try self.consumeExprConversion(view: view, advancing: &index)
    }

    assert(index == view.endIndex
      || view[index] == ":"
      || view[index] == "}"
    )

    var formatSpec: String?
    if index != view.endIndex && view[index] == ":" {
      formatSpec = try self.consumeFormatSpec(view: view, advancing: &index)
    }

    assert(index == view.endIndex || view[index] == "}")

    return .formattedValue(expr, conversion: conversion, spec: formatSpec)
  }

  private func eval(source: String) throws -> Expression {
    let trimmed = source.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmed.isEmpty {
      throw FStringError.emptyExpression
    }

    do {
      let lexer = Lexer(for: trimmed, delegate: self.lexerDelegate)
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
    /// `'`
    case single
    /// `"`
    case double

    fileprivate var scalar: UnicodeScalar {
      switch self {
      case .single: return "'"
      case .double: return "\""
      }
    }
  }

  private enum QuoteCount {
    /// `'` or `"`
    case short
    /// `'''` or `"""`
    case long
  }

  // CPython: char * int, Violet 2 * 2 (we avoid asserts this way)
  private typealias Quote = (type: QuoteType, count: QuoteCount)

  // swiftlint:disable cyclomatic_complexity
  // ^^^ Things are about to get very complicated!

  /// Consume first part of the expression.
  ///
  /// Will advance index up until:
  /// - end of string
  /// - end of expression (in this case `view[index] = '!', ':' or '}'`)
  ///
  /// This is almost 1:1 from CPython `fstring_find_expr`.
  /// But still, you can break it if you try long enough.
  private func consumeExprValue(
    view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex
  ) throws -> String {
    // swiftlint:enable cyclomatic_complexity

    var quote: Quote?
    var parenStackDepth = 0

    let startIndex = index
    while index != view.endIndex {
      let scalar = view[index]

      // Backslash is not allowed inside expression
      if scalar == "\\" {
        throw FStringError.backslashInExpression
      }

      // Are we ending string?
      else if let q = quote {
        switch self.consumeStringEnd(view: view, index: &index, quote: q) {
        case .consumed:
          quote = nil // We finished string
        case .notStringEnd:
          view.formIndex(after: &index) // Consume this character
        }
      }

      // Are we starting string?
      else if scalar == "'" || scalar == "\"" {
        assert(quote == nil)
        quote = self.consumeStringStart(view: view, index: &index)
      }

      // Comments are not allowed in expression
      // (but they are allowed in strings, so this has to be after quote checking)
      else if scalar == "#" {
        throw FStringError.commentInExpression
      }

      // Are we starting paren pair?
      else if scalar == "(" || scalar == "[" || scalar == "{" {
        parenStackDepth += 1
        view.formIndex(after: &index) // Consume paren
      }

      // Are we closing paren pair?
      else if parenStackDepth > 0 && (scalar == ")" || scalar == "]" || scalar == "}") {
        parenStackDepth -= 1
        view.formIndex(after: &index) // Consume paren
      }

      // Format characters (one of  ':}!') end the loop
      // We will NOT consume them because we need to know if we should parse
      // conversion/format AFTER we exit from this fn.
      else if parenStackDepth == 0 && (scalar == ":" || scalar == "}") {
        break
      }

      // '!' is a special case, because it may also be '!=' (see PEP-0498)
      else if parenStackDepth == 0 && scalar == "!" {
        let nextIndex = view.index(after: index)
        let isNotEqual = nextIndex != view.endIndex && view[nextIndex] == "="

        if isNotEqual {
          view.formIndex(after: &index) // consume '!'
          view.formIndex(after: &index) // consume '='
        } else {
          break
        }
      }

      // Nothing interesting, just go to next character
      else {
        view.formIndex(after: &index)
      }
    }

    guard quote == nil else {
      throw FStringError.unterminatedString
    }

    // f"{(let} it go" <- will not trigger it, we got +1 from '(' and -1 from '}',
    //                    it will trigger 'unexpectedEnd' instead
    // f"{((let} it go" <- will trigger it, we got +2 from '(' and -1 from '}'
    // This is how CPython works (kind of surprising).
    guard parenStackDepth == 0 else {
      throw FStringError.mismatchedParen
    }

    // We are expecting one of ':}!', not string end!
    guard index != view.endIndex else {
      throw FStringError.unexpectedEnd
    }

    let s = view[startIndex..<index]
    return String(s)
  }

  private func consumeStringStart(
    view: String.UnicodeScalarView,
    index: inout String.UnicodeScalarIndex
  ) -> Quote {
    let quote = view[index]
    assert(quote == "'" || quote == "\"")

    let type: QuoteType = quote == "'" ? .single : .double
    view.formIndex(after: &index) // consume 'quote'

    // 2nd character
    if index == view.endIndex || view[index] != quote {
      return Quote(type: type, count: .short)
    }

    // Do not advance index!
    // If 3rd character is not quote then we should consume only 1st quote!

    // 3rd character
    let index3 = view.index(after: index)
    if index3 == view.endIndex || view[index3] != quote {
      // something like "elsa''" <- '' is at end
      return Quote(type: type, count: .short)
    }

    // We have long quote, now we can advance 2nd and 3rd character.
    view.formIndex(after: &index)
    view.formIndex(after: &index)
    return Quote(type: type, count: .long)
  }

  private enum ConsumeQuoteEnd {
    case consumed
    case notStringEnd
  }

  private func consumeStringEnd(
    view: String.UnicodeScalarView,
    index: inout String.UnicodeScalarIndex,
    quote: Quote
  ) -> ConsumeQuoteEnd {
    let quoteScalar = quote.type.scalar

    guard view[index] == quoteScalar else {
      return .notStringEnd
    }

    switch quote.count {
    case .short:
      view.formIndex(after: &index) // Consume ending
      return .consumed

    case .long:
      let index2 = view.index(after: index) // 2nd char
      guard index2 != view.endIndex && view[index2] == quoteScalar else {
        return .notStringEnd
      }

      let index3 = view.index(after: index2) // 3rd char
      guard index3 != view.endIndex && view[index3] == quoteScalar else {
        return .notStringEnd
      }

      // We found proper ending!
      view.formIndex(after: &index) // 1st char
      view.formIndex(after: &index) // 2nd char
      view.formIndex(after: &index) // 3rd char
      return .consumed
    }
  }

  // MARK: - Consume expr - conversion

  private func consumeExprConversion(
    view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex
  ) throws -> StringExpr.Conversion {

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
    view: String.UnicodeScalarView,
    advancing index: inout String.UnicodeScalarIndex
  ) throws -> String {

    assert(view[index] == ":")
    view.formIndex(after: &index) // consume ':'

    if index == view.endIndex {
      throw FStringError.unexpectedEnd
    }

    let startIndex = index
    while index != view.endIndex && view[index] != "}" {
      if view[index] == "{" {
        // if we ever implement this: add validation in ASTValidationPass
        let unimplemented = FStringUnimplemented.expressionInFStringFormatSpecifier
        throw FStringError.unimplemented(unimplemented)
      }

      view.formIndex(after: &index)
    }

    assert(index == view.endIndex || view[index] == "}")
    return String(view[startIndex..<index])
  }
}
