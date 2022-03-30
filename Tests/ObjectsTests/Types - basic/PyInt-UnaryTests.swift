import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyIntUnaryTests: PyTestCase {

  // MARK: - Bool

  func test__bool__() {
    let py = self.createPy()
    self.assertBool(py, value: 0, expected: false)
    self.assertBool(py, value: 1, expected: true)
    self.assertBool(py, value: 5, expected: true)
    self.assertBool(py, value: -1, expected: true)
    self.assertBool(py, value: -5, expected: true)
  }

  private func assertBool(_ py: Py,
                          value: Int,
                          expected: Bool,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    self.assertIsTrue(py, object: valueObject, expected: expected, file: file, line: line)
  }

  // MARK: - Real

  func test_real() {
    let py = self.createPy()
    self.assertReal(py, value: 0)
    self.assertReal(py, value: 1)
    self.assertReal(py, value: 5)
    self.assertReal(py, value: -1)
    self.assertReal(py, value: -5)
  }

  private func assertReal(_ py: Py,
                          value: Int,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    let result = self.get(py, object: valueObject, propertyName: "real")
    self.assertIsEqual(py, left: result, right: valueObject, file: file, line: line)
  }

  func test_imag() {
    let py = self.createPy()
    self.assertImag(py, value: 0)
    self.assertImag(py, value: 1)
    self.assertImag(py, value: 5)
    self.assertImag(py, value: -1)
    self.assertImag(py, value: -5)
  }

  // MARK: - Imag

  private func assertImag(_ py: Py,
                          value: Int,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    let result = self.get(py, object: valueObject, propertyName: "imag")

    let expectedObject = py.newInt(0)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Conjugate

  func test_conjugate() {
    let py = self.createPy()
    self.assertConjugate(py, value: 0)
    self.assertConjugate(py, value: 1)
    self.assertConjugate(py, value: 5)
    self.assertConjugate(py, value: -1)
    self.assertConjugate(py, value: -5)
  }

  private func assertConjugate(_ py: Py,
                               value: Int,
                               file: StaticString = #file,
                               line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    let result = self.callMethod(py, object: valueObject, selector: "conjugate", args: [])
    self.assertIsEqual(py, left: result, right: valueObject, file: file, line: line)
  }

  // MARK: - Positive

  func test__pos__() {
    let py = self.createPy()
    self.assertPositive(py, value: 0, expected: 0)
    self.assertPositive(py, value: 1, expected: 1)
    self.assertPositive(py, value: 3, expected: 3)
    self.assertPositive(py, value: -1, expected: -1)
    self.assertPositive(py, value: -3, expected: -3)
  }

  private func assertPositive(_ py: Py,
                              value: Int,
                              expected: Int,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    let result = py.positive(object: valueObject)

    let expectedObject = py.newInt(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Negative

  func test__neg__() {
    let py = self.createPy()
    self.assertNegative(py, value: 0, expected: 0)
    self.assertNegative(py, value: 1, expected: -1)
    self.assertNegative(py, value: 3, expected: -3)
    self.assertNegative(py, value: -1, expected: 1)
    self.assertNegative(py, value: -3, expected: 3)
  }

  private func assertNegative(_ py: Py,
                              value: Int,
                              expected: Int,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    let result = py.negative(object: valueObject)

    let expectedObject = py.newInt(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Abs

  func test__abs__() {
    let py = self.createPy()
    self.assertAbsolute(py, value: 0, expected: 0)
    self.assertAbsolute(py, value: 1, expected: 1)
    self.assertAbsolute(py, value: 3, expected: 3)
    self.assertAbsolute(py, value: -1, expected: 1)
    self.assertAbsolute(py, value: -3, expected: 3)
  }

  private func assertAbsolute(_ py: Py,
                              value: Int,
                              expected: Int,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let valueObject = py.newInt(value).asObject
    let result = py.absolute(object: valueObject)

    let expectedObject = py.newInt(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }
}
