import Foundation

// MARK: - Array + push

extension Array {

  /// Basically: `self.append(element)`, but with more 'stack-oriented' name.
  public mutating func push(_ element: Element) {
    self.append(element)
  }
}

// MARK: - Collection + any

extension Collection {

  /// A Boolean value that indicates whether the collection has any elements.
  ///
  /// `hasAny` would be a better name, but that's what you get if you
  /// dab too much in .Net.
  public var any: Bool {
    return !self.isEmpty
  }
}

extension OptionSet {

  /// A Boolean value that indicates whether the set has any elements.
  public var any: Bool {
    return !self.isEmpty
  }
}

// MARK: - Collection + count where

extension Collection {

  /// Count elements that satisfy given predicate.
  public func count(where predicate: (Element) -> Bool) -> Int {
    var result = 0
    for element in self {
      if predicate(element) {
        result += 1
      }
    }

    return result
  }
}

// MARK: - Collection + takeFirst

extension Collection {

  /// Returns a subsequence containing the given number of initial elements.
  ///
  /// If the number of elements to take exceeds the number of elements in
  /// the collection, the result is the whole collection.
  ///
  ///     let numbers = [1, 2, 3, 4, 5]
  ///     print(numbers.takeFirst(2))
  ///     // Prints "[1, 2]"
  ///     print(numbers.takeFirst(10))
  ///     // Prints "[1, 2, 3, 4, 5]"
  ///
  /// - Parameter k: The number of elements to take from the beginning of
  ///   the collection. `k` must be greater than or equal to zero.
  /// - Returns: A subsequence ending after the specified number of
  ///   elements.
  ///
  /// - Complexity: O(1) if the collection conforms to `RandomAccessCollection`;
  ///   otherwise, O(*k*), where *k* is the number of elements to take.
  public func takeFirst(_ k: Int = 1) -> SubSequence {
    precondition(
      k >= 0,
      "Can't take a negative number of elements from a collection"
    )

    let end = self.index(self.startIndex,
                         offsetBy: k,
                         limitedBy: self.endIndex) ?? self.endIndex

    return self[..<end]
  }
}

// MARK: - BidirectionalCollection + takeLast

extension BidirectionalCollection {

  /// Returns a subsequence containing specified number of final elements.
  ///
  /// If the number of elements to take exceeds the number of elements in the
  /// collection, the result is the whole collection.
  ///
  ///     let numbers = [1, 2, 3, 4, 5]
  ///     print(numbers.takeLast(2))
  ///     // Prints "[4, 5]"
  ///     print(numbers.takeLast(10))
  ///     // Prints "[1, 2, 3, 4, 5]"
  ///
  /// - Parameter k: The number of elements to take from starting from the end
  ///   of the collection. `k` must be greater than or equal to zero.
  /// - Returns: A subsequence that takes `k` elements from the end.
  ///
  /// - Complexity: O(1) if the collection conforms to `RandomAccessCollection`;
  ///   otherwise, O(*k*), where *k* is the number of elements to take.
  public func takeLast(_ k: Int = 1) -> SubSequence {
    precondition(
      k >= 0,
      "Can't take a negative number of elements from a collection"
    )

    let start = self.index(
      self.endIndex,
      offsetBy: -k,
      limitedBy: self.startIndex) ?? self.startIndex

    return self[start...]
  }
}

// MARK: - BidirectionalCollection + endsWith

extension BidirectionalCollection {

  /// Returns a Boolean value indicating whether the ending elements of the
  /// collection are the same as the elements in another collection.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the shorter collection
  /// from `self`, `suffix` pair.
  public func ends<Suffix>(with suffix: Suffix) -> Bool
    where Suffix: BidirectionalCollection,
          Suffix.Element == Element,
          Element: Equatable {
    // This implementation assumes that `self.index(offsetBy:)` is not efficient
    // (for example it has to iterate collection from start or something).
    // Otherwise we would create `Slice` and use `==` on each element,
    // then we would not require `BidirectionalCollection`, but a `Sequence`.

    if self.isEmpty {
      return suffix.isEmpty
    }

    if suffix.isEmpty {
      return true
    }

    var selfIndex = self.endIndex
    var suffixIndex = suffix.endIndex

    // `endIndex` is AFTER the collection
    self.formIndex(before: &selfIndex)
    suffix.formIndex(before: &suffixIndex)

    while selfIndex != self.startIndex && suffixIndex != suffix.startIndex {
      guard self[selfIndex] == suffix[suffixIndex] else {
        return false
      }

      // Advance indices (is it still 'advance' when we go back?)
      self.formIndex(before: &selfIndex)
      suffix.formIndex(before: &suffixIndex)
    }

    // Compare first element
    guard self[selfIndex] == suffix[suffixIndex] else {
      return false
    }

    let areEqualLengthOrSuffixIsShorter = suffixIndex == suffix.startIndex
    return areEqualLengthOrSuffixIsShorter
  }
}

// MARK: - BidirectionalCollection + drop last

extension BidirectionalCollection {

  /// Returns a subsequence by skipping elements (starting from last) while
  /// `predicate` returns `true` and returning the remaining elements.
  ///
  /// - Parameter predicate: A closure that takes an element of the
  ///   sequence as its argument and returns `true` if the element should
  ///   be skipped or `false` if it should be included. Once the predicate
  ///   returns `false` it will not be called again.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the collection.
  public func dropLast(
    while predicate: (Element) throws -> Bool
  ) rethrows -> SubSequence {

    if self.isEmpty {
      return self.emptySubSequence
    }

    // `endIndex` is AFTER the collection
    var index = self.endIndex
    self.formIndex(before: &index)

    while index != self.startIndex {
      let isSkipped = try predicate(self[index])
      guard isSkipped else {
        return self[self.startIndex...index]
      }

      self.formIndex(before: &index)
    }

    // We are at 'self.startIndex'
    let isStartSkipped = try predicate(self[index])
    return isStartSkipped ?
      self.emptySubSequence :
      self[index...index] // include 1st character
  }

  private var emptySubSequence: SubSequence {
    return self[self.startIndex..<self.startIndex]
  }
}

// MARK: - [Mutable/RangeReplaceable]Collection + remove duplicates

extension Collection where
  Self: MutableCollection,
  Self: RangeReplaceableCollection,
  Element: Hashable {

  /// Remove elements, so that at the end all of our elements are unique.
  /// Stable.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the collection.
  public mutating func removeDuplicates() {
    // If you want to write this yourself then remember that 'self.partition'
    // is not guaranteed to be stable (don't ask me how I know this…).
    var alreadyProcessed = Set<Self.Element>()

    self.removeAll { element in
      if alreadyProcessed.contains(element) {
        return true
      }

      alreadyProcessed.insert(element)
      return false
    }
  }
}

// MARK: - Dictionary + contains

extension Dictionary {

  /// Returns a Boolean value indicating whether the sequence contains the
  /// given element.
  public func contains(_ key: Key) -> Bool {
    return self[key] != nil
  }
}

// MARK: - Dictionary + merge

extension Dictionary {

  public enum UniquingKeysWithStrategy {
    case takeExisting
  }

  public mutating func merge(_ other: [Key: Value],
                             uniquingKeysWith: UniquingKeysWithStrategy) {
    switch uniquingKeysWith {
    case .takeExisting:
      self.merge(other, uniquingKeysWith: takeExisting)
    }
  }
}

private func takeExisting<Value>(_ existing: Value, _ new: Value) -> Value {
  return existing
}

// MARK: - OptionSet + contains any of

extension OptionSet {

  /// Returns a Boolean value that indicates whether
  /// the set has any intersection with specified elements.
  public func contains(anyOf other: Self) -> Bool {
    return self.intersection(other).any
  }
}
