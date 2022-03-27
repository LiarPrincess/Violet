import XCTest
import Foundation
import BigInt
import FileSystem
import VioletObjects // Do not add '@testable'! We want to do everything 'by the book'.

extension PyTestCase {

  // MARK: - Description

  func assertDescription<T: PyObjectMixin>(_ py: Py,
                                           _ result: PyResultGen<T>,
                                           _ expected: String,
                                           file: StaticString = #file,
                                           line: UInt = #line) {
    switch result {
    case let .value(o):
      self.assertDescription(o, expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Result is error: \(reason)", file: file, line: line)
      return
    }
  }

  func assertDescription<T: PyObjectMixin>(_ object: T,
                                           _ expected: String,
                                           file: StaticString = #file,
                                           line: UInt = #line) {
    let result = String(describing: object)
    XCTAssertEqual(result, expected, file: file, line: line)
  }

  // MARK: - Repr, str

  func assertRepr<T: PyObjectMixin>(_ py: Py,
                                    object: T,
                                    expected: String,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
    let result = py.repr(object.asObject)
    let expectedObject = py.newString(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  func assertStr<T: PyObjectMixin>(_ py: Py,
                                   object: T,
                                   expected: String,
                                   file: StaticString = #file,
                                   line: UInt = #line) {
    let result = py.str(object.asObject)
    let expectedObject = py.newString(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Equal

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: L?,
                                                         right: R,
                                                         message: String? = nil,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    guard let left = left else {
      XCTFail("Left is '.none'", file: file, line: line)
      return
    }

    self.assertIsEqual(py,
                       left: left,
                       right: right,
                       message: message,
                       expected: expected,
                       file: file,
                       line: line)
  }

  func assertIsEqual<R: PyObjectMixin>(_ py: Py,
                                       left: PyResult,
                                       right: R,
                                       message: String? = nil,
                                       expected: Bool = true,
                                       file: StaticString = #file,
                                       line: UInt = #line) {
    switch left {
    case let .value(o):
      self.assertIsEqual(py,
                         left: o,
                         right: right,
                         message: message,
                         expected: expected,
                         file: file,
                         line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Left is error: \(reason)", file: file, line: line)
      return
    }
  }

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: PyResultGen<L>,
                                                         right: R,
                                                         message: String? = nil,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    switch left {
    case let .value(o):
      self.assertIsEqual(py,
                         left: o,
                         right: right,
                         message: message,
                         expected: expected,
                         file: file,
                         line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Left is error: \(reason)", file: file, line: line)
      return
    }
  }

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: L,
                                                         right: R,
                                                         message: String? = nil,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    let prefix = message.map { $0 + ": " } ?? ""

    switch py.isEqualBool(left: left.asObject, right: right.asObject) {
    case let .value(bool):
      // Doing 'if' gives better error messages than 'XCTAssertEqual'.
      if expected {
        XCTAssertTrue(bool, "\(prefix)\(left) == \(right)", file: file, line: line)
      } else {
        XCTAssertFalse(bool, "\(prefix)\(left) != \(right)", file: file, line: line)
      }
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is equal error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Not equal

  func assertIsNotEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                            left: L,
                                                            right: R,
                                                            expected: Bool = true,
                                                            file: StaticString = #file,
                                                            line: UInt = #line) {
    switch py.isNotEqual(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is not equal error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Is true

  func assertIsTrue<T: PyObjectMixin>(_ py: Py,
                                      object: T,
                                      expected: Bool = true,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    switch py.isTrueBool(object: object.asObject) {
    case let .value(bool):
      XCTAssertEqual(bool, expected, "Is true", file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is true error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Type error

  func assertTypeError(_ py: Py,
                       error: PyResult,
                       message: String?,
                       file: StaticString = #file,
                       line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertTypeError(py, error: e, message: message, file: file, line: line)
    }
  }

  func assertTypeError<T>(_ py: Py,
                          error: PyResultGen<T>,
                          message: String?,
                          file: StaticString = #file,
                          line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertTypeError(py, error: e, message: message, file: file, line: line)
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

  // MARK: - Value error

  func assertValueError(_ py: Py,
                        error: PyResult,
                        message: String?,
                        file: StaticString = #file,
                        line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertValueError(py, error: e, message: message, file: file, line: line)
    }
  }

  func assertValueError<T>(_ py: Py,
                           error: PyResultGen<T>,
                           message: String?,
                           file: StaticString = #file,
                           line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertValueError(py, error: e, message: message, file: file, line: line)
    }
  }

  func assertValueError<T: PyErrorMixin>(_ py: Py,
                                         error: T,
                                         message: String?,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
    let isValueError = py.cast.isValueError(error.asObject)
    XCTAssert(isValueError,
              "'\(error.typeName)' is not a value error.",
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
}
