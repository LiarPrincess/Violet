extension Array {

  /// Basically: `self.append(element)`
  public mutating func push(_ element: Element) {
    self.append(element)
  }
}

extension Collection {

  /// A Boolean value that indicates whether the collection has any elements.
  public var any: Bool {
    return !self.isEmpty
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

private func takeExisting<Value>(_ existing: Value, _ new: Value) -> Value {
  return existing
}

extension String {

  /// Create String instance from given scalars.
  /// It can produce broken strings such as '\u{0301}' (COMBINING ACUTE ACCENT).
  /// Even if string does look correct it may not have sense, e.g. ' \u{0301}'.
  public init(_ scalars: [UnicodeScalar]) {
    let view = UnicodeScalarView(scalars)
    self.init(view)
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
}
