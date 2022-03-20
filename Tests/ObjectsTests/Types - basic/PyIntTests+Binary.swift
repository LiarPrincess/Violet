import XCTest
import Foundation
import FileSystem
import VioletObjects

extension PyIntTests {

  // MARK: - Add, sub, mul

  func test__add__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i7 = py.newInt(7).asObject
    let none = py.none.asObject

    let r37 = py.add(left: i3, right: i7)
    self.assertInt(py, object: r37, value: 10)

    let r73 = py.add(left: i7, right: i3)
    self.assertInt(py, object: r73, value: 10)

    let intNone = py.add(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for +: 'int' and 'NoneType'"
    )

    let noneInt = py.add(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for +: 'NoneType' and 'int'"
    )
  }

  func test__sub__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i7 = py.newInt(7).asObject
    let none = py.none.asObject

    let r37 = py.sub(left: i3, right: i7)
    self.assertInt(py, object: r37, value: -4)

    let r73 = py.sub(left: i7, right: i3)
    self.assertInt(py, object: r73, value: 4)

    let intNone = py.sub(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for -: 'int' and 'NoneType'"
    )

    let noneInt = py.sub(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for -: 'NoneType' and 'int'"
    )
  }

  func test__mul__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i7 = py.newInt(7).asObject
    let none = py.none.asObject

    let r37 = py.mul(left: i3, right: i7)
    self.assertInt(py, object: r37, value: 21)

    let r73 = py.mul(left: i7, right: i3)
    self.assertInt(py, object: r73, value: 21)

    let intNone = py.mul(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for *: 'int' and 'NoneType'"
    )

    let noneInt = py.mul(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for *: 'NoneType' and 'int'"
    )
  }

  // MARK: - Div

  func test__truediv__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i7 = py.newInt(7).asObject
    let none = py.none.asObject

    let r37 = py.trueDiv(left: i3, right: i7)
    self.assertFloat(py, object: r37, value: 3.0 / 7.0)

    let r73 = py.trueDiv(left: i7, right: i3)
    self.assertFloat(py, object: r73, value: 7.0 / 3.0)

    let intNone = py.trueDiv(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for /: 'int' and 'NoneType'"
    )

    let noneInt = py.trueDiv(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for /: 'NoneType' and 'int'"
    )
  }

  func test__floordiv__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i_3 = py.newInt(-3).asObject
    let i7 = py.newInt(7).asObject
    let i_7 = py.newInt(-7).asObject
    let none = py.none.asObject

    // 3 // 7 -> 0
    let r37 = py.floorDiv(left: i3, right: i7)
    self.assertInt(py, object: r37, value: 0)
    // -3 // 7 -> -1
    let r_37 = py.floorDiv(left: i_3, right: i7)
    self.assertInt(py, object: r_37, value: -1)
    // 3 // -7 -> -1
    let r3_7 = py.floorDiv(left: i3, right: i_7)
    self.assertInt(py, object: r3_7, value: -1)
    // -3 // -7 -> 0
    let r_3_7 = py.floorDiv(left: i_3, right: i_7)
    self.assertInt(py, object: r_3_7, value: 0)

    // 7 // 3 -> 2
    let r73 = py.floorDiv(left: i7, right: i3)
    self.assertInt(py, object: r73, value: 2)
    // -7 // 3 -> -3
    let r_73 = py.floorDiv(left: i_7, right: i3)
    self.assertInt(py, object: r_73, value: -3)
    // 7 // -3 -> -3
    let r7_3 = py.floorDiv(left: i7, right: i_3)
    self.assertInt(py, object: r7_3, value: -3)
    // -7 // -3 -> 2
    let r_7_3 = py.floorDiv(left: i_7, right: i_3)
    self.assertInt(py, object: r_7_3, value: 2)

    let intNone = py.floorDiv(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for //: 'int' and 'NoneType'"
    )

    let noneInt = py.floorDiv(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for //: 'NoneType' and 'int'"
    )
  }

  func test__mod__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i_3 = py.newInt(-3).asObject
    let i7 = py.newInt(7).asObject
    let i_7 = py.newInt(-7).asObject
    let none = py.none.asObject

    // >>> 3 % 7 -> 3
    let r37 = py.mod(left: i3, right: i7)
    self.assertInt(py, object: r37, value: 3)
    // >>> -3 % 7 -> 4
    let r_37 = py.mod(left: i_3, right: i7)
    self.assertInt(py, object: r_37, value: 4)
    // >>> 3 % -7 -> -4
    let r3_7 = py.mod(left: i3, right: i_7)
    self.assertInt(py, object: r3_7, value: -4)
    // >>> -3 % -7 -> -3
    let r_3_7 = py.mod(left: i_3, right: i_7)
    self.assertInt(py, object: r_3_7, value: -3)

    // >>> 7 % 3 -> 1
    let r73 = py.mod(left: i7, right: i3)
    self.assertInt(py, object: r73, value: 1)
    // >>> -7 % 3 -> 2
    let r_73 = py.mod(left: i_7, right: i3)
    self.assertInt(py, object: r_73, value: 2)
    // >>> 7 % -3 -> -2
    let r7_3 = py.mod(left: i7, right: i_3)
    self.assertInt(py, object: r7_3, value: -2)
    // >>> -7 % -3 -> -1
    let r_7_3 = py.mod(left: i_7, right: i_3)
    self.assertInt(py, object: r_7_3, value: -1)

    let intNone = py.mod(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for %: 'int' and 'NoneType'"
    )

    let noneInt = py.mod(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for %: 'NoneType' and 'int'"
    )
  }

  func test__divmod__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i_3 = py.newInt(-3).asObject
    let i7 = py.newInt(7).asObject
    let i_7 = py.newInt(-7).asObject
    let none = py.none.asObject

    // >>> divmod(3, 7) -> (0, 3)
    let r37 = py.divMod(left: i3, right: i7)
    self.assertTuple(py, object: r37, elements: 0, 3)
    // >>> divmod(-3, 7) -> (-1, 4)
    let r_37 = py.divMod(left: i_3, right: i7)
    self.assertTuple(py, object: r_37, elements: -1, 4)
    // >>> divmod(3, -7) -> (-1, -4)
    let r3_7 = py.divMod(left: i3, right: i_7)
    self.assertTuple(py, object: r3_7, elements: -1, -4)
    // >>> divmod(-3, -7) -> (0, -3)
    let r_3_7 = py.divMod(left: i_3, right: i_7)
    self.assertTuple(py, object: r_3_7, elements: 0, -3)

    // >>> divmod(7, 3) -> (2, 1)
    let r73 = py.divMod(left: i7, right: i3)
    self.assertTuple(py, object: r73, elements: 2, 1)
    // >>> divmod(-7, 3) -> (-3, 2)
    let r_73 = py.divMod(left: i_7, right: i3)
    self.assertTuple(py, object: r_73, elements: -3, 2)
    // >>> divmod(7, -3) -> (-3, -2)
    let r7_3 = py.divMod(left: i7, right: i_3)
    self.assertTuple(py, object: r7_3, elements: -3, -2)
    // >>> divmod(-7, -3) -> (2, -1)
    let r_7_3 = py.divMod(left: i_7, right: i_3)
    self.assertTuple(py, object: r_7_3, elements: 2, -1)

    let intNone = py.divMod(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for divmod(): 'int' and 'NoneType'"
    )

    let noneInt = py.divMod(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for divmod(): 'NoneType' and 'int'"
    )
  }

  private func assertTuple(_ py: Py,
                           object: PyResult<PyObject>,
                           elements: Int...,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let tuple = elements.map { int in
      return py.newInt(int).asObject
    }

    self.assertTuple(py, object: object, elements: tuple, file: file, line: line)
  }

  // MARK: - Shift

  func test__lshift__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i7 = py.newInt(7).asObject
    let none = py.none.asObject

    // >>> 3 << 7 -> 384
    let r37 = py.lshift(left: i3, right: i7)
    self.assertInt(py, object: r37, value: 384)

    // >>> 7 << 3 -> 56
    let r73 = py.lshift(left: i7, right: i3)
    self.assertInt(py, object: r73, value: 56)

    let intNone = py.lshift(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for <<: 'int' and 'NoneType'"
    )

    let noneInt = py.lshift(left: none, right: i7)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for <<: 'NoneType' and 'int'"
    )
  }

  func test__rshift__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i103 = py.newInt(103).asObject
    let none = py.none.asObject

    // >>> 3 >> 103 -> 0
    let r3103 = py.rshift(left: i3, right: i103)
    self.assertInt(py, object: r3103, value: 0)

    // >>> 103 >> 3 -> 12
    let r1033 = py.rshift(left: i103, right: i3)
    self.assertInt(py, object: r1033, value: 12)

    let intNone = py.rshift(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for >>: 'int' and 'NoneType'"
    )

    let noneInt = py.rshift(left: none, right: i103)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for >>: 'NoneType' and 'int'"
    )
  }

  // MARK: - Bit

  func test__and__() {
    let py = self.createPy()

    //  5 = 0b0101
    // 12 = 0b1100
    let i5 = py.newInt(5).asObject
    let i12 = py.newInt(12).asObject
    let none = py.none.asObject

    let r125 = py.and(left: i12, right: i5)
    self.assertInt(py, object: r125, value: 4)

    let r512 = py.and(left: i5, right: i12)
    self.assertInt(py, object: r512, value: 4)

    let intNone = py.and(left: i12, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for &: 'int' and 'NoneType'"
    )

    let noneInt = py.and(left: none, right: i5)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for &: 'NoneType' and 'int'"
    )
  }

  func test__or__() {
    let py = self.createPy()

    //  5 = 0b0101
    // 12 = 0b1100
    let i5 = py.newInt(5).asObject
    let i12 = py.newInt(12).asObject
    let none = py.none.asObject

    let r125 = py.or(left: i12, right: i5)
    self.assertInt(py, object: r125, value: 13)

    let r512 = py.or(left: i5, right: i12)
    self.assertInt(py, object: r512, value: 13)

    let intNone = py.or(left: i12, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for |: 'int' and 'NoneType'"
    )

    let noneInt = py.or(left: none, right: i5)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for |: 'NoneType' and 'int'"
    )
  }

  func test__xor__() {
    let py = self.createPy()

    //  5 = 0b0101
    // 12 = 0b1100
    let i5 = py.newInt(5).asObject
    let i12 = py.newInt(12).asObject
    let none = py.none.asObject

    let r125 = py.xor(left: i12, right: i5)
    self.assertInt(py, object: r125, value: 9)

    let r512 = py.xor(left: i5, right: i12)
    self.assertInt(py, object: r512, value: 9)

    let intNone = py.xor(left: i12, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "unsupported operand type(s) for ^: 'int' and 'NoneType'"
    )

    let noneInt = py.xor(left: none, right: i5)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "unsupported operand type(s) for ^: 'NoneType' and 'int'"
    )
  }
}
