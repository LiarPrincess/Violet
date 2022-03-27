import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyListTests: PyTestCase {

  // MARK: - Description

  func test_description() {
    let py = self.createPy()

    let empty = py.newList(elements: [])
    self.assertDescription(empty, "PyList(list, count: 0, elements: [])")

    let i0 = py.newInt(0).asObject
    let i1 = py.newInt(1).asObject
    let i2 = py.newInt(2).asObject

    let count1 = py.newList(elements: [i0])
    self.assertDescription(count1, "PyList(list, count: 1, elements: [\(i0)])")

    let count2 = py.newList(elements: [i0, i1])
    self.assertDescription(count2, "PyList(list, count: 2, elements: [\(i0), \(i1)])")

    let count3 = py.newList(elements: [i0, i1, i2])
    self.assertDescription(count3, "PyList(list, count: 3, elements: [\(i0), \(i1), \(i2)])")
  }

  func test_description_recursive() {
    let py = self.createPy()

    let i0 = py.newInt(0).asObject
    let i0s = "PyInt(int, value: 0)"
    let i1 = py.newInt(1).asObject
    let i1s = "PyInt(int, value: 1)"

    let list = py.newList(elements: [i0])
    py.add(list: list, object: list.asObject)
    py.add(list: list, object: i1)

    let listRec = "PyList(list, RECURSIVE ENTRY, ptr: \(list.ptr))"
    let expected = "PyList(list, count: 3, elements: [\(i0s), \(listRec), \(i1s)])"

    let result = String(describing: list)
    XCTAssertEqual(result, expected)
  }
}
