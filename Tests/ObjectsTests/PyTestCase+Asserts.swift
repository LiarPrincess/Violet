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

    let expected = py.newInt(value).asObject
    self.assertIsEqual(py, left: object, right: expected, file: file, line: line)
  }

  // MARK: - Float

  func assertFloat(_ py: Py,
                   object: PyResult<PyObject>,
                   value: Double,
                   file: StaticString = #file,
                   line: UInt = #line) {
    if let object = self.unwrapResult(py, result: object, file: file, line: line) {
      self.assertFloat(py, object: object, value: value, file: file, line: line)
    }
  }

  func assertFloat(_ py: Py,
                   object: PyObject,
                   value: Double,
                   file: StaticString = #file,
                   line: UInt = #line) {
    guard py.cast.isFloat(object) else {
      XCTFail("Got '\(object.typeName)' instead of 'float'.", file: file, line: line)
      return
    }

    let expected = py.newFloat(value).asObject
    self.assertIsEqual(py, left: object, right: expected, file: file, line: line)
  }

  // MARK: - Tuple

  func assertTuple(_ py: Py,
                   object: PyResult<PyObject>,
                   elements: [PyObject],
                   file: StaticString = #file,
                   line: UInt = #line) {
    if let object = self.unwrapResult(py, result: object, file: file, line: line) {
      self.assertTuple(py, object: object, elements: elements, file: file, line: line)
    }
  }

  func assertTuple(_ py: Py,
                   object: PyObject,
                   elements: [PyObject],
                   file: StaticString = #file,
                   line: UInt = #line) {
    guard py.cast.isTuple(object) else {
      XCTFail("Got '\(object.typeName)' instead of 'tuple'.", file: file, line: line)
      return
    }

    let expected = py.newTuple(elements: elements)
    self.assertIsEqual(py, left: object, right: expected, file: file, line: line)
  }

  // MARK: - Equal

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: L?,
                                                         right: R,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    guard let left = left else {
      XCTFail("Left is '.none'", file: file, line: line)
      return
    }

    self.assertIsEqual(py, left: left, right: right, expected: expected, file: file, line: line)
  }

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: PyResult<L>,
                                                         right: R,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    switch left {
    case let .value(o):
      self.assertIsEqual(py, left: o, right: right, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Left is error: \(reason)", file: file, line: line)
      return
    }
  }

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: L,
                                                         right: R,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {


    switch py.isEqualBool(left: left.asObject, right: right.asObject) {
    case let .value(bool):
      // Doing 'if' gives better error messages than 'XCTAssertEqual'.
      if expected {
        XCTAssertTrue(bool, "\(left) == \(right)", file: file, line: line)
      } else {
        XCTAssertFalse(bool, "\(left) != \(right)", file: file, line: line)
      }
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Not equal error: \(reason)", file: file, line: line)
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
      XCTFail("Not equal error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Compare

  func assertIsLess<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                        left: L,
                                                        right: R,
                                                        expected: Bool = true,
                                                        file: StaticString = #file,
                                                        line: UInt = #line) {
    switch py.isLess(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is less error: \(reason)", file: file, line: line)
    }
  }

  func assertIsLessEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                             left: L,
                                                             right: R,
                                                             expected: Bool = true,
                                                             file: StaticString = #file,
                                                             line: UInt = #line) {
    switch py.isLessEqual(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is less equal error: \(reason)", file: file, line: line)
    }
  }

  func assertIsGreater<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                           left: L,
                                                           right: R,
                                                           expected: Bool = true,
                                                           file: StaticString = #file,
                                                           line: UInt = #line) {
    switch py.isGreater(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is greater error: \(reason)", file: file, line: line)
    }
  }

  func assertIsGreaterEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                                left: L,
                                                                right: R,
                                                                expected: Bool = true,
                                                                file: StaticString = #file,
                                                                line: UInt = #line) {
    switch py.isGreaterEqual(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is greater equal error: \(reason)", file: file, line: line)
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
}
