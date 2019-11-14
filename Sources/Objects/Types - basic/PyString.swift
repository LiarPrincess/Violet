import Core

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html

// swiftlint:disable file_length

// sourcery: pytype = str
/// Textual data in Python is handled with str objects, or strings.
/// Strings are immutable sequences of Unicode code points.
///
/// Everything here is 'best-efford'
///
/// We work on scalars (Unicode code points) instead of graphemes because:
/// - len("Cafe\u0301") = 5 (Swift: "Cafe\u{0301}".unicodeScalars.count)
/// - len("Café")       = 4 (Swift: "Café".unicodeScalars.count)
public class PyString: PyObject {

  internal static let doc = """
    str(object='') -> str
    str(bytes_or_buffer[, encoding[, errors]]) -> str

    Create a new string object from the given object. If encoding or
    errors is specified, then the object must expose a data buffer
    that will be decoded using the given encoding and error handler.
    Otherwise, returns the result of object.__str__() (if defined)
    or repr(object).
    encoding defaults to sys.getdefaultencoding().
    errors defaults to 'strict'.
    """

  internal let value: String
  internal lazy var scalars = self.value.unicodeScalars

  // MARK: - Init

  internal init(_ context: PyContext, value: String) {
    self.value = value
    super.init(type: context.builtins.types.str)
  }

  convenience init(_ context: PyContext,
                   value: String.UnicodeScalarView) {
    self.init(context, value: String(value))
  }

  convenience init(_ context: PyContext,
                   value: String.UnicodeScalarView.SubSequence) {
    self.init(context, value: String(value))
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    if self === other {
      return .value(true)
    }

    return self.compare(other).map { $0 == .equal }
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .less }
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .less || $0 == .equal }
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .greater }
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .greater || $0 == .equal }
  }

  private enum CompareResult {
    case less
    case greater
    case equal
  }

  private func compare(_ other: PyObject) -> PyResultOrNot<CompareResult> {
    guard let other = other as? PyString else {
      return .notImplemented
    }

    return .value(self.compare(other.value))
  }

  private func compare(_ other: String) -> CompareResult {
    // "Cafe\u0301" == "Café" (Caf\u00E9) -> False
    // "Cafe\u0301" <  "Café" (Caf\u00E9) -> True
    let lScalars = self.scalars
    let rScalars = other.unicodeScalars

    for (l, r) in zip(lScalars, rScalars) {
      if l.value < r.value {
        return .less
      }
      if l.value > r.value {
        return .greater
      }
    }

    let lCount = lScalars.count
    let rCount = rScalars.count
    return lCount < rCount ? .less :
           lCount > rCount ? .greater :
           .equal
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .value(HashHelper.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    // Compute length of output, quote characters and maximum character
    var singleQuoteCount = 0
    var doubleQuoteCount = 0
    for c in self.value {
      switch c {
      case "'":  singleQuoteCount += 1
      case "\"": doubleQuoteCount += 1
      default:   break
      }
    }

    // Use single quote if equal
    let quote: Character = doubleQuoteCount > singleQuoteCount ? "\"" : "'"

    var result = String(quote)
    result.reserveCapacity(self.value.count)

    for c in self.value {
      switch c {
      case quote, "\\":
        result.append("\\")
        result.append(c)
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
        result.append(c)
      }
    }
    result.append(quote)

    return .value(result)
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return .value(self.value)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    // len("Cafe\u0301") -> 5
    // len("Café")       -> 4
    return BigInt(self.scalars.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'

    guard let elementString = element as? PyString else {
      return .typeError(
        "'in <string>' requires string as left operand, not \(element.typeName)"
      )
    }

    switch self.find(in: self.scalars, value: elementString.value) {
    case .index:
      return .value(true)
    case .notFound:
      return .value(false)
    }
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    let result = SequenceHelper.getItem(context: self.context,
                                        elements: self.scalars,
                                        index: index,
                                        typeName: "string")

    switch result {
    case let .single(scalar):
      return .value(self.builtins.newString(String(scalar)))
    case let .slice(scalars):
      return .value(self.builtins.newString(String(scalars)))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Predicates

  internal static let isalnumDoc = """
    Return True if the string is an alpha-numeric string, False otherwise.

    A string is alpha-numeric if all characters in the string are alpha-numeric and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isalnum, doc = isalnumDoc
  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one characte.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  internal func isAlphaNumeric() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      let category = properties.generalCategory
      return PyString.alphaCategories.contains(category)
        || category == .decimalNumber
        || properties.numericType != nil
    }
  }

  private static let alphaCategories: Set<Unicode.GeneralCategory> = Set([
    .modifierLetter, // Lm
    .titlecaseLetter, // Lt
    .uppercaseLetter, // Lu
    .lowercaseLetter, // Ll
    .otherLetter // Lo
  ])

  internal static let isalphaDoc = """
    Return True if the string is an alphabetic string, False otherwise.

    A string is alphabetic if all characters in the string are alphabetic and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isalpha, doc = isalphaDoc
  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  internal func isAlpha() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let category = scalar.properties.generalCategory
      return PyString.alphaCategories.contains(category)
    }
  }

  internal static let isasciiDoc = """
    Return True if all characters in the string are ASCII, False otherwise.

    ASCII characters have code points in the range U+0000-U+007F.
    Empty string is ASCII too.
    """

  // sourcery: pymethod = isascii, doc = isasciiDoc
  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  internal func isAscii() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { $0.isASCII }
  }

  internal static let isdecimalDoc = """
    Return True if the string is a decimal string, False otherwise.

    A string is a decimal string if all characters in the string are decimal and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isdecimal, doc = isdecimalDoc
  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  internal func isDecimal() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.generalCategory == .decimalNumber }
  }

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  internal func isDigit() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      guard let numericType = scalar.properties.numericType else {
        return false
      }

      return numericType == .digit || numericType == .decimal
    }
  }

  internal static let isidentifierDoc = """
    Return True if the string is a valid Python identifier, False otherwise.

    Use keyword.iskeyword() to test for reserved identifiers such as "def" and
    "class".
    """

  // sourcery: pymethod = isidentifier, doc = isidentifierDoc
  /// https://docs.python.org/3/library/stdtypes.html#str.isidentifier
  internal func isIdentifier() -> Bool {
    switch self.scalars.isValidIdentifier {
    case .yes:
      return true
    case .no, .emptyString:
      return false
    }
  }

  internal static let islowerDoc = """
    Return True if the string is a lowercase string, False otherwise.

    A string is lowercase if all cased characters in the string are lowercase and
    there is at least one cased character in the string.
    """

  // sourcery: pymethod = islower, doc = islowerDoc
  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  internal func isLower() -> Bool {
    // If the character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      return !properties.isCased || properties.isLowercase
    }
  }

  internal static let isnumericDoc = """
    Return True if the string is a numeric string, False otherwise.

    A string is numeric if all characters in the string are numeric and there is at
    least one character in the string.
    """

  // sourcery: pymethod = isnumeric, doc = isnumericDoc
  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  internal func isNumeric() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.numericType != nil }
  }

  internal static let isprintableDoc = """
    Return True if the string is printable, False otherwise.

    A string is printable if all of its characters are considered printable in
    repr() or if it is empty.
    """

  // sourcery: pymethod = isprintable, doc = isprintableDoc
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
  internal func isPrintable() -> Bool {
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

  internal static let isspaceDoc = """
    Return True if the string is a whitespace string, False otherwise.

    A string is whitespace if all characters in the string are whitespace and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isspace, doc = isspaceDoc
  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  internal func isSpace() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy {
        $0.properties.generalCategory == .spaceSeparator
        ||
        Unicode.bidiClass_ws_b_s.contains($0.value)
    }
  }

  internal static let istitleDoc = """
    Return True if the string is a title-cased string, False otherwise.

    In a title-cased string, upper- and title-case characters may only
    follow uncased characters and lowercase characters only cased ones.
    """

  // sourcery: pymethod = istitle, doc = istitleDoc
  /// Return true if the string is a titlecased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  internal func isTitle() -> Bool {
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

  internal static let isupperDoc = """
    Return True if the string is an uppercase string, False otherwise.

    A string is uppercase if all cased characters in the string are uppercase and
    there is at least one cased character in the string.
    """

  // sourcery: pymethod = isupper, doc = isupperDoc
  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  internal func isUpper() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      return !properties.isCased || properties.isUppercase
    }
  }

  // MARK: - Starts/ends with

  internal static let startswithDoc = """
    S.startswith(prefix[, start[, end]]) -> bool

    Return True if S starts with the specified prefix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    prefix can also be a tuple of strings to try.
    """

  internal func startsWith(_ element: PyObject) -> PyResult<Bool> {
    return self.startsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = startswith, doc = startswithDoc
  internal func startsWith(_ element: PyObject,
                           start: PyObject?,
                           end: PyObject?) -> PyResult<Bool> {
    // "e\u0301".startswith("é") -> False

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    if let tuple = element as? PyTuple {
      for element in tuple.elements {
        guard let string = element as? PyString else {
          return .typeError(
            "tuple for startswith must only contain str, not \(element.typeName)"
          )
        }

        if substring.starts(with: string.value.unicodeScalars) {
          return .value(true)
        }
      }
    }

    if let string = element as? PyString,
      substring.starts(with: string.value.unicodeScalars) {
      return .value(true)
    }

    return .typeError(
      "startswith first arg must be str or a tuple of str, not \(element.typeName)"
    )
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  internal func endsWith(_ element: PyObject) -> PyResultOrNot<Bool> {
    return self.endsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal func endsWith(_ element: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResultOrNot<Bool> {
    // "e\u0301".endswith("é") -> False

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    if let tuple = element as? PyTuple {
      for element in tuple.elements {
        guard let string = element as? PyString else {
          return .typeError(
            "tuple for endswith must only contain str, not \(element.typeName)"
          )
        }

        if substring.ends(with: string.value.unicodeScalars) {
          return .value(true)
        }
      }
    }

    if let string = element as? PyString,
      substring.ends(with: string.value.unicodeScalars) {
      return .value(true)
    }

    return .typeError(
      "endswith first arg must be str or a tuple of str, not \(element.typeName)"
    )
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  internal func strip(_ chars: PyObject?) -> PyResult<String> {
    switch self.parseStripChars(chars, fnName: "strip") {
    case .whitespace:
      let tmp = self.lstripWhitespace(in: self.value)
      let result = self.rstripWhitespace(in: String(tmp))
      return .value(String(result))
    case let .chars(set):
      let tmp = self.lstrip(value: self.value, chars: set)
      let result = self.rstrip(value: tmp, chars: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(_ chars: PyObject) -> PyResult<String> {
    switch self.parseStripChars(chars, fnName: "lstrip") {
    case .whitespace:
      let result = self.lstripWhitespace(in: self.value)
      return .value(String(result))
    case let .chars(set):
      let result = self.lstrip(value: self.value, chars: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  private func lstripWhitespace(in value: String) -> String.UnicodeScalarView.SubSequence {
    return value.unicodeScalars.drop { $0.properties.isWhitespace }
  }

  private func lstrip(value: String, chars: Set<UnicodeScalar>) -> String {
    let scalars = value.unicodeScalars
    var index = scalars.startIndex

    while index != scalars.endIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(after: &index)
    }

    // Avoid `String` allocation
    if index == scalars.startIndex {
      return value
    }

    return String(scalars[index...])
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject) -> PyResult<String> {
    switch self.parseStripChars(chars, fnName: "rstrip") {
    case .whitespace:
      let result = self.rstripWhitespace(in: self.value)
      return .value(String(result))
    case let .chars(set):
      let result = self.rstrip(value: self.value, chars: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  private func rstripWhitespace(in value: String) -> String.UnicodeScalarView.SubSequence {
    return value.unicodeScalars.dropLast { $0.properties.isWhitespace }
  }

  private func rstrip(value: String, chars: Set<UnicodeScalar>) -> String {
    let scalars = value.unicodeScalars
    var index = scalars.endIndex

    while index != scalars.startIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(before: &index)
    }

    // Avoid `String` allocation
    if index == scalars.endIndex {
      return value
    }

    return String(scalars[index...])
  }

  private enum StripCharsResult {
    case whitespace
    case chars(Set<UnicodeScalar>)
    case error(PyErrorEnum)
  }

  private func parseStripChars(_ chars: PyObject?,
                               fnName: String) -> StripCharsResult {
    guard let chars = chars else {
      return .whitespace
    }

    if chars is PyNone {
      return .whitespace
    }

    if let charsString = chars as? PyString {
      return .chars(Set(charsString.value.unicodeScalars))
    }

    return .error(
      .typeError("\(fnName) arg must be str or None, not \(chars.typeName)")
    )
  }

  // MARK: - Find

  internal static let findDoc = """
    S.find(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  internal func find(_ element: PyObject) -> PyResult<Int> {
    return self.find(element, start: nil, end: nil)
  }

  // sourcery: pymethod = find, doc = findDoc
  internal func find(_ element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<Int> {
    guard let elementString = element as? PyString else {
      return .typeError("find arg must be str, not \(element.typeName)")
    }

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    switch self.find(in: substring, value: elementString.value) {
    case let .index(index: _, position: position):
      return .value(position)
    case .notFound:
      return .value(-1)
    }
  }

  internal static let rfindDoc = """
    S.rfind(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  internal func rfind(_ element: PyObject) -> PyResult<Int> {
    return self.rindex(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rfind, doc = rfindDoc
  internal func rfind(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<Int> {
    guard let elementString = element as? PyString else {
      return .typeError("find arg must be str, not \(element.typeName)")
    }

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    switch self.rfind(in: substring, value: elementString.value) {
    case let .index(index: _, position: position):
      return .value(position)
    case .notFound:
      return .value(-1)
    }
  }

  private enum FindResult {
    case index(index: String.UnicodeScalarIndex, position: Int)
    case notFound
  }

  private func find(in scalarsSub: String.UnicodeScalarView.SubSequence,
                    value: String) -> FindResult {
    let scalars = String.UnicodeScalarView(scalarsSub)
    return find(in: scalars, value: value)
  }

  private func find(in scalars: String.UnicodeScalarView,
                    value: String) -> FindResult {
    // There are many good substring algorithms, and we went with this?
    var position = 0
    var index = scalars.startIndex
    let needle = value.unicodeScalars

    while index != scalars.endIndex {
      let substring = scalars[index...]
      if substring.starts(with: needle) {
        return .index(index: index, position: position)
      }

      position += 1
      scalars.formIndex(after: &index)
    }

    return .notFound
  }

  private func rfind(in scalarsSub: String.UnicodeScalarView.SubSequence,
                     value: String) -> FindResult {
    let scalars = String.UnicodeScalarView(scalarsSub)
    return rfind(in: scalars, value: value)
  }

  private func rfind(in scalars: String.UnicodeScalarView,
                     value: String) -> FindResult {
    if scalars.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = scalars.count - 1
    var index = scalars.endIndex
    let needle = value.unicodeScalars

    // `endIndex` is AFTER the collection
    scalars.formIndex(before: &index)

    while index != scalars.startIndex {
      let substring = scalars[index...]
      if substring.starts(with: needle) {
        return .index(index: index, position: position)
      }

      position -= 1
      scalars.formIndex(before: &index)
    }

    if scalars.starts(with: needle) {
      return .index(index: index, position: 0)
    }

    return .notFound
  }

  // MARK: - Index

  internal static let indexDoc = """
    S.index(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  // Special overload for `IndexOwner` protocol
  internal func index(of element: PyObject) -> PyResult<BigInt>{
    return self.index(of: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index, doc = indexDoc
  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    guard let elementString = element as? PyString else {
      return .typeError("index arg must be str, not \(element.typeName)")
    }

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    switch self.find(in: substring, value: elementString.value) {
    case let .index(index: _, position: position):
      return .value(BigInt(position))
    case .notFound:
      return .valueError("substring not found")
    }
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  internal func rindex(_ element: PyObject) -> PyResult<Int> {
    return self.rindex(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rindex, doc = rindexDoc
  internal func rindex(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<Int> {
    guard let elementString = element as? PyString else {
       return .typeError("rindex arg must be str, not \(element.typeName)")
     }

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    switch self.rfind(in: substring, value: elementString.value) {
    case let .index(index: _, position: position):
      return .value(position)
    case .notFound:
      return .valueError("substring not found")
    }
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  internal func lower() -> String {
    return self.value.lowercased()
  }

  // sourcery: pymethod = upper
  internal func upper() -> String {
    return self.value.uppercased()
  }

  // sourcery: pymethod = title
  internal func title() -> String {
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

  // sourcery: pymethod = swapcase
  internal func swapcase() -> String {
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

  // sourcery: pymethod = casefold
  internal func casefold() -> String {
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

  // sourcery: pymethod = capitalize
  internal func capitalize() -> String {
    // Capitalize only first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = self.scalars.first else {
      return self.value
    }

    let head = first.properties.titlecaseMapping
    let tail = String(self.scalars.dropFirst()).lowercased()
    return head + tail
  }

  // MARK: - Just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    guard let widthInt = width as? PyInt else {
      return .typeError("ljust width arg must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("ljust width is too large")
    }

    var fill: UnicodeScalar = " "
    switch self.parseJustFillChar(fillChar, fnName: "ljust") {
    case .default: break
    case let .value(s): fill  = s
    case let .error(e): return .error(e)
    }

    /// CPython: marg
    let count = width - self.scalars.count
    guard count > 0 else {
      // swiftlint:disable:previous empty_count
      return .value(self.value)
    }

    let left = count / 2 + (count & width & 1)
    let right = count - left
    return .value(self.pad(left: left, right: right, fill: fill))
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    guard let widthInt = width as? PyInt else {
      return .typeError("ljust width arg must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("ljust width is too large")
    }

    var fill: UnicodeScalar = " "
    switch self.parseJustFillChar(fillChar, fnName: "ljust") {
    case .default: break
    case let .value(s): fill  = s
    case let .error(e): return .error(e)
    }

    let count = width - self.scalars.count
    return .value(self.pad(left: 0, right: count, fill: fill))
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    guard let widthInt = width as? PyInt else {
      return .typeError("rjust width arg must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("rjust width is too large")
    }

    var fill: UnicodeScalar = " "
    switch self.parseJustFillChar(fillChar, fnName: "rjust") {
    case .default: break
    case let .value(s): fill  = s
    case let .error(e): return .error(e)
    }

    let count = width - self.scalars.count
    return .value(self.pad(left: count, right: 0, fill: fill))
  }

  private enum JustFillChar {
    case `default`
    case value(UnicodeScalar)
    case error(PyErrorEnum)
  }

  private func parseJustFillChar(_ fillChar: PyObject?, fnName: String) -> JustFillChar {
    guard let fillChar = fillChar else {
      return .default
    }

    guard let fillCharString = fillChar as? PyString else {
      return .error(
        .typeError("ljust fillchar arg must be str, not \(fillChar.typeName)")
      )
    }

    let scalars = fillCharString.value.unicodeScalars
    guard let first = scalars.first, scalars.count == 1 else {
      return .error(
        .valueError("The fill character must be exactly one character long")
      )
    }

    return .value(first)
  }

  private func pad(left: Int, right: Int, fill: UnicodeScalar) -> String {
    // Fast path to avoid allocation
    guard left > 0 || right > 0 else {
      return self.value
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

  // TODO: Really, really test this. (Objects/stringlib/split.h)

  // sourcery: pymethod = split
  internal func split(separator: PyObject?,
                      maxCount: PyObject?) -> PyResult<[String]> {
    var sep: String
    switch self.parseSplitSeparator(separator) {
    case .whitespace: return self.splitWhitespace(maxCount)
    case let .some(s): sep = s
    case let .error(e): return .error(e)
    }

    var splitCounter: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): splitCounter = c
    case let .error(e): return .error(e)
    }

    var result = [String]()
    var index = self.scalars.startIndex

    let sepScalars = sep.unicodeScalars
    let sepCount = sepScalars.count

    while splitCounter > 0 {
      defer { splitCounter -= 1 }

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
    return .value(result)
  }

  private func splitWhitespace(_ maxCount: PyObject?) -> PyResult<[String]> {
    assert(self.scalars.any)

    if self.scalars.isEmpty {
      return .value([])
    }

    var splitCounter: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): splitCounter = c
    case let .error(e): return .error(e)
    }

    var result = [String]()
    var index = self.scalars.startIndex

    while splitCounter > 0 {
      defer { splitCounter -= 1 }

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

    return .value(result)
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(separator: PyObject?,
                       maxCount: PyObject?) -> PyResult<[String]> {
    if self.scalars.isEmpty {
      return .value([])
    }

    var sep: String
    switch self.parseSplitSeparator(separator) {
    case .whitespace: return self.rsplitWhitespace(maxCount)
    case let .some(s): sep = s
    case let .error(e): return .error(e)
    }

    var splitCounter: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): splitCounter = c
    case let .error(e): return .error(e)
    }

    var result = [String]()
    var index = self.scalars.endIndex
    self.scalars.formIndex(before: &index)

    let sepScalars = sep.unicodeScalars
    let sepCount = sepScalars.count

    while splitCounter > 0 {
      defer { splitCounter -= 1 }

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

    return .value(result)
  }

  private func rsplitWhitespace(_ maxCount: PyObject?) -> PyResult<[String]> {
    assert(self.scalars.any)

    var splitCounter: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): splitCounter = c
    case let .error(e): return .error(e)
    }

    var result = [String]()
    var index = self.scalars.endIndex
    self.scalars.formIndex(before: &index)

    while splitCounter > 0 {
      defer { splitCounter -= 1 }

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

    return .value(result)
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(keepEnds: PyObject) -> PyResult<[String]> {
    guard let keepEndsBool = keepEnds as? PyBool else {
      return .typeError("keepends must be bool, not \(keepEnds.typeName)")
    }

    let keepEnds = keepEndsBool.asBool()

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

    return .value(result)
  }

  private func isWhitespace(_ scalar: UnicodeScalar) -> Bool {
    return scalar.properties.isWhitespace
  }

  private static let lineBreaks: Set<UnicodeScalar> = Set([
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

  private func isLineBreak(_ scalar: UnicodeScalar) -> Bool {
    return PyString.lineBreaks.contains(scalar)
  }

  private enum SplitSeparator {
    case whitespace
    case some(String)
    case error(PyErrorEnum)
  }

  private func parseSplitSeparator(_ separator: PyObject?) -> SplitSeparator {
    guard let separator = separator else {
      return .whitespace
    }

    if separator is PyNone {
      return .whitespace
    }

    guard let sep = separator as? PyString else {
      return .error(
        .typeError("sep must be str or None, not \(separator.typeName)")
      )
    }

    if sep.value.isEmpty {
      return .error(.valueError("empty separator"))
    }

    return .some(sep.value)
  }

  private enum SplitMaxCount {
    case count(Int)
    case error(PyErrorEnum)
  }

  private func parseSplitMaxCount(_ maxCount: PyObject?) -> SplitMaxCount {
    guard let maxCount = maxCount else {
      return .count(Int.max)
    }

    guard let pyInt = maxCount as? PyInt else {
      return .error(.typeError("maxsplit must be int, not \(maxCount.typeName)"))
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .error(.overflowError("maxsplit is too big"))
    }

    return .count(int < 0 ? Int.max : int)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  internal func partition(separator: PyObject) -> PyResult<PyTuple> {
    guard let separatorString = separator as? PyString else {
      return .typeError("sep must be string, not \(separator.typeName)")
    }

    let sep = separatorString.value
    if sep.isEmpty {
      return .valueError("empty separator")
    }

    switch self.find(in: self.scalars, value: sep) {
    case let .index(index: index, position: _):
      let sepCount = sep.unicodeScalars.count
      let afterStart = self.scalars.index(index, offsetBy: sepCount)

      let before = PyString(context, value: self.scalars[..<index])
      let after  = PyString(context, value: self.scalars[afterStart...])
      return .value(PyTuple(self.context, elements: [before, separatorString, after]))

    case .notFound:
      let empty = self.createEmpty()
      return .value(PyTuple(self.context, elements: [self, empty, empty]))
    }
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    guard let separatorString = separator as? PyString else {
      return .typeError("sep must be string, not \(separator.typeName)")
    }

    let sep = separatorString.value
    if sep.isEmpty {
      return .valueError("empty separator")
    }

    switch self.rfind(in: self.scalars, value: sep) {
    case let .index(index: index, position: _):
      let sepCount = sep.unicodeScalars.count
      let afterStart = self.scalars.index(index, offsetBy: sepCount)

      let before = PyString(context, value: self.scalars[..<index])
      let after  = PyString(context, value: self.scalars[afterStart...])
      return .value(PyTuple(self.context, elements: [before, separatorString, after]))

    case .notFound:
      let empty = self.createEmpty()
      return .value(PyTuple(self.context, elements: [self, empty, empty]))
    }
  }

  private func createEmpty() -> PyString {
    return PyString(self.context, value: "")
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<String> {
    var tab: Int
    switch self.parseExpandTabsSize(tabSize) {
    case let .value(v): tab = v
    case let .error(e): return .error(e)
    }

    var result = ""
    var linePos = 0

    for scalar in self.scalars {
      switch scalar {
      case "\t":
        if tab > 0 {

          let incr = tab - (linePos % tab)
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

    return .value(result)
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

  // MARK: - Count

  internal static let countDoc = """
    S.count(sub[, start[, end]]) -> int

    Return the number of non-overlapping occurrences of substring sub in
    string S[start:end].  Optional arguments start and end are
    interpreted as in slice notation.
    """

  // Special overload for `CountOwner` protocol.
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
    return self.count(element, start: nil, end: nil)
  }

  // sourcery: pymethod = count, doc = countDoc
  internal func count(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    guard let elementString = element as? PyString else {
      return .typeError("sub arg must be str, not \(element.typeName)")
    }

    let substring: String.UnicodeScalarView.SubSequence
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    let elementScalars = elementString.scalars
    let elementCount = elementScalars.count

    var result = 0
    var index = substring.startIndex

    while index != substring.endIndex {
      defer { substring.formIndex(after: &index) }

      let s = substring[index...]
      if s.starts(with: elementScalars) {
        result += 1
        index = substring.index(index, offsetBy: elementCount)
      }
    }

    return .value(BigInt(result))
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<String> {
    guard let oldString = old as? PyString else {
      return .typeError("old must be str, not \(old.typeName)")
    }

    guard let newString = new as? PyString else {
      return .typeError("new must be str, not \(old.typeName)")
    }

    var remainingCount: Int
    switch self.parseReplaceCount(count) {
    case let .value(c): remainingCount = c
    case let .error(e): return .error(e)
    }

    let oldScalars = oldString.scalars
    let oldCount = oldScalars.count

    var result = ""
    var index = self.scalars.startIndex

    while index != self.scalars.endIndex {
      let s = self.scalars[index...]
      guard s.starts(with: oldScalars) else {
        result.append(self.scalars[index])
        continue
      }

      result.append(contentsOf: newString.value)
      index = self.scalars.index(index, offsetBy: oldCount)

      remainingCount -= 1
      if remainingCount <= 0 {
        break
      }
    }

    return .value(result)
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

  // MARK: - Zfil

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<String> {
    guard let widthInt = width as? PyInt else {
      return .typeError("width must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("width is too big")
    }

    let fillCount = width - self.scalars.count
    guard fillCount > 0 else {
      return .value(self.value)
    }

    let padding = String(repeating: "0", count: fillCount)
    guard let first = self.scalars.first else {
      return .value(padding)
    }

    var result = ""

    var withoutSign = self.scalars
    if first == "+" || first == "-" {
      result.append(first)
      withoutSign = String.UnicodeScalarView(self.scalars.dropFirst())
    }

    result.append(padding)
    result.unicodeScalars.append(contentsOf: withoutSign)
    return .value(result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherStr = other as? PyString else {
      return .typeError("can only concatenate str (not '\(other.typeName)') to str")
    }

    if self.value.isEmpty {
      return .value(PyString(self.context, value: otherStr.value))
    }

    if otherStr.value.isEmpty {
      return .value(PyString(self.context, value: self.value))
    }

    let result = self.value + otherStr.value
    return .value(PyString(self.context, value: result))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let pyInt = other as? PyInt else {
      return .typeError("can only multiply str and int (not '\(other.typeName)')")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("repeated string is too long")
    }

    if self.value.isEmpty || int == 1 {
      return .value(PyString(self.context, value: self.value))
    }

    var result = ""
    for _ in 0..<max(int, 0) {
      result.append(self.value)
    }

    return .value(PyString(self.context, value: result))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mul(other)
  }

  // MARK: - Helpers

  private func getSubstring(
    start: PyObject?,
    end: PyObject?) -> PyResult<String.UnicodeScalarView.SubSequence> {

    var startIndex = self.scalars.startIndex
    switch self.extractIndex(start) {
    case .none: break
    case let .index(index): startIndex = index
    case let .error(e): return .error(e)
    }

    var endIndex = self.scalars.endIndex
    switch self.extractIndex(end) {
    case .none: break
    case let .index(index): endIndex = index
    case let .error(e): return .error(e)
    }

    let result = self.scalars[startIndex..<endIndex]
    return .value(result)
  }

  private enum ExtractIndexResult {
    case none
    case index(String.UnicodeScalarIndex)
    case error(PyErrorEnum)
  }

  private func extractIndex(_ value: PyObject?) -> ExtractIndexResult {
    guard let value = value else {
      return .none
    }

    switch SequenceHelper.extractIndex2(value, typeName: "str") {
    case .none:
      return .none
    case var .index(index):
      let count = self.scalars.count

      if index < 0 {
        index += count
        if index < 0 {
          index = 0
        }
      }

      let result = self.scalars.index(self.scalars.startIndex,
                                      offsetBy: index,
                                      limitedBy: self.scalars.endIndex)

      return .index(result ?? self.scalars.endIndex)
    case let .error(e):
      return .error(e)
    }
  }
}
