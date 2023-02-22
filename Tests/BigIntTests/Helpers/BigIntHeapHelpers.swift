@testable import BigInt

// MARK: - BigIntHeap

extension BigIntHeap {

  internal init(isNegative: Bool, words: Word...) {
    self.init(isNegative: isNegative, words: words)
  }

  internal init(isNegative: Bool, words: [Word]) {
    var storage = BigIntStorage(isNegative: isNegative, words: words)
    let token = storage.guaranteeUniqueBufferReference()
    storage.fixInvariants(token)
    self.init(storageWithValidInvariants: storage)
  }

  internal init(storage: BigIntStorage) {
    var copy = storage
    let token = copy.guaranteeUniqueBufferReference()
    copy.fixInvariants(token)
    self.init(storageWithValidInvariants: copy)
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
    let token = self.guaranteeUniqueBufferReference()
    self.setIsNegative(token, value: isNegative)

    for word in words {
      self.append(token, element: word)
    }
  }
}
