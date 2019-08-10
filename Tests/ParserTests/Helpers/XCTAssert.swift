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
