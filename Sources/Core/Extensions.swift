import Foundation

// MARK: - Array

extension Array {

  /// Basically: `self.append(element)`
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
}

// MARK: - BidirectionalCollection

extension BidirectionalCollection {

  /// Returns a Boolean value indicating whether the ending elements of the
  /// collection are the same as the elements in another collection.
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

    // If it is the suffix that was shorter then it is OK.
    return suffixIndex == suffix.startIndex
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
}

// MARK: - OptionSet

extension OptionSet {

  /// A Boolean value that indicates whether the set has any elements.
  public var any: Bool {
    return !self.isEmpty
  }

  /// Returns a Boolean value that indicates whether
  /// the set contains any of the specified elements.
  ///
  /// `contains(anyOf:)` would be a better name, but this one comes up faster
  /// in intelisense.
  public func containsAny(_ other: Self) -> Bool {
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

  public mutating func merge(_ other: [Key : Value],
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
  /// It can produce broken strings such as '\u{0301}' (COMBINING ACUTE ACCENT).
  /// Even if string does look correct it may not have sense, e.g. ' \u{0301}'.
  public init<Scalars: Collection>(_ scalars: Scalars)
    where Scalars.Element == UnicodeScalar {

    let view = UnicodeScalarView(scalars)
    self.init(view)
  }

  public mutating func append(_ scalar: UnicodeScalar) {
    self.unicodeScalars.append(scalar)
  }
}

// MARK: - UnicodeScalar

extension UnicodeScalar {

  /// Scalar -> U+XXXX (for example U+005F). Then you can use it
  /// [here](https://unicode.org/cldr/utility/character.jsp?a=005f)\.
  public var uPlus: String {
    let hex = String(self.value, radix: 16, uppercase: true)
    let pad = String(repeating: "0", count: 4 - hex.count)
    return "U+\(pad)\(hex)"
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
