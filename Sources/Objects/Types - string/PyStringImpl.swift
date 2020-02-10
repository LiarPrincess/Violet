import Core

// swiftlint:disable file_length

// MARK: - String builder

/// Sometimes we will slice `String` and then try to concat pieces together
/// (for example in `replace`).
/// We can use `Array` as an accumulator, but then we would have to convert
/// `Array<Scalar> -> String` and `Array<UInt8> -> Data` which is inefficient.
/// We will introduce abstract `StringBuilder` to append directly to final object.
internal protocol StringBuilderType {

  associatedtype Element
  /// Builder result.
  /// Totally abstract and defined by specific `Builder` implementation.
  /// `PyStringImpl` will never interact with it directly.
  associatedtype Result

  /// Builder final value.
  var result: Result { get }

  /// Create new empty builder.
  init()
  /// Apped single element.
  mutating func append(_ value: Element)
  /// Apped multiple elements.
  mutating func append<C: Sequence>(contentsOf other: C)
    where C.Element == Self.Element
}

// MARK: - String implementation

/// (Almost) all of the `str` methods.
/// Everything here is 'best-efford' because strings are hard.
///
/// Note that we will use the same implementation for `str` and `bytes`.
///
/// Also: look at us! Using traits/protocols as intended!
internal protocol PyStringImpl {

  /// `UnicodeScalarView` for str and `Data` for bytes.
  ///
  /// - `Bidirectional` because we need to iterate backwards for `rfind` etc.
  /// - `Comparable` because we need to implement `__eq__`, `__lt__` etc.
  /// - `Hashable` - not needed, but gives us  O(1) `strip` lookups.
  associatedtype Scalars: BidirectionalCollection where
    Scalars.Element: Comparable,
    Scalars.Element: Hashable

  /// See `StringBuilderType` documentation.
  /// `Builder.Result` is abstract and we will never touch it.
  associatedtype Builder: StringBuilderType where
    Builder.Element == Scalars.Element

  /// `UnicodeScalarView` for `str` and `Data` for `bytes`.
  ///
  /// We improperly use name `scalars` for both because this is easier to
  /// visualise than `elements/values/etc.`.
  var scalars: Scalars { get }

  /// Name of the type that uses this implementations (e.g. `str` or `bytes`).
  /// Used in error messages.
  static var typeName: String { get }
  /// Default fill character (for example for `center`).
  static var defaultFill: Element { get }
  /// Fill used by `zfill` function
  static var zFill: Element { get }

  /// Convert value to `UnicodeScalar`.
  ///
  /// Sometimes we will do that when we really need to work on strings
  /// (for example to classify something as whitespace).
  static func toScalar(_ element: Element) -> UnicodeScalar
  /// Given a `PyObject` try to extract valid value to use in function.
  ///
  /// For `str`: `Self` will be `str`.
  /// For `bytes`: `Self` will be `bytes`.
  /// Used for example in `find` where you can only `find` homogenous value.
  static func extractSelf(from object: PyObject) -> Self?
}

extension PyStringImpl {

  // MARK: - Aliases

  internal typealias Index = Scalars.Index
  internal typealias Element = Scalars.Element
  internal typealias SubSequence = Scalars.SubSequence

  // MARK: - Is(thingie) predicates

  private static func isWhitespace(_ value: Element) -> Bool {
    let scalar = Self.toScalar(value)
    return scalar.properties.isWhitespace
  }

  private static func isLineBreak(_ value: Element) -> Bool {
    let scalar = Self.toScalar(value)
    return Unicode.lineBreaks.contains(scalar)
  }
}

// MARK: - Compare

internal enum StringCompareResult {
  case less
  case greater
  case equal
}

extension PyStringImpl {

  internal func compare<S: PyStringImpl>(to other: S) -> StringCompareResult
    where S.Element == Self.Element {

    // "Cafe\u0301" == "Café" (Caf\u00E9) -> False
    // "Cafe\u0301" <  "Café" (Caf\u00E9) -> True
    var selfIter = self.scalars.makeIterator()
    var otherIter = other.scalars.makeIterator()

    var selfValue = selfIter.next()
    var otherValue = otherIter.next()

    while let s = selfValue, let o = otherValue {
      if s < o {
        return .less
      }

      if s > o {
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
      trap("Error when comparing '\(self)' and '\(other)'")
    }
  }
}

// MARK: - Repr

extension PyStringImpl {

  internal func createRepr() -> String {
    let quote = self.getReprQuoteChar()

    var result = String(quote)
    result.reserveCapacity(self.scalars.count)

    for element in self.scalars {
      let scalar = Self.toScalar(element)
      switch scalar {
      case quote, "\\":
        result.append("\\")
        result.append(scalar)
      case "\n":
        result.append("\\n")
      case "\t":
        result.append("\\t")
      case "\r":
        result.append("\\r")
      default:
        if self.isPritable(scalar: scalar) {
          result.append(scalar)
        } else {
          let repr = self.createNonPrintableRepr(scalar: scalar)
          result.append(repr)
        }
      }
    }
    result.append(quote)

    return result
  }

  private func getReprQuoteChar() -> UnicodeScalar {
    var singleCount = 0
    var doubleCount = 0

    for element in self.scalars {
      switch Self.toScalar(element) {
      case "'":  singleCount += 1
      case "\"": doubleCount += 1
      default: break
      }
    }

    // Use single quote if equal
    return singleCount <= doubleCount ? "'" : "\""
  }

  private func createNonPrintableRepr(scalar: UnicodeScalar) -> String {
    var result = "\\"
    let value = scalar.value

    if value < 0xff {
      // Map 8-bit characters to '\xhh'
      result.append("x")
      result.append(self.hex((value >> 4) & 0xf))
      result.append(self.hex((value >> 0) & 0xf))
    } else if value < 0xffff {
      // Map 16-bit characters to '\uxxxx'
      result.append("u")
      result.append(self.hex((value >> 12) & 0xf))
      result.append(self.hex((value >>  8) & 0xf))
      result.append(self.hex((value >>  4) & 0xf))
      result.append(self.hex((value >>  0) & 0xf))
    } else {
      // Map 21-bit characters to '\U00xxxxxx'
      result.append("U")
      result.append(self.hex((value >> 28) & 0xf))
      result.append(self.hex((value >> 24) & 0xf))
      result.append(self.hex((value >> 20) & 0xf))
      result.append(self.hex((value >> 16) & 0xf))
      result.append(self.hex((value >> 12) & 0xf))
      result.append(self.hex((value >>  8) & 0xf))
      result.append(self.hex((value >>  4) & 0xf))
      result.append(self.hex((value >>  0) & 0xf))
    }

    return result
  }

  private func hex(_ value: UInt32) -> String {
    return String(value, radix: 16, uppercase: false)
  }
}

// MARK: - Length

extension PyStringImpl {

  internal var first: Element? {
    return self.scalars.first
  }

  internal var isEmpty: Bool {
    return self.scalars.isEmpty
  }

  internal var any: Bool {
    return !self.isEmpty
  }

  internal var count: Int {
    // len("Cafe\u0301") -> 5
    // len("Café")       -> 4
    return self.scalars.count
  }
}

// MARK: - Index

extension PyStringImpl {

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
}

// MARK: - Substring

/// Substring that remembers it's `start` and `end` values.
internal struct PyIndexedSubstring<Scalars: BidirectionalCollection>
  where Scalars.Element: Comparable,
        Scalars.Element: Hashable {

  internal struct Index {
    internal let value: Scalars.Index
    /// `Int` value exactly as provided by the user.
    /// For example: `0, 1, -5` etc.
    internal let int: Int
    /// `Int` value adjusted to the collection length.
    /// For example: `-5` was replaced by valid index (like `42`).
    internal let adjustedInt: Int
  }

  internal let value: Scalars.SubSequence
  /// Substring start. `nil` it it was not given.
  internal let start: Index?
  /// Substring end. `nil` it it was not given.
  internal let end: Index?
}

extension PyStringImpl {

  internal typealias IndexedSubSequence = PyIndexedSubstring<Scalars>

  internal func substring(start: PyObject?,
                          end: PyObject?) -> PyResult<IndexedSubSequence> {
    let startIndex: IndexedSubSequence.Index?
    switch self.extractIndex(start) {
    case .value(nil): startIndex = nil
    case .value(let i): startIndex = i
    case let .error(e): return .error(e)
    }

    var endIndex: IndexedSubSequence.Index?
    switch self.extractIndex(end) {
    case .value(nil): endIndex = nil
    case .value(let i): endIndex = i
    case let .error(e): return .error(e)
    }

    let startInt = startIndex?.adjustedInt ?? Int.min
    let endInt = endIndex?.adjustedInt ?? Int.max

    // Handle something like 'elsa'[1000: 5]
    guard startInt < endInt else {
      let start = self.scalars.startIndex
      let empty = self.scalars[start..<start]
      let result = IndexedSubSequence(value: empty,
                                      start: startIndex,
                                      end: endIndex)
      return .value(result)
    }

    let value = self.substring(start: startIndex?.value ?? self.startIndex,
                               end: endIndex?.value ?? self.endIndex)

    let result = IndexedSubSequence(value: value,
                                    start: startIndex,
                                    end: endIndex)

    return .value(result)
  }

  internal func substring(start: Index? = nil,
                          end:   Index? = nil) -> Scalars.SubSequence {
    let s = start ?? self.startIndex
    let e = end   ?? self.endIndex
    return self.scalars[s..<e]
  }

  private func extractIndex(
    _ value: PyObject?
  ) -> PyResult<IndexedSubSequence.Index?> {
    guard let value = value else {
      return .value(nil)
    }

    if value is PyNone {
      return .value(nil)
    }

    switch IndexHelper.int(value) {
    case let .value(int):
      var adjustedInt = int
      if adjustedInt < 0 {
        adjustedInt += self.count

        // >>> 'elsa'[-1234:2]
        // 'el'
        if adjustedInt < 0 {
          adjustedInt = 0
        }
      }

      let value = self.index(self.startIndex,
                             offsetBy: adjustedInt,
                             limitedBy: self.endIndex)

      let result = IndexedSubSequence.Index(value: value ?? self.endIndex,
                                            int: int,
                                            adjustedInt: adjustedInt)

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - Contains

extension PyStringImpl {

  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    guard let string = Self.extractSelf(from: element) else {
      let s = Self.typeName
      let t = element.typeName
      return .typeError("'in <\(s)>' requires \(s) as left operand, not \(t)")
    }

    return .value(self.contains(string))
  }

  internal func contains(_ data: Self) -> Bool {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'

    switch self.findRaw(in: self.scalars, value: data) {
    case .index: return true
    case .notFound: return false
    }
  }
}

// MARK: - Properties

extension PyStringImpl {

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one characte.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  internal var isAlphaNumeric: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      let properties = scalar.properties
      let category = properties.generalCategory
      return Unicode.alphaCategories.contains(category)
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
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      let category = scalar.properties.generalCategory
      return Unicode.alphaCategories.contains(category)
    }
  }

  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  internal var isAscii: Bool {
    return self.scalars.any && self.scalars.allSatisfy {  element in
      let scalar = Self.toScalar(element)
      return scalar.isASCII
    }
  }

  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  internal var isDecimal: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      return scalar.properties.generalCategory == .decimalNumber
    }
  }

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  internal var isDigit: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      guard let numericType = scalar.properties.numericType else {
        return false
      }

      return numericType == .digit || numericType == .decimal
    }
  }

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  internal var isLower: Bool {
    // If the character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      let properties = scalar.properties
      return !properties.isCased || properties.isLowercase
    }
  }

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  internal var isUpper: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      let properties = scalar.properties
      return !properties.isCased || properties.isUppercase
    }
  }

  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  internal var isNumeric: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      return scalar.properties.numericType != nil
    }
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
    // We do not have to check if 'self.scalars.any'!
    return self.scalars.allSatisfy(self.isPritable(element:))
  }

  private func isPritable(element: Element) -> Bool {
    let scalar = Self.toScalar(element)
    return self.isPritable(scalar: scalar)
  }

  private func isPritable(scalar: UnicodeScalar) -> Bool {
    if scalar == " " { // 'space' is considered printable
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

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  internal var isSpace: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toScalar(element)
      return scalar.properties.generalCategory == .spaceSeparator
        || Unicode.bidiClass_ws_b_s.contains(scalar.value)
    }
  }

  /// Return true if the string is a titlecased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  internal var isTitle: Bool {
    var cased = false
    var isPreviousCased = false
    for element in self.scalars {
      let scalar = Self.toScalar(element)
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
}

// MARK: - Case

extension PyStringImpl {

  internal func titleCasedString() -> String {
    var result = ""
    var isPreviousCased = false

    for element in self.scalars {
      let scalar = Self.toScalar(element)
      let properties = scalar.properties

      switch properties.generalCategory {
      case .lowercaseLetter:
        if !isPreviousCased {
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

  internal func swapCaseString() -> String {
    var result = ""
    for element in self.scalars {
      let scalar = Self.toScalar(element)
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

  internal func caseFoldString() -> String {
    var result = ""
    for element in self.scalars {
      let scalar = Self.toScalar(element)
      if let mapping = Unicode.caseFoldMapping[scalar.value] {
        result.append(mapping)
      } else {
        result.append(scalar)
      }
    }
    return result
  }

  internal func capitalizeString() -> String {
    // Capitalize only first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = self.scalars.first else {
      return ""
    }

    let firstScalar = Self.toScalar(first)
    var result = firstScalar.properties.titlecaseMapping

    for element in self.scalars.dropFirst() {
      let scalar = Self.toScalar(element)
      result.append(contentsOf: scalar.properties.lowercaseMapping)
    }

    return result
  }
}

// MARK: - Starts/ends with

extension PyStringImpl {

  internal func starts(with element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<Bool> {
    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    if let string = Self.extractSelf(from: element) {
      return .value(self.starts(substring: substring, with: string))
    }

    if let tuple = element as? PyTuple {
      for element in tuple.elements {
        guard let string = Self.extractSelf(from: element) else {
          let s = Self.typeName
          let t = element.typeName
          return .typeError("tuple for startswith must only contain \(s), not \(t)")
        }

        if self.starts(substring: substring, with: string) {
          return .value(true)
        }
      }

      return .value(false)
    }

    let s = Self.typeName
    let t = element.typeName
    return .typeError("startswith first arg must be \(s) or a tuple of \(s), not \(t)")
  }

  internal func ends(with element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<Bool> {
    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    if let string = Self.extractSelf(from: element) {
      return .value(self.ends(substring: substring, with: string))
    }

    if let tuple = element as? PyTuple {
      for element in tuple.elements {
        guard let string = Self.extractSelf(from: element) else {
          let s = Self.typeName
          let t = element.typeName
          return .typeError("tuple for endswith must only contain \(s), not \(t)")
        }

        if self.ends(substring: substring, with: string) {
          return .value(true)
        }
      }

      return .value(false)
    }

    let s = Self.typeName
    let t = element.typeName
    return .typeError("endswith first arg must be \(s) or a tuple of \(s), not \(t)")
  }

  internal func starts(substring zelf: IndexedSubSequence,
                       with string: Self) -> Bool {
    if self.is(substring: zelf, longerThan: string) {
      return false
    }

    if string.isEmpty {
      return true
    }

    return zelf.value.starts(with: string.scalars)
  }

  internal func ends(substring zelf: IndexedSubSequence,
                     with string: Self) -> Bool {
    if self.is(substring: zelf, longerThan: string) {
      return false
    }

    if zelf.value.isEmpty {
      return true
    }

    return zelf.value.ends(with: string.scalars)
  }

  private func `is`(substring zelf: IndexedSubSequence,
                    longerThan string: Self) -> Bool {
    let start = zelf.start?.adjustedInt ?? Int.min
    var end = zelf.end?.adjustedInt ?? Int.max
    end -= string.count

    return start > end
  }
}

// MARK: - Strip

private enum StripChars<Element: Hashable> {
  case whitespace
  case chars(Set<Element>)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func strip(_ chars: PyObject?) -> PyResult<Self.SubSequence> {
    switch self.parseStripChars(chars, fnName: "strip") {
    case .whitespace:
      return .value(self.stripWhitespace())
    case let .chars(set):
      let tmp = self.lstrip(self.scalars, chars: set)
      let result = self.rstrip(tmp, chars: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  internal func lstrip(_ chars: PyObject?) -> PyResult<Self.SubSequence> {
    switch self.parseStripChars(chars, fnName: "lstrip") {
    case .whitespace:
      return .value(self.lstripWhitespace())
    case let .chars(set):
      return .value(self.lstrip(self.scalars, chars: set))
    case let .error(e):
      return .error(e)
    }
  }

  internal func rstrip(_ chars: PyObject?) -> PyResult<Self.SubSequence> {
    switch self.parseStripChars(chars, fnName: "rstrip") {
    case .whitespace:
      return .value(self.rstripWhitespace())
    case let .chars(set):
      return .value(self.rstrip(self.scalars, chars: set))
    case let .error(e):
      return .error(e)
    }
  }

  private func parseStripChars(_ chars: PyObject?,
                               fnName: String) -> StripChars<Element> {
    guard let chars = chars else {
      return .whitespace
    }

    if chars is PyNone {
      return .whitespace
    }

    if let charsString = Self.extractSelf(from: chars) {
      return .chars(Set(charsString.scalars))
    }

    let msg = "\(fnName) arg must be \(Self.typeName) or None, not \(chars.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  private func lstrip<C: BidirectionalCollection>(
    _ scalars: C,
    chars: Set<C.Element>) -> C.SubSequence where C.Element == Self.Element {

    var index = scalars.startIndex

    while index != scalars.endIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(after: &index)
    }

    return scalars[index...]
  }

  private func rstrip<C: BidirectionalCollection>(
    _ scalars: C,
    chars: Set<C.Element>) -> C.SubSequence where C.Element == Self.Element {

    var index = scalars.endIndex

    // `endIndex` is AFTER the collection
    scalars.formIndex(before: &index)

    while index != scalars.startIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(before: &index)
    }

    return scalars[...index]
  }
}

// MARK: - Strip whitespace

extension PyStringImpl {

  internal func stripWhitespace() -> Self.SubSequence {
    let tmp = self.lstripWhitespace(in: self.scalars)
    return self.rstripWhitespace(in: tmp)
  }

  internal func lstripWhitespace() -> Self.SubSequence {
    return self.lstripWhitespace(in: self.scalars)
  }

  internal func rstripWhitespace() -> Self.SubSequence {
    return self.rstripWhitespace(in: self.scalars)
  }

  private func lstripWhitespace<C: Collection>(in value: C) -> C.SubSequence
    where C.Element == Self.Element {

    return value.drop(while: Self.isWhitespace)
  }

  private func rstripWhitespace<C: BidirectionalCollection>(in value: C) -> C.SubSequence
    where C.Element == Self.Element {

    return value.dropLast(while: Self.isWhitespace)
  }
}

// MARK: - Find

internal enum StringFindResult<Index> {
  case index(index: Index, position: BigInt)
  case notFound
}

extension PyStringImpl {

  internal func find(_ element: PyObject,
                     start: PyObject? = nil,
                     end: PyObject? = nil) -> PyResult<BigInt> {
    guard let elementString = Self.extractSelf(from: element) else {
      return .typeError("find arg must be \(Self.typeName), not \(element.typeName)")
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.findRaw(in: substring.value, value: elementString)
    return self.getFindResult(substring: substring, result: result)
  }

  /// Helper method to use for all of the `find` needs.
  internal func findRaw<C: Collection>(
    in container: C,
    value: Self
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {
    return self.findRaw(in: container, scalars: value.scalars)
  }

  /// Helper method to use for all of the `find` needs.
  internal func findRaw<C: Collection>(
    in container: C,
    scalars: Scalars
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {

    if container.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = BigInt(0)
    var index = container.startIndex

    while index != container.endIndex {
      let substring = container[index...]
      if substring.starts(with: scalars) {
        return .index(index: index, position: position)
      }

      position += 1
      container.formIndex(after: &index)
    }

    return .notFound
  }

  internal func rfind(_ element: PyObject,
                      start: PyObject? = nil,
                      end: PyObject? = nil) -> PyResult<BigInt> {
    guard let elementString = Self.extractSelf(from: element) else {
      return .typeError("rfind arg must be \(Self.typeName), not \(element.typeName)")
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.rfindRaw(in: substring.value, value: elementString)
    return self.getFindResult(substring: substring, result: result)
  }

  /// Helper method to use for all of the `rfind` needs.
  internal func rfindRaw<C: BidirectionalCollection>(
    in container: C,
    value: Self
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {
    return self.rfindRaw(in: container, scalars: value.scalars)
  }

  /// Helper method to use for all of the `rfind` needs.
  internal func rfindRaw<C: BidirectionalCollection>(
    in container: C,
    scalars: Scalars
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {

    if container.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = container.count - 1
    var index = container.endIndex

    // `endIndex` is AFTER the collection
    container.formIndex(before: &index)

    while index != container.startIndex {
      let substring = container[index...]
      if substring.starts(with: scalars) {
        return .index(index: index, position: BigInt(position))
      }

      position -= 1
      container.formIndex(before: &index)
    }

    // Check if maybe we start with it (it was not checked inside the loop!)
    if container.starts(with: scalars) {
      return .index(index: index, position: 0)
    }

    return .notFound
  }

  private func getFindResult(substring: IndexedSubSequence,
                             result: StringFindResult<Index>) -> PyResult<BigInt> {
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      // Python convention of returning '-1'.
      return .value(-1)
    }
  }
}

// MARK: - Index

extension PyStringImpl {

  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    guard let elementString = Self.extractSelf(from: element) else {
      return .typeError("index arg must be \(Self.typeName), not \(element.typeName)")
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.findRaw(in: substring.value, value: elementString)
    return self.getIndexResult(substring: substring, result: result)
  }

  internal func rindex(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    guard let elementString = Self.extractSelf(from: element) else {
       return .typeError("rindex arg must be \(Self.typeName), not \(element.typeName)")
     }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.rfindRaw(in: substring.value, value: elementString)
    return self.getIndexResult(substring: substring, result: result)
  }

  private func getIndexResult(substring: IndexedSubSequence,
                              result: StringFindResult<Index>) -> PyResult<BigInt> {
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      return .valueError("substring not found")
    }
  }
}

// MARK: - Get item

internal enum StringGetItemResult<Item, Slice> {
  case item(Item)
  case slice(Slice)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func getItem(
    at index: PyObject
  ) -> StringGetItemResult<Element, Builder.Result> {
    switch IndexHelper.tryInt(index) {
    case .value(let index):
      switch self.getItem(at: index) {
      case let .value(r): return .item(r)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      switch self.getSlice(slice: slice) {
      case let .value(r): return .slice(r)
      case let .error(e): return .error(e)
      }
    }

    let t = index.typeName
    let msg = "\(Self.typeName) indices must be integers or slices, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }

  internal func getItem(at index: Int) -> PyResult<Element> {
    var offset = index
    if offset < 0 {
      offset += self.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= offset && offset < self.count else {
      return .indexError("\(Self.typeName) index out of range")
    }

    let indexOrNil = self.scalars.index(self.scalars.startIndex,
                                        offsetBy: offset,
                                        limitedBy: self.scalars.endIndex)

    guard let index = indexOrNil else {
      return .indexError("\(Self.typeName) index out of range")
    }

    return .value(self.scalars[index])
  }

  private func getSlice(slice: PySlice) -> PyResult<Builder.Result> {
    let unpack: PySlice.UnpackedIndices
    switch slice.unpack() {
    case let .value(v): unpack = v
    case let .error(e): return .error(e)
    }

    let adjusted = slice.adjust(unpack, toLength: self.scalars.count)
    return self.getSlice(start: adjusted.start,
                         step: adjusted.step,
                         count: adjusted.length)
  }

  internal func getSlice(start: Int,
                         step: Int,
                         count: Int) -> PyResult<Builder.Result> {
    var builder = Builder()

    // swiftlint:disable:next empty_count
    if count <= 0 {
      return .value(builder.result)
    }

    if step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if step == 1 {
      let result = self.scalars.dropFirst(start).prefix(count)
      builder.append(contentsOf: result)
      return .value(builder.result)
    }

    guard var index = self.scalars.index(self.scalars.startIndex,
                                         offsetBy: start,
                                         limitedBy: self.scalars.endIndex) else {
      return .value(builder.result)
    }

    for _ in 0..<count {
      builder.append(self.scalars[index])

      let limit = step > 0 ? self.scalars.endIndex : self.scalars.startIndex
      guard let newIndex = self.scalars.index(index,
                                              offsetBy: step,
                                              limitedBy: limit) else {
        return .value(builder.result)
      }

      index = newIndex
    }

    return .value(builder.result)
  }
}

// MARK: - Center, just

private enum FillChar<T> {
  case `default`
  case value(T)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func center(width: PyObject,
                       fill: PyObject?) -> PyResult<Builder.Result> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "center") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let parsedFill: Element
    switch self.parseJustFillChar(fill, fnName: "center") {
    case .default: parsedFill = Self.defaultFill
    case .value(let s): parsedFill  = s
    case .error(let e): return .error(e)
    }

    return .value(self.center(width: parsedWidth, fill: parsedFill))
  }

  internal func center(width: Int, fill: Element) -> Builder.Result {
    let marg = width - self.scalars.count
    guard marg > 0 else {
      var builder = Builder()
      builder.append(contentsOf: self.scalars)
      return builder.result
    }

    let left = marg / 2 + (marg & width & 1)
    let right = marg - left
    return self.pad(left: left, right: right, fill: fill)
  }

  internal func ljust(width: PyObject,
                      fill: PyObject?) -> PyResult<Builder.Result> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "ljust") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let parsedFill: Element
    switch self.parseJustFillChar(fill, fnName: "ljust") {
    case .default: parsedFill = Self.defaultFill
    case .value(let s): parsedFill  = s
    case .error(let e): return .error(e)
    }

    return .value(self.ljust(width: parsedWidth, fill: parsedFill))
  }

  internal func ljust(width: Int, fill: Element) -> Builder.Result {
    let count = width - self.scalars.count
    return self.pad(left: 0, right: count, fill: fill)
  }

  internal func rjust(width: PyObject,
                      fill: PyObject?) -> PyResult<Builder.Result> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "rjust") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let parsedFill: Element
    switch self.parseJustFillChar(fill, fnName: "rjust") {
    case .default: parsedFill = Self.defaultFill
    case .value(let s): parsedFill  = s
    case .error(let e): return .error(e)
    }

    return .value(self.rjust(width: parsedWidth, fill: parsedFill))
  }

  internal func rjust(width: Int, fill: Element) -> Builder.Result {
    let count = width - self.scalars.count
    return self.pad(left: count, right: 0, fill: fill)
  }

  private func parseJustWidth(_ width: PyObject,
                              fnName: String) -> PyResult<Int> {
    guard let pyInt = width as? PyInt else {
      return .typeError("\(fnName) width arg must be int, not \(width.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("\(fnName) width is too large")
    }

    return .value(int)
  }

  private func parseJustFillChar(_ fill: PyObject?,
                                 fnName: String) -> FillChar<Element> {
    guard let fill = fill else {
      return .default
    }

    guard let str = Self.extractSelf(from: fill),
          let first = str.scalars.first, str.scalars.count == 1 else {
      let t = fill.typeName
      let msg = "\(fnName) fillchar arg must be \(Self.typeName) of length 1, not \(t)"
      return .error(Py.newTypeError(msg: msg))
    }

    return .value(first)
  }

  private func pad(left: Int, right: Int, fill: Element) -> Builder.Result {
    var builder = Builder()

    guard left > 0 || right > 0 else {
      builder.append(contentsOf: self.scalars)
      return builder.result
    }

    if left > 0 {
      builder.append(contentsOf: Array(repeating: fill, count: left))
    }

    builder.append(contentsOf: self.scalars)

    if right > 0 {
      builder.append(contentsOf: Array(repeating: fill, count: right))
    }

    return builder.result
  }
}

// MARK: - Split

private enum SplitSeparator<T> {
  case whitespace
  case some(T)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func split(separator: PyObject?,
                      maxCount: PyObject?) -> PyResult<[Scalars.SubSequence]> {
    if self.isEmpty {
      return .value([])
    }

    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    switch self.parseSplitSeparator(separator) {
    case .whitespace:
      return .value(self.splitWhitespace(maxCount: count))
    case .some(let s):
      return .value(self.split(separator: s, maxCount: count))
    case .error(let e):
      return .error(e)
    }
  }

  internal func split(separator: Self, maxCount: Int) -> [Scalars.SubSequence] {
    let sepScalars = separator.scalars
    let sepCount = sepScalars.count

    var result = [Scalars.SubSequence]()
    var index = self.scalars.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Advance index until the end of the group
      let groupStart = index
      while index != self.scalars.endIndex {
        if self.scalars[index...].starts(with: sepScalars) {
          break // we found separator, break while
        }

        self.scalars.formIndex(after: &index)
      }

      if index == self.scalars.endIndex {
        break
      }

      // If we start with the `sep` then don't add it, just advance
      if index != self.scalars.startIndex {
        result.append(self.scalars[groupStart..<index])
      }

      // Move index after `sep`
      index = self.scalars.index(index, offsetBy: sepCount)
    }

    result.append(self.scalars[index...])
    return result
  }

  internal func splitWhitespace(maxCount: Int) -> [Scalars.SubSequence] {
    var result = [Scalars.SubSequence]()
    var index = self.scalars.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      while index != self.scalars.endIndex && Self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      if index == self.scalars.endIndex {
        break
      }

      // Consume group
      let groupStart = index
      while index != self.scalars.endIndex && !Self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      let s = index == self.scalars.endIndex ?
        self.scalars[groupStart...] :
        self.scalars[groupStart...index]

      result.append(s)
    }

    if index != self.scalars.endIndex {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      while index != self.scalars.endIndex && Self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      if index != self.scalars.endIndex {
        result.append(self.scalars[index...])
      }
    }

    return result
  }

  internal func rsplit(separator: PyObject?,
                       maxCount: PyObject?) -> PyResult<[Scalars.SubSequence]> {
    if self.isEmpty {
      return .value([])
    }

    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    switch self.parseSplitSeparator(separator) {
    case .whitespace:
      return .value(self.rsplitWhitespace(maxCount: count))
    case .some(let s):
      return .value(self.rsplit(separator: s, maxCount: count))
    case .error(let e):
      return .error(e)
    }
  }

  internal func rsplit(separator: Self, maxCount: Int) -> [Scalars.SubSequence] {
    let sepScalars = separator.scalars
    let sepCount = sepScalars.count

    var result = [Scalars.SubSequence]()
    var index = self.scalars.index(before: self.scalars.endIndex)

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      let groupEnd = index // Include character at this index!
      while index != self.scalars.startIndex {
        if self.scalars[index...].starts(with: sepScalars) {
          break // we found separator, break while
        }

        self.scalars.formIndex(before: &index)
      }

      // Consume group
      let groupStart = self.scalars.index(index, offsetBy: sepCount)
      result.append(self.scalars[groupStart...groupEnd])

      if index == self.scalars.startIndex {
        break
      }
    }

    if index != self.scalars.startIndex {
      result.append(self.scalars[self.scalars.startIndex..<index])
    }

    // Because we were going from end we appended in a reverse order.
    // Now reverse this reverse to get correct order.
    // Random thought: 'reverse' is idempotent if you always apply it twice
    // (and it has not side-effects).
    result.reverse()
    return result
  }

  internal func rsplitWhitespace(maxCount: Int) -> [Scalars.SubSequence] {
    var result = [Scalars.SubSequence]()
    var index = self.scalars.endIndex
    self.scalars.formIndex(before: &index)

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      while index != self.scalars.startIndex && Self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(before: &index)
      }

      if index == self.scalars.startIndex {
        break
      }

      // Consume group
      let groupEnd = index // Include character at this index!
      var groupStart = index
      while index != self.scalars.startIndex && !Self.isWhitespace(self.scalars[index]) {
        groupStart = index // `groupStart` = index to the right of `index`
        self.scalars.formIndex(before: &index)
      }

      /// Index may be non-whitespace when we arrive at startIndex
      let s = Self.isWhitespace(self.scalars[index]) ?
        self.scalars[groupStart...groupEnd] :
        self.scalars[index...groupEnd]

      result.append(s)
    }

    if index != self.scalars.startIndex {
      while index != self.scalars.startIndex && Self.isWhitespace(self.scalars[index]) {
        self.scalars.formIndex(before: &index)
      }

      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      result.append(self.scalars[...index])
    }

    return result
  }

  private func parseSplitSeparator(_ separator: PyObject?) -> SplitSeparator<Self> {
    guard let separator = separator else {
      return .whitespace
    }

    if separator is PyNone {
      return .whitespace
    }

    guard let sep = Self.extractSelf(from: separator) else {
      let msg = "sep must be \(Self.typeName) or None, not \(separator.typeName)"
      return .error(Py.newTypeError(msg: msg))
    }

    if sep.scalars.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    return .some(sep)
  }

  private func parseSplitMaxCount(_ maxCount: PyObject?) -> PyResult<Int> {
    guard let maxCount = maxCount else {
      return .value(Int.max)
    }

    guard let pyInt = maxCount as? PyInt else {
      return .typeError("maxsplit must be int, not \(maxCount.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("maxsplit is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}

// MARK: - Split lines

extension PyStringImpl {

  internal func splitLines(keepEnds: PyObject?) -> PyResult<[Scalars.SubSequence]> {
    guard let keepEnds = keepEnds else {
      return .value(self.splitLines(keepEnds: false))
    }

    // `bool` is also `int`
    if let int = keepEnds as? PyInt {
      let isTrue = int.value.isTrue
      return .value(self.splitLines(keepEnds: isTrue))
    }

    return .typeError("keepends must be integer or bool, not \(keepEnds.typeName)")
  }

  internal func splitLines(keepEnds: Bool) -> [Scalars.SubSequence] {
    var result = [Scalars.SubSequence]()
    var index = self.scalars.startIndex

    while index != self.scalars.endIndex {
      let groupStart = index

      // Advance 'till line break
      while index != self.scalars.endIndex && !Self.isLineBreak(self.scalars[index]) {
        self.scalars.formIndex(after: &index)
      }

      // 'index' is either new line or 'endIndex'
      let lineExcludingNewLine = groupStart..<index

      // Consume CRLF as one line break
      if index != self.scalars.endIndex {
        let after = self.scalars.index(after: index)
        if after != self.scalars.endIndex
          && Self.toScalar(self.scalars[index]) == "\r"
          && Self.toScalar(self.scalars[after]) == "\n" {

          index = after
        }
      }

      // Go to the start of the next group
      if index != self.scalars.endIndex {
        self.scalars.formIndex(after: &index)
      }

      // 'index' is either 1st character of next group or end
      let lineIncludingNewLine = groupStart..<index

      let line = keepEnds ? lineIncludingNewLine : lineExcludingNewLine
      result.append(self.scalars[line])
    }

    return result
  }
}

// MARK: - Partition

internal enum StringPartitionResult<SubString> {
  /// Separator was not found
  case separatorNotFound
  /// Separator was found.
  case separatorFound(before: SubString, after: SubString)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal typealias PartitionResult = StringPartitionResult<Self.SubSequence>

  internal func partition(separator: PyObject) -> PartitionResult {
    guard let sep = Self.extractSelf(from: separator) else {
      let msg = "sep must be string, not \(separator.typeName)"
      return .error(Py.newTypeError(msg: msg))
    }

    return self.partition(separator: sep)
  }

  internal func partition(separator: Self) -> PartitionResult {
    if separator.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    switch self.findRaw(in: self.scalars, value: separator) {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let sepCount = separator.scalars.count
      let index2 = self.index(index1, offsetBy: sepCount, limitedBy: endIndex)

      let before = self.substring(end: index1)
      let after = self.substring(start: index2)
      return .separatorFound(before: before, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }

  internal func rpartition(separator: PyObject) -> PartitionResult {
    guard let sep = Self.extractSelf(from: separator) else {
      let msg = "sep must be string, not \(separator.typeName)"
      return .error(Py.newTypeError(msg: msg))
    }

    return self.rpartition(separator: sep)
  }

  internal func rpartition(separator: Self) -> PartitionResult {
    if separator.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    switch self.rfindRaw(in: self.scalars, value: separator) {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let sepCount = separator.scalars.count
      let index2 = self.index(index1, offsetBy: sepCount, limitedBy: self.endIndex)

      let before = self.substring(end: index1)
      let after = self.substring(start: index2)
      return .separatorFound(before: before, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }
}

// MARK: - Expand tabs

extension PyStringImpl {

  internal func expandTabs(tabSize: PyObject?) -> PyResult<Builder.Result> {
    switch self.parseExpandTabsSize(tabSize) {
    case let .value(v):
      return .value(self.expandTabs(tabSize: v))
    case let .error(e):
      return .error(e)
    }
  }

  internal func expandTabs(tabSize: Int) -> Builder.Result {
    var builder = Builder()
    var linePos = 0

    for element in self.scalars {
      let scalar = Self.toScalar(element)
      switch scalar {
      case "\t":
        if tabSize > 0 {
          let incr = tabSize - (linePos % tabSize)
          linePos += incr
          builder.append(contentsOf: Array(repeating: Self.defaultFill, count: incr))
        }

      default:
        linePos += 1
        builder.append(element)

        if scalar == "\n" || scalar == "\r" {
          linePos = 0
        }
      }
    }

    return builder.result
  }

  private func parseExpandTabsSize(_ tabSize: PyObject?) -> PyResult<Int> {
    guard let tabSize = tabSize else {
      return .value(8)
    }

    guard let pyInt = tabSize as? PyInt else {
      return .typeError("tabsize must be int, not \(tabSize.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("tabsize is too big")
    }

    return .value(int)
  }
}

// MARK: - Count

extension PyStringImpl {

  internal func count(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    guard let elementString = Self.extractSelf(from: element) else {
      return .typeError("sub arg must be \(Self.typeName), not \(element.typeName)")
    }

    switch self.substring(start: start, end: end) {
    case let .value(s):
      return .value(self.count(in: s.value, element: elementString))
    case let .error(e):
      return .error(e)
    }
  }

  private func count(in collection: Scalars.SubSequence, element: Self) -> BigInt {
    var result = BigInt(0)
    var index = collection.startIndex

    while index != collection.endIndex {
      let s = collection[index...]
      if s.starts(with: element.scalars) {
        result += 1
        index = self.index(index, offsetBy: element.count)
      } else {
        self.formIndex(after: &index)
      }
    }

    return result
  }
}

// MARK: - Join

extension PyStringImpl {

  internal func join(iterable: PyObject) -> PyResult<Builder.Result> {
    var index = 0
    let b = Py.reduce(iterable: iterable, into: Builder()) { builder, object in
      let isFirst = index == 0
      if !isFirst {
        builder.append(contentsOf: self.scalars) // comma in ','.join([1, 2])
      }

      guard let string = Self.extractSelf(from: object) else {
        let s = Self.typeName
        let t = object.typeName
        let msg = "sequence item \(index): expected a \(s)-like object, \(t) found"
        return .error(Py.newTypeError(msg: msg))
      }

      index += 1
      builder.append(contentsOf: string.scalars)
      return .goToNextElement
    }

    return b.map { $0.result }
  }
}

// MARK: - Replace

extension PyStringImpl {

  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<Builder.Result> {
    guard let oldString = Self.extractSelf(from: old) else {
      return .typeError("old must be \(Self.typeName), not \(old.typeName)")
    }

    guard let newString = Self.extractSelf(from: new) else {
      return .typeError("new must be \(Self.typeName), not \(new.typeName)")
    }

    var parsedCount: Int
    switch self.parseReplaceCount(count) {
    case let .value(c): parsedCount = c
    case let .error(e): return .error(e)
    }

    let result = self.replace(old: oldString, new: newString, count: parsedCount)
    return .value(result)
  }

  internal func replace(old: Self, new: Self, count: Int) -> Builder.Result {
    var remainingCount = count

    let oldScalars = old.scalars
    let oldCount = oldScalars.count

    var builder = Builder()
    var index = self.scalars.startIndex

    while index != self.scalars.endIndex {
      let s = self.scalars[index...]
      guard s.starts(with: oldScalars) else {
        builder.append(self.scalars[index])
        continue
      }

      builder.append(contentsOf: new.scalars)
      index = self.scalars.index(index, offsetBy: oldCount)

      remainingCount -= 1
      if remainingCount <= 0 {
        builder.append(contentsOf: self.scalars[index...])
        break
      }
    }

    return builder.result
  }

  private func parseReplaceCount(_ count: PyObject?) -> PyResult<Int> {
    guard let count = count else {
      return .value(Int.max)
    }

    guard let pyInt = count as? PyInt else {
      return .typeError("count must be int, not \(count.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("count is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}

// MARK: - ZFill

extension PyStringImpl {

  internal func zfill(width: PyObject) -> PyResult<Builder.Result> {
    guard let widthInt = width as? PyInt else {
      return .typeError("width must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("width is too big")
    }

    let result = self.zfill(width: width)
    return .value(result)
  }

  internal func zfill(width: Int) -> Builder.Result {
    var builder = Builder()

    let fillCount = width - self.scalars.count
    guard fillCount > 0 else {
      builder.append(contentsOf: self.scalars)
      return builder.result
    }

    let padding = Array(repeating: Self.zFill, count: fillCount)
    guard let first = self.scalars.first else {
      builder.append(contentsOf: padding)
      return builder.result
    }

    let firstScalar = Self.toScalar(first)
    let hasSign = firstScalar == "+" || firstScalar == "-"

    if hasSign {
      builder.append(first)
    }

    builder.append(contentsOf: padding)

    if hasSign {
      builder.append(contentsOf: self.scalars.dropFirst())
    } else {
      builder.append(contentsOf: self.scalars)
    }

    return builder.result
  }
}

// MARK: - Add

extension PyStringImpl {

  internal func add(_ other: PyObject) -> PyResult<Builder.Result> {
    guard let otherStr = Self.extractSelf(from: other) else {
      let s = Self.typeName
      let t = other.typeName
      return .typeError("can only concatenate \(s) (not '\(t)') to \(s)")
    }

    return .value(self.add(otherStr))
  }

  internal func add(_ other: Self) -> Builder.Result {
    var builder = Builder()

    if self.any {
      builder.append(contentsOf: self.scalars)
    }

    if other.any {
      builder.append(contentsOf: other.scalars)
    }

    return builder.result
  }
}

// MARK: - Mul

extension PyStringImpl {

  internal func mul(_ other: PyObject) -> PyResult<Builder.Result> {
    guard let pyInt = other as? PyInt else {
      let s = Self.typeName
      let t = other.typeName
      return .typeError("can only multiply \(s) and int (not '\(t)')")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("repeated string is too long")
    }

    return .value(self.mul(int))
  }

  internal func mul(_ n: Int) -> Builder.Result {
    var builder = Builder()

    if self.isEmpty {
      return builder.result
    }

    for _ in 0..<max(n, 0) {
      builder.append(contentsOf: self.scalars)
    }

    return builder.result
  }

  internal func rmul(_ other: PyObject) -> PyResult<Builder.Result> {
    return self.mul(other)
  }
}

// MARK: - Helpers

extension PyStringImpl {

  @available(*, deprecated, message: "Use only for debug")
  private func toString(_ value: Self.Scalars) -> String {
    // swiftlint:disable force_cast
    let view = value as! String.UnicodeScalarView
    return String(view)
  }

  @available(*, deprecated, message: "Use only for debug")
  private func toString(_ value: Self.Scalars.SubSequence) -> String {
    // swiftlint:disable force_cast
    let view = value as! String.SubSequence.UnicodeScalarView
    return String(view)
  }
}
