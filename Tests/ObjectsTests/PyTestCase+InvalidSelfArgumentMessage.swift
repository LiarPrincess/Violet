import XCTest
import Foundation
import BigInt
import FileSystem
import VioletObjects // Do not add '@testable'! We want to do everything 'by the book'.

extension PyTestCase {

  // MARK: - Properties

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        getter: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
  }

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        setter: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
  }

  // MARK: - Methods

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        fn: String,
                                        positionalArgCount: Int,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    guard let method = self.getMethod(py,
                                      type: type,
                                      name: fn,
                                      file: file,
                                      line: line) else {
      return
    }

    let args = self.createArgs(py, type: type, count: positionalArgCount)
    self.callExpectingInvalidSelfError(py,
                                       callable: method,
                                       args: args,
                                       kwargs: nil,
                                       expectedType: type,
                                       expectedFnName: fn,
                                       file: file,
                                       line: line)
  }

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        argsKwargsFn: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {

  }

  // MARK: - Helpers

  private func getMethod(_ py: Py,
                         type: PyType,
                         name: String,
                         file: StaticString,
                         line: UInt) -> PyObject? {
    let typeObject = type.asObject
    let nameStr = py.newString(name)

    switch py.getMethod(object: typeObject, selector: nameStr, allowsCallableFromDict: true) {
    case .value(let o):
      return o
    case .notFound:
      let typeName = py.getName(type: type)
      XCTFail("'\(typeName).\(name)': does not exist.", file: file, line: line)
      return nil
    case .error(let e):
      let typeName = py.getName(type: type)
      let reason = self.toString(py, error: e)
      XCTFail("'\(typeName).\(name)': \(reason)", file: file, line: line)
      return nil
    }
  }

  private func createArgs(_ py: Py, type: PyType, count: Int) -> [PyObject] {
    let isNone = type === py.types.none
    let invalidSelf = isNone ? py.notImplemented.asObject : py.none.asObject

    var result = [invalidSelf]
    for _ in 1..<count {
      result.append(py.none.asObject)
    }

    return result
  }

  private func callExpectingInvalidSelfError(_ py: Py,
                                             callable: PyObject,
                                             args: [PyObject],
                                             kwargs: PyDict?,
                                             expectedType: PyType,
                                             expectedFnName: String,
                                             file: StaticString,
                                             line: UInt) {
    let error: PyBaseException
    switch py.call(callable: callable, args: args, kwargs: nil) {
    case .value(let o):
      XCTFail("Returned '\(o)'.", file: file, line: line)
      return
    case .notCallable:
      XCTFail("Not callable.", file: file, line: line)
      return
    case .error(let e):
      error = e
    }

    guard py.cast.isTypeError(error.asObject) else {
      XCTFail("Invalid error type: \(error.typeName)", file: file, line: line)
      return
    }

    guard let message = self.getMessageString(py, error: error) else {
      XCTFail("No message.", file: file, line: line)
      return
    }

    // Standard message looks like this:
    // descriptor '__add__' requires a 'int' object but received a 'NoneType'
    let typeName = py.getName(type: expectedType)
    let hasTypeName = message.contains(typeName)
    XCTAssert(hasTypeName, "'\(typeName)' not in '\(message)'", file: file, line: line)

    let hasFnName = message.contains(expectedFnName)
    XCTAssert(hasFnName, "'\(expectedFnName)' not in '\(message)'", file: file, line: line)
  }
}
