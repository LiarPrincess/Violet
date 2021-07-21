private let isAlphaMask: UInt16 = 0x01
private let isDecimalMask: UInt16 = 0x02
private let isDigitMask: UInt16 = 0x04
private let isLowerMask: UInt16 = 0x08
private let isLineBreakMask: UInt16 = 0x10
private let isSpaceMask: UInt16 = 0x20
private let isTitleMask: UInt16 = 0x40
private let isUpperMask: UInt16 = 0x80
private let isXidStartMask: UInt16 = 0x100
private let isXidContinueMask: UInt16 = 0x200
private let isPrintableMask: UInt16 = 0x400
private let isNumericMask: UInt16 = 0x800
private let isCaseIgnorableMask: UInt16 = 0x1000
private let isCasedMask: UInt16 = 0x2000
private let isExtendedCaseMask: UInt16 = 0x4000
private let hasFoldMask: UInt16 = 0x8000

// MARK: - LowerAndFold

/// Union: `Int32 | 2xUInt16`
private struct LowerAndFold {

  /// No-conversion access for most common path.
  fileprivate let lowerOnly: Int32

  fileprivate var lower: UInt16 {
    let u32 = UInt32(bitPattern: self.lowerOnly)
    return UInt16(truncatingIfNeeded: u32)
  }

  fileprivate var fold: UInt16 {
    let u32ValueInHighBits = UInt32(bitPattern: self.lowerOnly)
    let u32 = u32ValueInHighBits >> 16
    return UInt16(truncatingIfNeeded: u32)
  }

  fileprivate init(lowerOnly: Int32) {
    self.lowerOnly = lowerOnly
  }

  fileprivate init(lower: UInt16, fold: UInt16) {
    let u32 = UInt32(lower) | UInt32(fold) << 16
    self.lowerOnly = Int32(bitPattern: u32)
    // Don't eat any of them bits!
    assert(self.lower == lower)
    assert(self.fold == fold)
  }
}

// MARK: - Record

extension UnicodeData {

  internal struct Record {

    // MARK: - Properties

    private let _upper: Int32 // 32 bit
    private let _lowerAndFold: LowerAndFold // 64 bit (1st word end)
    private let _title: Int32 // 96 bit
    internal let decimal: UInt8 // 104 bit
    internal let digit: UInt8 // 112 bit
    private let _flags: UInt16 // 128 bit (2nd word end)
    // If you need more bits, then you can pack both 'decimal' and 'digit'
    // in a single 'UInt8' (since they are both <10).

    /// If `self.isExtendedCase` -> index in `_PyUnicode_ExtendedCase`.
    /// Otherwise -> relative offset to lower case.
    internal var lower: Int {
      switch self.hasFold {
      case true:
        let u16 = self._lowerAndFold.lower
        return Int(u16)
      case false:
        let i32 = self._lowerAndFold.lowerOnly
        return Int(i32)
      }
    }

    /// Index in `_PyUnicode_ExtendedCase`
    internal var fold: Int? {
      switch self.hasFold {
      case true:
        let u16 = self._lowerAndFold.fold
        return Int(u16)
      case false:
        return nil
      }
    }

    /// If `self.isExtendedCase` -> index in `_PyUnicode_ExtendedCase`.
    /// Otherwise -> relative offset to upper case
    internal var upper: Int { Int(self._upper) }
    /// If `self.isExtendedCase` -> index in `_PyUnicode_ExtendedCase`.
    ///  Otherwise -> relative offset to title case.
    internal var title: Int { Int(self._title) }

    // MARK: - Flags

    internal var isAlpha: Bool { self._flags & isAlphaMask != 0 }
    internal var isDecimal: Bool { self._flags & isDecimalMask != 0 }
    internal var isDigit: Bool { self._flags & isDigitMask != 0 }
    internal var isLower: Bool { self._flags & isLowerMask != 0 }
    internal var isLineBreak: Bool { self._flags & isLineBreakMask != 0 }
    internal var isSpace: Bool { self._flags & isSpaceMask != 0 }
    internal var isTitle: Bool { self._flags & isTitleMask != 0 }
    internal var isUpper: Bool { self._flags & isUpperMask != 0 }
    internal var isXidStart: Bool { self._flags & isXidStartMask != 0 }
    internal var isXidContinue: Bool { self._flags & isXidContinueMask != 0 }
    internal var isPrintable: Bool { self._flags & isPrintableMask != 0 }
    internal var isNumeric: Bool { self._flags & isNumericMask != 0 }
    internal var isCaseIgnorable: Bool { self._flags & isCaseIgnorableMask != 0 }
    internal var isCased: Bool { self._flags & isCasedMask != 0 }
    internal var isExtendedCase: Bool { self._flags & isExtendedCaseMask != 0 }
    internal var hasFold: Bool { self._flags & hasFoldMask != 0 }

    // MARK: - Init

    // swiftlint:disable:next function_body_length
    internal init(upper: Int32,
                  lower: Int32,
                  title: Int32,
                  fold: UInt16?,
                  decimal: UInt8,
                  digit: UInt8,
                  flags: UInt16) {
      #if DEBUG
      // Validate script output
      let isExtended = flags & isExtendedCaseMask != 0
      if isExtended {
        // Extended -> 'upper', 'lower' and 'title' are an index inside
        // the '_PyUnicode_ExtendedCase'.
        let maxIndex = _PyUnicode_ExtendedCase.count
        assert(0 <= upper && upper < maxIndex)
        assert(0 <= lower && lower < maxIndex)
        assert(0 <= title && title < maxIndex)
      } else {
        // Not extended -> relative offset to cased version.
        let maxCode = 0x10_ffff
        assert(Swift.abs(upper) < maxCode)
        assert(Swift.abs(lower) < maxCode)
        assert(Swift.abs(title) < maxCode)
      }

      if let f = fold {
        // Fold is an index inside the '_PyUnicode_ExtendedCase'.
        let isExtended = flags & isExtendedCaseMask != 0
        assert(isExtended, "isExtendedCase must be set when having a fold")

        let maxIndex = _PyUnicode_ExtendedCase.count
        assert(0 <= f && f < maxIndex)
      }

      assert(decimal < 10)
      assert(digit < 10)
      #endif

      // We will try to put both 'lower' and 'fold' inside 'self._lowerAndFold'
      var flagsToSet = flags
      var lowerAndFold: LowerAndFold
      if let fold = fold {
        // We are extended: 'lower' and 'fold' point to an entry inside the
        // '_PyUnicode_ExtendedCase'.
        // To be able to pack them together both of them have to be < 2^16.
        let extendedCount = _PyUnicode_ExtendedCase.count
        assert(extendedCount < UInt16.max)

        // This cast is safe because: lower < extendedCount < UInt16.max
        // (the 'lower < extendedCount' was checked in DEBUG block).
        let lowerU16 = UInt16(lower)
        flagsToSet = flagsToSet | hasFoldMask
        lowerAndFold = LowerAndFold(lower: lowerU16, fold: fold)
      } else {
        lowerAndFold = LowerAndFold(lowerOnly: lower)
      }

      self._upper = upper
      self._lowerAndFold = lowerAndFold
      self._title = title
      self.decimal = decimal
      self.digit = digit
      self._flags = flagsToSet

      #if DEBUG
      // Check if all of the bit thingies worked:
      assert(self.lower == Int(lower))

      if let f = fold {
        assert(self.fold == Int(f))
      }
      #endif
    }
  }
}
