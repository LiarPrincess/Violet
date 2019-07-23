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
//     func test_\(name)_isLexed() {
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

  func test_leftParen_isLexed() {
    var lexer = Lexer(string: "(")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftParen)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_leftSqb_isLexed() {
    var lexer = Lexer(string: "[")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftSqb)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_leftBrace_isLexed() {
    var lexer = Lexer(string: "{")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftBrace)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightParen_isLexed() {
    var lexer = Lexer(string: ")")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightParen)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightSqb_isLexed() {
    var lexer = Lexer(string: "]")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightSqb)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightBrace_isLexed() {
    var lexer = Lexer(string: "}")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightBrace)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_colon_isLexed() {
    var lexer = Lexer(string: ":")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .colon)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_comma_isLexed() {
    var lexer = Lexer(string: ",")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .comma)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_semicolon_isLexed() {
    var lexer = Lexer(string: ";")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .semicolon)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_ellipsis_isLexed() {
    var lexer = Lexer(string: "...")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .ellipsis)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_plus_isLexed() {
    var lexer = Lexer(string: "+")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .plus)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_minus_isLexed() {
    var lexer = Lexer(string: "-")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .minus)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_star_isLexed() {
    var lexer = Lexer(string: "*")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .star)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_slash_isLexed() {
    var lexer = Lexer(string: "/")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slash)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_vbar_isLexed() {
    var lexer = Lexer(string: "|")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .vbar)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_amper_isLexed() {
    var lexer = Lexer(string: "&")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .amper)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_circumflex_isLexed() {
    var lexer = Lexer(string: "^")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .circumflex)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_at_isLexed() {
    var lexer = Lexer(string: "@")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .at)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_plusEqual_isLexed() {
    var lexer = Lexer(string: "+=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .plusEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_minusEqual_isLexed() {
    var lexer = Lexer(string: "-=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .minusEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_starEqual_isLexed() {
    var lexer = Lexer(string: "*=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .starEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_slashEqual_isLexed() {
    var lexer = Lexer(string: "/=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slashEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_percentEqual_isLexed() {
    var lexer = Lexer(string: "%=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .percentEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_vbarEqual_isLexed() {
    var lexer = Lexer(string: "|=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .vbarEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_amperEqual_isLexed() {
    var lexer = Lexer(string: "&=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .amperEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_circumflexEqual_isLexed() {
    var lexer = Lexer(string: "^=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .circumflexEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_atEqual_isLexed() {
    var lexer = Lexer(string: "@=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .atEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_less_isLexed() {
    var lexer = Lexer(string: "<")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .less)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_greater_isLexed() {
    var lexer = Lexer(string: ">")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .greater)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_equal_isLexed() {
    var lexer = Lexer(string: "=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .equal)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_equalEqual_isLexed() {
    var lexer = Lexer(string: "==")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .equalEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_notEqual_isLexed() {
    var lexer = Lexer(string: "!=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .notEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_lessEqual_isLexed() {
    var lexer = Lexer(string: "<=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .lessEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_greaterEqual_isLexed() {
    var lexer = Lexer(string: ">=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .greaterEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_leftShift_isLexed() {
    var lexer = Lexer(string: "<<")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftShift)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_rightShift_isLexed() {
    var lexer = Lexer(string: ">>")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightShift)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_starStar_isLexed() {
    var lexer = Lexer(string: "**")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .starStar)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_slashSlash_isLexed() {
    var lexer = Lexer(string: "//")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slashSlash)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_leftShiftEqual_isLexed() {
    var lexer = Lexer(string: "<<=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .leftShiftEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_rightShiftEqual_isLexed() {
    var lexer = Lexer(string: ">>=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightShiftEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_starStarEqual_isLexed() {
    var lexer = Lexer(string: "**=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .starStarEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_slashSlashEqual_isLexed() {
    var lexer = Lexer(string: "//=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .slashSlashEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_dot_isLexed() {
    var lexer = Lexer(string: ".")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .dot)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_percent_isLexed() {
    var lexer = Lexer(string: "%")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .percent)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_tilde_isLexed() {
    var lexer = Lexer(string: "~")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .tilde)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_rightArrow_isLexed() {
    var lexer = Lexer(string: "->")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .rightArrow)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  func test_colonEqual_isLexed() {
    var lexer = Lexer(string: ":=")
    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .colonEqual)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }
}
