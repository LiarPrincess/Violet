import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Format

  /// Used for implementing formatted literal strings (f-strings).
  internal func formatValue(conversion: Instruction.StringConversion,
                            hasFormat: Bool) -> InstructionResult {
    let format: PyObject? = hasFormat ? self.stack.pop() : nil
    let objectFromStack = self.stack.pop()

    let object: PyObject
    switch self.convert(object: objectFromStack, conversion: conversion) {
    case let .value(o): object = o
    case let .error(e): return .exception(e)
    }

    if PyCast.isString(object) && format == nil {
      self.stack.push(object)
      return .ok
    }

    switch self.format(object: object, format: format) {
    case let .value(o):
      self.stack.push(o)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func convert(
    object: PyObject,
    conversion: Instruction.StringConversion
  ) -> PyResult<PyObject> {
    switch conversion {
    case .none:
      return .value(object)
    case .str:
      return Py.str(object: object).map { $0 as PyObject }
    case .repr:
      return Py.repr(object: object).map { $0 as PyObject }
    case .ascii:
      return Py.ascii(object: object).map { $0 as PyObject }
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
      return .exception(e)
    }
  }
}
