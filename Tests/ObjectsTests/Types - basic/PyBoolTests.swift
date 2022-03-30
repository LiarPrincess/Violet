import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable function_parameter_count
// swiftlint:disable discouraged_optional_boolean

class PyBoolTests: PyTestCase {

  // MARK: - Description

  func test_description() {
    let py = self.createPy()
    self.assertDescription(py.true, "PyBool(bool, value: 1, isTrue: true)")
    self.assertDescription(py.false, "PyBool(bool, value: 0, isTrue: false)")
  }

  // MARK: - Repr, str

  func test__repr__() {
    let py = self.createPy()
    self.assertRepr(py, object: py.true, expected: "True")
    self.assertRepr(py, object: py.false, expected: "False")
  }

  func test__str__() {
    let py = self.createPy()
    self.assertStr(py, object: py.true, expected: "True")
    self.assertStr(py, object: py.false, expected: "False")
  }

  // MARK: - And

  func test__and__() {
    let py = self.createPy()

    self.assertAnd(py, left: true, right: true, expected: true)
    self.assertAnd(py, left: true, right: false, expected: false)
    self.assertAnd(py, left: false, right: true, expected: false)
    self.assertAnd(py, left: false, right: false, expected: false)

    let messageR = "unsupported operand type(s) for &: 'bool' and 'NoneType'"
    self.assertAndTypeError(py, left: true, right: .none, message: messageR)
    self.assertAndTypeError(py, left: false, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for &: 'NoneType' and 'bool'"
    self.assertAndTypeError(py, left: .none, right: true, message: messageL)
    self.assertAndTypeError(py, left: .none, right: false, message: messageL)
  }

  // MARK: - Or

  func test__or__() {
    let py = self.createPy()

    self.assertOr(py, left: true, right: true, expected: true)
    self.assertOr(py, left: true, right: false, expected: true)
    self.assertOr(py, left: false, right: true, expected: true)
    self.assertOr(py, left: false, right: false, expected: false)

    let messageR = "unsupported operand type(s) for |: 'bool' and 'NoneType'"
    self.assertOrTypeError(py, left: true, right: .none, message: messageR)
    self.assertOrTypeError(py, left: false, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for |: 'NoneType' and 'bool'"
    self.assertOrTypeError(py, left: .none, right: true, message: messageL)
    self.assertOrTypeError(py, left: .none, right: false, message: messageL)
  }

  // MARK: - Xor

  func test__xor__() {
    let py = self.createPy()

    self.assertXor(py, left: true, right: true, expected: false)
    self.assertXor(py, left: true, right: false, expected: true)
    self.assertXor(py, left: false, right: true, expected: true)
    self.assertXor(py, left: false, right: false, expected: false)

    let messageR = "unsupported operand type(s) for ^: 'bool' and 'NoneType'"
    self.assertXorTypeError(py, left: true, right: .none, message: messageR)
    self.assertXorTypeError(py, left: false, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for ^: 'NoneType' and 'bool'"
    self.assertXorTypeError(py, left: .none, right: true, message: messageL)
    self.assertXorTypeError(py, left: .none, right: false, message: messageL)
  }

  // MARK: - Helpers

  // swiftlint:disable line_length
  private func assertAnd(_ py: Py, left: Bool, right: Bool, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.and, file: file, line: line)
  }

  private func assertAndTypeError(_ py: Py, left: Bool?, right: Bool?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.and, file: file, line: line)
  }

  private func assertOr(_ py: Py, left: Bool, right: Bool, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.or, file: file, line: line)
  }

  private func assertOrTypeError(_ py: Py, left: Bool?, right: Bool?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.or, file: file, line: line)
  }

  private func assertXor(_ py: Py, left: Bool, right: Bool, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.xor, file: file, line: line)
  }

  private func assertXorTypeError(_ py: Py, left: Bool?, right: Bool?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.xor, file: file, line: line)
  }

  // swiftlint:enable line_length

  private typealias BinaryOperation = (Py) -> (PyObject, PyObject) -> PyResult

  private func assertBinaryOperation(_ py: Py,
                                     left: Bool,
                                     right: Bool,
                                     expected: Bool,
                                     fn: BinaryOperation,
                                     file: StaticString,
                                     line: UInt) {
    let leftObject = py.newBool(left).asObject
    let rightObject = py.newBool(right).asObject
    let result = fn(py)(leftObject, rightObject)

    let expectedObject = py.newBool(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  private func assertBinaryOperationTypeError(_ py: Py,
                                              left: Bool?,
                                              right: Bool?,
                                              message: String,
                                              fn: BinaryOperation,
                                              file: StaticString,
                                              line: UInt) {
    let leftObject = left.map { py.newBool($0).asObject } ?? py.none.asObject
    let rightObject = right.map { py.newBool($0).asObject } ?? py.none.asObject

    let result = fn(py)(leftObject, rightObject)
    self.assertTypeError(py, error: result, message: message, file: file, line: line)
  }
}
