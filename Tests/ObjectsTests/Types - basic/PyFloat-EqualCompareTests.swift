import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable function_parameter_count

class PyFloatEqualCompareTests: PyTestCase {

  // MARK: - Equal

  func test__eq__() {
    let py = self.createPy()

    // Equal
    self.assertIsEqual(py, left: 3.1, right: 3.1, expected: true)
    self.assertIsEqual(py, left: -3.1, right: -3.1, expected: true)
    self.assertIsEqual(py, left: 5.7, right: 5.7, expected: true)
    self.assertIsEqual(py, left: -5.7, right: -5.7, expected: true)

    // Different sign
    self.assertIsEqual(py, left: 3.1, right: -3.1, expected: false)
    self.assertIsEqual(py, left: -3.1, right: 3.1, expected: false)
    self.assertIsEqual(py, left: 5.7, right: -5.7, expected: false)
    self.assertIsEqual(py, left: -5.7, right: 5.7, expected: false)

    // Left is less
    self.assertIsEqual(py, left: 3.1, right: 5.7, expected: false)
    self.assertIsEqual(py, left: -3.1, right: 5.7, expected: false)
    self.assertIsEqual(py, left: -5.7, right: 3.1, expected: false)
    self.assertIsEqual(py, left: -5.7, right: -3.1, expected: false)

    // Left is greater
    self.assertIsEqual(py, left: 3.1, right: -5.7, expected: false)
    self.assertIsEqual(py, left: -3.1, right: -5.7, expected: false)
    self.assertIsEqual(py, left: 5.7, right: 3.1, expected: false)
    self.assertIsEqual(py, left: 5.7, right: -3.1, expected: false)

    let f3 = py.newFloat(3.1).asObject
    let none = py.none.asObject
    self.assertIsEqual(py, left: f3, right: none, expected: false)
    self.assertIsEqual(py, left: none, right: f3, expected: false)
  }

  // MARK: - Not equal

  func test__ne__() {
    let py = self.createPy()

    // Equal
    self.assertIsNotEqual(py, left: 3.1, right: 3.1, expected: false)
    self.assertIsNotEqual(py, left: -3.1, right: -3.1, expected: false)
    self.assertIsNotEqual(py, left: 5.7, right: 5.7, expected: false)
    self.assertIsNotEqual(py, left: -5.7, right: -5.7, expected: false)

    // Different sign
    self.assertIsNotEqual(py, left: 3.1, right: -3.1, expected: true)
    self.assertIsNotEqual(py, left: -3.1, right: 3.1, expected: true)
    self.assertIsNotEqual(py, left: 5.7, right: -5.7, expected: true)
    self.assertIsNotEqual(py, left: -5.7, right: 5.7, expected: true)

    // Left is less
    self.assertIsNotEqual(py, left: 3.1, right: 5.7, expected: true)
    self.assertIsNotEqual(py, left: -3.1, right: 5.7, expected: true)
    self.assertIsNotEqual(py, left: -5.7, right: 3.1, expected: true)
    self.assertIsNotEqual(py, left: -5.7, right: -3.1, expected: true)

    // Left is greater
    self.assertIsNotEqual(py, left: 3.1, right: -5.7, expected: true)
    self.assertIsNotEqual(py, left: -3.1, right: -5.7, expected: true)
    self.assertIsNotEqual(py, left: 5.7, right: 3.1, expected: true)
    self.assertIsNotEqual(py, left: 5.7, right: -3.1, expected: true)

    let f3 = py.newFloat(3.1).asObject
    let none = py.none.asObject
    self.assertIsNotEqual(py, left: f3, right: none)
    self.assertIsNotEqual(py, left: none, right: f3)
  }

  // MARK: - Less

  func test__lt__() {
    let py = self.createPy()

    // Equal
    self.assertIsLess(py, left: 3.1, right: 3.1, expected: false)
    self.assertIsLess(py, left: -3.1, right: -3.1, expected: false)
    self.assertIsLess(py, left: 5.7, right: 5.7, expected: false)
    self.assertIsLess(py, left: -5.7, right: -5.7, expected: false)

    // Different sign
    self.assertIsLess(py, left: 3.1, right: -3.1, expected: false)
    self.assertIsLess(py, left: -3.1, right: 3.1, expected: true)
    self.assertIsLess(py, left: 5.7, right: -5.7, expected: false)
    self.assertIsLess(py, left: -5.7, right: 5.7, expected: true)

    // Left is less
    self.assertIsLess(py, left: 3.1, right: 5.7, expected: true)
    self.assertIsLess(py, left: -3.1, right: 5.7, expected: true)
    self.assertIsLess(py, left: -5.7, right: 3.1, expected: true)
    self.assertIsLess(py, left: -5.7, right: -3.1, expected: true)

    // Left is greater
    self.assertIsLess(py, left: 3.1, right: -5.7, expected: false)
    self.assertIsLess(py, left: -3.1, right: -5.7, expected: false)
    self.assertIsLess(py, left: 5.7, right: 3.1, expected: false)
    self.assertIsLess(py, left: 5.7, right: -3.1, expected: false)

    let messageR = "'<' not supported between instances of 'float' and 'NoneType'"
    self.assertIsLessTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertIsLessTypeError(py, left: 5.7, right: .none, message: messageR)

    let messageL = "'<' not supported between instances of 'NoneType' and 'float'"
    self.assertIsLessTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertIsLessTypeError(py, left: .none, right: 5.7, message: messageL)
  }

  // MARK: - Less equal

  func test__le__() {
    let py = self.createPy()

    // Equal
    self.assertIsLessEqual(py, left: 3.1, right: 3.1, expected: true)
    self.assertIsLessEqual(py, left: -3.1, right: -3.1, expected: true)
    self.assertIsLessEqual(py, left: 5.7, right: 5.7, expected: true)
    self.assertIsLessEqual(py, left: -5.7, right: -5.7, expected: true)

    // Different sign
    self.assertIsLessEqual(py, left: 3.1, right: -3.1, expected: false)
    self.assertIsLessEqual(py, left: -3.1, right: 3.1, expected: true)
    self.assertIsLessEqual(py, left: 5.7, right: -5.7, expected: false)
    self.assertIsLessEqual(py, left: -5.7, right: 5.7, expected: true)

    // Left is less
    self.assertIsLessEqual(py, left: 3.1, right: 5.7, expected: true)
    self.assertIsLessEqual(py, left: -3.1, right: 5.7, expected: true)
    self.assertIsLessEqual(py, left: -5.7, right: 3.1, expected: true)
    self.assertIsLessEqual(py, left: -5.7, right: -3.1, expected: true)

    // Left is greater
    self.assertIsLessEqual(py, left: 3.1, right: -5.7, expected: false)
    self.assertIsLessEqual(py, left: -3.1, right: -5.7, expected: false)
    self.assertIsLessEqual(py, left: 5.7, right: 3.1, expected: false)
    self.assertIsLessEqual(py, left: 5.7, right: -3.1, expected: false)

    let messageR = "'<=' not supported between instances of 'float' and 'NoneType'"
    self.assertIsLessEqualTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertIsLessEqualTypeError(py, left: 5.7, right: .none, message: messageR)

    let messageL = "'<=' not supported between instances of 'NoneType' and 'float'"
    self.assertIsLessEqualTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertIsLessEqualTypeError(py, left: .none, right: 5.7, message: messageL)
  }

  // MARK: - Greater

  func test__gt__() {
    let py = self.createPy()

    // Equal
    self.assertIsGreater(py, left: 3.1, right: 3.1, expected: false)
    self.assertIsGreater(py, left: -3.1, right: -3.1, expected: false)
    self.assertIsGreater(py, left: 5.7, right: 5.7, expected: false)
    self.assertIsGreater(py, left: -5.7, right: -5.7, expected: false)

    // Different sign
    self.assertIsGreater(py, left: 3.1, right: -3.1, expected: true)
    self.assertIsGreater(py, left: -3.1, right: 3.1, expected: false)
    self.assertIsGreater(py, left: 5.7, right: -5.7, expected: true)
    self.assertIsGreater(py, left: -5.7, right: 5.7, expected: false)

    // Left is less
    self.assertIsGreater(py, left: 3.1, right: 5.7, expected: false)
    self.assertIsGreater(py, left: -3.1, right: 5.7, expected: false)
    self.assertIsGreater(py, left: -5.7, right: 3.1, expected: false)
    self.assertIsGreater(py, left: -5.7, right: -3.1, expected: false)

    // Left is greater
    self.assertIsGreater(py, left: 3.1, right: -5.7, expected: true)
    self.assertIsGreater(py, left: -3.1, right: -5.7, expected: true)
    self.assertIsGreater(py, left: 5.7, right: 3.1, expected: true)
    self.assertIsGreater(py, left: 5.7, right: -3.1, expected: true)

    let messageR = "'>' not supported between instances of 'float' and 'NoneType'"
    self.assertIsGreaterTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertIsGreaterTypeError(py, left: 5.7, right: .none, message: messageR)

    let messageL = "'>' not supported between instances of 'NoneType' and 'float'"
    self.assertIsGreaterTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertIsGreaterTypeError(py, left: .none, right: 5.7, message: messageL)
  }

  // MARK: - Greater equal

  func test__ge__() {
    let py = self.createPy()

    // Equal
    self.assertIsGreaterEqual(py, left: 3.1, right: 3.1, expected: true)
    self.assertIsGreaterEqual(py, left: -3.1, right: -3.1, expected: true)
    self.assertIsGreaterEqual(py, left: 5.7, right: 5.7, expected: true)
    self.assertIsGreaterEqual(py, left: -5.7, right: -5.7, expected: true)

    // Different sign
    self.assertIsGreaterEqual(py, left: 3.1, right: -3.1, expected: true)
    self.assertIsGreaterEqual(py, left: -3.1, right: 3.1, expected: false)
    self.assertIsGreaterEqual(py, left: 5.7, right: -5.7, expected: true)
    self.assertIsGreaterEqual(py, left: -5.7, right: 5.7, expected: false)

    // Left is less
    self.assertIsGreaterEqual(py, left: 3.1, right: 5.7, expected: false)
    self.assertIsGreaterEqual(py, left: -3.1, right: 5.7, expected: false)
    self.assertIsGreaterEqual(py, left: -5.7, right: 3.1, expected: false)
    self.assertIsGreaterEqual(py, left: -5.7, right: -3.1, expected: false)

    // Left is greater
    self.assertIsGreaterEqual(py, left: 3.1, right: -5.7, expected: true)
    self.assertIsGreaterEqual(py, left: -3.1, right: -5.7, expected: true)
    self.assertIsGreaterEqual(py, left: 5.7, right: 3.1, expected: true)
    self.assertIsGreaterEqual(py, left: 5.7, right: -3.1, expected: true)

    let messageR = "'>=' not supported between instances of 'float' and 'NoneType'"
    self.assertIsGreaterEqualTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertIsGreaterEqualTypeError(py, left: 5.7, right: .none, message: messageR)

    let messageL = "'>=' not supported between instances of 'NoneType' and 'float'"
    self.assertIsGreaterEqualTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertIsGreaterEqualTypeError(py, left: .none, right: 5.7, message: messageL)
  }

  // MARK: - Helpers

  // swiftlint:disable line_length

  private func assertIsEqual(_ py: Py, left: Double, right: Double, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertCompareOperation(py, left: left, right: right, expected: expected, fn: Py.isEqual, file: file, line: line)
  }

  private func assertIsNotEqual(_ py: Py, left: Double, right: Double, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertCompareOperation(py, left: left, right: right, expected: expected, fn: Py.isNotEqual, file: file, line: line)
  }

  private func assertIsLess(_ py: Py, left: Double, right: Double, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertCompareOperation(py, left: left, right: right, expected: expected, fn: Py.isLess, file: file, line: line)
  }

  private func assertIsLessTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.isLess, file: file, line: line)
  }

  private func assertIsLessEqual(_ py: Py, left: Double, right: Double, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertCompareOperation(py, left: left, right: right, expected: expected, fn: Py.isLessEqual, file: file, line: line)
  }

  private func assertIsLessEqualTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.isLessEqual, file: file, line: line)
  }

  private func assertIsGreater(_ py: Py, left: Double, right: Double, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertCompareOperation(py, left: left, right: right, expected: expected, fn: Py.isGreater, file: file, line: line)
  }

  private func assertIsGreaterTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.isGreater, file: file, line: line)
  }

  private func assertIsGreaterEqual(_ py: Py, left: Double, right: Double, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertCompareOperation(py, left: left, right: right, expected: expected, fn: Py.isGreaterEqual, file: file, line: line)
  }

  private func assertIsGreaterEqualTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.isGreaterEqual, file: file, line: line)
  }

  // swiftlint:enable line_length

  typealias BinaryOperation = (Py) -> (PyObject, PyObject) -> PyResult

  func assertCompareOperation(_ py: Py,
                              left: Double,
                              right: Double,
                              expected: Bool,
                              fn: BinaryOperation,
                              file: StaticString,
                              line: UInt) {
    let leftObject = py.newFloat(left).asObject
    let rightObject = py.newFloat(right).asObject
    let result = fn(py)(leftObject, rightObject)

    let expectedObject = py.newBool(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  func assertBinaryOperationTypeError(_ py: Py,
                                      left: Double?,
                                      right: Double?,
                                      message: String,
                                      fn: BinaryOperation,
                                      file: StaticString,
                                      line: UInt) {
    let leftObject = left.map { py.newFloat($0).asObject } ?? py.none.asObject
    let rightObject = right.map { py.newFloat($0).asObject } ?? py.none.asObject

    let result = fn(py)(leftObject, rightObject)
    self.assertTypeError(py, error: result, message: message, file: file, line: line)
  }
}
