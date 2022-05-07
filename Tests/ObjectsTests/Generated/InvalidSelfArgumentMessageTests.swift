// ==============================================================================================
// Automatically generated from: /Tests/ObjectsTests/Generated/InvalidSelfArgumentMessageTests.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ==============================================================================================

import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

class InvalidSelfArgumentMessageTests: PyTestCase {

  func test_bool() {
    let py = self.createPy()
    let type = py.types.bool

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__and__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rand__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__or__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ror__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__xor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rxor__", positionalArgCount: 2)
  }

  func test_builtinFunction() {
    let py = self.createPy()
    let type = py.types.builtinFunction

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__name__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__qualname__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__text_signature__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__module__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__self__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__call__")
  }

  func test_builtinMethod() {
    let py = self.createPy()
    let type = py.types.builtinMethod

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__name__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__qualname__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__text_signature__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__module__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__self__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__call__")
  }

  func test_bytearray() {
    let py = self.createPy()
    let type = py.types.bytearray

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setitem__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isalnum", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isalpha", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isascii", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isdigit", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "islower", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isspace", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "istitle", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isupper", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "startswith", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "endswith", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "strip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "lstrip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rstrip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "find", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rfind", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "index", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rindex", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "lower", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "upper", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "title", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "swapcase", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "capitalize", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "center", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "ljust", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rjust", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "split")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "rsplit")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "splitlines")
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "partition", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rpartition", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "expandtabs", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "count", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "join", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "replace", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "zfill", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iadd__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__imul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "append", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "extend", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "insert", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "remove", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "pop", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "clear", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "reverse", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "copy", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_bytearray_iterator() {
    let py = self.createPy()
    let type = py.types.bytearray_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_bytes() {
    let py = self.createPy()
    let type = py.types.bytes

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isalnum", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isalpha", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isascii", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isdigit", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "islower", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isspace", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "istitle", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isupper", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "startswith", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "endswith", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "strip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "lstrip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rstrip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "find", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rfind", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "index", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rindex", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "lower", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "upper", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "title", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "swapcase", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "capitalize", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "center", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "ljust", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rjust", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "split")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "rsplit")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "splitlines")
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "partition", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rpartition", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "expandtabs", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "count", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "join", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "replace", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "zfill", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
  }

  func test_bytes_iterator() {
    let py = self.createPy()
    let type = py.types.bytes_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_callable_iterator() {
    let py = self.createPy()
    let type = py.types.callable_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
  }

  func test_cell() {
    let py = self.createPy()
    let type = py.types.cell

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
  }

  func test_classmethod() {
    let py = self.createPy()
    let type = py.types.classmethod

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__func__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__isabstractmethod__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_code() {
    let py = self.createPy()
    let type = py.types.code

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_name")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_filename")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_firstlineno")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_argcount")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_posonlyargcount")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_kwonlyargcount")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "co_nlocals")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
  }

  func test_complex() {
    let py = self.createPy()
    let type = py.types.complex

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "real")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "imag")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__bool__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__int__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__float__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "conjugate", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__pos__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__neg__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__abs__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__radd__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__sub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rsub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__pow__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rpow__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__truediv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rtruediv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__floordiv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rfloordiv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__divmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rdivmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getnewargs__", positionalArgCount: 1)
  }

  func test_dict() {
    let py = self.createPy()
    let type = py.types.dict

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setitem__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "get")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "setdefault")
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "clear", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "update")
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "copy", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "pop", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "popitem", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "keys", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "items", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "values", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_dict_itemiterator() {
    let py = self.createPy()
    let type = py.types.dict_itemiterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_dict_items() {
    let py = self.createPy()
    let type = py.types.dict_items

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
  }

  func test_dict_keyiterator() {
    let py = self.createPy()
    let type = py.types.dict_keyiterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_dict_keys() {
    let py = self.createPy()
    let type = py.types.dict_keys

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
  }

  func test_dict_valueiterator() {
    let py = self.createPy()
    let type = py.types.dict_valueiterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_dict_values() {
    let py = self.createPy()
    let type = py.types.dict_values

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
  }

  func test_ellipsis() {
    let py = self.createPy()
    let type = py.types.ellipsis

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__reduce__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
  }

  func test_enumerate() {
    let py = self.createPy()
    let type = py.types.enumerate

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
  }

  func test_filter() {
    let py = self.createPy()
    let type = py.types.filter

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
  }

  func test_float() {
    let py = self.createPy()
    let type = py.types.float

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "real")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "imag")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__bool__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__int__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__float__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "conjugate", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__pos__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__neg__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__abs__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "is_integer", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "as_integer_ratio", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__radd__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__sub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rsub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__pow__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rpow__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__truediv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rtruediv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__floordiv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rfloordiv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__divmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rdivmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__round__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__trunc__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "hex", positionalArgCount: 1)
  }

  func test_frame() {
    let py = self.createPy()
    let type = py.types.frame

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_back")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_builtins")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_globals")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_locals")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_code")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_lasti")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "f_lineno")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setattr__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delattr__", positionalArgCount: 2)
  }

  func test_frozenset() {
    let py = self.createPy()
    let type = py.types.frozenset

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__and__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rand__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__or__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ror__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__xor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rxor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__sub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rsub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "issubset", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "issuperset", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isdisjoint", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "intersection", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "union", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "difference", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "symmetric_difference", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "copy", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
  }

  func test_function() {
    let py = self.createPy()
    let type = py.types.function

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__name__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__name__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__qualname__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__qualname__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__defaults__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__defaults__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__kwdefaults__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__kwdefaults__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__closure__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__closure__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__globals__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__globals__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__annotations__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__annotations__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__code__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__code__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__module__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__module__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__call__")
  }

  func test_int() {
    let py = self.createPy()
    let type = py.types.int

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "real")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "imag")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "numerator")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "denominator")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__bool__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__int__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__float__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__index__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "conjugate", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__pos__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__neg__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__invert__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__abs__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__trunc__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__floor__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ceil__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__radd__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__sub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rsub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "bit_length", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__pow__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rpow__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__truediv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rtruediv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__floordiv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rfloordiv__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__divmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rdivmod__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lshift__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rlshift__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rshift__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rrshift__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__and__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rand__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__or__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ror__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__xor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rxor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__round__", positionalArgCount: 2)
  }

  func test_iterator() {
    let py = self.createPy()
    let type = py.types.iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_list() {
    let py = self.createPy()
    let type = py.types.list

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "count", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "index", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__reversed__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setitem__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "append", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "insert", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "extend", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "remove", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "pop", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "sort")
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "reverse", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "clear", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "copy", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iadd__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__imul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_list_iterator() {
    let py = self.createPy()
    let type = py.types.list_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_list_reverseiterator() {
    let py = self.createPy()
    let type = py.types.list_reverseiterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_map() {
    let py = self.createPy()
    let type = py.types.map

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
  }

  func test_method() {
    let py = self.createPy()
    let type = py.types.method

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__doc__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setattr__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delattr__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__func__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__self__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__call__")
  }

  func test_module() {
    let py = self.createPy()
    let type = py.types.module

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setattr__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delattr__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__dir__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_SimpleNamespace() {
    let py = self.createPy()
    let type = py.types.simpleNamespace

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setattr__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delattr__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_NoneType() {
    let py = self.createPy()
    let type = py.types.none

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__bool__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
  }

  func test_NotImplementedType() {
    let py = self.createPy()
    let type = py.types.notImplemented

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
  }

  func test_property() {
    let py = self.createPy()
    let type = py.types.property

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "fget")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "fset")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "fdel")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__doc__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__set__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delete__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "getter", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "setter", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "deleter", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_range() {
    let py = self.createPy()
    let type = py.types.range

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "start")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "stop")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "step")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__bool__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__reversed__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "count", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "index", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__reduce__")
  }

  func test_range_iterator() {
    let py = self.createPy()
    let type = py.types.range_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_reversed() {
    let py = self.createPy()
    let type = py.types.reversed

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_set() {
    let py = self.createPy()
    let type = py.types.set

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__and__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rand__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__or__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ror__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__xor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rxor__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__sub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rsub__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "issubset", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "issuperset", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isdisjoint", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "intersection", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "union", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "difference", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "symmetric_difference", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "add", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "update", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "remove", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "discard", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "clear", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "copy", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "pop", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_set_iterator() {
    let py = self.createPy()
    let type = py.types.set_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_slice() {
    let py = self.createPy()
    let type = py.types.slice

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "start")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "stop")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "step")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "indices", positionalArgCount: 2)
  }

  func test_staticmethod() {
    let py = self.createPy()
    let type = py.types.staticmethod

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__func__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__isabstractmethod__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_str() {
    let py = self.createPy()
    let type = py.types.str

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isalnum", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isalpha", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isascii", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isdecimal", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isdigit", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isidentifier", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "islower", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isnumeric", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isprintable", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isspace", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "istitle", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "isupper", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "startswith", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "endswith", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "strip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "lstrip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rstrip", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "find", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rfind", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "index", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rindex", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "lower", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "upper", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "title", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "swapcase", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "capitalize", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "casefold", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "center", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "ljust", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rjust", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "split")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "rsplit")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "splitlines")
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "partition", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "rpartition", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "expandtabs", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "count", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "join", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "replace", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "zfill", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
  }

  func test_str_iterator() {
    let py = self.createPy()
    let type = py.types.str_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_super() {
    let py = self.createPy()
    let type = py.types.super

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__thisclass__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__self__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__self_class__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__get__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_TextFile() {
    let py = self.createPy()
    let type = py.types.textFile

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "readable", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "readline", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "read", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "writable", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "write", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "flush", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "closed", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "close", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__del__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__enter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__exit__", positionalArgCount: 4)
  }

  func test_traceback() {
    let py = self.createPy()
    let type = py.types.traceback

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "tb_frame")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "tb_lasti")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "tb_lineno")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "tb_next")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "tb_next")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__dir__", positionalArgCount: 1)
  }

  func test_tuple() {
    let py = self.createPy()
    let type = py.types.tuple

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__eq__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ne__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__lt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__le__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__gt__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__ge__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__hash__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__len__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__contains__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "count", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "index", positionalArgCount: 4)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getitem__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__add__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__mul__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__rmul__", positionalArgCount: 2)
  }

  func test_tuple_iterator() {
    let py = self.createPy()
    let type = py.types.tuple_iterator

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__length_hint__", positionalArgCount: 1)
  }

  func test_type() {
    let py = self.createPy()
    let type = py.types.type

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__name__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__name__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__qualname__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__qualname__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__doc__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__module__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__module__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__base__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__bases__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__bases__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__mro__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "mro", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__subclasscheck__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__instancecheck__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__subclasses__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setattr__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delattr__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__dir__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__call__")
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_zip() {
    let py = self.createPy()
    let type = py.types.zip

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__iter__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__next__", positionalArgCount: 1)
  }

  func test_ArithmeticError() {
    let py = self.createPy()
    let type = py.errorTypes.arithmeticError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_AssertionError() {
    let py = self.createPy()
    let type = py.errorTypes.assertionError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_AttributeError() {
    let py = self.createPy()
    let type = py.errorTypes.attributeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_BaseException() {
    let py = self.createPy()
    let type = py.errorTypes.baseException

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "args")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "args")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__traceback__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__traceback__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__cause__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__cause__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__context__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__context__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__suppress_context__")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "__suppress_context__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__repr__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__getattribute__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__setattr__", positionalArgCount: 3)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__delattr__", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "with_traceback", positionalArgCount: 2)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_BlockingIOError() {
    let py = self.createPy()
    let type = py.errorTypes.blockingIOError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_BrokenPipeError() {
    let py = self.createPy()
    let type = py.errorTypes.brokenPipeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_BufferError() {
    let py = self.createPy()
    let type = py.errorTypes.bufferError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_BytesWarning() {
    let py = self.createPy()
    let type = py.errorTypes.bytesWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ChildProcessError() {
    let py = self.createPy()
    let type = py.errorTypes.childProcessError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ConnectionAbortedError() {
    let py = self.createPy()
    let type = py.errorTypes.connectionAbortedError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ConnectionError() {
    let py = self.createPy()
    let type = py.errorTypes.connectionError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ConnectionRefusedError() {
    let py = self.createPy()
    let type = py.errorTypes.connectionRefusedError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ConnectionResetError() {
    let py = self.createPy()
    let type = py.errorTypes.connectionResetError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_DeprecationWarning() {
    let py = self.createPy()
    let type = py.errorTypes.deprecationWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_EOFError() {
    let py = self.createPy()
    let type = py.errorTypes.eofError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_Exception() {
    let py = self.createPy()
    let type = py.errorTypes.exception

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_FileExistsError() {
    let py = self.createPy()
    let type = py.errorTypes.fileExistsError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_FileNotFoundError() {
    let py = self.createPy()
    let type = py.errorTypes.fileNotFoundError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_FloatingPointError() {
    let py = self.createPy()
    let type = py.errorTypes.floatingPointError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_FutureWarning() {
    let py = self.createPy()
    let type = py.errorTypes.futureWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_GeneratorExit() {
    let py = self.createPy()
    let type = py.errorTypes.generatorExit

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ImportError() {
    let py = self.createPy()
    let type = py.errorTypes.importError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "msg")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "msg")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "name")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "name")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "path")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "path")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ImportWarning() {
    let py = self.createPy()
    let type = py.errorTypes.importWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_IndentationError() {
    let py = self.createPy()
    let type = py.errorTypes.indentationError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_IndexError() {
    let py = self.createPy()
    let type = py.errorTypes.indexError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_InterruptedError() {
    let py = self.createPy()
    let type = py.errorTypes.interruptedError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_IsADirectoryError() {
    let py = self.createPy()
    let type = py.errorTypes.isADirectoryError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_KeyError() {
    let py = self.createPy()
    let type = py.errorTypes.keyError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_KeyboardInterrupt() {
    let py = self.createPy()
    let type = py.errorTypes.keyboardInterrupt

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_LookupError() {
    let py = self.createPy()
    let type = py.errorTypes.lookupError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_MemoryError() {
    let py = self.createPy()
    let type = py.errorTypes.memoryError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ModuleNotFoundError() {
    let py = self.createPy()
    let type = py.errorTypes.moduleNotFoundError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_NameError() {
    let py = self.createPy()
    let type = py.errorTypes.nameError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_NotADirectoryError() {
    let py = self.createPy()
    let type = py.errorTypes.notADirectoryError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_NotImplementedError() {
    let py = self.createPy()
    let type = py.errorTypes.notImplementedError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_OSError() {
    let py = self.createPy()
    let type = py.errorTypes.osError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_OverflowError() {
    let py = self.createPy()
    let type = py.errorTypes.overflowError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_PendingDeprecationWarning() {
    let py = self.createPy()
    let type = py.errorTypes.pendingDeprecationWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_PermissionError() {
    let py = self.createPy()
    let type = py.errorTypes.permissionError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ProcessLookupError() {
    let py = self.createPy()
    let type = py.errorTypes.processLookupError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_RecursionError() {
    let py = self.createPy()
    let type = py.errorTypes.recursionError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ReferenceError() {
    let py = self.createPy()
    let type = py.errorTypes.referenceError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ResourceWarning() {
    let py = self.createPy()
    let type = py.errorTypes.resourceWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_RuntimeError() {
    let py = self.createPy()
    let type = py.errorTypes.runtimeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_RuntimeWarning() {
    let py = self.createPy()
    let type = py.errorTypes.runtimeWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_StopAsyncIteration() {
    let py = self.createPy()
    let type = py.errorTypes.stopAsyncIteration

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_StopIteration() {
    let py = self.createPy()
    let type = py.errorTypes.stopIteration

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "value")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "value")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_SyntaxError() {
    let py = self.createPy()
    let type = py.errorTypes.syntaxError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "msg")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "msg")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "filename")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "filename")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "lineno")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "lineno")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "offset")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "offset")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "text")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "text")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "print_file_and_line")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "print_file_and_line")

    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "__str__", positionalArgCount: 1)
    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_SyntaxWarning() {
    let py = self.createPy()
    let type = py.errorTypes.syntaxWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_SystemError() {
    let py = self.createPy()
    let type = py.errorTypes.systemError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_SystemExit() {
    let py = self.createPy()
    let type = py.errorTypes.systemExit

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")
    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "code")
    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "code")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_TabError() {
    let py = self.createPy()
    let type = py.errorTypes.tabError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_TimeoutError() {
    let py = self.createPy()
    let type = py.errorTypes.timeoutError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_TypeError() {
    let py = self.createPy()
    let type = py.errorTypes.typeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UnboundLocalError() {
    let py = self.createPy()
    let type = py.errorTypes.unboundLocalError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UnicodeDecodeError() {
    let py = self.createPy()
    let type = py.errorTypes.unicodeDecodeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UnicodeEncodeError() {
    let py = self.createPy()
    let type = py.errorTypes.unicodeEncodeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UnicodeError() {
    let py = self.createPy()
    let type = py.errorTypes.unicodeError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UnicodeTranslateError() {
    let py = self.createPy()
    let type = py.errorTypes.unicodeTranslateError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UnicodeWarning() {
    let py = self.createPy()
    let type = py.errorTypes.unicodeWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_UserWarning() {
    let py = self.createPy()
    let type = py.errorTypes.userWarning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ValueError() {
    let py = self.createPy()
    let type = py.errorTypes.valueError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_Warning() {
    let py = self.createPy()
    let type = py.errorTypes.warning

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }

  func test_ZeroDivisionError() {
    let py = self.createPy()
    let type = py.errorTypes.zeroDivisionError

    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "__dict__")

    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "__init__")
  }
}
