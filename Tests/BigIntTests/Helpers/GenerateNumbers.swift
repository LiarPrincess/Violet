@testable import BigInt

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMin = Smi.Storage.min

// MARK: - Fixed width integers

/// Will return `2 * countButNotReally + 3` values (don't ask).
internal func generateSmiValues(countButNotReally: Int) -> [Smi.Storage] {
  return generateValues(
    countButNotReally: countButNotReally,
    type: Smi.Storage.self
  )
}

/// Will return `2 * countButNotReally + 3` values (don't ask).
internal func generateIntValues(countButNotReally: Int) -> [Int] {
  return generateValues(
    countButNotReally: countButNotReally,
    type: Int.self
  )
}

private func generateValues<T: FixedWidthInteger>(
  countButNotReally: Int,
  type: T.Type
) -> [T] {
  assert(countButNotReally > 0)

  var result = [T]()
  result.append(0)
  result.append(1)
  result.append(-1)

  let step = Int(T.max) / countButNotReally

  // 1st iteration will append 'T.min' and 'T.max'
  for i in 0..<countButNotReally {
    let s = i * step

    let fromMax = T(Int(T.max) - s)
    result.append(fromMax)

    let fromMin = T(Int(T.min) + s)
    result.append(fromMin)
  }

  return result
}

// MARK: - Heap

internal struct HeapPrototype {

  internal let isNegative: Bool
  internal let words: [BigIntStorage.Word]

  internal var isPositive: Bool {
    return !self.isNegative
  }

  internal var isZero: Bool {
    return self.words.isEmpty
  }

  internal var hasMagnitudeOfOne: Bool {
    return self.words.count == 1 && self.words[0] == 1
  }

  internal func create() -> BigIntHeap {
    return BigIntHeap(isNegative: self.isNegative, words: self.words)
  }
}

/// Will return `2 * countButNotReally + 5` values (don't ask).
///
/// We do not return `BigIntHeap` directly because in some cases
/// (for example equality tests) you may want to create more than 1 value
/// INDEPENDENTLY.
internal func generateHeapValues(countButNotReally: Int,
                                 maxWordCount: Int = 3) -> [HeapPrototype] {
  var result = [HeapPrototype]()
  result.append(HeapPrototype(isNegative: false, words: [])) //  0
  result.append(HeapPrototype(isNegative: false, words: [1])) //  1
  result.append(HeapPrototype(isNegative: true, words: [1])) // -1
  result.append(HeapPrototype(isNegative: false, words: [.max])) //  Word.max
  result.append(HeapPrototype(isNegative: true, words: [.max])) // -Word.max

  var word = Word(2) // Start from '2' and go up
  for i in 0..<countButNotReally {
    let min1WordBecauseWeAlreadyAddedZero = 1
    let wordCount = (i % maxWordCount) + min1WordBecauseWeAlreadyAddedZero

    var words = [Word]()
    for _ in 0..<wordCount {
      words.append(word)
      word += 1
    }

    result.append(HeapPrototype(isNegative: false, words: words))
    result.append(HeapPrototype(isNegative: true, words: words))
  }

  return result
}
