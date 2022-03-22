import XCTest
import Foundation
import BigInt
import FileSystem
import VioletObjects // Do not add '@testable'! We want to do everything 'by the book'.

extension PyTestCase {

  // MARK: - Property

  func get<T: PyObjectMixin>(_ py: Py,
                             object objectArg: T,
                             propertyName: String,
                             file: StaticString = #file,
                             line: UInt = #line) -> PyResult {
    let object = objectArg.asObject
    let propertyNameStr = py.newString(propertyName)
    return py.getAttribute(object: object, name: propertyNameStr, default: nil)
  }

  // MARK: - Call

  func callMethod<T: PyObjectMixin>(_ py: Py,
                                    object objectArg: T,
                                    selector: String,
                                    args: [PyObject],
                                    file: StaticString = #file,
                                    line: UInt = #line) -> PyResult {
    let object = objectArg.asObject
    let selectorStr = py.newString(selector)

    let result = py.callMethod(object: object,
                               selector: selectorStr,
                               args: args,
                               kwargs: nil)

    return result.asResult
  }

  // MARK: - Result

  func unwrapResult(_ py: Py,
                    result: PyResult,
                    file: StaticString = #file,
                    line: UInt = #line) -> PyObject? {
    switch result {
    case let .value(o):
      return o
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Result is error: \(reason)", file: file, line: line)
      return nil
    }
  }

  func unwrapResult<T>(_ py: Py,
                       result: PyResultGen<T>,
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

  func unwrapError(result: PyResult,
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

  func unwrapError<T>(result: PyResultGen<T>,
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

  // MARK: - Error + string

  func toString<T: PyErrorMixin>(_ py: Py, error: T) -> String {
    let typeName = error.typeName

    guard let message = self.getMessage(py, error: error) else {
      return typeName
    }

    switch py.strString(message.asObject) {
    case .value(let s):
      return s
    case .error:
      return typeName
    }
  }

  // MARK: - Error message

  func getMessageString<T: PyErrorMixin>(_ py: Py, error: T) -> String? {
    guard let message = self.getMessage(py, error: error) else {
      return nil
    }

    switch py.strString(message.asObject) {
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
