import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyIntTernaryTests: PyTestCase {

  func test__pow__() {
    let py = self.createPy()

    self.assertPow(py, base: 3, exp: 11, mod: .none, expected: 177_147)
    self.assertPow(py, base: 3, exp: -11, mod: .none, expected: 5.645_029_269_476_762e-06)
    self.assertPow(py, base: -3, exp: 11, mod: .none, expected: -177_147)
    self.assertPow(py, base: -3, exp: -11, mod: .none, expected: -5.645_029_269_476_762e-06)

    self.assertPow(py, base: 11, exp: 3, mod: .none, expected: 1_331)
    self.assertPow(py, base: 11, exp: -3, mod: .none, expected: 0.0_007_513_148_009_015_778)
    self.assertPow(py, base: -11, exp: 3, mod: .none, expected: -1_331)
    self.assertPow(py, base: -11, exp: -3, mod: .none, expected: -0.0_007_513_148_009_015_778)

    let messageE = "unsupported operand type(s) for ** or pow(): 'int' and 'NoneType'"
    self.assertPowTypeError(py, base: 3, exp: .none, mod: .none, message: messageE)
    self.assertPowTypeError(py, base: 11, exp: .none, mod: .none, message: messageE)

    let messageB = "unsupported operand type(s) for ** or pow(): 'NoneType' and 'int'"
    self.assertPowTypeError(py, base: .none, exp: 3, mod: .none, message: messageB)
    self.assertPowTypeError(py, base: .none, exp: 11, mod: .none, message: messageB)
  }

  func test__pow__mod() {
    let py = self.createPy()

    // There are only 4 possibilities, because:
    // ValueError: pow() 2nd argument cannot be negative when 3rd argument specified
    self.assertPow(py, base: 3, exp: 11, mod: 7, expected: 5)
    self.assertPow(py, base: 3, exp: 11, mod: -7, expected: -2)
    self.assertPow(py, base: -3, exp: 11, mod: 7, expected: 2)
    self.assertPow(py, base: -3, exp: 11, mod: -7, expected: -5)

    self.assertPow(py, base: 11, exp: 3, mod: 7, expected: 1)
    self.assertPow(py, base: 11, exp: 3, mod: -7, expected: -6)
    self.assertPow(py, base: -11, exp: 3, mod: 7, expected: 6)
    self.assertPow(py, base: -11, exp: 3, mod: -7, expected: -1)

    let i3 = py.newInt(3).asObject
    let i_7 = py.newInt(-7).asObject
    let i27 = py.newInt(27).asObject
    let strA = py.newString("A").asObject

    let strMod = py.pow(base: i3, exp: i27, mod: strA)
    self.assertTypeError(
      py,
      error: strMod,
      message: "unsupported operand type(s) for pow(): 'int', 'int', 'str'"
    )

    let negativeExp = py.pow(base: i3, exp: i_7, mod: i27)
    self.assertValueError(
      py,
      error: negativeExp,
      message: "pow() 2nd argument cannot be negative when 3rd argument specified"
    )
  }

  private func assertPow(_ py: Py,
                         base: Int,
                         exp: Int,
                         mod: Int?,
                         expected: Int,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let baseObject = py.newInt(base).asObject
    let expObject = py.newInt(exp).asObject
    let modObject = mod.map { py.newInt($0).asObject } ?? py.none.asObject
    let result = py.pow(base: baseObject, exp: expObject, mod: modObject)

    let expectedObject = py.newInt(expected).asObject
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  private func assertPow(_ py: Py,
                         base: Int,
                         exp: Int,
                         mod: Int?,
                         expected: Double,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let baseObject = py.newInt(base).asObject
    let expObject = py.newInt(exp).asObject
    let modObject = mod.map { py.newInt($0).asObject } ?? py.none.asObject
    let result = py.pow(base: baseObject, exp: expObject, mod: modObject)

    let expectedObject = py.newFloat(expected).asObject
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  private func assertPowTypeError(_ py: Py,
                                  base: Int?,
                                  exp: Int?,
                                  mod: Int?,
                                  message: String,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let baseObject = base.map { py.newInt($0).asObject } ?? py.none.asObject
    let expObject = exp.map { py.newInt($0).asObject } ?? py.none.asObject
    let modObject = mod.map { py.newInt($0).asObject } ?? py.none.asObject

    let result = py.pow(base: baseObject, exp: expObject, mod: modObject)
    self.assertTypeError(py, error: result, message: message, file: file, line: line)
  }
}
