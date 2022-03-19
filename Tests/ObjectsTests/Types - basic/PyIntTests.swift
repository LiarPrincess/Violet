import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyIntTests: PyTestCase {

  func test__add__() {
    let py = self.createPy()
    self.assertInvalidSelfArgumentMessage(py, type: py.types.int, argumentCount: 2)

    let two = py.newInt(3).asObject
    let five = py.newInt(5).asObject
    let none = py.none.asObject

    let intInt = py.add(left: two, right: five)
    self.assertInt(py, object: intInt, value: 8)

    let intNone = py.add(left: two, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for +: 'int' and 'NoneType'"
    )

    let noneInt = py.add(left: none, right: five)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for +: 'NoneType' and 'int'"
    )
  }
}
