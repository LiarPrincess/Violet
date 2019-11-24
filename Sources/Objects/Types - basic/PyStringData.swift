import Core

// swiftlint:disable file_length

// MARK: - String data

/// Basically `PyString` that does not require `PyContext`.
///
/// Everything here is 'best-efford'
///
/// We work on scalars (Unicode code points) instead of graphemes because:
/// - len("Cafe\u0301") = 5 (Swift: "Cafe\u{0301}".unicodeScalars.count)
/// - len("Café")       = 4 (Swift: "Café".unicodeScalars.count)
internal struct PyStringData: PyStringDataImpl, CustomStringConvertible {

  internal let value: String

  internal var scalars: String.UnicodeScalarView {
    return self.value.unicodeScalars
  }

  internal var description: String {
    return self.value
  }

  internal init(_ value: String) {
    self.value = value
  }
}

// MARK: - String data slice

internal struct PyStringDataSlice: PyStringDataImpl {

  internal let scalars: String.UnicodeScalarView.SubSequence

  internal init(_ value: String.UnicodeScalarView.SubSequence) {
    self.scalars = value
  }
}

// MARK: - String

extension String {
  internal init<S: PyStringDataImpl>(_ value: S) {
    self.init(value.scalars)
  }
}

// MARK: - Implementation

internal protocol PyStringDataImpl {

  /// Basically either `String.UnicodeScalarView`
  /// or `String.UnicodeScalarView.SubSequence`
  /// (there is no chance that any other type would be able to conform
  /// to our requirements).
  associatedtype UnicodeScalars: BidirectionalCollection where
    //  UnicodeScalars.Element == UnicodeScalar, // redundant
    //  UnicodeScalars.Index == String.UnicodeScalarIndex, // redundant
    UnicodeScalars.SubSequence == String.UnicodeScalarView.SubSequence

  var scalars: UnicodeScalars { get }
}

internal enum StringCompareResult {
  case less
  case greater
  case equal
}
internal enum StringFindResult {
  case index(index: String.UnicodeScalarIndex, position: Int)
  case notFound
}

internal enum StringPartitionResult {
  /// Separator was not found
  case notFound
  /// Separator was found.
  case triple(before: PyStringDataSlice, after: PyStringDataSlice)
  case error(PyErrorEnum)
}

private let alphaCategories: Set<Unicode.GeneralCategory> = Set([
  .modifierLetter, // Lm
  .titlecaseLetter, // Lt
  .uppercaseLetter, // Lu
  .lowercaseLetter, // Ll
  .otherLetter // Lo
])

private let lineBreaks: Set<UnicodeScalar> = Set([
  "\n", // \n - Line Feed
  "\r", // \r - Carriage Return
  // \r\n - Carriage Return + Line Feed
  "\u{0b}", // \v or \x0b - Line Tabulation
  "\u{0c}", // \f or \x0c - Form Feed
  "\u{1c}", // \x1c - File Separator
  "\u{1d}", // \x1d - Group Separator
  "\u{1e}", // \x1e - Record Separator
  "\u{85}", // \x85 - Next Line (C1 Control Code)
  "\u{2028}", // \u2028 - Line Separator
  "\u{2029}" // \u2029 - Paragraph Separator
])

extension PyStringDataImpl {

  // MARK: - Compare

  internal func compare(to other: PyStringData) -> StringCompareResult {
    // "Cafe\u0301" == "Café" (Caf\u00E9) -> False
    // "Cafe\u0301" <  "Café" (Caf\u00E9) -> True
    var selfIter = self.scalars.makeIterator()
    var otherIter = other.scalars.makeIterator()

    var selfValue = selfIter.next()
    var otherValue = otherIter.next()

    while let s = selfValue, let o = otherValue {
      if s.value < o.value {
        return .less
      }

      if s.value > o.value {
        return .greater
      }

      selfValue = selfIter.next()
      otherValue = otherIter.next()
    }

    // One (or both) of the values is nil (which means that we arrived to end)
    switch (selfValue, otherValue) {
    case (nil, nil): return .equal // Both at end
    case (nil, _): return .less // Finished self, other has some remaining
    case (_, nil): return .greater // Finished other, self has some remaining
    default:
      // Not possible? See `while` condition.
      fatalError("Error when comparing '\(self)' and '\(other)'")
    }
  }

  // MARK: - Repr

  internal var repr: String {
    // Find quote character
    var singleQuoteCount = 0
    var doubleQuoteCount = 0
    for c in self.scalars {
      switch c {
      case "'":  singleQuoteCount += 1
      case "\"": doubleQuoteCount += 1
      default:   break
      }
    }

    // Use single quote if equal
    let quote: UnicodeScalar = doubleQuoteCount > singleQuoteCount ? "\"" : "'"

    var result = String(quote)
    result.reserveCapacity(self.scalars.count)

    for s in self.scalars {
      switch s {
      case quote, "\\":
        result.append("\\")
        result.append(s)
      case "\n":
        result.append("\\")
        result.append("n")
      case "\t":
        result.append("\\")
        result.append("t")
      case "\r":
        result.append("\\")
        result.append("r")
      default:
        result.append(s)
      }
    }
    result.append(quote)

    return result
  }

  // MARK: - Str

  internal var str: String {
    return String(self)
  }

  // MARK: - Length

  internal var isEmpty: Bool {
    return self.scalars.isEmpty
  }

  internal var count: Int {
    // len("Cafe\u0301") -> 5
    // len("Café")       -> 4
    return self.scalars.count
  }

  // MARK: - Index

  internal typealias Index = String.UnicodeScalarIndex

  internal var startIndex: Index {
    return self.scalars.startIndex
  }

  internal var endIndex: Index {
    return self.scalars.endIndex
  }

  internal func formIndex(after i: inout Index) {
    self.scalars.formIndex(after: &i)
  }

  internal func formIndex(before i: inout Index) {
    self.scalars.formIndex(before: &i)
  }

  internal func index(_ i: Index, offsetBy distance: Int) -> Index {
    return self.scalars.index(i, offsetBy: distance)
  }

  internal func index(_ i: Index,
                      offsetBy distance: Int,
                      limitedBy limit: Index) -> Index? {
    return self.scalars.index(i, offsetBy: distance, limitedBy: limit)
  }

  // MARK: - Substring

  internal func substring(start: Index? = nil,
                          end:   Index? = nil) -> PyStringDataSlice {
    let s = start ?? self.startIndex
    let e = end   ?? self.endIndex
    return PyStringDataSlice(self.scalars[s..<e])
  }

  // MARK: - Contains

  internal func contains(_ data: PyStringData) -> Bool {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'

    switch self.find(in: self, value: data) {
    case .index: return true
    case .notFound: return false
    }
  }

  // MARK: - Properties

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one characte.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  internal var isAlphaNumeric: Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      let category = properties.generalCategory
      return alphaCategories.contains(category)
        || category == .decimalNumber
        || properties.numericType != nil
    }
  }

  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  internal var isAlpha: Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let category = scalar.properties.generalCategory
      return alphaCategories.contains(category)
    }
  }

  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  internal var isAscii: Bool {
    return self.scalars.any && self.scalars.allSatisfy { $0.isASCII }
  }

  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  internal var isDecimal: Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.generalCategory == .decimalNumber }
  }

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  internal var isDigit: Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      guard let numericType = scalar.properties.numericType else {
        return false
      }

      return numericType == .digit || numericType == .decimal
    }
  }

  /// https://docs.python.org/3/library/stdtypes.html#str.isidentifier
  internal var isIdentifier: Bool {
    switch self.scalars.isValidIdentifier {
    case .yes:
      return true
    case .no, .emptyString:
      return false
    }
  }

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  internal var isLower: Bool {
    // If the character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      return !properties.isCased || properties.isLowercase
    }
  }

  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  internal var isNumeric: Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.numericType != nil }
  }

  /// Return true if all characters in the string are printable
  /// or the string is empty.
  ///
  /// Nonprintable characters are those characters defined in the Unicode
  /// character database as “Other” or “Separator”,
  /// excepting the ASCII space (0x20) which is considered printable.
  ///
  /// All characters except those characters defined in the Unicode character
  /// database as following categories are considered printable.
  ///    * Cc (Other, Control)
  ///    * Cf (Other, Format)
  ///    * Cs (Other, Surrogate)
  ///    * Co (Other, Private Use)
  ///    * Cn (Other, Not Assigned)
  ///    * Zl Separator, Line ('\u2028', LINE SEPARATOR)
  ///    * Zp Separator, Paragraph ('\u2029', PARAGRAPH SEPARATOR)
  ///    * Zs (Separator, Space) other than ASCII space('\x20').
  /// https://docs.python.org/3/library/stdtypes.html#str.isprintable
  internal var isPrintable: Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let space = 32
      if scalar.value == space {
        return true
      }

      switch scalar.properties.generalCategory {
      case .control, // Cc
      .format, // Cf
      .surrogate, // Cs
      .privateUse, // Co
      .unassigned, // Cn
      .lineSeparator, // Zl
      .paragraphSeparator, // Zp
      .spaceSeparator: // Zs
        return false
      default:
        return true
      }
    }
  }

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  internal var isSpace: Bool {
    return self.scalars.any && self.scalars.allSatisfy {
      $0.properties.generalCategory == .spaceSeparator
        || Unicode.bidiClass_ws_b_s.contains($0.value)
    }
  }

  /// Return true if the string is a titlecased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  internal var isTitle: Bool {
    var cased = false
    var isPreviousCased = false
    for scalar in self.scalars {
      switch scalar.properties.generalCategory {
      case .lowercaseLetter:
        if !isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true

      case .uppercaseLetter, .titlecaseLetter:
        if isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true

      default:
        isPreviousCased = false
      }
    }

    return cased
  }

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  internal var isUpper: Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      return !properties.isCased || properties.isUppercase
    }
  }

  // MARK: - Starts/Ends with

  internal func starts<S: PyStringDataImpl>(with element: S) -> Bool {
    // "e\u0301".startswith("é") -> False
    return self.scalars.starts(with: element.scalars)
  }

  internal func ends<S: PyStringDataImpl>(with element: S) -> Bool {
    // "e\u0301".endswith("é") -> False
    return self.scalars.ends(with: element.scalars)
  }

  // MARK: - Strip whitespace

  internal func stripWhitespace() -> String {
    let tmp = self.lstripWhitespace(in: self)
    return String(self.rstripWhitespace(in: tmp))
  }

  internal func lstripWhitespace() -> String {
    return String(self.lstripWhitespace(in: self))
  }

  internal func rstripWhitespace() -> String {
    return String(self.rstripWhitespace(in: self))
  }

  private func lstripWhitespace<S: PyStringDataImpl>(in value: S) -> PyStringDataSlice {
    let result = value.scalars.drop { $0.properties.isWhitespace }
    return PyStringDataSlice(result)
  }

  private func rstripWhitespace<S: PyStringDataImpl>(in value: S) -> PyStringDataSlice {
    let result = value.scalars.dropLast { $0.properties.isWhitespace }
    return PyStringDataSlice(result)
  }

  // MARK: - Strip

  internal func strip(chars: Set<UnicodeScalar>) -> String {
    let tmp = self.lstrip(self, chars: chars)
    return String(self.rstrip(tmp, chars: chars))
  }

  internal func lstrip(chars: Set<UnicodeScalar>) -> String {
    return String(self.lstrip(self, chars: chars))
  }

  internal func rstrip(chars: Set<UnicodeScalar>) -> String {
    return String(self.rstrip(self, chars: chars))
  }

  private func lstrip<S: PyStringDataImpl>(
    _ value: S,
    chars: Set<UnicodeScalar>) -> PyStringDataSlice {

    let scalars = value.scalars
    var index = scalars.startIndex

    while index != scalars.endIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(after: &index)
    }

    return value.substring(start: index)
  }

  private func rstrip<S: PyStringDataImpl>(
    _ value: S,
    chars: Set<UnicodeScalar>) -> PyStringDataSlice {

    let scalars = value.scalars
    var index = scalars.endIndex

    while index != scalars.startIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(before: &index)
    }

    return value.substring(end: index)
  }

  // MARK: - Find

  internal func find(value: PyStringData) -> StringFindResult {
    return self.find(in: self, value: value)
  }

  private func find<S: PyStringDataImpl>(in container: S,
                                         value: PyStringData) -> StringFindResult {
    if container.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = 0
    var index = container.startIndex

    while index != container.endIndex {
      let substring = container.substring(start: index)
      if substring.starts(with: value) {
        return .index(index: index, position: position)
      }

      position += 1
      container.formIndex(after: &index)
    }

    return .notFound
  }

  internal func rfind(value: PyStringData) -> StringFindResult {
    return self.rfind(in: self, value: value)
  }

  private func rfind<S: PyStringDataImpl>(in container: S,
                                          value: PyStringData) -> StringFindResult {
    if container.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = container.count - 1
    var index = container.endIndex

    // `endIndex` is AFTER the collection
    container.formIndex(before: &index)

    while index != container.startIndex {
      let substring = container.substring(start: index)
      if substring.starts(with: value) {
        return .index(index: index, position: position)
      }

      position -= 1
      container.formIndex(before: &index)
    }

    // Check if maybe we start with it (it was not checked inside loop!)
    if container.starts(with: value) {
      return .index(index: index, position: 0)
    }

    return .notFound
  }

  // MARK: - Case

  internal func lowerCased() -> String {
    return String(self).lowercased()
  }

  internal func upperCased() -> String {
    return String(self).uppercased()
  }

  internal func titleCased() -> String {
    var result = ""
    var isPreviousCased = false

    for scalar in self.scalars {
      let properties = scalar.properties

      switch properties.generalCategory {
      case .lowercaseLetter:
        if isPreviousCased {
          result.append(properties.titlecaseMapping)
        } else {
          result.append(scalar)
        }
        isPreviousCased = true

      case .uppercaseLetter, .titlecaseLetter:
        if isPreviousCased {
          result.append(properties.lowercaseMapping)
        } else {
          result.append(scalar)
        }
        isPreviousCased = true

      default:
        isPreviousCased = false
        result.append(scalar)
      }
    }

    return result
  }

  internal func swapCase() -> String {
    var result = ""
    for scalar in self.scalars {
      let properties = scalar.properties
      if properties.isLowercase {
        result.append(properties.uppercaseMapping)
      } else if properties.isUppercase {
        result.append(properties.lowercaseMapping)
      } else {
        result.append(scalar)
      }
    }
    return result
  }

  internal func caseFold() -> String {
    var result = ""
    for scalar in self.scalars {
      if let mapping = Unicode.caseFoldMapping[scalar.value] {
        result.append(mapping)
      } else {
        result.append(scalar)
      }
    }
    return result
  }

  internal func capitalize() -> String {
    // Capitalize only first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = self.scalars.first else {
      return String(self)
    }

    let head = first.properties.titlecaseMapping
    let tail = String(self.scalars.dropFirst()).lowercased()
    return head + tail
  }

  // MARK: - Center, just

  internal func center(width: Int, fill: UnicodeScalar) -> String {
    let marg = width - self.scalars.count
    guard marg > 0 else {
      return String(self)
    }

    let left = marg / 2 + (marg & width & 1)
    let right = marg - left
    return self.pad(left: left, right: right, fill: fill)
  }

  internal func ljust(width: Int, fill: UnicodeScalar) -> String {
    let count = width - self.scalars.count
    return self.pad(left: 0, right: count, fill: fill)
  }

  internal func rjust(width: Int, fill: UnicodeScalar) -> String {
    let count = width - self.scalars.count
    return self.pad(left: count, right: 0, fill: fill)
  }

  private func pad(left: Int, right: Int, fill: UnicodeScalar) -> String {
    guard left > 0 || right > 0 else {
      return String(self)
    }

    var result = [UnicodeScalar]()

    if left > 0 {
      result = Array(repeating: fill, count: left)
    }

    result.append(contentsOf: self.scalars)

    if right > 0 {
      result.append(contentsOf: Array(repeating: fill, count: right))
    }

    return String(result)
  }

  // MARK: - Split

  internal func split(separator: PyStringData, maxCount: Int) -> [String] {
    var result = [String]()
    var index = self.scalars.startIndex

    let sepScalars = separator.scalars
    let sepCount = sepScalars.count

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Advance index until the end of the group
      let groupStart = index
      while index != self.scalars.endIndex || self.scalars[index...].starts(with: sepScalars) {
        self.scalars.formIndex(after: &index)
      }

      if index == self.scalars.endIndex {
        break
      }

      // If we start with the `sep` then dont add it, just advance
      if index != self.scalars.startIndex {
        result.append(String(self.scalars[groupStart..<index]))
      }

      // Move index after `sep`
      index = self.scalars.index(index, offsetBy: sepCount)
    }

    result.append(String(self.scalars[index...]))
    return result
  }

  internal func splitWhitespace(maxCount: Int) -> [String] {
    var result = [String]()
    var index = self.scalars.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      while index != self.scalars.endIndex && self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      if index == self.scalars.endIndex {
        break
      }

      // Consume group
      let groupStart = index
      while index != self.scalars.endIndex && !self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      let s = index == self.scalars.endIndex ?
        self.scalars[groupStart...] :
        self.scalars[groupStart...index]

      result.append(String(s))
    }

    if index != self.scalars.endIndex {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      while index != self.scalars.endIndex && self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      if index != self.scalars.endIndex {
        result.append(String(self.scalars[index...]))
      }
    }

    return result
  }

  internal func rsplit(separator: PyStringData, maxCount: Int) -> [String] {
    var result = [String]()
    var index = self.scalars.endIndex
    self.scalars.formIndex(before: &index)

    let sepScalars = separator.scalars
    let sepCount = sepScalars.count

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      let groupEnd = index // Include character at this index!
      while index != self.scalars.startIndex && !self.scalars[index...].starts(with: sepScalars) {
        self.scalars.formIndex(before: &index)
      }

      // Consume group
      let isAtStartWithSep = index == self.scalars.startIndex
        && self.scalars[index...].starts(with: sepScalars)

      let groupStart = isAtStartWithSep ?
        self.scalars.index(index, offsetBy: sepCount) :
        self.scalars.startIndex

      let s = self.scalars[groupStart...groupEnd]
      result.append(String(s))

      if index == self.scalars.startIndex {
        break
      }
    }

    return result
  }

  internal func rsplitWhitespace(maxCount: Int) -> [String] {
    var result = [String]()
    var index = self.scalars.endIndex
    self.scalars.formIndex(before: &index)

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      while index != self.scalars.startIndex && self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(before: &index)
      }

      if index == self.scalars.startIndex {
        break
      }

      // Consume group
      let groupEnd = index // Include character at this index!
      var groupStart = index
      while index != self.scalars.startIndex && !self.isWhitespace(self.scalars[index]) {
        groupStart = index // `groupStart` = index to the right of `index`
        self.scalars.formIndex(before: &index)
      }

      /// Index may be non-whitespace when we arrive at startIndex
      let s = self.isWhitespace(self.scalars[index]) ?
        self.scalars[groupStart...groupEnd] :
        self.scalars[index...groupEnd]

      result.append(String(s))
    }

    if index != self.scalars.startIndex {
      while index != self.scalars.startIndex && self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(before: &index)
      }

      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      result.append(String(self.scalars[...index]))
    }

    return result
  }

  private func isWhitespace(_ scalar: UnicodeScalar) -> Bool {
    return scalar.properties.isWhitespace
  }

  // MARK: - Split lines

  internal func splitLines(keepEnds: Bool) -> [String] {
    var result = [String]()
    var index = self.scalars.startIndex

    while index != self.scalars.endIndex {
      let groupStart = index

      // Advance 'till line break
      while index != self.scalars.endIndex && !self.isLineBreak(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      var eol = index
      if index != self.scalars.endIndex {
        // Consume CRLF as one line break
        if let after = self.scalars.index(index,
                                          offsetBy: 1,
                                          limitedBy: self.scalars.endIndex),
          self.scalars[index] == "\r" && self.scalars[after] == "\n" {

          self.scalars.formIndex(after: &index)
        }

        self.scalars.formIndex(after: &index)
        if keepEnds {
          eol = index
        }
      }

      result.append(String(self.scalars[groupStart...eol]))
    }

    return result
  }

  private func isLineBreak(_ scalar: UnicodeScalar) -> Bool {
    return lineBreaks.contains(scalar)
  }

  // MARK: - Partition

  internal func partition(separator: PyStringData) -> StringPartitionResult {
    if separator.isEmpty {
      return .error(.valueError("empty separator"))
    }

    switch self.find(in: self, value: separator) {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let sepCount = separator.scalars.count
      let index2 = self.index(index1, offsetBy: sepCount, limitedBy: endIndex)

      let before = self.substring(end: index1)
      let after = self.substring(start: index2)
      return .triple(before: before, after: after)

    case .notFound:
      return .notFound
    }
  }

  internal func rpartition(separator: PyStringData) -> StringPartitionResult {
    if separator.isEmpty {
      return .error(.valueError("empty separator"))
    }

    switch self.rfind(in: self, value: separator) {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let sepCount = separator.scalars.count
      let index2 = self.index(index1, offsetBy: sepCount, limitedBy: endIndex)

      let before = self.substring(end: index1)
      let after = self.substring(start: index2)
      return .triple(before: before, after: after)

    case .notFound:
      return .notFound
    }
  }

  // MARK: - Expand tabs

  internal func expandTabs(tabSize: Int) -> String {
    var result = ""
    var linePos = 0

    for scalar in self.scalars {
      switch scalar {
      case "\t":
        if tabSize > 0 {

          let incr = tabSize - (linePos % tabSize)
          linePos += incr
          result.append(contentsOf: Array(repeating: " ", count: incr))
        }

      default:
        linePos += 1
        result.append(scalar)

        if scalar == "\n" || scalar == "\r" {
          linePos = 0
        }
      }
    }

    return result
  }

  // MARK: - Count

  internal func count(element: PyStringData) -> Int {
    var result = 0
    var index = self.startIndex

    while index != self.endIndex {
      let s = self.substring(start: index)
      if s.starts(with: element) {
        result += 1
        index = self.index(index, offsetBy: element.count)
      } else {
        self.formIndex(after: &index)
      }
    }

    return result
  }

  // MARK: - Replace

  internal func replace(old: PyStringData,
                        new: PyStringData,
                        count: Int) -> String {
    var remainingCount = count

    let oldScalars = old.scalars
    let oldCount = oldScalars.count

    var result = String.UnicodeScalarView()
    var index = self.scalars.startIndex

    while index != self.scalars.endIndex {
      let s = self.scalars[index...]
      guard s.starts(with: oldScalars) else {
        result.append(self.scalars[index])
        continue
      }

      result.append(contentsOf: new.scalars)
      index = self.scalars.index(index, offsetBy: oldCount)

      remainingCount -= 1
      if remainingCount <= 0 {
        result.append(contentsOf: self.scalars[index...])
        break
      }
    }

    return String(result)
  }

  // MARK: - ZFill

  internal func zfill(width: Int) -> String {
    let fillCount = width - self.scalars.count
    guard fillCount > 0 else {
      return String(self)
    }

    let padding = String(repeating: "0", count: fillCount)
    guard let first = self.scalars.first else {
      return padding
    }

    var result = ""
    let hasSign = first == "+" || first == "-"

    if hasSign {
      result.append(first)
    }

    result.append(padding)

    if hasSign {
      result.unicodeScalars.append(contentsOf: self.scalars.dropFirst())
    } else {
      result.unicodeScalars.append(contentsOf: self.scalars)
    }

    return result
  }

  // MARK: - Add

  internal func add(_ other: PyStringData) -> String {
    if self.isEmpty {
      return String(other)
    }

    if other.isEmpty {
      return String(self)
    }

    return String(self.scalars + other.scalars)
  }

  // MARK: - Mul

  internal func mul(_ n: Int) -> String {
    if self.isEmpty || n == 1 {
      return String(self)
    }

    var result = String.UnicodeScalarView()
    for _ in 0..<max(n, 0) {
      result.append(contentsOf: self.scalars)
    }

    return String(result)
  }
}
