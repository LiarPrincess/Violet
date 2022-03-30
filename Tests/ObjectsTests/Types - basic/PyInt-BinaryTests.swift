import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable function_parameter_count

class PyIntBinaryTests: PyTestCase {

  // MARK: - Add

  func test__add__() {
    let py = self.createPy()

    self.assertAdd(py, left: 3, right: 7, expected: 10)
    self.assertAdd(py, left: 3, right: -7, expected: -4)
    self.assertAdd(py, left: -3, right: 7, expected: 4)
    self.assertAdd(py, left: -3, right: -7, expected: -10)

    self.assertAdd(py, left: 7, right: 3, expected: 10)
    self.assertAdd(py, left: 7, right: -3, expected: 4)
    self.assertAdd(py, left: -7, right: 3, expected: -4)
    self.assertAdd(py, left: -7, right: -3, expected: -10)

    let messageR = "unsupported operand type(s) for +: 'int' and 'NoneType'"
    self.assertAddTypeError(py, left: 3, right: .none, message: messageR)
    self.assertAddTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for +: 'NoneType' and 'int'"
    self.assertAddTypeError(py, left: .none, right: 3, message: messageL)
    self.assertAddTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Sub

  func test__sub__() {
    let py = self.createPy()

    self.assertSub(py, left: 3, right: 7, expected: -4)
    self.assertSub(py, left: 3, right: -7, expected: 10)
    self.assertSub(py, left: -3, right: 7, expected: -10)
    self.assertSub(py, left: -3, right: -7, expected: 4)

    self.assertSub(py, left: 7, right: 3, expected: 4)
    self.assertSub(py, left: 7, right: -3, expected: 10)
    self.assertSub(py, left: -7, right: 3, expected: -10)
    self.assertSub(py, left: -7, right: -3, expected: -4)

    let messageR = "unsupported operand type(s) for -: 'int' and 'NoneType'"
    self.assertSubTypeError(py, left: 3, right: .none, message: messageR)
    self.assertSubTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for -: 'NoneType' and 'int'"
    self.assertSubTypeError(py, left: .none, right: 3, message: messageL)
    self.assertSubTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Mul

  func test__mul__() {
    let py = self.createPy()

    self.assertMul(py, left: 3, right: 7, expected: 21)
    self.assertMul(py, left: 3, right: -7, expected: -21)
    self.assertMul(py, left: -3, right: 7, expected: -21)
    self.assertMul(py, left: -3, right: -7, expected: 21)

    self.assertMul(py, left: 7, right: 3, expected: 21)
    self.assertMul(py, left: 7, right: -3, expected: -21)
    self.assertMul(py, left: -7, right: 3, expected: -21)
    self.assertMul(py, left: -7, right: -3, expected: 21)

    let messageR = "unsupported operand type(s) for *: 'int' and 'NoneType'"
    self.assertMulTypeError(py, left: 3, right: .none, message: messageR)
    self.assertMulTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for *: 'NoneType' and 'int'"
    self.assertMulTypeError(py, left: .none, right: 3, message: messageL)
    self.assertMulTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Truediv

  func test__truediv__() {
    let py = self.createPy()

    self.assertTrueDiv(py, left: 3, right: 7, expected: 3.0 / 7.0)
    self.assertTrueDiv(py, left: -3, right: 7, expected: -3.0 / 7.0)
    self.assertTrueDiv(py, left: 3, right: -7, expected: 3.0 / -7.0)
    self.assertTrueDiv(py, left: -3, right: -7, expected: -3.0 / -7.0)

    self.assertTrueDiv(py, left: 7, right: 3, expected: 7.0 / 3.0)
    self.assertTrueDiv(py, left: -7, right: 3, expected: -7.0 / 3.0)
    self.assertTrueDiv(py, left: 7, right: -3, expected: 7.0 / -3.0)
    self.assertTrueDiv(py, left: -7, right: -3, expected: -7.0 / -3.0)

    let messageR = "unsupported operand type(s) for /: 'int' and 'NoneType'"
    self.assertTrueDivTypeError(py, left: 3, right: .none, message: messageR)
    self.assertTrueDivTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for /: 'NoneType' and 'int'"
    self.assertTrueDivTypeError(py, left: .none, right: 3, message: messageL)
    self.assertTrueDivTypeError(py, left: .none, right: 7, message: messageL)
  }

  private func assertTrueDiv(_ py: Py,
                             left: Int,
                             right: Int,
                             expected: Double,
                             file: StaticString = #file,
                             line: UInt = #line) {
    let leftObject = py.newInt(left).asObject
    let rightObject = py.newInt(right).asObject
    let result = py.trueDiv(left: leftObject, right: rightObject)

    let expectedObject = py.newFloat(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Floordiv

  func test__floordiv__() {
    let py = self.createPy()

    self.assertFloorDiv(py, left: 3, right: 7, expected: 0)
    self.assertFloorDiv(py, left: -3, right: 7, expected: -1)
    self.assertFloorDiv(py, left: 3, right: -7, expected: -1)
    self.assertFloorDiv(py, left: -3, right: -7, expected: 0)

    self.assertFloorDiv(py, left: 7, right: 3, expected: 2)
    self.assertFloorDiv(py, left: -7, right: 3, expected: -3)
    self.assertFloorDiv(py, left: 7, right: -3, expected: -3)
    self.assertFloorDiv(py, left: -7, right: -3, expected: 2)

    let messageR = "unsupported operand type(s) for //: 'int' and 'NoneType'"
    self.assertFloorDivTypeError(py, left: 3, right: .none, message: messageR)
    self.assertFloorDivTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for //: 'NoneType' and 'int'"
    self.assertFloorDivTypeError(py, left: .none, right: 3, message: messageL)
    self.assertFloorDivTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Mod

  func test__mod__() {
    let py = self.createPy()

    self.assertMod(py, left: 3, right: 7, expected: 3)
    self.assertMod(py, left: -3, right: 7, expected: 4)
    self.assertMod(py, left: 3, right: -7, expected: -4)
    self.assertMod(py, left: -3, right: -7, expected: -3)

    self.assertMod(py, left: 7, right: 3, expected: 1)
    self.assertMod(py, left: -7, right: 3, expected: 2)
    self.assertMod(py, left: 7, right: -3, expected: -2)
    self.assertMod(py, left: -7, right: -3, expected: -1)

    let messageR = "unsupported operand type(s) for %: 'int' and 'NoneType'"
    self.assertModTypeError(py, left: 3, right: .none, message: messageR)
    self.assertModTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for %: 'NoneType' and 'int'"
    self.assertModTypeError(py, left: .none, right: 3, message: messageL)
    self.assertModTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Divmod

  func test__divmod__() {
    let py = self.createPy()

    self.assertDivMod(py, left: 3, right: 7, div: 0, mod: 3)
    self.assertDivMod(py, left: -3, right: 7, div: -1, mod: 4)
    self.assertDivMod(py, left: 3, right: -7, div: -1, mod: -4)
    self.assertDivMod(py, left: -3, right: -7, div: 0, mod: -3)

    self.assertDivMod(py, left: 7, right: 3, div: 2, mod: 1)
    self.assertDivMod(py, left: -7, right: 3, div: -3, mod: 2)
    self.assertDivMod(py, left: 7, right: -3, div: -3, mod: -2)
    self.assertDivMod(py, left: -7, right: -3, div: 2, mod: -1)

    let messageR = "unsupported operand type(s) for divmod(): 'int' and 'NoneType'"
    self.assertDivModTypeError(py, left: 3, right: .none, message: messageR)
    self.assertDivModTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for divmod(): 'NoneType' and 'int'"
    self.assertDivModTypeError(py, left: .none, right: 3, message: messageL)
    self.assertDivModTypeError(py, left: .none, right: 7, message: messageL)
  }

  private func assertDivMod(_ py: Py,
                            left: Int,
                            right: Int,
                            div: Int,
                            mod: Int,
                            file: StaticString = #file,
                            line: UInt = #line) {
    let leftObject = py.newInt(left).asObject
    let rightObject = py.newInt(right).asObject
    let result = py.divMod(left: leftObject, right: rightObject)

    let divObject = py.newInt(div).asObject
    let modObject = py.newInt(mod).asObject
    let tuple = py.newTuple(elements: divObject, modObject)
    self.assertIsEqual(py, left: result, right: tuple, file: file, line: line)
  }

  // MARK: - Shifts

  func test__lshift__() {
    let py = self.createPy()

    self.assertLshift(py, left: 3, right: 7, expected: 384)
    self.assertLshift(py, left: 7, right: 3, expected: 56)

    let messageR = "unsupported operand type(s) for <<: 'int' and 'NoneType'"
    self.assertLshiftTypeError(py, left: 3, right: .none, message: messageR)
    self.assertLshiftTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for <<: 'NoneType' and 'int'"
    self.assertLshiftTypeError(py, left: .none, right: 3, message: messageL)
    self.assertLshiftTypeError(py, left: .none, right: 7, message: messageL)
  }

  func test__rshift__() {
    let py = self.createPy()

    self.assertRshift(py, left: 3, right: 103, expected: 0)
    self.assertRshift(py, left: 103, right: 3, expected: 12)

    let messageR = "unsupported operand type(s) for >>: 'int' and 'NoneType'"
    self.assertRshiftTypeError(py, left: 3, right: .none, message: messageR)
    self.assertRshiftTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for >>: 'NoneType' and 'int'"
    self.assertRshiftTypeError(py, left: .none, right: 3, message: messageL)
    self.assertRshiftTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - And

  func test__and__() {
    let py = self.createPy()

    //  5 = 0b0101
    // 12 = 0b1100
    self.assertAnd(py, left: 12, right: 5, expected: 4)
    self.assertAnd(py, left: 5, right: 12, expected: 4)

    let messageR = "unsupported operand type(s) for &: 'int' and 'NoneType'"
    self.assertAndTypeError(py, left: 3, right: .none, message: messageR)
    self.assertAndTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for &: 'NoneType' and 'int'"
    self.assertAndTypeError(py, left: .none, right: 3, message: messageL)
    self.assertAndTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Or

  func test__or__() {
    let py = self.createPy()

    //  5 = 0b0101
    // 12 = 0b1100
    self.assertOr(py, left: 12, right: 5, expected: 13)
    self.assertOr(py, left: 5, right: 12, expected: 13)

    let messageR = "unsupported operand type(s) for |: 'int' and 'NoneType'"
    self.assertOrTypeError(py, left: 3, right: .none, message: messageR)
    self.assertOrTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for |: 'NoneType' and 'int'"
    self.assertOrTypeError(py, left: .none, right: 3, message: messageL)
    self.assertOrTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Xor

  func test__xor__() {
    let py = self.createPy()

    //  5 = 0b0101
    // 12 = 0b1100
    self.assertXor(py, left: 12, right: 5, expected: 9)
    self.assertXor(py, left: 5, right: 12, expected: 9)

    let messageR = "unsupported operand type(s) for ^: 'int' and 'NoneType'"
    self.assertXorTypeError(py, left: 3, right: .none, message: messageR)
    self.assertXorTypeError(py, left: 7, right: .none, message: messageR)

    let messageL = "unsupported operand type(s) for ^: 'NoneType' and 'int'"
    self.assertXorTypeError(py, left: .none, right: 3, message: messageL)
    self.assertXorTypeError(py, left: .none, right: 7, message: messageL)
  }

  // MARK: - Helpers

  // swiftlint:disable line_length

  private func assertAdd(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.add, file: file, line: line)
  }

  private func assertAddTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.add, file: file, line: line)
  }

  private func assertSub(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.sub, file: file, line: line)
  }

  private func assertSubTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.sub, file: file, line: line)
  }

  private func assertMul(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.mul, file: file, line: line)
  }

  private func assertMulTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.mul, file: file, line: line)
  }

  private func assertTrueDivTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.trueDiv, file: file, line: line)
  }

  private func assertFloorDiv(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.floorDiv, file: file, line: line)
  }

  private func assertFloorDivTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.floorDiv, file: file, line: line)
  }

  private func assertMod(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.mod, file: file, line: line)
  }

  private func assertModTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.mod, file: file, line: line)
  }

  private func assertDivModTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.divMod, file: file, line: line)
  }

  private func assertLshift(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.lshift, file: file, line: line)
  }

  private func assertLshiftTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.lshift, file: file, line: line)
  }

  private func assertRshift(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.rshift, file: file, line: line)
  }

  private func assertRshiftTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.rshift, file: file, line: line)
  }

  private func assertAnd(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.and, file: file, line: line)
  }

  private func assertAndTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.and, file: file, line: line)
  }

  private func assertOr(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.or, file: file, line: line)
  }

  private func assertOrTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.or, file: file, line: line)
  }

  private func assertXor(_ py: Py, left: Int, right: Int, expected: Int, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperation(py, left: left, right: right, expected: expected, fn: Py.xor, file: file, line: line)
  }

  private func assertXorTypeError(_ py: Py, left: Int?, right: Int?, message: String, file: StaticString = #file, line: UInt = #line) {
    self.assertBinaryOperationTypeError(py, left: left, right: right, message: message, fn: Py.xor, file: file, line: line)
  }

  // swiftlint:enable line_length

  typealias BinaryOperation = (Py) -> (PyObject, PyObject) -> PyResult

  func assertBinaryOperation(_ py: Py,
                             left: Int,
                             right: Int,
                             expected: Int,
                             fn: BinaryOperation,
                             file: StaticString,
                             line: UInt) {
    let leftObject = py.newInt(left).asObject
    let rightObject = py.newInt(right).asObject
    let result = fn(py)(leftObject, rightObject)

    let expectedObject = py.newInt(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  func assertBinaryOperationTypeError(_ py: Py,
                                      left: Int?,
                                      right: Int?,
                                      message: String,
                                      fn: BinaryOperation,
                                      file: StaticString,
                                      line: UInt) {
    let leftObject = left.map { py.newInt($0).asObject } ?? py.none.asObject
    let rightObject = right.map { py.newInt($0).asObject } ?? py.none.asObject

    let result = fn(py)(leftObject, rightObject)
    self.assertTypeError(py, error: result, message: message, file: file, line: line)
  }
}
