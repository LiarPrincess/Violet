import XCTest
import VioletCore
@testable import VioletObjects

class PyComplexNewTests: PyTestCase {

  // MARK: - New from string

  func test_fromString_empty_fails() {
    guard let message = self.parseError("") else {
      return
    }

    XCTAssertEqual(message, "complex() arg is a malformed string")
  }

  func test_fromString_real() {
    guard let noSign = self.parse("123.4") else { return }
    XCTAssertEqual(noSign.real, 123.4)
    XCTAssertEqual(noSign.imag, 0.0)

    guard let plus = self.parse("+123.4") else { return }
    XCTAssertEqual(plus.real, 123.4)
    XCTAssertEqual(plus.imag, 0.0)

    guard let minus = self.parse("-123.4") else { return }
    XCTAssertEqual(minus.real, -123.4)
    XCTAssertEqual(minus.imag, 0.0)

    guard let noDecimal = self.parse("123") else { return }
    XCTAssertEqual(noDecimal.real, 123)
    XCTAssertEqual(noDecimal.imag, 0)

    guard let dotEnding = self.parse("123.") else { return }
    XCTAssertEqual(dotEnding.real, 123)
    XCTAssertEqual(dotEnding.imag, 0)
  }

  func test_fromString_imag() {
    guard let noSign = self.parse("123.4j") else { return }
    XCTAssertEqual(noSign.real, 0.0)
    XCTAssertEqual(noSign.imag, 123.4)

    guard let plus = self.parse("+123.4j") else { return }
    XCTAssertEqual(plus.real, 0.0)
    XCTAssertEqual(plus.imag, 123.4)

    guard let minus = self.parse("-123.4j") else { return }
    XCTAssertEqual(minus.real, 0.0)
    XCTAssertEqual(minus.imag, -123.4)

    guard let noDecimal = self.parse("123j") else { return }
    XCTAssertEqual(noDecimal.real, 0)
    XCTAssertEqual(noDecimal.imag, 123)

    guard let dotEnding = self.parse("123.j") else { return }
    XCTAssertEqual(dotEnding.real, 0)
    XCTAssertEqual(dotEnding.imag, 123)
  }

  func test_fromString_real_imag() {
    guard let plusPlus = self.parse("123.4+56.7j") else { return }
    XCTAssertEqual(plusPlus.real, 123.4)
    XCTAssertEqual(plusPlus.imag, 56.7)

    guard let plusMinus = self.parse("123.4-56.7j") else { return }
    XCTAssertEqual(plusMinus.real, 123.4)
    XCTAssertEqual(plusMinus.imag, -56.7)

    guard let minusPlus = self.parse("-123.4+56.7j") else { return }
    XCTAssertEqual(minusPlus.real, -123.4)
    XCTAssertEqual(minusPlus.imag, 56.7)

    guard let minusMinus = self.parse("-123.4-56.7j") else { return }
    XCTAssertEqual(minusMinus.real, -123.4)
    XCTAssertEqual(minusMinus.imag, -56.7)
  }

  // MARK: - Helpers

  private func parse(_ s: String,
                     file: StaticString = #file,
                     line: UInt = #line) -> PyComplex.Raw? {
    switch PyComplex.new(fromString: s) {
    case let .value(r):
      return r
    case let .valueError(message):
      XCTFail(message, file: file, line: line)
      return nil
    }
  }

  private func parseError(_ s: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> String? {
    switch PyComplex.new(fromString: s) {
    case let .value(r):
      XCTAssertNotNil(r, file: file, line: line)
      return nil
    case let .valueError(message):
      return message
    }
  }
}
