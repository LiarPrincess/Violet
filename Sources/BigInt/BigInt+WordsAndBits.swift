// This file contains:
// - bitWidth
// - words
// - minRequiredWidth - this is for Python 'bit_length'
// - trailingZeroBitCount
//
// Those properties (except for 'minRequiredWidth') are crucial for Swift integer
// interop and well… they are quite tricky to get right.
//
// WARNING:
// This file is full of dark arcane magic (mostly involving bit operations)!
// Listen to this for best effect: https://www.youtube.com/watch?v=ML0XFlWkEvk
// 'Salem's Secret' is the best song on this ablum and btw. you may get some
// flashbacks with Count Strahd von Zarovich.

// MARK: - Bit width

private let bitWidthForZero = 1

extension BigInt {

  /// The number of bits used for the underlying binary representation of
  /// values of this type.
  ///
  /// For example: bit width of a `Int64` instance is 64.
  /// In `BigInt` it is a bit more complicated…
  public var bitWidth: Int {
    switch self.value {
    case let .smi(smi):
      return smi.bitWidth
    case let .heap(heap):
      return heap.bitWidth
    }
  }
}

extension Smi {

  internal var bitWidth: Int {
    if self.isZero {
      return bitWidthForZero
    }

    let fullWidth = Self.Storage.bitWidth

    if self.isPositive {
      let leadingZeroBitCount = self.value.leadingZeroBitCount
      let zeroAsSign = 1
      return fullWidth - leadingZeroBitCount + zeroAsSign
    }

    let oneAsSign = 1
    let leadingOneBitCount = (~self.value).leadingZeroBitCount
    return fullWidth - leadingOneBitCount + oneAsSign
  }
}

extension BigIntHeap {

  internal var bitWidth: Int {
    guard let last = self.storage.last else {
      assert(self.isZero)
      return bitWidthForZero
    }

    assert(!last.isZero)

    let wordsWidth = self.storage.count * Word.bitWidth
    let leadingZeroBitCount = last.leadingZeroBitCount

    func bitWidthForPositive() -> Int {
      // Positivie numbers need leading '0',
      // because leading '1' marks negative number.
      let zeroAsSign = 1
      return wordsWidth - leadingZeroBitCount + zeroAsSign
    }

    if self.isPositive {
      return bitWidthForPositive()
    }

    // For negative numbers we can use the same formula except for the case
    // when number is power of 2 (magnitude has single '1' and then a lot of '0').
    // In such case we do not have to add 'zeroAsSign'.
    //
    // Look at this (example for 4-bit word):
    // +------------------------+-------------------------------+
    // |        positive        |            negative           |
    // +-----+------+-----------+------+------------+-----------+
    // | dec | bin  | bit width | -dec |    bin     | bit width |
    // +-----+------+-----------+------+------------+-----------+
    // |   7 | 0111 | 4-1+1 = 4 |   -7 |       1001 |         4 |
    // |   8 | 1000 | 4-0+1 = 5 |   -8 |       1000 | THIS -> 4 |
    // |   9 | 1001 | 4-0+1 = 5 |   -9 |  1111 0111 |         5 |
    // +-----+------+-----------+------+------------+-----------+
    //
    // There is a bit more detailed explanation below.
    //
    // To quicky find powers of 2:
    // 1. most significant word is power of 2
    // 2. all other words are 0

    let isLastPowerOf2 = (last & (last - 1)) == 0
    guard isLastPowerOf2 else {
      return bitWidthForPositive()
    }

    let hasAllOtherWords0 = self.storage.dropLast().allSatisfy { $0 == 0 }
    guard hasAllOtherWords0 else {
      return bitWidthForPositive()
    }

    // We are at our special case
    return wordsWidth - leadingZeroBitCount

    // OLD EXPLANATION:
    // Two complement:
    // 1. invert all words
    // 2. add 1
    // This 'add 1' step may require additional bit
    // (example for 4-bit word: 0011 + 1 = 0100, we had 2 bits, now we have 3).
    //
    // Step 1: Find word that swallows '+1'
    // We do not have to do full 2 complement here (it would require allocation),
    // because there is a faster way:
    // What we actually need is to find the word that swallows this '+1' after
    // the inversion. Basically all of the numbers do this except for the word
    // that has all bits set to 1 (example for 4-bit word: 1111 + 1 = 1 0000).
    // So… inverse of which number has all bits set to '1'? Well… '0'!
    // let indexWhichSwallowsPlus1 = self.storage.firstIndex { $0 != 0 } ??
    //
    // Step 2: If it was not the last word
    // If one of our 'inner words' swallowed '1' then we definitelly do not need
    // additional bit. We can just simply invert 'last' and use it as 2 complement:
    //   let complement = ~last
    //   let leadingZeroBitCount = complement.leadingZeroBitCount
    //   return wordsWidth - leadingZeroBitCount
    //
    // Step 3: If 'last' is the one that handles '+1' thwn we may need additional bit
    // Our last word will handle '+1', we can calculate full 2 complement in place:
    //   let inverted = ~last
    //   let complement = inverted + 1 // Will not overflow, because we checked for 0
    // Now we are in the exactly same same place as 'smi':
    //   let oneAsSign = 1
    //   let complementLeadingOneBitCount = (~complement).leadingZeroBitCount
    //   return wordsWidth - complementLeadingOneBitCount + oneAsSign
  }
}
