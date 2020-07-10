@testable import BigInt

// MARK: - BigIntHeap

extension BigIntHeap {

  internal init(isNegative: Bool, words: Word...) {
    self.init(isNegative: isNegative, words: words)
  }

  internal init(isNegative: Bool, words: [Word]) {
    let storage = BigIntStorage(isNegative: isNegative, words: words)
    self.init(storage: storage)
  }
}

// MARK: - BigIntStorage

extension BigIntStorage {

  internal init(isNegative: Bool, words: Word...) {
    self.init(isNegative: isNegative, words: words)
  }

  internal init(isNegative: Bool, words: [Word]) {
    if words.isEmpty {
      self = BigIntStorage.zero
      return
    }

    self.init(minimumCapacity: words.count)
    self.isNegative = isNegative

    for word in words {
      self.append(word)
    }
  }
}
