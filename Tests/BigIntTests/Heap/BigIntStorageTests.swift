import XCTest
@testable import BigInt

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
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)
    let originalIsNegative = original.isNegative

    var copy = original
    copy.isNegative.toggle()

    XCTAssertEqual(original.isNegative, originalIsNegative)
    XCTAssertEqual(copy.isNegative, !originalIsNegative)
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
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = original
    copy[0] = 100

    XCTAssertEqual(original.count, 3)
    XCTAssertEqual(copy.count, 3)

    for i in 0..<original.count {
      XCTAssertEqual(original[i], Word(i))

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
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)

    var copy = original
    copy.append(100)

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 0, 1, 2))
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
    let original = BigIntStorage(isNegative: false, words: initialWords)

    let newWords: [Word] = [.min, .max, 7, .min, .max, 7, .min, .max, 7]
    var copy = original
    copy.append(contentsOf: newWords)

    let finalWords = initialWords + newWords
    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: initialWords))
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: finalWords))
  }

  // MARK: - Prepend

  func test_prepend_insideExistingBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(minimumCapacity: 8)
    for word in initialWords {
      storage.append(word)
    }

    let prependCount = storage.capacity - storage.count
    XCTAssert(prependCount != 0, "Expected to have some space left")

    storage.prepend(42, count: prependCount)
    XCTAssertEqual(storage.count, storage.capacity)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_inNewBuffer() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var storage = BigIntStorage(minimumCapacity: 8)
    for word in initialWords {
      storage.append(word)
    }

    let prependCount = storage.capacity // This will force allocation
    storage.prepend(42, count: prependCount)
    XCTAssertEqual(storage.count, initialWords.count + prependCount)

    let finalWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: finalWords))
  }

  func test_prepend_cow() {
    let initialWords: [Word] = [.max, 1, .min, 7]
    var original = BigIntStorage(minimumCapacity: 8)
    for word in initialWords {
      original.append(word)
    }

    var copy = original

    let prependCount = copy.capacity - copy.count
    XCTAssert(prependCount != 0, "Expected to have some space left")

    // This should always copy the 'original' buffer
    copy.prepend(42, count: prependCount)

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: initialWords))

    let copyWords = [Word](repeating: 42, count: prependCount) + initialWords
    XCTAssertEqual(copy, BigIntStorage(isNegative: false, words: copyWords))
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
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    copy.dropFirst(wordCount: initialWords.count * 2)

    XCTAssertEqual(original.count, initialWords.count)

    for (s, w) in zip(original, initialWords) {
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
    let original = BigIntStorage(isNegative: false, words: initialWords)

    var copy = original
    copy.dropFirst(wordCount: 3)

    XCTAssertEqual(original.count, initialWords.count)

    for (s, w) in zip(original, initialWords) {
      XCTAssertEqual(s, w)
    }
  }

  // MARK: - Equatable

  func test_equatable() {
    let original = BigIntStorage(isNegative: false, words: 0, 1, 2)
    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 0, 1, 2))

    var negative = original
    negative.isNegative.toggle()
    XCTAssertNotEqual(original, negative)

    var withAppend = original
    withAppend.append(100)
    XCTAssertNotEqual(original, withAppend)

    var changedFirst = original
    changedFirst[0] = 100
    XCTAssertNotEqual(original, changedFirst)

    var changedLast = original
    changedLast[2] = 100
    XCTAssertNotEqual(original, changedLast)
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
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.unsignedValues {
      var copy = original
      copy.set(to: value)

      XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 1, 2, 3))
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
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    for value in self.signedValues {
      var copy = original
      copy.set(to: value)

      XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 1, 2, 3))
    }
  }

  // MARK: - Transform

  func test_transform() {
    var storage = BigIntStorage(isNegative: false, words: 1, 2, 3)
    storage.transformEveryWord { $0 + 1 }

    XCTAssertEqual(storage, BigIntStorage(isNegative: false, words: 2, 3, 4))
  }

  func test_transform_cow() {
    let original = BigIntStorage(isNegative: false, words: 1, 2, 3)

    var copy = original
    copy.transformEveryWord { $0 + 1 }

    XCTAssertEqual(original, BigIntStorage(isNegative: false, words: 1, 2, 3))
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
