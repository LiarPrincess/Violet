import XCTest
import Foundation
import BigInt
import FileSystem
import VioletObjects // Do not add '@testable'! We want to do everything 'by the book'.

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
                                                       left: L?,
                                                       right: R,
                                                       file: StaticString = #file,
                                                       line: UInt = #line) {
    guard let left = left else {
      XCTFail("Left is '.none'", file: file, line: line)
      return
    }

    self.assertEqual(py, left: left, right: right, file: file, line: line)
  }

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

  // MARK: - Type error

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
      if let message = self.getMessageString(py, error: error) {
        XCTAssertEqual(message, expectedMessage, "Message", file: file, line: line)
      } else {
        XCTFail("No message", file: file, line: line)
      }
    }
  }

  // MARK: - Invalid 'self'

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        argumentCount: Int,
                                        fnName: StaticString = #function,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    // Method name will be taken from test name.
    guard let selector = self.getInvalidSelfArgumentFunctionName(fnName: fnName) else {
      XCTFail("Unable to get function name from '\(fnName)'.", file: file, line: line)
      return
    }

    let typeName = py.getName(type: type)
    let typeObject = type.asObject
    let selectorStr = py.newString(selector)

    let fn: PyObject
    switch py.getMethod(object: typeObject, selector: selectorStr, allowsCallableFromDict: true) {
    case .value(let o):
      fn = o
    case .notFound:
      XCTFail("'\(typeName).\(selector)': does not exist.", file: file, line: line)
      return
    case .error(let e):
      let reason = self.toString(py, error: e)
      XCTFail("'\(typeName).\(selector)': \(reason)", file: file, line: line)
      return
    }

    let arg = py.none.asObject
    let args = (0..<argumentCount).map { _ in arg }

    let error: PyBaseException
    switch py.call(callable: fn, args: args, kwargs: nil) {
    case .value(let o):
      XCTFail("'\(typeName).\(selector)': returned '\(o)'.", file: file, line: line)
      return
    case .notCallable:
      XCTFail("'\(typeName).\(selector)': not callable.", file: file, line: line)
      return
    case .error(let e):
      self.assertTypeError(py, error: e, message: nil)
      error = e
    }

    guard let message = self.getMessageString(py, error: error) else {
      XCTFail("'\(typeName).\(selector)': no message.", file: file, line: line)
      return
    }

    // descriptor '__add__' requires a 'int' object but received a 'NoneType'
    XCTAssert(message.contains(typeName), "Missing '\(typeName)'", file: file, line: line)
    XCTAssert(message.contains(selector), "Missing '\(selector)'", file: file, line: line)
  }

  /// `test__add__()` -> `__add__`.
  private func getInvalidSelfArgumentFunctionName(fnName: StaticString) -> String? {
    let fnString = String(describing: fnName)

    let prefix = "test"
    guard fnString.hasPrefix(prefix) else {
      return nil
    }

    let nameStartIndex = fnString.index(fnString.startIndex, offsetBy: prefix.count)

    guard let parenOpenIndex = fnString.firstIndex(of: "(") else {
      return nil
    }

    let result = fnString[nameStartIndex..<parenOpenIndex]
    return String(result)
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

  func toString<T: PyErrorMixin>(_ py: Py, error: T) -> String {
    let typeName = error.typeName

    guard let message = self.getMessage(py, error: error) else {
      return typeName
    }

    switch py.strString(object: message.asObject) {
    case .value(let s):
      return s
    case .error:
      return typeName
    }
  }

  func getMessageString<T: PyErrorMixin>(_ py: Py, error: T) -> String? {
    guard let message = self.getMessage(py, error: error) else {
      return nil
    }

    switch py.strString(object: message.asObject) {
    case .value(let s):
      return s
    case .error:
      return nil
    }
  }

  func getMessage<T: PyErrorMixin>(_ py: Py, error: T) -> PyString? {
    let args = py.getArgs(exception: error.asBaseException)

    let firstArg: PyObject
    switch py.getItem(object: args.asObject, index: 0) {
    case .value(let o): firstArg = o
    case .error: return nil
    }

    guard let message = py.cast.asString(firstArg) else {
      return nil
    }

    return message
  }
}
