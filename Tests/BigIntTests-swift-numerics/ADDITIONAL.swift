@testable import BigInt

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
      self.appendAssumingCapacity(token, element: word)
    }
  }
}

extension BigInt {
  internal init(_ storage: BigIntStorage) {
    var copy = storage
    let token = copy.guaranteeUniqueBufferReference()
    copy.fixInvariants(token)
    copy.checkInvariants()
    let heap = BigIntHeap(storageWithValidInvariants: copy)
    self = BigInt(heap)
  }
}
