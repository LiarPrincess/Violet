// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

// swiftlint:disable file_length
// swiftlint:disable type_body_length

// Use this to generate:
// for (name, kind) in namedKinds { // e.g. name: "leftParen", kind: .leftParen
//   let length = kind.description.count
//   print("""
//
//     func test_\(name)() {
//       var lexer = Lexer(string: "\(kind)")
//       if let token = self.getToken(&lexer) {
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
    var lexer = Lexer(string: "(")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftParen)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_leftSqb() {
    var lexer = Lexer(string: "[")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftSqb)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_leftBrace() {
    var lexer = Lexer(string: "{")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftBrace)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightParen() {
    var lexer = Lexer(string: ")")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightParen)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightSqb() {
    var lexer = Lexer(string: "]")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightSqb)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightBrace() {
    var lexer = Lexer(string: "}")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightBrace)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_colon() {
    var lexer = Lexer(string: ":")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .colon)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_comma() {
    var lexer = Lexer(string: ",")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .comma)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_semicolon() {
    var lexer = Lexer(string: ";")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .semicolon)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_ellipsis() {
    var lexer = Lexer(string: "...")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .ellipsis)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_plus() {
    var lexer = Lexer(string: "+")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .plus)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_minus() {
    var lexer = Lexer(string: "-")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .minus)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_star() {
    var lexer = Lexer(string: "*")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .star)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_slash() {
    var lexer = Lexer(string: "/")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slash)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_vbar() {
    var lexer = Lexer(string: "|")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .vbar)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_amper() {
    var lexer = Lexer(string: "&")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .amper)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_circumflex() {
    var lexer = Lexer(string: "^")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .circumflex)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_at() {
    var lexer = Lexer(string: "@")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .at)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_plusEqual() {
    var lexer = Lexer(string: "+=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .plusEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_minusEqual() {
    var lexer = Lexer(string: "-=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .minusEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_starEqual() {
    var lexer = Lexer(string: "*=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .starEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_slashEqual() {
    var lexer = Lexer(string: "/=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slashEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_percentEqual() {
    var lexer = Lexer(string: "%=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .percentEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_vbarEqual() {
    var lexer = Lexer(string: "|=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .vbarEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_amperEqual() {
    var lexer = Lexer(string: "&=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .amperEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_circumflexEqual() {
    var lexer = Lexer(string: "^=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .circumflexEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_atEqual() {
    var lexer = Lexer(string: "@=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .atEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_less() {
    var lexer = Lexer(string: "<")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .less)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_greater() {
    var lexer = Lexer(string: ">")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .greater)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_equal() {
    var lexer = Lexer(string: "=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .equal)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_equalEqual() {
    var lexer = Lexer(string: "==")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .equalEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_notEqual() {
    var lexer = Lexer(string: "!=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .notEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_lessEqual() {
    var lexer = Lexer(string: "<=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .lessEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_greaterEqual() {
    var lexer = Lexer(string: ">=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .greaterEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_leftShift() {
    var lexer = Lexer(string: "<<")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftShift)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_rightShift() {
    var lexer = Lexer(string: ">>")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightShift)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_starStar() {
    var lexer = Lexer(string: "**")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .starStar)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_slashSlash() {
    var lexer = Lexer(string: "//")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slashSlash)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_leftShiftEqual() {
    var lexer = Lexer(string: "<<=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftShiftEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_rightShiftEqual() {
    var lexer = Lexer(string: ">>=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightShiftEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_starStarEqual() {
    var lexer = Lexer(string: "**=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .starStarEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_slashSlashEqual() {
    var lexer = Lexer(string: "//=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slashSlashEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_dot() {
    var lexer = Lexer(string: ".")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .dot)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_percent() {
    var lexer = Lexer(string: "%")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .percent)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_tilde() {
    var lexer = Lexer(string: "~")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .tilde)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightArrow() {
    var lexer = Lexer(string: "->")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightArrow)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_colonEqual() {
    var lexer = Lexer(string: ":=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .colonEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }
}
