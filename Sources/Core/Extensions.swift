import Foundation

// swiftlint:disable file_length

// MARK: - Array

extension Array {

  /// Basically: `self.append(element)`, but with more 'stack-oriented' name.
  public mutating func push(_ element: Element) {
    self.append(element)
  }
}

// MARK: - Collection

extension Collection {

  /// A Boolean value that indicates whether the collection has any elements.
  ///
  /// `hasAny` would be a better name, but that's what you get if you
  /// dab too much in .Net.
  public var any: Bool {
    return !self.isEmpty
  }

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

// MARK: - BidirectionalCollection

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

// MARK: - [Mutable/RangeReplaceable]Collection

extension MutableCollection
  where Self: RangeReplaceableCollection, Element: Hashable {
  /// Remove elements, so that at the end all of our elements are unique.
  /// Stable.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the collection.
  public mutating func removeDuplicates() {
    // If you want to write this yourself then remember that 'self.partition'
    // is not guaranteed to be stable (don't ask me how I know this...).
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

// MARK: - OptionSet

extension OptionSet {

  /// A Boolean value that indicates whether the set has any elements.
  public var any: Bool {
    return !self.isEmpty
  }

  /// Returns a Boolean value that indicates whether
  /// the set has any intersection with specified elements.
  public func contains(anyOf other: Self) -> Bool {
    return self.intersection(other).any
  }
}

// MARK: - Dictionary

extension Dictionary {

  /// Returns a Boolean value indicating whether the sequence contains the
  /// given element.
  public func contains(_ key: Key) -> Bool {
    return self[key] != nil
  }

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

// MARK: - String

extension String {

  /// Use `strerror` to describe given error.
  public init?(errno: Int32) {
    guard let cStr = strerror(errno) else {
      return nil
    }

    self = String(cString: cStr)
  }

  /// Create String instance from given scalars.
  ///
  /// It can produce broken strings such as '\u{0301}' (COMBINING ACUTE ACCENT).
  /// Even if string does look correct it may not have sense, e.g. ' \u{0301}'.
  public init<Scalars: Collection>(_ scalars: Scalars)
    where Scalars.Element == UnicodeScalar {

    let view = UnicodeScalarView(scalars)
    self.init(view)
  }

  private enum Quote: Character, CustomStringConvertible {
    case single = "'"
    case double = "\""

    fileprivate var description: String {
      return String(self.rawValue)
    }

    fileprivate var opposite: Quote {
      switch self {
      case .single: return .double
      case .double: return .single
      }
    }
  }

  /// Add quotes if needed.
  public var quoted: String {
    // This will also check for empty
    guard let first = self.first, let last = self.last else {
      return "''"
    }

    var firstAsQuote: Quote?
    switch first {
    case "'": firstAsQuote = .single
    case "\"": firstAsQuote = .double
    default: break
    }

    // Check if we already have quotes
    if let f = firstAsQuote, f.rawValue == last {
      return self
    }

    // We need to add quotes (but not the same as existing)
    // If we do not have quotes then single quote is preferred
    let quote = firstAsQuote?.opposite ?? .single
    return "\(quote)\(self)\(quote)"
  }

  public mutating func append(_ scalar: UnicodeScalar) {
    self.unicodeScalars.append(scalar)
  }
}

// MARK: - UnicodeScalar

extension UnicodeScalar {

  /// Try to convert scalar to digit.
  ///
  /// Acceptable values:
  /// - ascii numbers
  /// - ascii lowercase letters (a - z)
  /// - ascii uppercase letters (A - Z)
  public var asDigit: Int? {
    // Tip: use 'man ascii':
    let  a = 0x61,  z = 0x7a
    let  A = 0x41,  Z = 0x5a
    let n0 = 0x30, n9 = 0x39

    let value = Int(self.value)

    if n0 <= value && value <= n9 {
      return value - n0
    }

    if a <= value && value <= z {
      return value - a + 10 // '+ 10' because 'a' is 10 not 0
    }

    if A <= value && value <= Z {
      return value - A + 10
    }

    return nil
  }

  /// Try to convert scalar to decimal digit.
  ///
  /// Acceptable values:
  /// - ascii numbers
  public var asDecimalDigit: Int? {
    guard let digit = self.asDigit else {
      return nil
    }

    return digit < 10 ? digit : nil
  }

  /// Try to convert scalar to hex digit.
  ///
  /// Acceptable values:
  /// - ascii numbers
  /// - ascii lowercase letters (a - f)
  /// - ascii uppercase letters (A - F)
  public var asHexDigit: Int? {
    guard let digit = self.asDigit else {
      return nil
    }

    return digit < 16 ? digit : nil
  }

  /// U+XXXX (for example U+005F). Then you can use it
  /// [here](https://unicode.org/cldr/utility/character.jsp?a=005f)\.
  public var codePointNotation: String {
    var numberPart = String(self.value, radix: 16, uppercase: true)

    if numberPart.count < 4 {
      let pad = String(repeating: "0", count: 4 - numberPart.count)
      assert(pad.any)
      numberPart = pad + numberPart
    }

    return "U+\(numberPart)"
  }

  /// Basically `self.properties.isXIDStart` + underscore.
  ///
  /// Why underscore?
  /// I'm glad you asked:
  /// https://unicode.org/cldr/utility/character.jsp?a=005f
  public var isIdentifierStart: Bool {
    return self.properties.isXIDStart || self == "_"
  }

  /// Basically `self.properties.isXIDContinue`
  public var isIdentifierContinue: Bool {
    return self.properties.isXIDContinue
  }
}

public enum IsValidIdentifierResult {
  case yes
  case no(scalar: UnicodeScalar, column: SourceColumn)
  case emptyString
}

extension Collection where Element == UnicodeScalar {

  public var isValidIdentifier: IsValidIdentifierResult {
    // Returning single scalar does not make sense (scalars don't have meaning).
    // We include its index, but not very precise.
    // Basically everything is 'best efford', because text is hard.

    guard let first = self.first else {
      return .emptyString
    }

    guard first.isIdentifierStart else {
      return .no(scalar: first, column: 0)
    }

    for (index, c) in self.dropFirst().enumerated() {
      guard c.isIdentifierContinue else {
        let skippedFirst: SourceColumn = 1
        let column = skippedFirst + SourceColumn(index)
        return .no(scalar: c, column: column)
      }
    }

    return .yes
  }
}
