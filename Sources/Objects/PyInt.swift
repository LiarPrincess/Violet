import Foundation
import Core

// TODO: Add predefined values (-5, 257) + other types

public class PyInt: PyObject {

  internal var value: BigInt

  internal init(type: PyIntType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }
}

public class PyIntType: PyType, ContextOwner,
  ReprConvertibleTypeClass, StrConvertibleTypeClass,
  ComparableTypeClass, HashableTypeClass,

  SignedNumberTypeClass,
  AbsoluteNumberTypeClass,
  AdditiveTypeClass, SubtractiveTypeClass,
  MultiplicativeTypeClass, PowerTypeClass,
  DividableTypeClass, FloorDividableTypeClass, RemainderTypeClass, DivModTypeClass,
  PyBoolConvertibleTypeClass, PyIntConvertibleTypeClass, PyFloatConvertibleTypeClass,
  InvertNumberTypeClass,
  ShiftableTypeClass,
  BinaryTypeClass {

  public var name: String  { return "int" }
  public var base: PyType? { return nil }
  public var doc:  String  { return """
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

  public unowned let context: Context

  public init(context: Context) {
    self.context = context
  }

  // MARK: - Ctors

  public func new(_ value: BigInt) -> PyInt {
    return PyInt(type: self, value: value)
  }

  // MARK: - String

  public func repr(value: PyObject) throws -> String {
    let v = try self.extractInt(value)
    return String(describing: v)
  }

  public func str(value: PyObject) throws -> String {
    return try self.repr(value: value)
  }

  // MARK: - Equatable, hashable

  public func compare(left: PyObject, right: PyObject, x: Int) throws -> PyObject {
    fatalError()
  }

  public func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    fatalError()
  }

  // MARK: - Conversion

  public func bool(value: PyObject) throws -> PyBool {
    let v = try self.extractInt(value)
    return v.isZero ? self.context.false : self.context.true
  }

  public func int(value: PyObject) throws -> PyInt {
    return try self.matchType(value)
  }

  public func float(value: PyObject) throws -> PyFloat {
    let v = try self.extractInt(value)
    return self.types.float.new(Double(v))
  }

  // MARK: - Signed number

  public func positive(value: PyObject) throws -> PyObject {
    return try self.matchType(value)
  }

  public func negative(value: PyObject) throws -> PyObject {
    let v = try self.extractInt(value)
    return self.new(-v)
  }

  // MARK: - Add, sub

  public func add(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l + r)
  }

  public func sub(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l - r)
  }

  // MARK: - Mul

  public func mul(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l * r)
  }

  // MARK: - Div

  public func div(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw ObjectError.intDivisionByZero
    }

    return self.types.float.new(Double(l) / Double(r))
  }

  public func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw ObjectError.intDivisionByZero
    }

    return self.new(l / r)
  }

  public func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw ObjectError.intModuloZero
    }

    return self.new(l % r)
  }

  public func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    if r.isZero {
      throw ObjectError.intDivModZero
    }

    let remainder = l % r
    let quotient = l / r
    return self.types.tuple.new(self.new(quotient), self.new(remainder))
  }

  // MARK: - Abs

  public func abs(value: PyObject) throws -> PyObject {
    let v = try self.extractInt(value)
    return self.new(Swift.abs(v))
  }

  // MARK: - Power

  public func pow(left: PyObject, right: PyObject) throws -> PyObject {
    fatalError()
  }

  // MARK: - Shift

  public func lShift(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    guard r > 0 else {
      throw ObjectError.negativeShiftCount
    }

    return self.new(l << r)
  }

  public func rShift(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)

    guard r > 0 else {
      throw ObjectError.negativeShiftCount
    }

    return self.new(l >> r)
  }

  // MARK: - Binary

  public func and(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l & r)
  }

  public func or(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l | r)
  }

  public func xor(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extractInt(left)
    let r = try self.extractInt(right)
    return self.new(l ^ r)
  }

  public func invert(value: PyObject) throws -> PyObject {
    let v = try self.extractInt(value)
    return self.new(~v)
  }

  // MARK: - Helpers

  private func matchType(_ object: PyObject) throws -> PyInt {
    if let int = object as? PyInt {
      return int
    }

    throw ObjectError.invalidTypeConversion(object: object, to: self)
  }

  internal func extractIntOrNil(_ object: PyObject) -> BigInt? {
    let i = object as? PyInt
    return i.map { $0.value }
  }

  internal func extractInt(_ object: PyObject) throws -> BigInt {
    if let i = object as? PyInt {
      return i.value
    }

    throw ObjectError.invalidTypeConversion(object: object, to: self)
  }
}
