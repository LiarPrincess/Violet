import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyFloatTernaryTests: PyTestCase {

  func test__pow__() {
    let py = self.createPy()
    self.assertPow(py, base: 3.1, exp: 5.7, expected: 632.064_872_663_979)
    self.assertPow(py, base: 5.7, exp: 3.1, expected: 220.40_023_466_591_268)
  }

  private func assertPow(_ py: Py,
                         base: Double,
                         exp: Double,
                         expected: Double,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let baseObject = py.newFloat(base).asObject
    let expObject = py.newFloat(exp).asObject
    let result = py.pow(base: baseObject, exp: expObject, mod: nil)

    let expectedObject = py.newFloat(expected).asObject
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }
}
