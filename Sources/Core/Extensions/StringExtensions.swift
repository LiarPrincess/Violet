import Foundation

// MARK: - String + init from errno

extension String {

  /// Use `strerror` to describe given error.
  public init?(errno: Int32) {
    guard let cStr = strerror(errno) else {
      return nil
    }

    self = String(cString: cStr)
  }
}

// MARK: - String + init from scalars

extension String {

  /// Create String instance from given scalars.
  ///
  /// It can produce broken strings such as '\u{0301}' (COMBINING ACUTE ACCENT).
  /// Even if string does look correct it may not have sense, e.g. ' \u{0301}'.
  public init<Scalars: Collection>(_ scalars: Scalars)
    where Scalars.Element == UnicodeScalar {

    let view = UnicodeScalarView(scalars)
    self.init(view)
  }
}

// MARK: - String + quoted

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

extension String {

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
}

// MARK: - String + append scalar

extension String {

  public mutating func append(_ scalar: UnicodeScalar) {
    self.unicodeScalars.append(scalar)
  }
}

// MARK: - Scalar + as digit

extension UnicodeScalar {

  /// Try to convert scalar to digit.
  ///
  /// Acceptable values:
  /// - ascii numbers
  /// - ascii lowercase letters (a - z)
  /// - ascii uppercase letters (A - Z)
  public var asDigit: Int? {
    // Tip: use 'man ascii':
    let a = 0x61, z = 0x7a
    let A = 0x41, Z = 0x5a
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
}

// MARK: - Scalar + code point notation

extension UnicodeScalar {

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
}

// MARK: - Scalar + identifier

extension UnicodeScalar {

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
    // Basically everything is 'best effort', because text is hard.

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
