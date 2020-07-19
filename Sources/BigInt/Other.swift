// MARK: - BinaryInteger + predicates

extension BinaryInteger {

  internal var isZero: Bool {
    return self == .zero
  }

  /// Including `0`.
  internal var isPositive: Bool {
    return self >= .zero
  }

  internal var isNegative: Bool {
    return self < .zero
  }
}

// MARK: - FixedWidthInteger + full width

extension FixedWidthInteger {

  internal typealias FullWidthAdd = (carry: Self, result: Self)

  /// `result = self + y`
  internal func addingFullWidth(_ y: Self) -> FullWidthAdd {
    let (result, overflow) = self.addingReportingOverflow(y)
    let carry: Self = overflow ? 1 : 0
    return (carry, result)
  }

  /// `result = self + y + z`
  internal func addingFullWidth(_ y: Self, _ z: Self) -> FullWidthAdd {
    let (xy, overflow1) = self.addingReportingOverflow(y)
    let (xyz, overflow2) = xy.addingReportingOverflow(z)
    let carry: Self = (overflow1 ? 1 : 0) + (overflow2 ? 1 : 0)
    return (carry, xyz)
  }

  internal typealias FullWidthSub = (borrow: Self, result: Self)

  /// `result = self - y`
  internal func subtractingFullWidth(_ y: Self) -> FullWidthSub {
    let (result, overflow) = self.subtractingReportingOverflow(y)
    let borrow: Self = overflow ? 1 : 0
    return (borrow, result)
  }

  /// `result = self - y - z`
  internal func subtractingFullWidth(_ y: Self, _ z: Self) -> FullWidthSub {
    let (xy, overflow1) = self.subtractingReportingOverflow(y)
    let (xyz, overflow2) = xy.subtractingReportingOverflow(z)
    let borrow: Self = (overflow1 ? 1 : 0) + (overflow2 ? 1 : 0)
    return (borrow, xyz)
  }
}

// MARK: - FixedWidthInteger + maxRepresentablePower

extension FixedWidthInteger {

  /// Returns the highest number that satisfy `radix^n <= 2^Self.bitWidth`
  internal static func maxRepresentablePower(of radix: Int) -> (n: Int, power: Self) {
    var n = 1
    var power = Self(radix)

    while true {
      let (newPower, overflow) = power.multipliedReportingOverflow(by: Self(radix))

      if overflow {
        return (n, power)
      }

      n += 1
      power = newPower
    }
  }
}

// MARK: - UInt + asSmi

extension UInt {

  internal func asSmiIfPossible(isNegative: Bool) -> Smi.Storage? {
    let isPositive = !isNegative

    if isPositive && self <= Smi.Storage.max {
      return Smi.Storage(self)
    }

    if isNegative && self <= Smi.Storage.min.magnitude {
      let int = Int(self)
      return Smi.Storage(-int)
    }

    return nil
  }
}

// MARK: - UnicodeScalar + asDigit

extension UnicodeScalar {

  /// Try to convert scalar to digit.
  ///
  /// Acceptable values:
  /// - ascii numbers
  /// - ascii lowercase letters (a - z)
  /// - ascii uppercase letters (A - Z)
  internal var asDigit: BigIntHeap.Word? {
    // Tip: use 'man ascii':
    let a: BigIntHeap.Word = 0x61, z: BigIntHeap.Word = 0x7a
    let A: BigIntHeap.Word = 0x41, Z: BigIntHeap.Word = 0x5a
    let n0: BigIntHeap.Word = 0x30, n9: BigIntHeap.Word = 0x39

    let value = BigIntHeap.Word(self.value)

    if n0 <= value && value <= n9 {
      return value - n0
    }

    if a <= value && value <= z {
      return value - a + 10 // '+ 10' because 'a' is 10 not 0
    }

    if A <= value && value <= Z {
      return value - A + 10
    }

    return nil
  }
}
