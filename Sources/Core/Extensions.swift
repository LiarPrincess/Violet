extension Array {

  /// Basically: `self.append(element)`
  public mutating func push(_ element: Element) {
    self.append(element)
  }
}

extension Collection {

  /// A Boolean value that indicates whether the collection has any elements.
  ///
  /// `hasAny` would be a better name, but that's what you get if you
  /// dab too much in .Net.
  public var any: Bool {
    return !self.isEmpty
  }
}

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
}

extension OptionSet {

  /// A Boolean value that indicates whether the set has any elements.
  public var any: Bool {
    return !self.isEmpty
  }

  /// Returns a Boolean value that indicates whether
  /// the set contains any of the specified elements.
  public func containsAny(_ other: Self) -> Bool {
    return self.intersection(other).any
  }
}

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

extension String {

  /// Create String instance from given scalars.
  /// It can produce broken strings such as '\u{0301}' (COMBINING ACUTE ACCENT).
  /// Even if string does look correct it may not have sense, e.g. ' \u{0301}'.
  public init(_ scalars: [UnicodeScalar]) {
    let view = UnicodeScalarView(scalars)
    self.init(view)
  }

  public mutating func append(_ scalar: UnicodeScalar) {
    self.unicodeScalars.append(scalar)
  }
}

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

extension Substring.UnicodeScalarView {
  public var isValidIdentifier: IsValidIdentifierResult {
    return isValidIdentifierImpl(self)
  }
}

extension String.UnicodeScalarView {
  public var isValidIdentifier: IsValidIdentifierResult {
    return isValidIdentifierImpl(self)
  }
}

// MARK: - Helpers

private func takeExisting<Value>(_ existing: Value, _ new: Value) -> Value {
  return existing
}

public enum IsValidIdentifierResult {
  case yes
  case no(scalar: UnicodeScalar, column: SourceColumn)
  case emptyString
}

private func isValidIdentifierImpl<C>(_ scalars: C) -> IsValidIdentifierResult
  where C: Collection, C.Element == UnicodeScalar {

  // Returning single scalar does not make sense (scalars don't have meaning).
  // We include its index, but not very precise.
  // Basically everything is 'best efford', because text is hard.

  guard let first = scalars.first else {
    return .emptyString
  }

  guard first.isIdentifierStart else {
    return .no(scalar: first, column: 0)
  }

  for (index, c) in scalars.dropFirst().enumerated() {
    guard c.isIdentifierContinue else {
      let skippedFirst: SourceColumn = 1
      let column = skippedFirst + SourceColumn(index)
      return .no(scalar: c, column: column)
    }
  }

  return .yes
}
