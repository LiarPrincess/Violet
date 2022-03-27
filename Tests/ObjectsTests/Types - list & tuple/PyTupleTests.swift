import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyTupleTests: PyTestCase {

  // MARK: - Description

  func test_description() {
    let py = self.createPy()

    let empty = py.emptyTuple
    let empty2 = py.newTuple(elements: [])
    self.assertDescription(empty, "PyTuple(tuple, count: 0, elements: [])")
    self.assertDescription(empty2, "PyTuple(tuple, count: 0, elements: [])")

    let i0 = py.newInt(0).asObject
    let i1 = py.newInt(1).asObject
    let i2 = py.newInt(2).asObject

    let count1 = py.newTuple(elements: [i0])
    self.assertDescription(count1, "PyTuple(tuple, count: 1, elements: [\(i0)])")

    let count2 = py.newTuple(elements: [i0, i1])
    self.assertDescription(count2, "PyTuple(tuple, count: 2, elements: [\(i0), \(i1)])")

    let count3 = py.newTuple(elements: [i0, i1, i2])
    self.assertDescription(count3, "PyTuple(tuple, count: 3, elements: [\(i0), \(i1), \(i2)])")
  }

  func test_description_recursive() {
    let py = self.createPy()

    let i0 = py.newInt(0).asObject
    let i1 = py.newInt(1).asObject
    let i2 = py.newInt(2).asObject

    // Tuple can contain itself, if it contains a mutable container (like 'list').
    let list = py.newList(elements: [i1])
    let tuple = py.newTuple(elements: [i0, list.asObject, i2])
    py.add(list: list, object: tuple.asObject)

    let tupleRec = "PyTuple(tuple, RECURSIVE ENTRY, ptr: \(tuple.ptr))"
    let listElement = "PyList(list, count: 2, elements: [\(i1), \(tupleRec)])"
    let expected = "PyTuple(tuple, count: 3, elements: [\(i0), \(listElement), \(i2)])"

    let result = String(describing: tuple)
    XCTAssertEqual(result, expected)
  }
}
