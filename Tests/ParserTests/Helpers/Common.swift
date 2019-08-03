import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable large_tuple

/// Shared test helpers.
internal protocol Common { }

extension Common {

  // MARK: - Creation

  /// Create parser for given tokens.
  /// Will automatically add EOF at the end.
  internal func parser(_ tokens: Token...) -> Parser {
    let eofLocation = tokens.last?.end ?? .start
    let eof = Token(.eof, start: eofLocation, end: eofLocation)

    var lexerTokens = tokens
    lexerTokens.append(eof)

    let lexer = FakeLexer(tokens: lexerTokens)
    return Parser(lexer: lexer)
  }

  internal func token(_ kind: TokenKind,
                      start: SourceLocation,
                      end: SourceLocation) -> Token {
    return Token(kind, start: start, end: end)
  }

  // MARK: - Parse

  /// Use this if you just want to perform detailed tests on token.
  internal func parse(_ parser: inout Parser,
                      file:    StaticString = #file,
                      line:    UInt         = #line) -> Expression? {
    do {
      return try parser.parse()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  internal func XCTAssertExpression(_ expr:     Expression,
                                    _ expected: String,
                                    _ message:  String = "",
                                    file: StaticString = #file,
                                    line: UInt         = #line) {
    let desc = String(describing: expr.kind)
    XCTAssertEqual(desc, expected, message, file: file, line: line)
  }

  // MARK: - Errors

  internal func error(_ parser: inout Parser,
                      file:    StaticString = #file,
                      line:    UInt = #line) -> ParserError? {
    do {
      let result = try parser.parse()
      XCTAssert(false, "Result: \(result)", file: file, line: line)
      return nil
    } catch let error as ParserError {
      return error
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Desctruct

  internal func destructUnary(_ expr: Expression,
                              file:   StaticString = #file,
                              line:   UInt         = #line) ->
    (UnaryOperator, right: Expression)? {

    if case let ExpressionKind.unaryOp(op, right: right) = expr.kind {
      return (op, right)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructBinary(_ expr: Expression,
                               file:   StaticString = #file,
                               line:   UInt         = #line) ->
    (BinaryOperator, left: Expression, right: Expression)? {

      if case let ExpressionKind.binaryOp(op, left: left, right: right) = expr.kind {
        return (op, left, right)
      }

      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
  }

  internal func destructBoolean(_ expr: Expression,
                                file:   StaticString = #file,
                                line:   UInt         = #line) ->
    (BooleanOperator, left: Expression, right: Expression)? {

      if case let ExpressionKind.boolOp(op, left: left, right: right) = expr.kind {
        return (op, left, right)
      }

      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
  }

  internal func destructCompare(_ expr: Expression,
                                file:   StaticString = #file,
                                line:   UInt         = #line) ->
    (left: Expression, elements: [ComparisonElement])? {

      if case let ExpressionKind.compare(left: left, elements: elements) = expr.kind {
        return (left, elements)
      }

      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
  }

  internal func destructAttribute(_ expr: Expression,
                                  file:   StaticString = #file,
                                  line:   UInt         = #line) ->
    (Expression, name: String)? {

      if case let ExpressionKind.attribute(value, name: name) = expr.kind {
        return (value, name)
      }

      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
  }

  internal func destructSubscriptIndex(_ expr: Expression,
                                       file:   StaticString = #file,
                                       line:   UInt         = #line) ->
    (slice: Slice, index: Expression)? {

    guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
    }

    switch slice.kind {
    case let .index(index):
      return (slice, index)
    default:
      XCTAssertTrue(false, slice.kind.description, file: file, line: line)
      return nil
    }
  }

  internal func destructSubscriptSlice(_ expr: Expression,
                                       file:   StaticString = #file,
                                       line:   UInt         = #line) ->
    (slice: Slice, lower: Expression?, upper: Expression?, step: Expression?)? {

      guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
        XCTAssertTrue(false, expr.kind.description, file: file, line: line)
        return nil
      }

      switch slice.kind {
      case let .slice(lower: l, upper: u, step: s):
        return (slice, l, u, s)
      default:
        XCTAssertTrue(false, slice.kind.description, file: file, line: line)
        return nil
      }
  }

  internal func destructSubscriptSliceExt(_ expr: Expression,
                                          file:   StaticString = #file,
                                          line:   UInt         = #line) ->
    (slice: Slice, dims: [Slice])? {

      guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
        XCTAssertTrue(false, expr.kind.description, file: file, line: line)
        return nil
      }

      switch slice.kind {
      case let .extSlice(dims: dims):
        return (slice, dims)
      default:
        XCTAssertTrue(false, slice.kind.description, file: file, line: line)
        return nil
      }
  }

  internal func destructLambda(_ expr: Expression,
                               file:   StaticString = #file,
                               line:   UInt         = #line) ->
    (args: Arguments, body: Expression)? {

    if case let ExpressionKind.lambda(args: args, body: body) = expr.kind {
      return (args, body)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }
}
