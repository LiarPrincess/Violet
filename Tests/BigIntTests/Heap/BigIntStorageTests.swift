import XCTest
@testable import BigInt

// swiftlint:disable file_length

private typealias Word = BigIntStorage.Word

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

  // MARK: - Append word

  func test_append() {
    let count = 4
    var storage = BigIntStorage(minimumCapacity: count)
    let token = storage.guaranteeUniqueBufferReference()

    for i in 0..<count {
      storage.append(token, element: Word(i))
    }

    XCTAssertEqual(storage.count, count)

    storage.withWordsBuffer { words in
      for i in 0..<count {
        XCTAssertEqual(words[i], Word(i))
      }
    }
  }

  func test_append_withGrow() {
    var storage = BigIntStorage(minimumCapacity: 4)
    let token = storage.guaranteeUniqueBufferReference()

    let oldCapacity = storage.capacity
    for i in 0..<oldCapacity {
      storage.append(token, element: Word(i))
    }
    XCTAssertEqual(storage.count, oldCapacity)
    XCTAssertEqual(storage.capacity, oldCapacity)

    // This should grow
    storage.append(token, element: 100)

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

  func test_append_cow() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    copy.append(token, element: 100)

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 0, 1, 2))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: 0, 1, 2, 100))
  }

  // MARK: - Append collection

  func test_appendCollection_toZero() {
    var storage = BigIntStorage(isNegative: false, magnitude: 0)
    let token = storage.guaranteeUniqueBufferReference()
    XCTAssertTrue(storage.isZero)
    XCTAssertEqual(storage.count, 0)

    let words: [Word] = [.min, 1, 5, .max, 7]
    words.withUnsafeBufferPointer { ptr in
      storage.append(token, contentsOf: ptr)
    }

    XCTAssertFalse(storage.isZero)
    XCTAssertEqual(storage.count, words.count)

    storage.withWordsBuffer { storage in
      for (s, w) in zip(storage, words) {
        XCTAssertEqual(s, w)
      }
    }

    // Check if we modified the shared value.
    XCTAssertTrue(BigIntStorage.zero.isZero)
  }

  func test_appendCollection_toNonZero() {
    let initialWords: [Word] = [.min, 1, 5, .max, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)
    let token = storage.guaranteeUniqueBufferReference()
    XCTAssertEqual(storage.count, initialWords.count)

    let newWords: [Word] = [.min, .max, 7, .min, .max, 7, .min, .max, 7]
    newWords.withUnsafeBufferPointer { ptr in
      storage.append(token, contentsOf: ptr)
    }

    let finalWords = initialWords + newWords
    XCTAssertEqual(storage.count, finalWords.count)

    storage.withWordsBuffer { storage in
      for (s, w) in zip(storage, finalWords) {
        XCTAssertEqual(s, w)
      }
    }
  }

  func test_appendCollection_cow() {
    let initialWords: [Word] = [.min, 1, 5, .max, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    let newWords: [Word] = [.min, .max, 7, .min, .max, 7, .min, .max, 7]
    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    newWords.withUnsafeBufferPointer { ptr in
      copy.append(token, contentsOf: ptr)
    }

    let finalWords = initialWords + newWords
    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: initialWords))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: finalWords))
  }

  // MARK: - Prepend

  func test_prepend_insideExistingBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(minimumCapacity: 8)
    let token = storage.guaranteeUniqueBufferReference()

    for word in initialWords {
      storage.append(token, element: word)
    }

    let prependCount = storage.capacity - storage.count
    XCTAssert(prependCount != 0, "Expected to have some space left")

    storage.prepend(token, element: 42, count: prependCount)
    XCTAssertEqual(storage.count, storage.capacity)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_inNewBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(minimumCapacity: 8)
    let token = storage.guaranteeUniqueBufferReference()

    for word in initialWords {
      storage.append(token, element: word)
    }

    let prependCount = storage.capacity // This will force allocation
    storage.prepend(token, element: 42, count: prependCount)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var original = BigIntStorage(minimumCapacity: 8)
    let originalToken = original.guaranteeUniqueBufferReference()

    for word in initialWords {
      original.append(originalToken, element: word)
    }

    var copy = original
    let copyToken = copy.guaranteeUniqueBufferReference()

    let prependCount = copy.capacity - copy.count
    XCTAssert(prependCount != 0, "Expected to have some space left")

    // This should always copy the 'original' buffer
    copy.prepend(copyToken, element: 42, count: prependCount)

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
      storage.replaceAll(token, withContentsOf: ptr)
    }

    XCTAssert(storage.isZero)
  }

  func test_replaceAll_moreThanCount() {
    var storage = BigIntStorage(isNegative: false, words: [.max, 1, .min, 7])
    let token = storage.guaranteeUniqueBufferReference()

    let words: [Word] = [0, 42, .max, 1, .min, 7]
    words.withUnsafeBufferPointer { ptr in
      storage.replaceAll(token, withContentsOf: ptr)
    }

    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: words))
  }

  func test_replaceAll_moreThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    let words: [Word] = [0, 42, .max, 1, .min, 7]
    words.withUnsafeBufferPointer { ptr in
      copy.replaceAll(token, withContentsOf: ptr)
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
      storage.replaceAll(token, withContentsOf: ptr)
    }

    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: words))
  }

  func test_replaceAll_lessThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    let token = copy.guaranteeUniqueBufferReference()
    let words: [Word] = [0, 42]
    words.withUnsafeBufferPointer { ptr in
      copy.replaceAll(token, withContentsOf: ptr)
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
    withAppend.append(withAppendToken, element: 100)
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
      let token = storage.guaranteeUniqueBufferReference()
      storage.setTo(token, value: value)
      XCTAssertEqual(storage, BigIntStorage(isNegative: false, magnitude: value))
    }
  }

  func test_set_UInt_cow() {
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.unsignedValues {
      var copy = original
      let copyToken = copy.guaranteeUniqueBufferReference()
      copy.setTo(copyToken, value: value)
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
      let token = storage.guaranteeUniqueBufferReference()
      storage.setTo(token, value: value)

      let isNegative = value.isNegative
      let magnitude = value.magnitude
      XCTAssertEqual(storage, BigIntStorage(isNegative: isNegative, magnitude: magnitude))
    }
  }

  func test_set_Int_cow() {
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.signedValues {
      var copy = original
      let copyToken = copy.guaranteeUniqueBufferReference()
      copy.setTo(copyToken, value: value)
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
