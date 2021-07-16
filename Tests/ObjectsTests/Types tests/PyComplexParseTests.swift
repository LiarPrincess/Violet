import XCTest
import VioletCore
@testable import VioletObjects

class PyComplexParseTests: PyTestCase {

  // MARK: - Empty

  func test_empty_fails() {
    guard let e = self.parseError("") else {
      return
    }

    let isValueError = PyCast.isValueError(e)
    XCTAssert(isValueError)
  }

  // MARK: - Real only

  func test_real_noSign() {
    guard let r = self.parse("123.4") else { return }
    XCTAssertEqual(r.real, 123.4)
    XCTAssertEqual(r.imag, 0.0)
  }

  func test_real_signed() {
    guard let plus = self.parse("+123.4") else { return }
    XCTAssertEqual(plus.real, 123.4)
    XCTAssertEqual(plus.imag, 0.0)

    guard let minus = self.parse("-123.4") else { return }
    XCTAssertEqual(minus.real, -123.4)
    XCTAssertEqual(minus.imag, 0.0)
  }

  func test_real_noDecimal() {
    guard let r = self.parse("123") else { return }
    XCTAssertEqual(r.real, 123)
    XCTAssertEqual(r.imag, 0)

    guard let r2 = self.parse("123.") else { return }
    XCTAssertEqual(r2.real, 123)
    XCTAssertEqual(r2.imag, 0)
  }

  // MARK: - Imag only

  func test_imag_noSign() {
    guard let r = self.parse("123.4j") else { return }
    XCTAssertEqual(r.real, 0.0)
    XCTAssertEqual(r.imag, 123.4)
  }

  func test_imag_signed() {
    guard let plus = self.parse("+123.4j") else { return }
    XCTAssertEqual(plus.real, 0.0)
    XCTAssertEqual(plus.imag, 123.4)

    guard let minus = self.parse("-123.4j") else { return }
    XCTAssertEqual(minus.real, 0.0)
    XCTAssertEqual(minus.imag, -123.4)
  }

  func test_imag_noDecimal() {
    guard let r = self.parse("123j") else { return }
    XCTAssertEqual(r.real, 0)
    XCTAssertEqual(r.imag, 123)

    guard let r2 = self.parse("123.j") else { return }
    XCTAssertEqual(r2.real, 0)
    XCTAssertEqual(r2.imag, 123)
  }

  // MARK: - Real and imag

  func test_both_signed() {
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
    switch PyComplex.parse(s) {
    case let .value(r):
      return r
    case let .error(e):
      XCTAssertNotNil(e, file: file, line: line)
      return nil
    }
  }

  private func parseError(_ s: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> PyBaseException? {
    switch PyComplex.parse(s) {
    case let .value(r):
      XCTAssertNotNil(r, file: file, line: line)
      return nil
    case let .error(e):
      return e
    }
  }
}
