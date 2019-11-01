import Core

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html

// swiftlint:disable file_length

// sourcery: pytype = str
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
  internal func repr() -> String {
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

    return result
  }

  // sourcery: pymethod = __str__
  internal func str() -> String {
    return self.value
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> Int {
    return self.scalars.count
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

    // There are many good substring algorithms, and we went with this?
    var iter = scalars.startIndex
    let needle = elementString.value.unicodeScalars

    while iter != self.scalars.endIndex {
      let substring = self.scalars[iter...]
      if substring.starts(with: needle) {
        return .value(true)
      }

      self.scalars.formIndex(after: &iter)
    }

    return .value(false)
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

  // sourcery: pymethod = isalnum
  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one characte.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  internal func isAlphaNumeric() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { scalar in
      let properties = scalar.properties
      return properties.isAlphabetic
        || properties.generalCategory == .decimalNumber
        || scalar.properties.numericType != nil
    }
  }

  // sourcery: pymethod = isalpha
  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  internal func isAlpha() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.isAlphabetic }
  }

  // sourcery: pymethod = isascii
  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  internal func isAscii() -> Bool {
    return self.scalars.any && self.scalars.allSatisfy { $0.isASCII }
  }

  // sourcery: pymethod = isdecimal
  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  internal func isDecimal() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.generalCategory == .decimalNumber }
  }

  // sourcery: pymethod = isdigit
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

  // sourcery: pymethod = isidentifier
  /// https://docs.python.org/3/library/stdtypes.html#str.isidentifier
  internal func isIdentifier() -> Bool {
    switch self.scalars.isValidIdentifier {
    case .yes:
      return true
    case .no, .emptyString:
      return false
    }
  }

  // sourcery: pymethod = islower
  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  internal func isLower() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.isLowercase }
  }

  // sourcery: pymethod = isnumeric
  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  internal func isNumeric() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.numericType != nil }
  }

  // sourcery: pymethod = isprintable
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
    return self.scalars.any &&
      self.scalars.allSatisfy { scalar in
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

  // sourcery: pymethod = isspace
  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  internal func isSpace() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.isWhitespace }
  }

  // sourcery: pymethod = istitle
  /// Return true if the string is a titlecased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  internal func isTitle() -> Bool {
    guard self.scalars.any else {
      return false
    }

    var cased = false
    var isPreviousCased = false
    for scalar in self.scalars {
      let category = scalar.properties.generalCategory

      if category == .uppercaseLetter || category == .titlecaseLetter {
        if isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true
      } else if category == .lowercaseLetter {
        if !isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true
      } else {
        isPreviousCased = false
      }
    }

    return cased
  }

  // sourcery: pymethod = isupper
  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  internal func isUpper() -> Bool {
    return self.scalars.any &&
      self.scalars.allSatisfy { $0.properties.isUppercase }
  }

  // MARK: - Starts/ends with

  internal static let startswithDoc = """
    S.startswith(prefix[, start[, end]]) -> bool

    Return True if S starts with the specified prefix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    prefix can also be a tuple of strings to try.
    """

  // sourcery: pymethod = startswith, doc = startswithDoc
  internal func startsWith(_ value: PyObject,
                           start: PyObject,
                           end: PyObject) -> PyResult<Bool> {
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

    let substring = self.scalars[startIndex..<endIndex]

    if let tuple = value as? PyTuple {
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

    if let string = value as? PyString,
      substring.starts(with: string.value.unicodeScalars) {
      return .value(true)
    }

    return .typeError(
      "startswith first arg must be str or a tuple of str, not \(value.typeName)"
    )
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal func endsWith(_ value: PyObject,
                         start: PyObject,
                         end: PyObject) -> PyResultOrNot<Bool> {
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

    let substring = self.scalars[startIndex..<endIndex]

    if let tuple = value as? PyTuple {
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

    if let string = value as? PyString,
      substring.ends(with: string.value.unicodeScalars) {
      return .value(true)
    }

    return .typeError(
      "endswith first arg must be str or a tuple of str, not \(value.typeName)"
    )
  }

  // MARK: - Strip

  // TODO: `xStrip` argument is optional

  // sourcery: pymethod = strip
  internal func strip(_ chars: PyObject) -> PyResult<String> {
    guard let charsString = chars as? PyString else {
      return .typeError("strip arg must be str, not \(chars.typeName)")
    }

    let set = Set(charsString.value.unicodeScalars)
    let tmp = self.lStrip(value: self.value, chars: set)
    let result = self.rStrip(value: tmp, chars: set)
    return .value(result)
  }

  // sourcery: pymethod = lstrip
  internal func lStrip(_ chars: PyObject) -> PyResult<String> {
    guard let charsString = chars as? PyString else {
      return .typeError("lstrip arg must be str, not \(chars.typeName)")
    }

    let set = Set(charsString.value.unicodeScalars)
    let result = self.lStrip(value: self.value, chars: set)
    return .value(result)
  }

  private func lStrip(value: String, chars: Set<UnicodeScalar>) -> String {
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

  // sourcery: pymethod = rstrip
  internal func rStrip(_ chars: PyObject) -> PyResult<String> {
    guard let charsString = chars as? PyString else {
      return .typeError("rstrip arg must be str, not \(chars.typeName)")
    }

    let set = Set(charsString.value.unicodeScalars)
    let result = self.rStrip(value: self.value, chars: set)
    return .value(result)
  }

  private func rStrip(value: String, chars: Set<UnicodeScalar>) -> String {
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

  private enum ExtractIndexResult {
    case none
    case index(String.UnicodeScalarIndex)
    case error(PyErrorEnum)
  }

  private func extractIndex(_ value: PyObject) -> ExtractIndexResult {
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
