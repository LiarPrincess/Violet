import XCTest
import Foundation
import FileSystem
import VioletObjects

class PyDictTests: PyTestCase {

  // MARK: - Description

  func test_description() {
    let py = self.createPy()

    let empty = py.newDict()
    self.assertDescription(empty, "PyDict(dict, count: 0, elements: OrderedDictionary())")

    let i0 = py.newInt(0).asObject
    let i1 = py.newInt(1).asObject
    let i2 = py.newInt(2).asObject
    let strA = py.newString("A").asObject

    let count1 = py.newDict(elements: [
      .init(key: i0, value: i1)
    ])
    let elements1 = "OrderedDictionary(Key(\(i0)): \(i1))"
    self.assertDescription(py, count1, "PyDict(dict, count: 1, elements: \(elements1))")

    let count2 = py.newDict(elements: [
      .init(key: i0, value: i1),
      .init(key: i2, value: strA)
    ])
    let elements2 = "OrderedDictionary(Key(\(i0)): \(i1), Key(\(i2)): \(strA))"
    self.assertDescription(py, count2, "PyDict(dict, count: 2, elements: \(elements2))")
  }

  func test_description_recursive() {
    let py = self.createPy()

    let i0 = py.newInt(0).asObject
    let i1 = py.newInt(1).asObject
    let i2 = py.newInt(2).asObject
    let i3 = py.newInt(3).asObject
    let strA = py.newString("A").asObject

    let dict = py.newDict()
    self.add(py, dict, key: i0, value: i1)
    self.add(py, dict, key: i2, value: dict)
    self.add(py, dict, key: i3, value: strA)

    var elements = "OrderedDictionary("
    elements.append("Key(\(i0)): \(i1), ")
    elements.append("Key(\(i2)): PyDict(dict, RECURSIVE ENTRY, ptr: \(dict.ptr)), ")
    elements.append("Key(\(i3)): \(strA)")
    elements.append(")")

    let expected = "PyDict(dict, count: 3, elements: \(elements))"
    let result = String(describing: dict)
    XCTAssertEqual(result, expected)
  }

  // MARK: - Helpers

  internal func add<K: PyObjectMixin, V: PyObjectMixin>(_ py: Py,
                                                        _ dict: PyDict,
                                                        key: K,
                                                        value: V,
                                                        file: StaticString = #file,
                                                        line: UInt = #line) {
    if let e = py.add(dict: dict, key: key.asObject, value: value.asObject) {
      let reason = self.toString(py, error: e)
      XCTFail(reason, file: file, line: line)
    }
  }
}
