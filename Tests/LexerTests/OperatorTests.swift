import XCTest
import VioletCore
@testable import VioletLexer

// swiftlint:disable file_length
// swiftformat:disable consecutiveSpaces

// Use this to generate:
// for (name, kind) in namedKinds { // e.g. name: "leftParen", kind: .leftParen
//   let length = kind.description.count
//   print("""
//
//     func test_\(name)() {
//       let lexer = self.createLexer(for: "\(kind)")
//       if let token = self.getToken(lexer) {
//         XCTAssertEqual(token.kind, .\(name))
//         XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
//         XCTAssertEqual(token.end,   SourceLocation(line: 1, column: \(length)))
//       }
//     }
//   """)
// }

/// Use 'python3 -m tokenize -e file.py' for python reference
class OperatorTests: XCTestCase, Common {

  func test_leftParen() {
    let lexer = self.createLexer(for: "(")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .leftParen)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_leftSqb() {
    let lexer = self.createLexer(for: "[")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .leftSqb)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_leftBrace() {
    let lexer = self.createLexer(for: "{")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .leftBrace)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightParen() {
    let lexer = self.createLexer(for: ")")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .rightParen)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightSqb() {
    let lexer = self.createLexer(for: "]")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .rightSqb)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightBrace() {
    let lexer = self.createLexer(for: "}")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .rightBrace)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_colon() {
    let lexer = self.createLexer(for: ":")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .colon)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_comma() {
    let lexer = self.createLexer(for: ",")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .comma)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_semicolon() {
    let lexer = self.createLexer(for: ";")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .semicolon)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_ellipsis() {
    let lexer = self.createLexer(for: "...")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .ellipsis)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_plus() {
    let lexer = self.createLexer(for: "+")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .plus)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_minus() {
    let lexer = self.createLexer(for: "-")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .minus)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_star() {
    let lexer = self.createLexer(for: "*")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .star)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_slash() {
    let lexer = self.createLexer(for: "/")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .slash)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_vbar() {
    let lexer = self.createLexer(for: "|")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .vbar)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_amper() {
    let lexer = self.createLexer(for: "&")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .amper)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_circumflex() {
    let lexer = self.createLexer(for: "^")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .circumflex)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_at() {
    let lexer = self.createLexer(for: "@")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .at)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_plusEqual() {
    let lexer = self.createLexer(for: "+=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .plusEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_minusEqual() {
    let lexer = self.createLexer(for: "-=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .minusEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_starEqual() {
    let lexer = self.createLexer(for: "*=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .starEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_slashEqual() {
    let lexer = self.createLexer(for: "/=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .slashEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_percentEqual() {
    let lexer = self.createLexer(for: "%=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .percentEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_vbarEqual() {
    let lexer = self.createLexer(for: "|=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .vbarEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_amperEqual() {
    let lexer = self.createLexer(for: "&=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .amperEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_circumflexEqual() {
    let lexer = self.createLexer(for: "^=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .circumflexEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_atEqual() {
    let lexer = self.createLexer(for: "@=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .atEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_less() {
    let lexer = self.createLexer(for: "<")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .less)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_greater() {
    let lexer = self.createLexer(for: ">")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .greater)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_equal() {
    let lexer = self.createLexer(for: "=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .equal)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_equalEqual() {
    let lexer = self.createLexer(for: "==")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .equalEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_notEqual() {
    let lexer = self.createLexer(for: "!=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .notEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_lessEqual() {
    let lexer = self.createLexer(for: "<=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .lessEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_greaterEqual() {
    let lexer = self.createLexer(for: ">=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .greaterEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_leftShift() {
    let lexer = self.createLexer(for: "<<")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .leftShift)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_rightShift() {
    let lexer = self.createLexer(for: ">>")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .rightShift)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_starStar() {
    let lexer = self.createLexer(for: "**")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .starStar)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_slashSlash() {
    let lexer = self.createLexer(for: "//")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .slashSlash)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_leftShiftEqual() {
    let lexer = self.createLexer(for: "<<=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .leftShiftEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_rightShiftEqual() {
    let lexer = self.createLexer(for: ">>=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .rightShiftEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_starStarEqual() {
    let lexer = self.createLexer(for: "**=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .starStarEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_slashSlashEqual() {
    let lexer = self.createLexer(for: "//=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .slashSlashEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_dot() {
    let lexer = self.createLexer(for: ".")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .dot)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_percent() {
    let lexer = self.createLexer(for: "%")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .percent)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_tilde() {
    let lexer = self.createLexer(for: "~")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .tilde)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightArrow() {
    let lexer = self.createLexer(for: "->")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .rightArrow)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_colonEqual() {
    let lexer = self.createLexer(for: ":=")
    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .colonEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }
}
