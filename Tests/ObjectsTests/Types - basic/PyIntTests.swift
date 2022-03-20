import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyIntTests: PyTestCase {

  // MARK: - Pow

  func test__pow__() {
    let py = self.createPy()

    self.assertPow(py, base: 3, exp: 27, mod: .none, expected: 7_625_597_484_987)
    self.assertPow(py, base: 27, exp: 3, mod: .none, expected: 19683)

    let messageE = "unsupported operand type(s) for ** or pow(): 'int' and 'NoneType'"
    self.assertPowTypeError(py, base: 3, exp: .none, mod: .none, message: messageE)
    self.assertPowTypeError(py, base: 27, exp: .none, mod: .none, message: messageE)

    let messageB = "unsupported operand type(s) for ** or pow(): 'NoneType' and 'int'"
    self.assertPowTypeError(py, base: .none, exp: 3, mod: .none, message: messageB)
    self.assertPowTypeError(py, base: .none, exp: 27, mod: .none, message: messageB)
  }

  func test__pow__mod() {
    let py = self.createPy()

    self.assertPow(py, base: 3, exp: 27, mod: 987, expected: 363)
    self.assertPow(py, base: 27, exp: 3, mod: 987, expected: 930)

    let i3 = py.newInt(3).asObject
    let i27 = py.newInt(27).asObject
    let sA = py.newString("A").asObject

    let intIntStr = py.pow(base: i3, exp: i27, mod: sA)
    self.assertTypeError(
      py,
      error: intIntStr,
      message: "unsupported operand type(s) for pow(): 'int', 'int', 'str'"
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
