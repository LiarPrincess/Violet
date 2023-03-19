extension BigIntHeap {

  // MARK: - Hashable

  internal func hash(into hasher: inout Hasher) {
    if let smi = self.asSmiIfPossible() {
      smi.hash(into: &hasher)
    } else {
      hasher.combine(self.isNegative)
      hasher.combine(self.storage.count)

      self.storage.withWordsBuffer { words in
        for word in words {
          hasher.combine(word)
        }
      }
    }
  }

  // MARK: - Equatable

  internal static func == (heap: BigIntHeap, smi: Smi.Storage) -> Bool {
    guard heap.isNegative == smi.isNegative else {
      return false
    }

    // If we have more than 1 word then we are out of range of smi
    if heap.storage.count > 1 {
      return false
    }

    // We have the same sign. Do we have the same magnitude?
    // If we do not have any words then we are '0'
    return heap.storage.withWordsBuffer { words in
      let heapMagnitude = words.first ?? 0
      let smiMagnitude = smi.magnitude
      return heapMagnitude == smiMagnitude
    }
  }

  internal static func == (lhs: BigIntHeap, rhs: BigIntHeap) -> Bool {
    guard lhs.storage.isNegative == rhs.storage.isNegative else {
      return false
    }

    return lhs.storage.withWordsBuffer { lhs in
      return rhs.storage.withWordsBuffer { rhs in
        guard lhs.count == rhs.count else {
          return false
        }

        // By hand is faster than: zip(lhs, rhs).allSatisfy { $0.0 == $0.1 }
        for i in 0..<lhs.count where lhs[i] != rhs[i] {
          return false
        }

        return true
      }
    }
  }

  // MARK: - Comparable

  internal static func < (heap: BigIntHeap, smi: Smi.Storage) -> Bool {
    // Negative values are always smaller than positive ones (because math…)
    guard heap.isNegative == smi.isNegative else {
      return heap.isNegative
    }

    // We have the same sign, now we will be comparing magnitudes.
    let smiMagnitude = Word(smi.magnitude)
    let compareResult = heap.compareMagnitude(with: smiMagnitude)
    return compareResult.asLessOperatorResult(isNegative: heap.isNegative)
  }

  internal static func < (lhs: BigIntHeap, rhs: BigIntHeap) -> Bool {
    // Negative values are always smaller than positive ones (because math…)
    guard lhs.isNegative == rhs.isNegative else {
      return lhs.isNegative
    }

    // We have the same sign, now we will be comparing magnitudes.
    let compareResult = lhs.compareMagnitude(with: rhs)
    return compareResult.asLessOperatorResult(isNegative: lhs.isNegative)
  }

  // MARK: - Compare magnitudes

  internal enum CompareMagnitudeResult {
    case equal
    case less
    case greater

    fileprivate func asLessOperatorResult(isNegative: Bool) -> Bool {
      // This is very mind-bending (tbh. the whole 'math' is).
      //
      // Here is a diagram:
      // --------------------------------- 0 --------------------------------->
      // big magnitude                    zero                    big magnitude
      //
      // Soo… if we are positive:
      // - bigger magnitude  -> bigger number (further away from '0')
      // - smaller magnitude -> smaller number (closer to '0')
      //
      // If we are negative:
      // - bigger  magnitude -> smaller number (further away from '0')
      // - smaller magnitude -> bigger number (closer to '0')

      switch self {
      case .equal:
        return false
      case .less:
        return !isNegative
      case .greater:
        return isNegative
      }
    }
  }

  internal func compareMagnitude(with other: Word) -> CompareMagnitudeResult {
    // If we have more than 1 word then we are out of range of 'Word'
    if self.storage.count > 1 {
      return .greater
    }

    // If we do not have any words then we are '0'
    return self.storage.withWordsBuffer { words in
      let selfWord = words.first ?? 0
      return selfWord == other ? .equal :
             selfWord > other ? .greater :
            .less
    }
  }

  internal func compareMagnitude(with other: BigIntHeap) -> CompareMagnitudeResult {
    return self.compareMagnitude(with: other.storage)
  }

  internal func compareMagnitude(with other: BigIntStorage) -> CompareMagnitudeResult {
    // Shorter number is always smaller
    guard self.storage.count == other.count else {
      return self.storage.count < other.count ? .less : .greater
    }

    // Compare from most significant word
    return self.storage.withWordsBuffer { lhs in
      return other.withWordsBuffer { rhs in
        let count = lhs.count

        for i in stride(from: count - 1, through: 0, by: -1) {
          let l = lhs[i]
          let r = rhs[i]

          if l < r {
            return .less
          }

          if l > r {
            return .greater
          }

          // Equal -> compare next word
        }

        return .equal
      }
    }
  }
}
