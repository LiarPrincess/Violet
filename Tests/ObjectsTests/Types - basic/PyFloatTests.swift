import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyFloatTests: PyTestCase {

  // MARK: - Integer ratio

  func test_as_integer_ratio() {
    let py = self.createPy()
    // >>> (10.0).as_integer_ratio() -> (10, 1)
    self.assertIntegerRatio(py, 10.0, tuple: 10, 1)
    // >>> (0.0).as_integer_ratio() -> (0, 1)
    self.assertIntegerRatio(py, 0.0, tuple: 0, 1)
    // >>> (-.25).as_integer_ratio() -> (-1, 4)
    self.assertIntegerRatio(py, -0.25, tuple: -1, 4)
  }

  private func assertIntegerRatio(_ py: Py,
                                  _ value: Double,
                                  tuple tuple0: Int,
                                  _ tuple1: Int,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = self.callMethod(py,
                                 object: valueObject,
                                 selector: "as_integer_ratio",
                                 args: [])

    let tuple0Object = py.newInt(tuple0).asObject
    let tuple1Object = py.newInt(tuple1).asObject
    let tuple = [tuple0Object, tuple1Object]
    self.assertTuple(py, object: result, elements: tuple, file: file, line: line)
  }

  // MARK: - Round

  func test__round__() {
    let py = self.createPy()
    let f123_456 = py.newFloat(123.456)

    // (123.456).__round__(None) -> 123.0
    self.assertRound(py, f123_456, nDigits: nil, expected: 123.0)
    // (123.456).__round__(0) -> 123.0
    self.assertRound(py, f123_456, nDigits: 0, expected: 123.0)
    // (123.456).__round__(1) -> 123.5
    self.assertRound(py, f123_456, nDigits: 1, expected: 123.5)
    // (123.456).__round__(2) -> 123.46
    self.assertRound(py, f123_456, nDigits: 2, expected: 123.46)
    // (123.456).__round__(-1) -> 120.0
    self.assertRound(py, f123_456, nDigits: -1, expected: 120.0)
    // (123.456).__round__(-2) -> 100.0
    self.assertRound(py, f123_456, nDigits: -2, expected: 100.0)
  }

  private func assertRound(_ py: Py,
                           _ object: PyFloat,
                           nDigits: Int?,
                           expected: Double,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let nDigitsObject: PyObject
    if let d = nDigits {
      nDigitsObject = py.newInt(d).asObject
    } else {
      nDigitsObject = py.none.asObject
    }

    let result = self.callMethod(py,
                                 object: object.asObject,
                                 selector: "__round__",
                                 args: [nDigitsObject])

    let expectedObject = py.newFloat(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Trunc

  func test__trunc__() {
    let py = self.createPy()
    self.assertTrunc(py, 3.1, expected: 3)
    self.assertTrunc(py, -3.1, expected: -3)
    self.assertTrunc(py, 7.5, expected: 7)
    self.assertTrunc(py, -7.5, expected: -7)
  }

  private func assertTrunc(_ py: Py,
                           _ value: Double,
                           expected: Int,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = self.callMethod(py,
                                 object: valueObject,
                                 selector: "__trunc__",
                                 args: [])

    let expectedObject = py.newInt(expected).asObject
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Pow

  func test__pow__() {
    let py = self.createPy()
    self.assertPow(py, base: 3.1, exp: 5.7, expected: 632.064872663979)
    self.assertPow(py, base: 5.7, exp: 3.1, expected: 220.40023466591268)
  }

  private func assertPow(_ py: Py,
                         base: Double,
                         exp: Double,
                         expected: Double,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let baseObject = py.newFloat(base).asObject
    let expObject = py.newFloat(exp).asObject
    let result = py.pow(base: baseObject, exp: expObject, mod: nil)

    let expectedObject = py.newFloat(expected).asObject
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }
}
