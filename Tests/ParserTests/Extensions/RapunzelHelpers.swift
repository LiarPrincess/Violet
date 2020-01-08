import Foundation
import XCTest
import Lexer
import Core
import Rapunzel
@testable import Parser

// MARK: - Assert

internal func XCTAssertExprDoc(_ value: ExpressionKind,
                               _ expected: String,
                               _ message:  String = "",
                               file: StaticString = #file,
                               line: UInt         = #line) {
  let result = value.doc.layout()
  XCTAssertEqual(result, expected, message, file: file, line: line)
}

internal func XCTAssertStmtDoc(_ value: StatementKind,
                               _ expected: String,
                               _ message:  String = "",
                               file: StaticString = #file,
                               line: UInt         = #line) {
  let result = value.doc.layout()
  XCTAssertEqual(result, expected, message, file: file, line: line)
}

// MARK: - Shared

internal protocol RapunzelShared { }

extension RapunzelShared {

  // MARK: - Statement

  internal func statement(string: String) -> Statement {
    let e = self.expression(string: string)
    return self.statement(.expr(e))
  }

  internal func statement(_ kind: StatementKind) -> Statement {
    return Statement(
      kind,
      start: SourceLocation(line: 0, column: 0),
      end: SourceLocation(line: 0, column: 10)
    )
  }

  // MARK: - Expression

  internal func expression(string: String) -> Expression {
    return self.expression(.string(.literal(string)))
  }

  internal func expression(_ kind: ExpressionKind) -> Expression {
    return Expression(
      kind,
      start: SourceLocation(line: 1, column: 10),
      end: SourceLocation(line: 2, column: 20)
    )
  }

  // MARK: - Comprehension

  internal func comprehension(target: Expression,
                              iter: Expression,
                              ifs: [Expression],
                              isAsync: Bool) -> Comprehension {
    return Comprehension(
       target: target,
       iter: iter,
       ifs: ifs,
       isAsync: isAsync,
       start: SourceLocation(line: 3, column: 30),
       end: SourceLocation(line: 4, column: 40)
     )
  }

  // MARK: - Arguments

  // swiftlint:disable:next function_parameter_count
  internal func arguments(args: [Arg],
                          defaults: [Expression],
                          vararg: Vararg,
                          kwOnlyArgs: [Arg],
                          kwOnlyDefaults: [Expression],
                          kwarg: Arg?) -> Arguments {
    return Arguments(
      args: args,
      defaults: defaults,
      vararg: vararg,
      kwOnlyArgs: kwOnlyArgs,
      kwOnlyDefaults: kwOnlyDefaults,
      kwarg: kwarg,
      start: SourceLocation(line: 5, column: 50),
      end: SourceLocation(line: 6, column: 60)
    )
  }

  internal func arg(name: String, annotation: Expression?) -> Arg {
    return Arg(
      name,
      annotation: annotation,
      start: SourceLocation(line: 7, column: 70),
      end: SourceLocation(line: 8, column: 80)
    )
  }

  internal func keyword(kind: KeywordKind, value: Expression) -> Keyword {
    return Keyword(
      kind: kind,
      value: value,
      start: SourceLocation(line: 9, column: 90),
      end: SourceLocation(line: 10, column: 100)
    )
  }

  // MARK: - Slice

  internal func slice(kind: SliceKind) -> Slice {
    return Slice(
      kind,
      start: SourceLocation(line: 11, column: 110),
      end: SourceLocation(line: 12, column: 120)
    )
  }

  // MARK: - WithItem

  internal func withItem(contextExpr: Expression,
                         optionalVars: Expression?) -> WithItem {
    return WithItem(
      contextExpr: contextExpr,
      optionalVars: optionalVars,
      start: SourceLocation(line: 13, column: 130),
      end: SourceLocation(line: 14, column: 140)
    )
  }

  // MARK: - ExceptHandler

  internal func exceptHandler(kind: ExceptHandlerKind,
                              body: Statement) -> ExceptHandler {
    return ExceptHandler(
      kind: kind,
      body: NonEmptyArray(first: body),
      start: SourceLocation(line: 15, column: 150),
      end: SourceLocation(line: 16, column: 160)
    )
  }

  // MARK: - Alias

  internal func alias(name: String, asName: String?) -> Alias {
    return Alias(
      name: name,
      asName: asName,
      start: SourceLocation(line: 17, column: 170),
      end: SourceLocation(line: 18, column: 180)
    )
  }
}

// MARK: - Dump

@available(*, deprecated, message: "Usable only when writing tests")
internal func dump<R: RapunzelConvertible>(_ value: R) {
  print("========")
  print(value.dump())
  print("========")
}
