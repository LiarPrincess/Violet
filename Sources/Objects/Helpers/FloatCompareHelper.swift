import Foundation
import BigInt
import VioletCore

// swiftlint:disable type_name
// swiftlint:disable nesting
// cSpell:ignore floatobject

// Compare 'Double' to various Python objects.
// This is basically a nightmare, because whatever we do is wrong.
//
// In CPython:
// Objects -> floatobject.c
//   static PyObject* float_richcompare(PyObject *v, PyObject *w, int op)

// MARK: - Abstract

/// Private helper for comparison operations.
private protocol Abstract {
  /// Opposite compare. For example for `<` it will be `>`.
  associatedtype reflected: Abstract

  static func compare(left: BigInt, right: BigInt) -> Bool
  static func compare(left: Double, right: Double) -> Bool
}

private enum FloatSign: BigInt, Equatable {
  case plus = 1
  case minus = -1
  case zero = 0
}

extension Abstract {

  fileprivate static func compare(_ py: Py,
                                  left: Double,
                                  right: PyObject) -> CompareResult {
    // If both are floats then use standard Swift compare
    // (even if one of them is nan/inf/whatever).
    if let rightFloat = py.cast.asFloat(right) {
      let result = Self.compare(left: left, right: rightFloat.value)
      return .value(result)
    }

    // If 'left' is an infinity, it's magnitude exceeds any finite integer,
    // so it doesn't matter which int we compare it with.
    // If 'left' is a NaN, similarly.
    guard left.isFinite else {
      if py.cast.isInt(right) {
        let result = Self.compare(left: left, right: 0.0)
        return .value(result)
      }

      return .notImplemented
    }

    if let rightInt = py.cast.asInt(right) {
      return Self.compare(py, left: left, right: rightInt.value)
    }

    return .notImplemented
  }

  private static func compare(_ py: Py, left: Double, right: BigInt) -> CompareResult {
    // Easy case: different signs
    let leftSign = Self.getSign(left)
    let rightSign = Self.getSign(right)

    if leftSign != rightSign {
      let result = Self.compare(left: leftSign.rawValue, right: rightSign.rawValue)
      return .value(result)
    }

    // Scarry case: one is float, one is int, they have the same sign
    // Tbh. I don't know why we use '48' instead of '53',
    // but that's what CPython does.
    let nBits = right.minRequiredWidth
    if nBits <= 48 {
      switch PyFloat.asDouble(py, int: right) {
      case .value(let d):
        let result = Self.compare(left: left, right: d)
        return .value(result)
      case .overflow:
        // It's impossible that <= 48 bits overflowed
        unreachable()
      }
    }

    // Horror case: we are waaaay out of Double precision
    assert(rightSign != .zero) // else nBits = 0
    assert(leftSign != .zero) // we checked 'leftSign != rightSign'

    // We want to work with non-negative numbers.
    // Multiply both sides by -1; this also swaps the comparator.
    return leftSign == .minus ?
      Self.reflected.magic(left: -left, right: right, nBits: nBits) :
      Self.magic(left: left, right: right, nBits: nBits)
  }

  /// Use current position of the moon to return random value
  /// (actually if you read 'wiki', and 'cplusplus.com' it will make sense).
  private static func magic(left: Double,
                            right: BigInt,
                            nBits: Int) -> CompareResult {
    assert(left > 0)

    // Exponent is the # of bits in 'left' before the radix point;
    // we know that nBits (the # of bits in 'right') > 48 at this point
    // https://en.wikipedia.org/wiki/Radix_point

    let frexp = Frexp(value: left)
    let exponent = frexp.exponent

    if exponent < 0 || exponent < nBits {
      let result = Self.compare(left: 1.0, right: 2.0)
      return .value(result)
    }

    if exponent > nBits {
      let result = Self.compare(left: 2.0, right: 1.0)
      return .value(result)
    }

    // 'left' and 'right' have the same number of bits before the radix point.
    // Construct two ints that have the same comparison outcome.
    // BREAKPOINT: You can use 'assert 2.**54 == 2**54' to get here.
    assert(exponent == nBits)

    // 'vv' and 'ww' are the names used in CPython
    let (intPart, fracPart) = Foundation.modf(left)
    var leftVV = BigInt(intPart)
    var rightWW = Swift.abs(right)

    if fracPart != 0.0 {
      // Remove the last bit, and replace it with 1 for left
      rightWW = rightWW << 1
      leftVV = leftVV << 1
      leftVV = leftVV | 1
    }

    let result = Self.compare(left: leftVV, right: rightWW)
    return .value(result)
  }

  private static func getSign(_ value: Double) -> FloatSign {
    return value == 0.0 ? .zero :
           value > 0.0 ? .plus :
           .minus
  }

  private static func getSign(_ value: BigInt) -> FloatSign {
    return value == 0 ? .zero :
           value > 0 ? .plus :
           .minus
  }
}

internal enum FloatCompareHelper {

  // MARK: - Equal

  private enum EqualCompare: Abstract {

    fileprivate typealias reflected = EqualCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left == right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left == right
    }
  }

  internal static func isEqual(_ py: Py,
                               left: Double,
                               right: PyObject) -> CompareResult {
    return EqualCompare.compare(py, left: left, right: right)
  }

  // MARK: - Less

  private enum LessCompare: Abstract {

    fileprivate typealias reflected = GreaterCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left < right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left < right
    }
  }

  internal static func isLess(_ py: Py,
                              left: Double,
                              right: PyObject) -> CompareResult {
    return LessCompare.compare(py, left: left, right: right)
  }

  private enum LessEqualCompare: Abstract {

    fileprivate typealias reflected = GreaterEqualCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left <= right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left <= right
    }
  }

  internal static func isLessEqual(_ py: Py,
                                   left: Double,
                                   right: PyObject) -> CompareResult {
    return LessEqualCompare.compare(py, left: left, right: right)
  }

  // MARK: - Greater

  private enum GreaterCompare: Abstract {

    fileprivate typealias reflected = LessCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left > right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left > right
    }
  }

  internal static func isGreater(_ py: Py,
                                 left: Double,
                                 right: PyObject) -> CompareResult {
    return GreaterCompare.compare(py, left: left, right: right)
  }

  private enum GreaterEqualCompare: Abstract {

    fileprivate typealias reflected = LessEqualCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left >= right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left >= right
    }
  }

  internal static func isGreaterEqual(_ py: Py,
                                      left: Double,
                                      right: PyObject) -> CompareResult {
    return GreaterEqualCompare.compare(py, left: left, right: right)
  }
}
