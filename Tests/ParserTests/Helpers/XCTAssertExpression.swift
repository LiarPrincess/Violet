import XCTest
import Core
import Lexer
import Parser

internal func XCTAssertExpression(_ expr:     Expression,
                                  _ expected: String,
                                  _ message:  String = "",
                                  file: StaticString = #file,
                                  line: UInt         = #line) {
  let desc = String(describing: expr.kind)
  XCTAssertEqual(desc, expected, message, file: file, line: line)
}
