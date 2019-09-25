import Foundation
import Core

// TODO: Add predefined values (-5, 257) + other types

internal class PyInt: PyObject {

  internal var value: BigInt

  internal init(type: PyIntType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }
}

internal class PyIntType: PyType,
  ReprConvertibleTypeClass, StrConvertibleTypeClass,
  ComparableTypeClass, HashableTypeClass,

  SignedNumberTypeClass,
  AbsoluteNumberTypeClass,
  AdditiveTypeClass, SubtractiveTypeClass,
  MultiplicativeTypeClass, PowerTypeClass,
  DividableTypeClass, FloorDividableTypeClass, RemainderTypeClass, DivModTypeClass,
  PyBoolConvertibleTypeClass, PyIntConvertibleTypeClass, PyFloatConvertibleTypeClass,
  InvertibleNumberTypeClass,
  ShiftableTypeClass,
  BinaryTypeClass {

  internal var name: String { return "int" }
  internal var base: PyType? { return nil }
  internal var doc:  String? { return """
int([x]) -> integer
int(x, base=10) -> integer

Convert a number or string to an integer, or return 0 if no arguments
are given.  If x is a number, return x.__int__().  For floating point
numbers, this truncates towards zero.

If x is not a number or if base is given, then x must be a string,
bytes, or bytearray instance representing an integer literal in the
given base.  The literal can be preceded by '+' or '-' and be surrounded
by whitespace.  The base defaults to 10.  Valid bases are 0 and 2-36.
Base 0 means to interpret the base from the string as an integer literal.
>>> int('0b100', base=0)
4
""" }

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  // MARK: - Ctors

  internal func new(_ value: BigInt) -> PyInt {
    return PyInt(type: self, value: value)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try self.extractInt(value)
    return String(describing: v)
  }

  internal func str(value: PyObject) throws -> String {
    return try self.repr(value: value)
  }

  // MARK: - Equatable, hashable

  internal func compare(left: PyObject, right: PyObject, x: Int) throws -> PyObject {
    fatalError()
  }

  internal func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    fatalError()
  }

  // MARK: - Conversion

  internal func bool(value: PyObject) throws -> PyBool {
    let v = try self.extractInt(value)
    return self.context.types.bool.new(!v.isZero)
  }

  internal func int(value: PyObject) throws -> PyInt {
    return try self.matchType(value)
  }

  internal func float(value: PyObject) throws -> PyFloat {
    let v = try self.extractInt(value)
    return self.context.types.float.new(Double(v))
  }

  // MARK: - Signed number

  internal func positive(value: PyObject) throws -> PyObject {
    return try self.matchType(value)
  }

  internal func negative(value: PyObject) throws -> PyObject {
    let v = try self.extractInt(value)
    return self.new(-v)
  }

  // MARK: - Add, sub

  internal func add(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l + r)
  }

  internal func sub(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l - r)
  }

  // MARK: - Mul

  internal func mul(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l * r)
  }

  // MARK: - Div

  internal func div(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw PyContextError.intDivisionByZero
    }

    return self.context.types.float.new(Double(l) / Double(r))
  }

  internal func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw PyContextError.intDivisionByZero
    }

    return self.new(l / r)
  }

  internal func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw PyContextError.intModuloZero
    }

    return self.new(l % r)
  }

  internal func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw PyContextError.intDivModZero
    }

    let remainder = l % r
    let quotient = l / r
    return self.context.types.tuple.new(self.new(quotient), self.new(remainder))
  }

  // MARK: - Abs

  internal func abs(value: PyObject) throws -> PyObject {
    let v = try self.extractInt(value)
    return self.new(Swift.abs(v))
  }

  // MARK: - Power

  internal func pow(left: PyObject, right: PyObject) throws -> PyObject {
    fatalError()
  }

  // MARK: - Shift

  internal func lShift(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    guard r > 0 else {
      throw PyContextError.negativeShiftCount
    }

    return self.new(l << r)
  }

  internal func rShift(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    guard r > 0 else {
      throw PyContextError.negativeShiftCount
    }

    return self.new(l >> r)
  }

  // MARK: - Binary

  internal func and(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l & r)
  }

  internal func or(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l | r)
  }

  internal func xor(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l ^ r)
  }

  internal func invert(value: PyObject) throws -> PyObject {
    let v = try self.extractInt(value)
    return self.new(~v)
  }

  // MARK: - Helpers

  private func matchType(_ object: PyObject) throws -> PyInt {
    if let int = object as? PyInt {
      return int
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }

  internal func extractIntOrNil(_ object: PyObject) -> BigInt? {
    let i = object as? PyInt
    return i.map { $0.value }
  }

  internal func extractInt(_ object: PyObject) throws -> BigInt {
    if let i = object as? PyInt {
      return i.value
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
