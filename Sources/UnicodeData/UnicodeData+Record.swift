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

extension UnicodeData {

  internal struct Record {

    private let _upper: Int32 // 32 bit
    private let _lower: Int32 // 64 bit (1st word end)
    private let _title: Int32 // 96 bit
    internal let decimal: UInt8 // 104 bit
    internal let digit: UInt8 // 112 bit
    private let _flags: UInt16 // 128 bit (2nd word end)

    /// Delta to the character OR offset in `_PyUnicode_ExtendedCase`.
    internal var upper: Int { Int(self._upper) }
    /// Delta to the character OR offset in `_PyUnicode_ExtendedCase`.
    internal var lower: Int { Int(self._lower) }
    /// Delta to the character OR offset in `_PyUnicode_ExtendedCase`.
    internal var title: Int { Int(self._title) }

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

    internal init(upper: Int32,
                  lower: Int32,
                  title: Int32,
                  decimal: UInt8,
                  digit: UInt8,
                  flags: UInt16) {
      self._upper = upper
      self._lower = lower
      self._title = title
      self.decimal = decimal
      self.digit = digit
      self._flags = flags
    }
  }
}
