import XCTest
import Foundation
import BigInt
import FileSystem
@testable import VioletObjects

extension PyTestCase {

  // MARK: - Not implemented

  func assertNotImplemented(_ py: Py,
                            object: PyResult<PyObject>,
                            file: StaticString = #file,
                            line: UInt = #line) {
    if let object = self.unwrapResult(py, result: object, file: file, line: line) {
      self.assertNotImplemented(py, object: object, file: file, line: line)
    }
  }

  func assertNotImplemented(_ py: Py,
                            object: PyObject,
                            file: StaticString = #file,
                            line: UInt = #line) {
    let fromCast = py.cast.isNotImplemented(object)
    XCTAssertTrue(fromCast,
                  "py.cast.isNotImplemented",
                  file: file,
                  line: line)

    let pointerEquality = object.ptr === py.notImplemented.ptr
    XCTAssertTrue(pointerEquality,
                  "object.ptr === py.notImplemented.ptr",
                  file: file,
                  line: line)
  }

  // MARK: - Int

  func assertInt(_ py: Py,
                 object: PyResult<PyObject>,
                 value: BigInt,
                 file: StaticString = #file,
                 line: UInt = #line) {
    if let object = self.unwrapResult(py, result: object, file: file, line: line) {
      self.assertInt(py, object: object, value: value, file: file, line: line)
    }
  }

  func assertInt(_ py: Py,
                 object: PyObject,
                 value: BigInt,
                 file: StaticString = #file,
                 line: UInt = #line) {
    guard py.cast.isInt(object) else {
      XCTFail("Got '\(object.typeName)' instead of 'int'.", file: file, line: line)
      return
    }

    let expectedObject = py.newInt(value).asObject
    self.assertEqual(py, left: object, right: expectedObject, file: file, line: line)
  }

  // MARK: - Equal

  func assertEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                       left: L,
                                                       right: R,
                                                       file: StaticString = #file,
                                                       line: UInt = #line) {
    switch py.isEqual(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Not equal error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Is true

  func assertIsTrue<T: PyObjectMixin>(_ py: Py,
                                      object: T,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    switch py.isTrueBool(object: object.asObject) {
    case let .value(bool):
      XCTAssertTrue(bool, "Is true", file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is true error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Error

  func assertTypeError<T>(_ py: Py,
                          error: PyResult<T>,
                          message: String?,
                          file: StaticString = #file,
                          line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertTypeError(py,
                           error: e,
                           message: message,
                           file: file,
                           line: line)
    }
  }

  func assertTypeError<T: PyErrorMixin>(_ py: Py,
                                        error: T,
                                        message: String?,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    let isTypeError = py.cast.isTypeError(error.asObject)
    XCTAssert(isTypeError,
              "'\(error.typeName)' is not a type error.",
              file: file,
              line: line)

    if let expectedMessage = message {
      if let message = self.getMessageFromFirstArg(py, error: error) {
        XCTAssertEqual(message.value, expectedMessage, "Message", file: file, line: line)
      } else {
        XCTFail("No message", file: file, line: line)
      }
    }
  }

  private func toString<T: PyErrorMixin>(_ py: Py, error: T) -> String {
    let message = self.getMessageFromFirstArg(py, error: error)
    return message?.value ?? error.typeName
  }

  func getMessageFromFirstArg<T: PyErrorMixin>(_ py: Py, error: T) -> PyString? {
    let args = error.asBaseException.getArgs()

    guard let firstArg = args.elements.first else {
      return nil
    }

    guard let message = py.cast.asString(firstArg) else {
      return nil
    }

    return message
  }

  // MARK: - Helpers

  private func unwrapResult<T>(_ py: Py,
                               result: PyResult<T>,
                               file: StaticString = #file,
                               line: UInt = #line) -> T? {
    switch result {
    case let .value(o):
      return o
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Result is error: \(reason)", file: file, line: line)
      return nil
    }
  }

  private func unwrapError<T>(result: PyResult<T>,
                              file: StaticString = #file,
                              line: UInt = #line) -> PyBaseException? {
    switch result {
    case let .value(o):
      XCTFail("Result is value: \(o)", file: file, line: line)
      return nil
    case let .error(e):
      return e
    }
  }
}
