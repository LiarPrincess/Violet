import XCTest
import Foundation
import BigInt
import FileSystem
import VioletObjects // Do not add '@testable'! We want to do everything 'by the book'.

// swiftlint:disable function_parameter_count

extension PyTestCase {

  // MARK: - Properties

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        getter name: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    self.callPropertyExpectingInvalidSelfError(py,
                                               type: type,
                                               name: name,
                                               fn: .get,
                                               file: file,
                                               line: line)
  }

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        setter name: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    self.callPropertyExpectingInvalidSelfError(py,
                                               type: type,
                                               name: name,
                                               fn: .set,
                                               file: file,
                                               line: line)
  }

  private struct PropertyFunction {
    fileprivate static let get = PropertyFunction(name: "fget", argCount: 1)
    fileprivate static let set = PropertyFunction(name: "fset", argCount: 2)

    fileprivate let name: String
    fileprivate let argCount: Int
  }

  private func callPropertyExpectingInvalidSelfError(_ py: Py,
                                                     type: PyType,
                                                     name: String,
                                                     fn: PropertyFunction,
                                                     file: StaticString,
                                                     line: UInt) {
    // We have to get property from '__dict__', otherwise if the property
    // exists on 'type instance' we would get the value from the type.
    // For example: 'builtinFunction' has a '__name__' property.
    // If we tried to just 'type.__name__' we would get the name of the type.
    let typeDict = py.get__dict__(type: type).asObject
    let nameObject = py.newString(name).asObject

    let property: PyObject
    switch py.getItem(object: typeDict, index: nameObject) {
    case let .value(o):
      property = o
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Getting property failed: \(reason).", file: file, line: line)
      return
    }

    guard py.cast.isProperty(property) else {
      XCTFail("Not a property: \(property).", file: file, line: line)
      return
    }

    let propertyFn: PyObject
    switch py.getAttribute(object: property, name: fn.name, default: nil) {
    case let .value(o):
      propertyFn = o
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Getting '\(fn.name)' failed: \(reason).", file: file, line: line)
      return
    }

    let args = self.createArgs(py, type: type, count: fn.argCount)
    self.callExpectingInvalidSelfError(py,
                                       callable: propertyFn,
                                       args: args,
                                       kwargs: nil,
                                       expectedType: type,
                                       expectedFnName: name,
                                       file: file,
                                       line: line)
  }

  // MARK: - Methods

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        fn: String,
                                        positionalArgCount: Int,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    let args = self.createArgs(py, type: type, count: positionalArgCount)
    self.callMethodExpectingInvalidSelfError(py,
                                             type: type,
                                             fn: fn,
                                             args: args,
                                             file: file,
                                             line: line)
  }

  func assertInvalidSelfArgumentMessage(_ py: Py,
                                        type: PyType,
                                        argsKwargsFn fn: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    let invalidSelf = self.createInvalidSelfArg(py, type: type)
    let args = [invalidSelf]
    self.callMethodExpectingInvalidSelfError(py,
                                             type: type,
                                             fn: fn,
                                             args: args,
                                             file: file,
                                             line: line)
  }

  private func callMethodExpectingInvalidSelfError(_ py: Py,
                                                   type: PyType,
                                                   fn: String,
                                                   args: [PyObject],
                                                   file: StaticString,
                                                   line: UInt) {
    let typeObject = type.asObject
    let nameStr = py.newString(fn)

    let method: PyObject
    switch py.getMethod(object: typeObject, selector: nameStr, allowsCallableFromDict: true) {
    case .value(let o):
      method = o
    case .notFound:
      XCTFail("Method does not exist.", file: file, line: line)
      return
    case .error(let e):
      let reason = self.toString(py, error: e)
      XCTFail("Getting method failed: \(reason)", file: file, line: line)
      return
    }

    self.callExpectingInvalidSelfError(py,
                                       callable: method,
                                       args: args,
                                       kwargs: nil,
                                       expectedType: type,
                                       expectedFnName: fn,
                                       file: file,
                                       line: line)
  }

  // MARK: - Helpers

  private func createArgs(_ py: Py, type: PyType, count: Int) -> [PyObject] {
    let invalidSelf = self.createInvalidSelfArg(py, type: type)
    var result = [invalidSelf]

    for _ in 1..<count {
      result.append(py.none.asObject)
    }

    return result
  }

  private func createInvalidSelfArg(_ py: Py, type: PyType) -> PyObject {
    let isNone = type === py.types.none
    return isNone ? py.notImplemented.asObject : py.none.asObject
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
    XCTAssert(message.contains(typeName),
              "'\(typeName)' not in '\(message)'",
              file: file,
              line: line)

    XCTAssert(message.contains(expectedFnName),
              "'\(expectedFnName)' not in '\(message)'",
              file: file,
              line: line)
  }
}
