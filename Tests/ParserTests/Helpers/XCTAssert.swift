import XCTest
import Core
import Lexer
import Parser

internal func XCTAssertExpression(_ expr:     Expression?,
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

internal func XCTAssertStatement(_ stmt:     Statement,
                                 _ expected: String,
                                 _ message:  String = "",
                                 file: StaticString = #file,
                                 line: UInt         = #line) {
  let desc = String(describing: stmt.kind)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}

internal func XCTAssertWithItem(_ item:  WithItem,
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

internal func XCTAssertDictionaryElement(_ element:  DictionaryElement,
                                         key:      String,
                                         value:    String,
                                         _ message:  String = "",
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

internal func XCTAssertDictionaryElement(_ element:  DictionaryElement,
                                         unpacking:  String,
                                         _ message:  String = "",
                                         file: StaticString = #file,
                                         line: UInt         = #line) {

  guard case let .unpacking(expr) = element else {
    XCTAssertFalse(true, message, file: file, line: line)
    return
  }

  let desc = String(describing: expr)
  XCTAssertEqual(desc, unpacking, message, file: file, line: line)
}
