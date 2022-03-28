import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable line_length
// swiftlint:disable function_body_length

class PyTypeTests: PyTestCase {

  // MARK: - Builtin types

  func test_builtinTypes() {
    let py = self.createPy()

    let object = py.types.object
    self.assertName(py, object, "object")
    self.assertDoc(py, object, "The most base type")
    self.assertType(py, object)
    self.assertModule(py, object)
    self.assertBase(py, object, nil)
    self.assertBases(py, object, [])
    self.assertMro(py, object, [object])

    let type = py.types.type
    self.assertName(py, type, "type")
    self.assertDoc(py, type, "type(object_or_name, bases, dict)\ntype(object) -> the object's type\ntype(name, bases, dict) -> a new type")
    self.assertType(py, type)
    self.assertModule(py, type)
    self.assertBase(py, type, object)
    self.assertBases(py, type, [object])
    self.assertMro(py, type, [type, object])

    let int = py.types.int
    self.assertName(py, int, "int")
    self.assertDoc(py, int, "int([x]) -> integer\nint(x, base=10) -> integer\n\nConvert a number or string to an integer, or return 0 if no arguments\nare given.  If x is a number, return x.__int__().  For floating point\nnumbers, this truncates towards zero.\n\nIf x is not a number or if base is given, then x must be a string,\nbytes, or bytearray instance representing an integer literal in the\ngiven base.  The literal can be preceded by '+' or '-' and be surrounded\nby whitespace.  The base defaults to 10.  Valid bases are 0 and 2-36.\nBase 0 means to interpret the base from the string as an integer literal.\n>>> int('0b100', base=0)\n4")
    self.assertType(py, int)
    self.assertModule(py, int)
    self.assertBase(py, int, object)
    self.assertBases(py, int, [object])
    self.assertMro(py, int, [int, object])

    let bool = py.types.bool
    self.assertName(py, bool, "bool")
    self.assertDoc(py, bool, "bool(x) -> bool\n\nReturns True when the argument x is true, False otherwise.\nThe builtins True and False are the only two instances of the class bool.\nThe class bool is a subclass of the class int, and cannot be subclassed.")
    self.assertType(py, bool)
    self.assertModule(py, bool)
    self.assertBase(py, bool, int)
    self.assertBases(py, bool, [int])
    self.assertMro(py, bool, [bool, int, object])
  }

  // MARK: - Description

  func test_description() {
    let py = self.createPy()

    let object = py.types.object
    self.assertDescription(object, "PyType(type, flags: [custom1, custom5, custom21], name: 'object', qualname: 'object')")

    let type = py.types.type
    self.assertDescription(type, "PyType(type, flags: [custom1, custom2, custom5, custom15, custom20], name: 'type', qualname: 'type')")

    let int = py.types.int
    self.assertDescription(int, "PyType(type, flags: [custom1, custom5, custom8, custom21], name: 'int', qualname: 'int')")

    let bool = py.types.bool
    self.assertDescription(bool, "PyType(type, flags: [custom5, custom8], name: 'bool', qualname: 'bool')")
  }

  // MARK: - Asserts

  private func assertName(_ py: Py,
                          _ type: PyType,
                          _ expected: String,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let object = py.newString(expected).asObject

    let name = self.get(py, object: type, propertyName: "__name__")
    self.assertIsEqual(py, left: name, right: object, file: file, line: line)

    let qualname = self.get(py, object: type, propertyName: "__qualname__")
    self.assertIsEqual(py, left: qualname, right: object, file: file, line: line)
  }

  private func assertDoc(_ py: Py,
                         _ type: PyType,
                         _ expected: String,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let object = py.newString(expected).asObject
    let doc = self.get(py, object: type, propertyName: "__doc__")
    self.assertIsEqual(py, left: doc, right: object, file: file, line: line)
  }

  private func assertType(_ py: Py,
                          _ type: PyType,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let object = py.types.type
    let typeType = self.get(py, object: type, propertyName: "__class__")
    self.assertIsEqual(py, left: typeType, right: object, file: file, line: line)
  }

  private func assertModule(_ py: Py,
                            _ type: PyType,
                            file: StaticString = #file,
                            line: UInt = #line) {
    let object = py.intern(string: "builtins")
    let module = self.get(py, object: type, propertyName: "__module__")
    self.assertIsEqual(py, left: module, right: object, file: file, line: line)
  }

  private func assertBase(_ py: Py,
                          _ type: PyType,
                          _ expected: PyType?,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let object = expected.map { $0.asObject } ?? py.none.asObject
    let base = self.get(py, object: type, propertyName: "__base__")
    self.assertIsEqual(py, left: base, right: object, file: file, line: line)
  }

  private func assertBases(_ py: Py,
                           _ type: PyType,
                           _ expected: [PyType],
                           file: StaticString = #file,
                           line: UInt = #line) {
    let object = py.newTuple(elements: expected.map { $0.asObject })
    let bases = self.get(py, object: type, propertyName: "__bases__")
    self.assertIsEqual(py, left: bases, right: object, file: file, line: line)
  }

  private func assertMro(_ py: Py,
                         _ type: PyType,
                         _ expected: [PyType],
                         file: StaticString = #file,
                         line: UInt = #line) {
    let expectedElements = expected.map { $0.asObject }

    let tuple = py.newTuple(elements: expectedElements)
    let __mro__ = self.get(py, object: type, propertyName: "__mro__")
    self.assertIsEqual(py, left: __mro__, right: tuple, file: file, line: line)

    let list = py.newList(elements: expectedElements)
    let mro = self.callMethod(py, object: type, selector: "mro", args: [])
    self.assertIsEqual(py, left: mro, right: list, file: file, line: line)
  }
}
