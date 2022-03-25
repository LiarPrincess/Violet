import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Format

  internal typealias StringConversion = Instruction.StringConversion

  /// Used for implementing formatted literal strings (f-strings).
  internal func formatValue(conversion: StringConversion,
                            hasFormat: Bool) -> InstructionResult {
    let format: PyObject? = hasFormat ? self.stack.pop() : nil
    let objectFromStack = self.stack.pop()

    let object: PyObject
    switch self.convert(object: objectFromStack, conversion: conversion) {
    case let .value(o): object = o
    case let .error(e): return .exception(e)
    }

    if self.py.cast.isString(object) && format == nil {
      self.stack.push(object)
      return .ok
    }

    switch self.format(object: object, format: format) {
    case let .value(pyString):
      self.stack.push(pyString.asObject)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func convert(object: PyObject, conversion: StringConversion) -> PyResult {
    switch conversion {
    case .none:
      return .value(object)
    case .str:
      let result = self.py.str(object)
      return PyResult(result)
    case .repr:
      let result = self.py.repr(object)
      return PyResult(result)
    case .ascii:
      let result = self.py.ascii(object)
      return PyResult(result)
    }
  }

  // MARK: - Build

  /// Concatenates `count` strings from the stack
  /// and pushes the resulting string onto the stack.
  internal func buildString(count: Int) -> InstructionResult {
    let empty = self.py.emptyString.asObject
    let elements = self.stack.popElementsInPushOrder(count: count)

    switch self.py.join(strings: elements, separator: empty) {
    case let .value(pyString):
      self.stack.push(pyString.asObject)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
