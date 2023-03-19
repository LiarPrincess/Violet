import XCTest
@testable import BigInt

// swiftlint:disable file_length

private typealias Word = BigIntStorage.Word

private func XCTAssertEqual(_ lhs: BigIntStorage,
                            _ rhs: BigIntStorage,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let lhsBig = BigInt(lhs)
  let rhsBig = BigInt(rhs)
  XCTAssertEqual(lhsBig, rhsBig, file: file, line: line)
}

private func XCTAssertNotEqual(_ lhs: BigIntStorage,
                               _ rhs: BigIntStorage,
                               file: StaticString = #file,
                               line: UInt = #line) {
  let lhsBig = BigInt(lhs)
  let rhsBig = BigInt(rhs)
  XCTAssertNotEqual(lhsBig, rhsBig, file: file, line: line)
}

class BigIntStorageTests: XCTestCase {

  // MARK: - Memory layout

  private enum FutureBigInt {
    case smi(Smi)
    case ptr(BigIntStorage)
  }

  func test_memoryLayout() {
    XCTAssertEqual(MemoryLayout<FutureBigInt>.size, 8)
    XCTAssertEqual(MemoryLayout<FutureBigInt>.stride, 8)
  }

  // MARK: - Properties

  func test_isNegative_isPositive() {
    var storage = BigIntStorage(isNegative: false, words: 0, 1, 2, 3)
    let token = storage.guaranteeUniqueBufferReference()

    XCTAssertTrue(storage.isPositive)
    XCTAssertFalse(storage.isNegative)

    storage.toggleIsNegative(token)
    XCTAssertFalse(storage.isPositive)
    XCTAssertTrue(storage.isNegative)
  }

  /// We do allow both `+0` and `-0`.
  func test_isNegative_isPositive_for0() {
    var storage = BigIntStorage.zero
    let token = storage.guaranteeUniqueBufferReference()

    XCTAssertTrue(storage.isPositive)
    XCTAssertFalse(storage.isNegative)

    storage.toggleIsNegative(token)
    XCTAssertFalse(storage.isPositive)
    XCTAssertTrue(storage.isNegative)
  }

  func test_isNegative_cow() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)
    let originalIsNegative = original.isNegative

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    copy.toggleIsNegative(token)

    XCTAssertEqual(original.isNegative, originalIsNegative)
    XCTAssertEqual(copy.isNegative, !originalIsNegative)
  }

  // MARK: - Word access

  func test_withWordsBuffer() {
    let storage = BigIntStorage(isNegative: false, words: 0, 1, 2, 3)

    storage.withWordsBuffer { words in
      for i in 0..<storage.count {
        XCTAssertEqual(words[i], Word(i))
      }
    }
  }

  func test_withMutableWordsBuffer() {
    var storage = BigIntStorage(isNegative: false, words: 0, 1, 2, 3)
    let token = storage.guaranteeUniqueBufferReference()

    storage.withMutableWordsBuffer(token) { words in
      for i in 0..<words.count {
        words[i] += 1
        XCTAssertEqual(words[i], Word(i + 1))
      }
    }
  }

  func test_withMutableWordsBuffer_cow() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    copy.withMutableWordsBuffer(token) { $0[0] = 100 }

    XCTAssertEqual(original.count, 3)
    XCTAssertEqual(copy.count, 3)

    original.withWordsBuffer { original in
      copy.withWordsBuffer { copy in
        for i in 0..<original.count {
          XCTAssertEqual(original[i], Word(i))

          let copyExpected = i == 0 ? 100 : i
          XCTAssertEqual(copy[i], Word(copyExpected))
        }
      }
    }
  }

  // MARK: - Append with grow

  func test_appendWithGrow_withinCapacity() {
    let count = 4
    var storage = BigIntStorage(minimumCapacity: count)
    let token = storage.guaranteeUniqueBufferReference()

    for i in 0..<count {
      storage.appendWithPossibleGrow(token, element: Word(i))
    }

    XCTAssertEqual(storage.count, count)

    storage.withWordsBuffer { words in
      for i in 0..<count {
        XCTAssertEqual(words[i], Word(i))
      }
    }
  }

  func test_appendWithGrow_grow() {
    var storage = BigIntStorage(minimumCapacity: 4)
    let token = storage.guaranteeUniqueBufferReference()

    let oldCapacity = storage.capacity
    for i in 0..<oldCapacity {
      storage.appendWithPossibleGrow(token, element: Word(i))
    }
    XCTAssertEqual(storage.count, oldCapacity)
    XCTAssertEqual(storage.capacity, oldCapacity)

    // This should grow
    storage.appendWithPossibleGrow(token, element: 100)

    XCTAssertEqual(storage.count, oldCapacity + 1)
    XCTAssertNotEqual(storage.capacity, oldCapacity)
    XCTAssertGreaterThan(storage.capacity, oldCapacity)

    storage.withWordsBuffer { words in
      for i in 0..<oldCapacity {
        XCTAssertEqual(words[i], Word(i))
      }

      XCTAssertEqual(words.last, Word(100))
    }
  }

  func test_appendWithGrow_cow() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    copy.appendWithPossibleGrow(token, element: 100)

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 0, 1, 2))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: 0, 1, 2, 100))
  }

  // MARK: - Append assuming capacity

  func test_appendAssumingCapacity_withinCapacity() {
    let count = 4
    var storage = BigIntStorage(minimumCapacity: count)
    let token = storage.guaranteeUniqueBufferReference()

    for i in 0..<count {
      storage.appendAssumingCapacity(token, element: Word(i))
    }

    XCTAssertEqual(storage.count, count)

    storage.withWordsBuffer { words in
      for i in 0..<count {
        XCTAssertEqual(words[i], Word(i))
      }
    }
  }

  func test_appendAssumingCapacity_cow() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference(withCapacity: 4)
    copy.appendAssumingCapacity(token, element: 100)

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 0, 1, 2))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: 0, 1, 2, 100))
  }

  // MARK: - Prepend assuming capacity

  func test_prepend_insideExistingBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(minimumCapacity: 8)
    let token = storage.guaranteeUniqueBufferReference()

    for word in initialWords {
      storage.appendAssumingCapacity(token, element: word)
    }

    XCTAssertEqual(storage.count, initialWords.count)
    let prependCount = storage.capacity - storage.count
    XCTAssert(prependCount != 0, "Expected to have some space left")

    storage.prependAssumingCapacity(token, element: 42, count: prependCount)
    XCTAssertEqual(storage.count, storage.capacity)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    let capacity = 8
    let token = copy.guaranteeUniqueBufferReference(withCapacity: capacity)

    // This should always copy the 'original' buffer
    let prependCount = capacity - initialWords.count
    copy.prependAssumingCapacity(token, element: 42, count: prependCount)

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: initialWords))

    let copyWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: copyWords))
  }

  // MARK: - Drop first

  func test_dropFirst_zero() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)
    let token = storage.guaranteeUniqueBufferReference()

    storage.dropFirst(token, wordCount: 0)

    XCTAssertEqual(storage.count, initialWords.count)

    storage.withWordsBuffer { storage in
      for (s, w) in zip(storage, initialWords) {
        XCTAssertEqual(s, w)
      }
    }
  }

  func test_dropFirst_moreThanCount() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)
    let token = storage.guaranteeUniqueBufferReference()

    storage.dropFirst(token, wordCount: initialWords.count * 2)

    XCTAssertEqual(storage.count, 0)
  }

  func test_dropFirst_moreThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    copy.dropFirst(token, wordCount: initialWords.count * 2)

    XCTAssertEqual(original.count, initialWords.count)

    original.withWordsBuffer { original in
      for (s, w) in zip(original, initialWords) {
        XCTAssertEqual(s, w)
      }
    }
  }

  func test_dropFirst_lessThanCount() {
    let initialWords: [Word] = [.max, 1, .min, 7, 42]
    var storage = BigIntStorage(isNegative: false, words: initialWords)
    let token = storage.guaranteeUniqueBufferReference()

    let dropCount = 3
    storage.dropFirst(token, wordCount: dropCount)

    let expected = initialWords.dropFirst(dropCount)
    XCTAssertEqual(storage.count, expected.count)

    storage.withWordsBuffer { storage in
      for (s, w) in zip(storage, expected) {
        XCTAssertEqual(s, w)
      }
    }
  }

  func test_dropFirst_lessThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7, 42]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    copy.dropFirst(token, wordCount: 3)

    XCTAssertEqual(original.count, initialWords.count)

    original.withWordsBuffer { original in
      for (s, w) in zip(original, initialWords) {
        XCTAssertEqual(s, w)
      }
    }
  }

  // MARK: - Replace all

  func test_replaceAll_zero() {
    var storage = BigIntStorage(isNegative: false, words: [.max, 1, .min, 7, 42])
    let token = storage.guaranteeUniqueBufferReference()

    let words: [Word] = []
    words.withUnsafeBufferPointer { ptr in
      storage.replaceAllAssumingCapacity(token, withContentsOf: ptr)
    }

    XCTAssert(storage.isZero)
  }

  func test_replaceAll_moreThanCount() {
    var storage = BigIntStorage(minimumCapacity: 8)
    let token = storage.guaranteeUniqueBufferReference()
    let initalWords: [Word] = [.max, 1, .min, 7]

    for w in initalWords {
      storage.appendAssumingCapacity(token, element: w)
    }

    let words: [Word] = [0, 42, .max, 1, .min, 7]
    words.withUnsafeBufferPointer { ptr in
      storage.replaceAllAssumingCapacity(token, withContentsOf: ptr)
    }

    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: words))
  }

  func test_replaceAll_moreThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference(withCapacity: 8)
    let words: [Word] = [0, 42, .max, 1, .min, 7]

    words.withUnsafeBufferPointer { ptr in
      copy.replaceAllAssumingCapacity(token, withContentsOf: ptr)
    }

    XCTAssertEqual(original.count, initialWords.count)

    original.withWordsBuffer { original in
      for (s, w) in zip(original, initialWords) {
        XCTAssertEqual(s, w)
      }
    }
  }

  func test_replaceAll_lessThanCount() {
    var storage = BigIntStorage(isNegative: false, words: [.max, 1, .min, 7])
    let token = storage.guaranteeUniqueBufferReference()

    let words: [Word] = [0, 42]
    words.withUnsafeBufferPointer { ptr in
      storage.replaceAllAssumingCapacity(token, withContentsOf: ptr)
    }

    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: words))
  }

  func test_replaceAll_lessThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    let words: [Word] = [0, 42]
    var copy = original
    let token = copy.guaranteeUniqueBufferReference(withCapacity: words.count)

    words.withUnsafeBufferPointer { ptr in
      copy.replaceAllAssumingCapacity(token, withContentsOf: ptr)
    }

    XCTAssertEqual(original.count, initialWords.count)

    original.withWordsBuffer { original in
      for (s, w) in zip(original, initialWords) {
        XCTAssertEqual(s, w)
      }
    }
  }

  // MARK: - Equatable

  func test_equatable() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)
    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 0, 1, 2))

    var negative = original
    let negativeToken = negative.guaranteeUniqueBufferReference()
    negative.toggleIsNegative(negativeToken)
    XCTAssertNotEqual(original, negative)

    var withAppend = original
    let withAppendToken = withAppend.guaranteeUniqueBufferReference()
    withAppend.appendWithPossibleGrow(withAppendToken, element: 100)
    XCTAssertNotEqual(original, withAppend)

    var changedFirst = original
    let changedFirstToken = changedFirst.guaranteeUniqueBufferReference()
    changedFirst.withMutableWordsBuffer(changedFirstToken) { $0[0] = 100 }
    XCTAssertNotEqual(original, changedFirst)

    var changedLast = original
    let changedLastToken = changedLast.guaranteeUniqueBufferReference()
    changedLast.withMutableWordsBuffer(changedLastToken) { $0[2] = 100 }
    XCTAssertNotEqual(original, changedLast)
  }

  // MARK: - Set unsigned

  private let unsignedValues: [UInt] = [103, 0, .max, .min]

  func test_set_UInt() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.unsignedValues {
      // One of our values is '0' which shares storage,
      // so we have to renew token on every iteration
      let token = storage.guaranteeUniqueBufferReference(withCapacity: 1)
      storage.setToAssumingCapacity(token, value: value)
      XCTAssertEqual(storage, BigIntStorage(isNegative: false, magnitude: value))
    }
  }

  func test_set_UInt_cow() {
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.unsignedValues {
      var copy = original
      let token = copy.guaranteeUniqueBufferReference(withCapacity: 1)
      copy.setToAssumingCapacity(token, value: value)
      XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 1, 2, 3))
    }
  }

  // MARK: - Set signed

  private let signedValues: [Int] = [103, 0, -104, .max, .min]

  func test_set_Int() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.signedValues {
      // One of our values is '0' which shares storage,
      // so we have to renew token on every iteration
      let token = storage.guaranteeUniqueBufferReference(withCapacity: 1)
      storage.setToAssumingCapacity(token, value: value)

      let isNegative = value.isNegative
      let magnitude = value.magnitude
      XCTAssertEqual(storage, BigIntStorage(isNegative: isNegative, magnitude: magnitude))
    }
  }

  func test_set_Int_cow() {
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.signedValues {
      var copy = original
      let token = copy.guaranteeUniqueBufferReference(withCapacity: 1)
      copy.setToAssumingCapacity(token, value: value)
      XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 1, 2, 3))
    }
  }

  // MARK: - Invariants

  func test_fixInvariants_suffix0() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3, 0, 0)
    let token = storage.guaranteeUniqueBufferReference()

    storage.fixInvariants(token)
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: 1, 2, 3))
  }

  func test_fixInvariants_zero() {
    var storage = BigIntStorage(isNegative: true, words: 0, 0, 0)
    let token = storage.guaranteeUniqueBufferReference()

    storage.fixInvariants(token)
    XCTAssertEqual(storage, BigIntStorage.zero)
  }

  // MARK: - Description

  /// Please note that `capacity` is implementation dependent,
  /// if it changes then just fix test.
  func test_description() {
    let storage = BigIntStorage(isNegative: false, words: 1, 2, 3)

    let result = String(describing: storage)
    let expected = "BigIntStorage(isNegative: false, words: [0b1, 0b10, 0b11])"
    XCTAssertEqual(result, expected)
  }
}
