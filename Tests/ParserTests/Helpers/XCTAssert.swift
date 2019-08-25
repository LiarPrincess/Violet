import XCTest
import Core
import Lexer
import Parser

internal func XCTAssertExpression(_ expr: Expression?,
                                  _ expected: String,
                                  _ message:  String = "",
                                  file: StaticString = #file,
                                  line: UInt         = #line) {
  guard let e = expr else {
    XCTAssertTrue(false, "nil", file: file, line: line)
    return
  }

  let desc = String(describing: e.kind)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}

internal func XCTAssertStatement(_ stmt: Statement,
                                 _ expected: String,
                                 _ message:  String = "",
                                 file: StaticString = #file,
                                 line: UInt         = #line) {
  let desc = String(describing: stmt.kind)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}

internal func XCTAssertWithItem(_ item: WithItem,
                                _ expected: String,
                                _ message:  String = "",
                                file: StaticString = #file,
                                line: UInt         = #line) {
  let desc = String(describing: item)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}

internal func XCTAssertExceptHandler(_ handler:  ExceptHandler,
                                     _ expected: String,
                                     _ message:  String = "",
                                     file: StaticString = #file,
                                     line: UInt         = #line) {
  let desc = String(describing: handler)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}

internal func XCTAssertKeyword(_ keyword:  Keyword,
                               _ expected: String,
                               _ message:  String = "",
                               file: StaticString = #file,
                               line: UInt         = #line) {
  let desc = String(describing: keyword)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}

internal func XCTAssertArgument(_ arg:      Arg?,
                                _ expected: Arg,
                                file: StaticString = #file,
                                line: UInt         = #line) {

  XCTAssertNotNil(arg, file: file, line: line)
  guard let a = arg else { return }

  XCTAssertEqual(a.name, expected.name, file: file, line: line)

  let aDesc = String(describing: a.annotation)
  let eDesc = String(describing: expected.annotation)
  XCTAssertEqual(aDesc, eDesc, aDesc, file: file, line: line)

  XCTAssertEqual(a.start, expected.start, file: file, line: line)
  XCTAssertEqual(a.end,   expected.end,   file: file, line: line)
}

internal func XCTAssertArguments(_ args:     [Arg],
                                 _ expected: [Arg],
                                 file: StaticString = #file,
                                 line: UInt         = #line) {

  XCTAssertEqual(args.count,
                 expected.count,
                 "Invalid count",
                 file: file,
                 line: line)

  for (a, e) in zip(args, expected) {
    XCTAssertArgument(a, e)
  }
}

internal func XCTAssertArgumentDefaults(_ exprs:    [Expression],
                                        _ expected: [Expression],
                                        file: StaticString = #file,
                                        line: UInt         = #line) {

  XCTAssertEqual(exprs.count,
                 expected.count,
                 "Invalid count",
                 file: file,
                 line: line)

  for (e, rhs) in zip(exprs, expected) {
    let eDesc = String(describing: e)
    let rhsDesc = String(describing: rhs)
    XCTAssertEqual(eDesc, rhsDesc, eDesc, file: file, line: line)

    XCTAssertEqual(e.start, rhs.start)
    XCTAssertEqual(e.end, rhs.end)
  }
}

internal func XCTAssertVararg(_ vararg: Vararg,
                              _ expected: Vararg,
                              _ message:  String = "",
                              file: StaticString = #file,
                              line: UInt         = #line) {
  switch (vararg, expected) {
  case (.none, .none),
       (.unnamed, .unnamed):
    return
  case let (.named(v), .named(e)):
    XCTAssertArgument(v, e)
  default:
    XCTAssertEqual(vararg, expected, file: file, line: line)
  }
}

internal func XCTAssertDictionaryElement(_ element: DictionaryElement,
                                         key:       String,
                                         value:     String,
                                         _ message: String = "",
                                         file: StaticString = #file,
                                         line: UInt         = #line) {

  guard case let .keyValue(key: k, value: v) = element else {
    XCTAssertFalse(true, message, file: file, line: line)
    return
  }

  let kDesc = String(describing: k)
  XCTAssertEqual(kDesc, key, message, file: file, line: line)

  let vDesc = String(describing: v)
  XCTAssertEqual(vDesc, value, message, file: file, line: line)
}

internal func XCTAssertDictionaryElement(_ element: DictionaryElement,
                                         unpacking: String,
                                         _ message: String = "",
                                         file: StaticString = #file,
                                         line: UInt         = #line) {

  guard case let .unpacking(expr) = element else {
    XCTAssertFalse(true, message, file: file, line: line)
    return
  }

  let desc = String(describing: expr)
  XCTAssertEqual(desc, unpacking, message, file: file, line: line)
}
