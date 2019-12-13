import Bytecode
import Objects

extension Frame {

  /// Used for implementing formatted literal strings (f-strings).
  /// (And yes, Swift will pack both payloads in single byte).
  internal func formatValue(conversion: StringConversion,
                            hasFormat: Bool) -> InstructionResult {
    let format: PyObject? = hasFormat ? self.stack.pop() : nil
    let rawValue = self.stack.pop()

    let value: PyObject
    switch self.convert(value: rawValue, conversion: conversion) {
    case let .value(o): value = o
    case let .error(e): return .builtinError(e)
    }

    if let format = format {
      let formatted = self.context.PyObject_Format(value: value, format: format)
      self.stack.push(formatted)
    } else {
      // TODO: Make sure that this is string
      self.stack.push(value)
    }

    return .ok
  }

  private func convert(value: PyObject,
                       conversion: StringConversion) -> PyResult<PyObject> {
    switch conversion {
    case .none:
      return .value(value)
    case .str:
      return self.builtins.strValue(value).map(self.builtins.newString)
    case .repr:
      return self.builtins.repr(value).map(self.builtins.newString)
    case .ascii:
      return self.builtins.ascii(value).map(self.builtins.newString)
    }
  }

  /// Concatenates `count` strings from the stack
  /// and pushes the resulting string onto the stack.
  internal func buildString(count: Int) -> InstructionResult {
    let empty = self.builtins.emptyString
    let elements = self.stack.popElementsInPushOrder(count: count)

    switch self.builtins.join(strings: elements, separator: empty) {
    case let .value(r):
      self.stack.push(r)
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }
}
