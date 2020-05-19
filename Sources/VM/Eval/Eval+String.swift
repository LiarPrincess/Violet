import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Format

  /// Used for implementing formatted literal strings (f-strings).
  internal func formatValue(conversion: Instruction.StringConversion,
                            hasFormat: Bool) -> InstructionResult {
    let format: PyObject? = hasFormat ? self.pop() : nil
    let rawValue = self.pop()

    let value: PyObject
    switch self.convert(value: rawValue, conversion: conversion) {
    case let .value(o): value = o
    case let .error(e): return .exception(e)
    }

    if value is PyString && format == nil {
      self.push(value)
      return .ok
    }

    switch self.format(value: value, format: format) {
    case let .value(o):
      self.push(o)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func convert(
    value: PyObject,
    conversion: Instruction.StringConversion
  ) -> PyResult<PyObject> {
    switch conversion {
    case .none:
      return .value(value)
    case .str:
      return Py.strValue(object: value).map(Py.newString)
    case .repr:
      return Py.repr(object: value).map(Py.newString)
    case .ascii:
      return Py.ascii(object: value).map(Py.newString)
    }
  }

  // MARK: - Build

  /// Concatenates `count` strings from the stack
  /// and pushes the resulting string onto the stack.
  internal func buildString(count: Int) -> InstructionResult {
    let empty = Py.emptyString
    let elements = self.popElementsInPushOrder(count: count)

    switch Py.join(strings: elements, separator: empty) {
    case let .value(r):
      self.push(r)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
