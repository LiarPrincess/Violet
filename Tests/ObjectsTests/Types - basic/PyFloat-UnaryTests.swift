import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyFloatUnaryTests: PyTestCase {

  // MARK: - Bool

  func test__bool__() {
    let py = self.createPy()
    self.assertBool(py, value: 0.0, expected: false)
    self.assertBool(py, value: 1.0, expected: true)
    self.assertBool(py, value: 3.1, expected: true)
    self.assertBool(py, value: -1.0, expected: true)
    self.assertBool(py, value: -3.1, expected: true)

    // >>> import math
    // >>> bool(math.nan) -> True
    // >>> bool(math.inf) -> True
    self.assertBool(py, value: .nan, expected: true)
    self.assertBool(py, value: .infinity, expected: true)
    self.assertBool(py, value: -.infinity, expected: true)
  }

  private func assertBool(_ py: Py,
                          value: Double,
                          expected: Bool,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    self.assertIsTrue(py, object: valueObject, expected: expected, file: file, line: line)
  }

  // MARK: - Int

  func test__int__() {
    let py = self.createPy()
    self.assertInt(py, value: 0.0, expected: 0)
    self.assertInt(py, value: 3.1, expected: 3)
    self.assertInt(py, value: -3.1, expected: -3)
  }

  private func assertInt(_ py: Py,
                         value: Double,
                         expected: Int,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = self.callMethod(py, object: valueObject, selector: "__int__", args: [])

    let expectedObject = py.newInt(expected)
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

  // MARK: - Real

  func test_real() {
    let py = self.createPy()
    self.assertReal(py, value: 0.0)
    self.assertReal(py, value: 3.1)
    self.assertReal(py, value: -3.1)
  }

  private func assertReal(_ py: Py,
                          value: Double,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = self.get(py, object: valueObject, propertyName: "real")
    self.assertIsEqual(py, left: result, right: valueObject, file: file, line: line)
  }

  // MARK: - Imag

  func test_imag() {
    let py = self.createPy()
    self.assertImag(py, value: 0.0)
    self.assertImag(py, value: 3.1)
    self.assertImag(py, value: -3.1)
  }

  private func assertImag(_ py: Py,
                          value: Double,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = self.get(py, object: valueObject, propertyName: "imag")

    let expectedObject = py.newFloat(0.0)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Conjugate

  func test_conjugate() {
    let py = self.createPy()
    self.assertConjugate(py, value: 0.0)
    self.assertConjugate(py, value: 3.1)
    self.assertConjugate(py, value: -3.1)
  }

  private func assertConjugate(_ py: Py,
                               value: Double,
                               file: StaticString = #file,
                               line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = self.callMethod(py, object: valueObject, selector: "conjugate", args: [])
    self.assertIsEqual(py, left: result, right: valueObject, file: file, line: line)
  }

  // MARK: - Positive

  func test__pos__() {
    let py = self.createPy()
    self.assertPositive(py, value: 0.0, expected: 0.0)
    self.assertPositive(py, value: 1.0, expected: 1.0)
    self.assertPositive(py, value: 3.1, expected: 3.1)
    self.assertPositive(py, value: -1.0, expected: -1.0)
    self.assertPositive(py, value: -3.1, expected: -3.1)
  }

  private func assertPositive(_ py: Py,
                              value: Double,
                              expected: Double,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = py.positive(object: valueObject)

    let expectedObject = py.newFloat(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Negative

  func test__neg__() {
    let py = self.createPy()
    self.assertNegative(py, value: 0.0, expected: 0.0)
    self.assertNegative(py, value: 1.0, expected: -1.0)
    self.assertNegative(py, value: 3.1, expected: -3.1)
    self.assertNegative(py, value: -1.0, expected: 1.0)
    self.assertNegative(py, value: -3.1, expected: 3.1)
  }

  private func assertNegative(_ py: Py,
                              value: Double,
                              expected: Double,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = py.negative(object: valueObject)

    let expectedObject = py.newFloat(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Abs

  func test__abs__() {
    let py = self.createPy()
    self.assertAbsolute(py, value: 0.0, expected: 0.0)
    self.assertAbsolute(py, value: 1.0, expected: 1.0)
    self.assertAbsolute(py, value: 3.1, expected: 3.1)
    self.assertAbsolute(py, value: -1.0, expected: 1.0)
    self.assertAbsolute(py, value: -3.1, expected: 3.1)
  }

  private func assertAbsolute(_ py: Py,
                              value: Double,
                              expected: Double,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let valueObject = py.newFloat(value).asObject
    let result = py.absolute(object: valueObject)

    let expectedObject = py.newFloat(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }
}
