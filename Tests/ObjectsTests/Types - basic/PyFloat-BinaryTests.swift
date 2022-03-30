import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable function_parameter_count

class PyFloatBinaryTests: PyTestCase {

  // MARK: - Add, sub, mul

  func test__add__() {
    let py = self.createPy()

    self.assertAdd(py, left: 3.1, right: 7.5, expected: 10.6)
    self.assertAdd(py, left: 3.1, right: -7.5, expected: -4.4)
    self.assertAdd(py, left: -3.1, right: 7.5, expected: 4.4)
    self.assertAdd(py, left: -3.1, right: -7.5, expected: -10.6)

    self.assertAdd(py, left: 7.5, right: 3.1, expected: 10.6)
    self.assertAdd(py, left: 7.5, right: -3.1, expected: 4.4)
    self.assertAdd(py, left: -7.5, right: 3.1, expected: -4.4)
    self.assertAdd(py, left: -7.5, right: -3.1, expected: -10.6)

    let messageR = "unsupported operand type(s) for +: 'float' and 'NoneType'"
    self.assertAddTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertAddTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for +: 'NoneType' and 'float'"
    self.assertAddTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertAddTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  func test__sub__() {
    let py = self.createPy()

    self.assertSub(py, left: 3.1, right: 7.5, expected: -4.4)
    self.assertSub(py, left: 3.1, right: -7.5, expected: 10.6)
    self.assertSub(py, left: -3.1, right: 7.5, expected: -10.6)
    self.assertSub(py, left: -3.1, right: -7.5, expected: 4.4)

    self.assertSub(py, left: 7.5, right: 3.1, expected: 4.4)
    self.assertSub(py, left: 7.5, right: -3.1, expected: 10.6)
    self.assertSub(py, left: -7.5, right: 3.1, expected: -10.6)
    self.assertSub(py, left: -7.5, right: -3.1, expected: -4.4)

    let messageR = "unsupported operand type(s) for -: 'float' and 'NoneType'"
    self.assertSubTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertSubTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for -: 'NoneType' and 'float'"
    self.assertSubTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertSubTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  func test__mul__() {
    let py = self.createPy()

    self.assertMul(py, left: 3.1, right: 7.5, expected: 23.25)
    self.assertMul(py, left: 3.1, right: -7.5, expected: -23.25)
    self.assertMul(py, left: -3.1, right: 7.5, expected: -23.25)
    self.assertMul(py, left: -3.1, right: -7.5, expected: 23.25)

    self.assertMul(py, left: 7.5, right: 3.1, expected: 23.25)
    self.assertMul(py, left: 7.5, right: -3.1, expected: -23.25)
    self.assertMul(py, left: -7.5, right: 3.1, expected: -23.25)
    self.assertMul(py, left: -7.5, right: -3.1, expected: 23.25)

    let messageR = "unsupported operand type(s) for *: 'float' and 'NoneType'"
    self.assertMulTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertMulTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for *: 'NoneType' and 'float'"
    self.assertMulTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertMulTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  // MARK: - Div

  func test__truediv__() {
    let py = self.createPy()

    self.assertTrueDiv(py, left: 3.1, right: 7.5, expected: 3.1 / 7.5)
    self.assertTrueDiv(py, left: -3.1, right: 7.5, expected: -3.1 / 7.5)
    self.assertTrueDiv(py, left: 3.1, right: -7.5, expected: 3.1 / -7.5)
    self.assertTrueDiv(py, left: -3.1, right: -7.5, expected: -3.1 / -7.5)

    self.assertTrueDiv(py, left: 7.5, right: 3.1, expected: 7.5 / 3.1)
    self.assertTrueDiv(py, left: -7.5, right: 3.1, expected: -7.5 / 3.1)
    self.assertTrueDiv(py, left: 7.5, right: -3.1, expected: 7.5 / -3.1)
    self.assertTrueDiv(py, left: -7.5, right: -3.1, expected: -7.5 / -3.1)

    let messageR = "unsupported operand type(s) for /: 'float' and 'NoneType'"
    self.assertTrueDivTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertTrueDivTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for /: 'NoneType' and 'float'"
    self.assertTrueDivTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertTrueDivTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  func test__floordiv__() {
    let py = self.createPy()

    self.assertFloorDiv(py, left: 3.1, right: 7.5, expected: 0.0)
    self.assertFloorDiv(py, left: -3.1, right: 7.5, expected: -1.0)
    self.assertFloorDiv(py, left: 3.1, right: -7.5, expected: -1.0)
    self.assertFloorDiv(py, left: -3.1, right: -7.5, expected: 0.0)

    self.assertFloorDiv(py, left: 7.5, right: 3.1, expected: 2.0)
    self.assertFloorDiv(py, left: -7.5, right: 3.1, expected: -3.0)
    self.assertFloorDiv(py, left: 7.5, right: -3.1, expected: -3.0)
    self.assertFloorDiv(py, left: -7.5, right: -3.1, expected: 2.0)

    let messageR = "unsupported operand type(s) for //: 'float' and 'NoneType'"
    self.assertFloorDivTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertFloorDivTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for //: 'NoneType' and 'float'"
    self.assertFloorDivTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertFloorDivTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  func test__mod__() {
    let py = self.createPy()

    self.assertMod(py, left: 3.1, right: 7.5, expected: 3.1)
    self.assertMod(py, left: -3.1, right: 7.5, expected: 4.4)
    self.assertMod(py, left: 3.1, right: -7.5, expected: -4.4)
    self.assertMod(py, left: -3.1, right: -7.5, expected: -3.1)

    self.assertMod(py, left: 7.5, right: 3.1, expected: 1.2_999_999_999_999_998)
    self.assertMod(py, left: -7.5, right: 3.1, expected: 1.8_000_000_000_000_003)
    self.assertMod(py, left: 7.5, right: -3.1, expected: -1.8_000_000_000_000_003)
    self.assertMod(py, left: -7.5, right: -3.1, expected: -1.2_999_999_999_999_998)

    let messageR = "unsupported operand type(s) for %: 'float' and 'NoneType'"
    self.assertModTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertModTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for %: 'NoneType' and 'float'"
    self.assertModTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertModTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  func test__divmod__() {
    let py = self.createPy()

    self.assertDivMod(py, left: 3.1, right: 7.5, div: 0.0, mod: 3.1)
    self.assertDivMod(py, left: -3.1, right: 7.5, div: -1.0, mod: 4.4)
    self.assertDivMod(py, left: 3.1, right: -7.5, div: -1.0, mod: -4.4)
    self.assertDivMod(py, left: -3.1, right: -7.5, div: 0.0, mod: -3.1)

    self.assertDivMod(py, left: 7.5, right: 3.1, div: 2.0, mod: 1.2_999_999_999_999_998)
    self.assertDivMod(py, left: -7.5, right: 3.1, div: -3.0, mod: 1.8_000_000_000_000_003)
    self.assertDivMod(py, left: 7.5, right: -3.1, div: -3.0, mod: -1.8_000_000_000_000_003)
    self.assertDivMod(py, left: -7.5, right: -3.1, div: 2.0, mod: -1.2_999_999_999_999_998)

    let messageR = "unsupported operand type(s) for divmod(): 'float' and 'NoneType'"
    self.assertDivModTypeError(py, left: 3.1, right: .none, message: messageR)
    self.assertDivModTypeError(py, left: 7.5, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for divmod(): 'NoneType' and 'float'"
    self.assertDivModTypeError(py, left: .none, right: 3.1, message: messageL)
    self.assertDivModTypeError(py, left: .none, right: 7.5, message: messageL)
  }

  private func assertDivMod(_ py: Py,
                            left: Double,
                            right: Double,
                            div: Double,
                            mod: Double,
                            file: StaticString = #file,
                            line: UInt = #line) {
    let leftObject = py.newFloat(left).asObject
    let rightObject = py.newFloat(right).asObject
    let result = py.divMod(left: leftObject, right: rightObject)

    let divObject = py.newFloat(div).asObject
    let modObject = py.newFloat(mod).asObject
    let tuple = py.newTuple(elements: divObject, modObject)
    self.assertIsEqual(py, left: result, right: tuple, file: file, line: line)
  }

  // MARK: - Helpers

  // swiftlint:disable line_length

  private func assertAdd(_ py: Py, left: Double, right: Double, expected: Double, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.add, file: file, line: line)
  }

  private func assertAddTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.add, file: file, line: line)
  }

  private func assertSub(_ py: Py, left: Double, right: Double, expected: Double, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.sub, file: file, line: line)
  }

  private func assertSubTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.sub, file: file, line: line)
  }

  private func assertMul(_ py: Py, left: Double, right: Double, expected: Double, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.mul, file: file, line: line)
  }

  private func assertMulTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.mul, file: file, line: line)
  }

  private func assertTrueDiv(_ py: Py, left: Double, right: Double, expected: Double, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.trueDiv, file: file, line: line)
  }

  private func assertTrueDivTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.trueDiv, file: file, line: line)
  }

  private func assertFloorDiv(_ py: Py, left: Double, right: Double, expected: Double, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.floorDiv, file: file, line: line)
  }

  private func assertFloorDivTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.floorDiv, file: file, line: line)
  }

  private func assertMod(_ py: Py, left: Double, right: Double, expected: Double, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.mod, file: file, line: line)
  }

  private func assertModTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.mod, file: file, line: line)
  }

  private func assertDivModTypeError(_ py: Py, left: Double?, right: Double?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.divMod, file: file, line: line)
  }

  // swiftlint:enable line_length

  typealias BinaryOperation = (Py) -> (PyObject, PyObject) -> PyResult

  func assertBinaryOperation(_ py: Py,
                             left: Double,
                             right: Double,
                             expected: Double,
                             fn: BinaryOperation,
                             file: StaticString,
                             line: UInt) {
    let leftObject = py.newFloat(left).asObject
    let rightObject = py.newFloat(right).asObject
    let result = fn(py)(leftObject, rightObject)

    let expectedObject = py.newFloat(expected)
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
