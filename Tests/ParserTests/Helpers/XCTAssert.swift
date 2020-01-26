import Parser
import XCTest

internal func XCTAssertAST(_ ast: AST,
                           _ expected: String,
                           file: StaticString = #file,
                           line: UInt         = #line) {
  let string = String(describing: ast)
  XCTAssertEqual(string, expected, file: file, line: line)
}

internal func XCTAssertString(_ group: StringGroup,
                              _ expected: String,
                              file: StaticString = #file,
                              line: UInt         = #line) {
  let string  = String(describing: group)
  XCTAssertEqual(string , expected, file: file, line: line)
}
