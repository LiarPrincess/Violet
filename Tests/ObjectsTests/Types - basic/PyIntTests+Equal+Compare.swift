import XCTest
import Foundation
import FileSystem
import VioletObjects

extension PyIntTests {

  // MARK: - Equal

  func test__eq__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i5 = py.newInt(5).asObject
    let none = py.none.asObject

    self.assertIsEqual(py, left: i3, right: i3)

    self.assertIsEqual(py, left: i3, right: i5, expected: false)
    self.assertIsEqual(py, left: i5, right: i3, expected: false)

    self.assertIsEqual(py, left: i3, right: none, expected: false)
    self.assertIsEqual(py, left: none, right: i3, expected: false)
  }

  func test__ne__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i5 = py.newInt(5).asObject
    let none = py.none.asObject

    self.assertIsNotEqual(py, left: i3, right: i3, expected: false)

    self.assertIsNotEqual(py, left: i3, right: i5)
    self.assertIsNotEqual(py, left: i5, right: i3)

    self.assertIsNotEqual(py, left: i3, right: none)
    self.assertIsNotEqual(py, left: none, right: i3)
  }

  // MARK: - Compare

  func test__lt__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i5 = py.newInt(5).asObject
    let none = py.none.asObject

    self.assertIsLess(py, left: i3, right: i3, expected: false)

    self.assertIsLess(py, left: i3, right: i5)
    self.assertIsLess(py, left: i5, right: i3, expected: false)

    let intNone = py.isLess(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "'<' not supported between instances of 'int' and 'NoneType'"
    )

    let noneInt = py.isLess(left: none, right: i3)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "'<' not supported between instances of 'NoneType' and 'int'"
    )
  }

  func test__le__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i5 = py.newInt(5).asObject
    let none = py.none.asObject

    self.assertIsLessEqual(py, left: i3, right: i3)

    self.assertIsLessEqual(py, left: i3, right: i5)
    self.assertIsLessEqual(py, left: i5, right: i3, expected: false)

    let intNone = py.isLessEqual(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "'<=' not supported between instances of 'int' and 'NoneType'"
    )

    let noneInt = py.isLessEqual(left: none, right: i3)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "'<=' not supported between instances of 'NoneType' and 'int'"
    )
  }

  func test__gt__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i5 = py.newInt(5).asObject
    let none = py.none.asObject

    self.assertIsGreater(py, left: i3, right: i3, expected: false)

    self.assertIsGreater(py, left: i3, right: i5, expected: false)
    self.assertIsGreater(py, left: i5, right: i3)

    let intNone = py.isGreater(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "'>' not supported between instances of 'int' and 'NoneType'"
    )

    let noneInt = py.isGreater(left: none, right: i3)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "'>' not supported between instances of 'NoneType' and 'int'"
    )
  }

  func test__ge__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i5 = py.newInt(5).asObject
    let none = py.none.asObject

    self.assertIsGreaterEqual(py, left: i3, right: i3)

    self.assertIsGreaterEqual(py, left: i3, right: i5, expected: false)
    self.assertIsGreaterEqual(py, left: i5, right: i3)

    let intNone = py.isGreaterEqual(left: i3, right: none)
    self.assertTypeError(
      py,
      error: intNone,
      message: "'>=' not supported between instances of 'int' and 'NoneType'"
    )

    let noneInt = py.isGreaterEqual(left: none, right: i3)
    self.assertTypeError(
      py,
      error: noneInt,
      message: "'>=' not supported between instances of 'NoneType' and 'int'"
    )
  }
}
