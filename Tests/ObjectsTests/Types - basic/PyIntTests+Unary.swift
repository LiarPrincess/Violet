import XCTest
import Foundation
import FileSystem
import VioletObjects

extension PyIntTests {

  // MARK: - Type conversion

  func test__bool__() {
    let py = self.createPy()

    let i0 = py.newInt(0).asObject
    self.assertIsTrue(py, object: i0, expected: false)

    let i3 = py.newInt(3).asObject
    self.assertIsTrue(py, object: i3)
  }

  // MARK: - Imag

  func test_real() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let result = self.get(py, object: i3, propertyName: "real")
    self.assertIsEqual(py, left: result, right: i3)
  }

  func test_imag() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i0 = py.newInt(0).asObject

    let result = self.get(py, object: i3, propertyName: "imag")
    self.assertIsEqual(py, left: result, right: i0)
  }

  func test_conjugate() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let result = self.callMethod(py, object: i3, selector: "conjugate", args: [])
    self.assertIsEqual(py, left: result, right: i3)
  }

  // MARK: - Sign

  func test__pos__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i_3 = py.newInt(-3).asObject

    self.assertPositive(py, object: i3, expected: i3)
    self.assertPositive(py, object: i_3, expected: i_3)
  }

  func test__neg__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i_3 = py.newInt(-3).asObject

    self.assertNegative(py, object: i3, expected: i_3)
    self.assertNegative(py, object: i_3, expected: i3)
  }

  func test__abs__() {
    let py = self.createPy()

    let i3 = py.newInt(3).asObject
    let i_3 = py.newInt(-3).asObject

    self.assertAbsolute(py, object: i3, expected: i3)
    self.assertAbsolute(py, object: i_3, expected: i3)
  }
}
