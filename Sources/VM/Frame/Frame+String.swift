import Bytecode
import Objects

extension Frame {

  /// Used for implementing formatted literal strings (f-strings).
  /// (And yes, Swift will pack both payloads in single byte).
  internal func formatValue(conversion: StringConversion, hasFormat: Bool) throws {
    let format: PyObject? = hasFormat ? self.pop() : nil
    let rawValue = self.pop()
    let value = try self.convert(value: rawValue, conversion: conversion)

    if let format = format {
      let formatted = self.context.PyObject_Format(value: value, format: format)
      self.push(formatted)
    } else {
      // TODO: Make sure that this is string
      self.push(value)
    }
  }

  private func convert(value: PyObject,
                       conversion: StringConversion) throws -> PyObject {
    switch conversion {
    case .none:  return value
    case .str:   return self.context.str(value: value)
    case .repr:  return self.context.repr(value: value)
    case .ascii: return self.context.ascii(value: value)
    }
  }

  /// Concatenates `count` strings from the stack
  /// and pushes the resulting string onto the stack.
  internal func buildString(count: Int) throws {
    let elements = self.popElements(count: count)
    let str = self.context._PyUnicode_JoinArray(elements: elements)
    self.push(str)
  }
}
