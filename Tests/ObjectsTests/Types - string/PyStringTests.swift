import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyStringTests: PyTestCase {

  // MARK: - Description

  func test_description() {
    let py = self.createPy()

    let empty = py.emptyString
    let empty2 = py.newString("")
    self.assertDescription(empty, "PyString(str, count: -1, hash: 0, value: '')")
    self.assertDescription(empty2, "PyString(str, count: -1, hash: 0, value: '')")

    _ = self.getLength(py, empty)
    self.assertDescription(empty, "PyString(str, count: 0, hash: 0, value: '')")

    _ = self.getHash(py, empty)
    self.assertDescription(empty, "PyString(str, count: 0, hash: 0, value: '')")

    let str = py.newString("Let it go!")
    self.assertDescription(str, "PyString(str, count: -1, hash: 0, value: 'Let it go!')")

    _ = self.getLength(py, str)
    self.assertDescription(str, "PyString(str, count: 10, hash: 0, value: 'Let it go!')")

    if let hash = self.getHash(py, str) {
      self.assertDescription(str, "PyString(str, count: 10, hash: \(hash), value: 'Let it go!')")
    }
  }

  // MARK: - Helpers

  internal func getLength(_ py: Py,
                          _ str: PyString,
                          file: StaticString = #file,
                          line: UInt = #line) -> PyObject? {
    switch py.length(iterable: str.asObject) {
    case let .value(length):
      return length
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail(reason, file: file, line: line)
      return nil
    }
  }

  internal func getHash(_ py: Py,
                        _ str: PyString,
                        file: StaticString = #file,
                        line: UInt = #line) -> PyHash? {
    switch py.hash(object: str.asObject) {
    case let .value(hash):
      return hash
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail(reason, file: file, line: line)
      return nil
    }
  }
}
