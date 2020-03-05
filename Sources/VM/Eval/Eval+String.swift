import Bytecode
import Objects

extension Eval {

  // MARK: - Format

  /// Used for implementing formatted literal strings (f-strings).
  internal func formatValue(conversion: StringConversion,
                            hasFormat: Bool) -> InstructionResult {
    let format: PyObject? = hasFormat ? self.stack.pop() : nil
    let rawValue = self.stack.pop()

    let value: PyObject
    switch self.convert(value: rawValue, conversion: conversion) {
    case let .value(o): value = o
    case let .error(e): return .unwind(.exception(e))
    }

    if value is PyString && format == nil {
      self.stack.push(value)
      return .ok
    }

    let formatted = Py.PyObject_Format(value: value, format: format)
    self.stack.push(formatted)

    return .ok
  }

  private func convert(value: PyObject,
                       conversion: StringConversion) -> PyResult<PyObject> {
    switch conversion {
    case .none:
      return .value(value)
    case .str:
      return Py.strValue(value).map(Py.newString)
    case .repr:
      return Py.repr(value).map(Py.newString)
    case .ascii:
      return Py.ascii(value).map(Py.newString)
    }
  }

  // MARK: - Build

  /// Concatenates `count` strings from the stack
  /// and pushes the resulting string onto the stack.
  internal func buildString(count: Int) -> InstructionResult {
    let empty = Py.emptyString
    let elements = self.stack.popElementsInPushOrder(count: count)

    switch Py.join(strings: elements, separator: empty) {
    case let .value(r):
      self.stack.push(r)
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }
}