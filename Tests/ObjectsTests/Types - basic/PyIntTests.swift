import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyIntTests: PyTestCase {

  func test_description() {
    let py = self.createPy()

    let i0 = py.newInt(0)
    self.assertDescription(i0, "PyInt(int, value: 0)")

    let i7 = py.newInt(7)
    self.assertDescription(i7, "PyInt(int, value: 7)")

    let i_13 = py.newInt(-13)
    self.assertDescription(i_13, "PyInt(int, value: -13)")
  }
}
