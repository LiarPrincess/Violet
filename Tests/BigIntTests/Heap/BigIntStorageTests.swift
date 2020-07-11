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
    XCTAssertTrue(storage.isPositive)
    XCTAssertFalse(storage.isNegative)

    storage.isNegative.toggle()
    XCTAssertFalse(storage.isPositive)
    XCTAssertTrue(storage.isNegative)
  }

  func test_isNegative_cow() {
    let orginal = BigIntStorage(isNegative: false, words: 0, 1, 2)
    let orginalIsNegative = orginal.isNegative

    var copy = orginal
    copy.isNegative.toggle()

    XCTAssertEqual(orginal.isNegative, orginalIsNegative)
    XCTAssertEqual(copy.isNegative, !orginalIsNegative)
  }

  // MARK: - Subscript

  func test_subscript_get() {
    let storage = BigIntStorage(isNegative: false, words: 0, 1, 2, 3)

    for i in 0..<storage.count {
      XCTAssertEqual(storage[i], Word(i))
    }
  }

  func test_subscript_set() {
    var storage = BigIntStorage(isNegative: false, words: 0, 1, 2, 3)

    for i in 0..<storage.count {
      storage[i] += 1
      XCTAssertEqual(storage[i], Word(i + 1))
    }
  }

  func test_subscript_set_cow() {
    let orginal = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = orginal
    copy[0] = 100

    XCTAssertEqual(orginal.count, 3)
    XCTAssertEqual(copy.count, 3)

    for i in 0..<orginal.count {
      XCTAssertEqual(orginal[i], Word(i))

      let copyExpected = i == 0 ? 100 : i
      XCTAssertEqual(copy[i], Word(copyExpected))
    }
  }

  // MARK: - Append word

  func test_append() {
    let count = 4
    var storage = BigIntStorage(minimumCapacity: count)

    for i in 0..<count {
      storage.append(Word(i))
    }

    XCTAssertEqual(storage.count, count)

    for i in 0..<count {
      XCTAssertEqual(storage[i], Word(i))
    }
  }

  func test_append_withGrow() {
    var storage = BigIntStorage(minimumCapacity: 4)

    let oldCapacity = storage.capacity
    for i in 0..<oldCapacity {
      storage.append(Word(i))
    }
    XCTAssertEqual(storage.count, oldCapacity)
    XCTAssertEqual(storage.capacity, oldCapacity)

    // This should grow
    storage.append(100)

    XCTAssertEqual(storage.count, oldCapacity + 1)
    XCTAssertNotEqual(storage.capacity, oldCapacity)
    XCTAssertGreaterThan(storage.capacity, oldCapacity)

    for i in 0..<oldCapacity {
      XCTAssertEqual(storage[i], Word(i))
    }
    XCTAssertEqual(storage.last, Word(100))
  }

  func test_append_cow() {
    let orginal = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = orginal
    copy.append(100)

    XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: 0, 1, 2))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: 0, 1, 2, 100))
  }

  // MARK: - Append collection

  func test_appendCollection_toZero() {
    var storage = BigIntStorage(isNegative: false, magnitude: 0)
    XCTAssertTrue(storage.isZero)
    XCTAssertEqual(storage.count, 0)

    let words: [Word] = [.min, 1, 5, .max, 7]
    storage.append(contentsOf: words)

    XCTAssertFalse(storage.isZero)
    XCTAssertEqual(storage.count, words.count)

    for (s, w) in zip(storage, words) {
      XCTAssertEqual(s, w)
    }

    // Check if we modified the shared value.
    XCTAssertTrue(BigIntStorage.zero.isZero)
  }

  func test_appendCollection_toNonZero() {
    let initialWords: [Word] = [.min, 1, 5, .max, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)
    XCTAssertEqual(storage.count, initialWords.count)

    let newWords: [Word] = [.min, .max, 7, .min, .max, 7, .min, .max, 7]
    storage.append(contentsOf: newWords)

    let finalWords = initialWords + newWords
    XCTAssertEqual(storage.count, finalWords.count)

    for (s, w) in zip(storage, finalWords) {
      XCTAssertEqual(s, w)
    }
  }

  func test_appendCollection_cow() {
    let initialWords: [Word] = [.min, 1, 5, .max, 7]
    let orginal = BigIntStorage(isNegative: false, words: initialWords)

    let newWords: [Word] = [.min, .max, 7, .min, .max, 7, .min, .max, 7]
    var copy = orginal
    copy.append(contentsOf: newWords)

    let finalWords = initialWords + newWords
    XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: initialWords))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: finalWords))
  }

  // MARK: - Prepend

  func test_prepend_insideExistingBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)

    let prependCount = storage.capacity - storage.count
    XCTAssert(
      prependCount != 0,
      "Expected to have some space left (just modify 'initialWords' to fix)"
    )

    storage.prepend(42, count: prependCount)
    XCTAssertEqual(storage.count, storage.capacity)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_inNewBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)

    let prependCount = storage.capacity // This will force allocation
    storage.prepend(42, count: prependCount)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let orginal = BigIntStorage(isNegative: false, words: initialWords)

    var copy = orginal

    let prependCount = copy.capacity - copy.count
    XCTAssert(
      prependCount != 0,
      "Expected to have some space left (just modify 'initialWords' to fix)"
    )

    // This should always copy the 'orginal' buffer
    copy.prepend(42, count: prependCount)

    XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: initialWords))
  }

  // MARK: - Drop first

  func test_dropFirst_zero() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)

    storage.dropFirst(wordCount: 0)

    XCTAssertEqual(storage.count, initialWords.count)

    for (s, w) in zip(storage, initialWords) {
      XCTAssertEqual(s, w)
    }
  }

  func test_dropFirst_moreThanCount() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(isNegative: false, words: initialWords)

    storage.dropFirst(wordCount: initialWords.count * 2)

    XCTAssertEqual(storage.count, 0)
  }

  func test_dropFirst_moreThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    let orginal = BigIntStorage(isNegative: false, words: initialWords)

    var copy = orginal
    copy.dropFirst(wordCount: initialWords.count * 2)

    XCTAssertEqual(orginal.count, initialWords.count)

    for (s, w) in zip(orginal, initialWords) {
      XCTAssertEqual(s, w)
    }
  }

  func test_dropFirst_lessThanCount() {
    let initialWords: [Word] = [.max, 1, .min, 7, 42]
    var storage = BigIntStorage(isNegative: false, words: initialWords)

    let dropCount = 3
    storage.dropFirst(wordCount: dropCount)

    let expected = initialWords.dropFirst(dropCount)
    XCTAssertEqual(storage.count, expected.count)

    for (s, w) in zip(storage, expected) {
      XCTAssertEqual(s, w)
    }
  }

  func test_dropFirst_lessThanCount_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7, 42]
    let orginal = BigIntStorage(isNegative: false, words: initialWords)

    var copy = orginal
    copy.dropFirst(wordCount: 3)

    XCTAssertEqual(orginal.count, initialWords.count)

    for (s, w) in zip(orginal, initialWords) {
      XCTAssertEqual(s, w)
    }
  }

  // MARK: - Equatable

  func test_equatable() {
    let orginal = BigIntStorage(isNegative: false, words: 0, 1, 2)
    XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: 0, 1, 2))

    var negative = orginal
    negative.isNegative.toggle()
    XCTAssertNotEqual(orginal, negative)

    var withAppend = orginal
    withAppend.append(100)
    XCTAssertNotEqual(orginal, withAppend)

    var changedFirst = orginal
    changedFirst[0] = 100
    XCTAssertNotEqual(orginal, changedFirst)

    var changedLast = orginal
    changedLast[2] = 100
    XCTAssertNotEqual(orginal, changedLast)
  }

  // MARK: - Set unsigned

  private let unsignedValues: [UInt] = [103, 0, .max, .min]

  func test_set_UInt() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.unsignedValues {
      storage.set(to: value)
      XCTAssertEqual(storage, BigIntStorage(isNegative: false, magnitude: value))
    }
  }

  func test_set_UInt_cow() {
    let orginal = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.unsignedValues {
      var copy = orginal
      copy.set(to: value)

      XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: 1, 2, 3))
    }
  }

  // MARK: - Set signed

  private let signedValues: [Int] = [103, 0, -104, .max, .min]

  func test_set_Int() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.signedValues {
      storage.set(to: value)

      let isNegative = value.isNegative
      let magnitude = value.magnitude
      XCTAssertEqual(storage, BigIntStorage(isNegative: isNegative, magnitude: magnitude))
    }
  }

  func test_set_Int_cow() {
    let orginal = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.signedValues {
      var copy = orginal
      copy.set(to: value)

      XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: 1, 2, 3))
    }
  }

  // MARK: - Transform

  func test_transform() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3)
    storage.transformEveryWord { $0 + 1 }

    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: 2, 3, 4))
  }

  func test_transform_cow() {
    let orginal = BigIntStorage(isNegative: false, words: 1, 2, 3)

    var copy = orginal
    copy.transformEveryWord { $0 + 1 }

    XCTAssertEqual(orginal, BigIntStorage(isNegative: false, words: 1, 2, 3))
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
