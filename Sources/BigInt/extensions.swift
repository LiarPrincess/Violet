// MARK: - Integer + predicates

// Yes, this code is repeated 3 times.
// This is for performance reasons, because even in RELEASE builds we would see:
// 'protocol witness for FixedWidthInteger...' in instruments.

extension Smi.Storage {
  internal var isZero: Bool { return self == 0 }
  /// Including `0`.
  internal var isPositive: Bool { return self >= 0 }
  internal var isNegative: Bool { return self < 0 }
}

extension BigIntStorage.Word {
  internal var isZero: Bool { return self == 0 }
  /// Including `0`.
  internal var isPositive: Bool { return self >= 0 }
  internal var isNegative: Bool { return self < 0 }
}

extension Int {
  internal var isZero: Bool { return self == 0 }
  /// Including `0`.
  internal var isPositive: Bool { return self >= 0 }
  internal var isNegative: Bool { return self < 0 }
}

// MARK: - Word + maxRepresentablePower

extension BigIntStorage.Word {

  /// Returns the highest number that satisfy `radix^n <= 2^Self.bitWidth`
  internal static func maxRepresentablePower(of radix: Self) -> (n: Int, power: Self) {
    var n = 1
    var power = radix

    while true {
      let (newPower, overflow) = power.multipliedReportingOverflow(by: radix)

      if overflow {
        return (n, power)
      }

      n += 1
      power = newPower
    }
  }

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

// MARK: - Word + asSmi

extension BigIntStorage.Word {

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
