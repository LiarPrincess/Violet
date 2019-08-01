// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

class AtomExprTest: XCTestCase, Common {

  func test_int() {
    let value = PyInt(42)

    var parser = self.parser(
      self.token(.int(value), start: self.loc0, end: self.loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "42")
      XCTAssertEqual(expr.kind,  .int(value))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc1)
    }
  }

  func test_float() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc2)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "4.2")
      XCTAssertEqual(expr.kind,  .float(4.2))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc2)
    }
  }

  func test_imaginary() {
    var parser = self.parser(
      self.token(.imaginary(4.2), start: self.loc0, end: self.loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(complex 0.0 4.2)")
      XCTAssertEqual(expr.kind,  .complex(real: 0.0, imag: 4.2))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc1)
    }
  }

  func test_await() {
    let value = PyInt(42)

    var parser = self.parser(
      self.token(.await,      start: self.loc0, end: self.loc1),
      self.token(.int(value), start: self.loc2, end: self.loc3)
    )

    if let expr = self.parse(&parser) {
      let inner = Expression(.int(value), start: self.loc2, end: self.loc3)

      XCTAssertExpression(expr, "(await 42)")
      XCTAssertEqual(expr.kind,  .await(inner))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc3)
    }
  }
}
