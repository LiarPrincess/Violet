import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyIntTests: PyTestCase {

  // MARK: - Pow

  func test__pow__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i27 = py.newInt(27).asObject
    let none = py.none.asObject

    // >>> pow(3, 27) -> 7625597484987
    let r3_27 = py.pow(base: i3, exp: i27)
    self.assertInt(py, object: r3_27, value: 7_625_597_484_987)

    // >>> pow(27, 3) -> 19683
    let r27_3 = py.pow(base: i27, exp: i3)
    self.assertInt(py, object: r27_3, value: 19683)

    let intNone = py.pow(base: i3, exp: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for ** or pow(): 'int' and 'NoneType'"
    )

    let noneInt = py.pow(base: none, exp: i27)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for ** or pow(): 'NoneType' and 'int'"
    )
  }

  func test__pow__mod() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i27 = py.newInt(27).asObject
    let i987 = py.newInt(987).asObject
    let str = py.newString("A").asObject
    let none = py.none.asObject

    // >>> pow(3, 27, 987) -> 363
    let r3_27_987 = py.pow(base: i3, exp: i27, mod: i987)
    self.assertInt(py, object: r3_27_987, value: 363)

    // >>> pow(27, 3, 987) -> 930
    let r27_3_987 = py.pow(base: i27, exp: i3, mod: i987)
    self.assertInt(py, object: r27_3_987, value: 930)

    // >>> pow(3, 27, None) -> 7625597484987
    let r3_27_none = py.pow(base: i3, exp: i27, mod: none)
    self.assertInt(py, object: r3_27_none, value: 7_625_597_484_987)

    // >>> pow(27, 3, None) -> 19683
    let r27_3_none = py.pow(base: i27, exp: i3, mod: none)
    self.assertInt(py, object: r27_3_none, value: 19_683)

    let intIntStr = py.pow(base: i3, exp: i27, mod: str)
    self.assertTypeError(
      py,
      error: intIntStr,
      message: "unsupported operand type(s) for pow(): 'int', 'int', 'str'"
    )
  }
}
