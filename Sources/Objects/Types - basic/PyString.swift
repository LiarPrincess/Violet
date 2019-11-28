import Core

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html

// swiftlint:disable file_length

// sourcery: pytype = str
/// Textual data in Python is handled with str objects, or strings.
/// Strings are immutable sequences of Unicode code points.
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

  internal let data: PyStringData

  internal var value: String {
    return self.data.value
  }

  // MARK: - Init

  internal init(_ context: PyContext, value: String) {
    self.data = PyStringData(value)
    super.init(type: context.builtins.types.str, hasDict: false)
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

  private typealias CompareResult = StringCompareResult

  private func compare(_ other: PyObject) -> PyResultOrNot<StringCompareResult> {
    guard let other = other as? PyString else {
      return .notImplemented
    }

    return .value(self.data.compare(to: other.data))
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .value(self.hashRaw())
  }

  internal func hashRaw() -> PyHash {
    return self.hasher.hash(self.value)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value(self.data.repr)
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return .value(self.data.str)
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
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    guard let elementString = element as? PyString else {
      return .typeError(
        "'in <string>' requires string as left operand, not \(element.typeName)"
      )
    }

    return .value(self.data.contains(elementString.data))
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch SequenceHelper.tryGetIndex(index) {
    case .value(let index):
      return self.data.getItem(at: index).map(self.builtins.newString(_:))
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      return self.getSlice(slice: slice)
    }

    let msg = "str indices must be integers or slices, not \(index.typeName)"
    return .typeError(msg)
  }

  private func getSlice(slice: PySlice) -> PyResult<PyObject> {
    let unpack: PySlice.UnpackedIndices
    switch slice.unpack() {
    case let .value(v): unpack = v
    case let .error(e): return .error(e)
    }

    let adjusted = slice.adjust(unpack, toLength: self.data.count)
    let result = self.data.getSlice(start: adjusted.start,
                                    step: adjusted.step,
                                    count: adjusted.length)

    return result.map(self.builtins.newString(_:))
  }

  // MARK: - Predicates

  internal static let isalnumDoc = """
    Return True if the string is an alpha-numeric string, False otherwise.

    A string is alpha-numeric if all characters in the string are alpha-numeric and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isalnum, doc = isalnumDoc
  internal func isAlphaNumeric() -> Bool {
    return self.data.isAlphaNumeric
  }

  internal static let isalphaDoc = """
    Return True if the string is an alphabetic string, False otherwise.

    A string is alphabetic if all characters in the string are alphabetic and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isalpha, doc = isalphaDoc
  internal func isAlpha() -> Bool {
    return self.data.isAlpha
  }

  internal static let isasciiDoc = """
    Return True if all characters in the string are ASCII, False otherwise.

    ASCII characters have code points in the range U+0000-U+007F.
    Empty string is ASCII too.
    """

  // sourcery: pymethod = isascii, doc = isasciiDoc
  internal func isAscii() -> Bool {
    return self.data.isAscii
  }

  internal static let isdecimalDoc = """
    Return True if the string is a decimal string, False otherwise.

    A string is a decimal string if all characters in the string are decimal and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isdecimal, doc = isdecimalDoc
  internal func isDecimal() -> Bool {
    return self.data.isDecimal
  }

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal func isDigit() -> Bool {
    return self.data.isDigit
  }

  internal static let isidentifierDoc = """
    Return True if the string is a valid Python identifier, False otherwise.

    Use keyword.iskeyword() to test for reserved identifiers such as "def" and
    "class".
    """

  // sourcery: pymethod = isidentifier, doc = isidentifierDoc
  internal func isIdentifier() -> Bool {
    return self.data.isIdentifier
  }

  internal static let islowerDoc = """
    Return True if the string is a lowercase string, False otherwise.

    A string is lowercase if all cased characters in the string are lowercase and
    there is at least one cased character in the string.
    """

  // sourcery: pymethod = islower, doc = islowerDoc
  internal func isLower() -> Bool {
    return self.data.isLower
  }

  internal static let isnumericDoc = """
    Return True if the string is a numeric string, False otherwise.

    A string is numeric if all characters in the string are numeric and there is at
    least one character in the string.
    """

  // sourcery: pymethod = isnumeric, doc = isnumericDoc
  internal func isNumeric() -> Bool {
    return self.data.isNumeric
  }

  internal static let isprintableDoc = """
    Return True if the string is printable, False otherwise.

    A string is printable if all of its characters are considered printable in
    repr() or if it is empty.
    """

  // sourcery: pymethod = isprintable, doc = isprintableDoc
  internal func isPrintable() -> Bool {
    return self.data.isPrintable
  }

  internal static let isspaceDoc = """
    Return True if the string is a whitespace string, False otherwise.

    A string is whitespace if all characters in the string are whitespace and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isspace, doc = isspaceDoc
  internal func isSpace() -> Bool {
    return self.data.isSpace
  }

  internal static let istitleDoc = """
    Return True if the string is a title-cased string, False otherwise.

    In a title-cased string, upper- and title-case characters may only
    follow uncased characters and lowercase characters only cased ones.
    """

  // sourcery: pymethod = istitle, doc = istitleDoc
  internal func isTitle() -> Bool {
    return self.data.isTitle
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
    return self.data.isUpper
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
    let substring: PyStringDataSlice
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    if let string = element as? PyString {
      return .value(substring.starts(with: string.data))
    }

    if let tuple = element as? PyTuple {
      for element in tuple.elements {
        guard let string = element as? PyString else {
          let t = element.typeName
          return .typeError("tuple for startswith must only contain str, not \(t)")
        }

        if substring.starts(with: string.data) {
          return .value(true)
        }
      }

      return .value(false)
    }

    let t = element.typeName
    return .typeError("startswith first arg must be str or a tuple of str, not \(t)")
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
    let substring: PyStringDataSlice
    switch self.getSubstring(start: start, end: end) {
    case let .value(v): substring = v
    case let .error(e): return .error(e)
    }

    if let string = element as? PyString {
      return .value(substring.ends(with: string.data))
    }

    if let tuple = element as? PyTuple {
      for element in tuple.elements {
        guard let string = element as? PyString else {
          let t = element.typeName
          return .typeError("tuple for endswith must only contain str, not \(t)")
        }

        if substring.ends(with: string.data) {
          return .value(true)
        }
      }

      return .value(false)
    }

    let t = element.typeName
    return .typeError("endswith first arg must be str or a tuple of str, not \(t)")
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
      return .value(self.data.stripWhitespace())
    case let .chars(set):
      return .value(self.data.strip(chars: set))
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
      return .value(self.data.lstripWhitespace())
    case let .chars(set):
      return .value(self.data.lstrip(chars: set))
    case let .error(e):
      return .error(e)
    }
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject) -> PyResult<String> {
    switch self.parseStripChars(chars, fnName: "rstrip") {
    case .whitespace:
      return .value(self.data.rstripWhitespace())
    case let .chars(set):
      return .value(self.data.rstrip(chars: set))
    case let .error(e):
      return .error(e)
    }
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
      return .chars(Set(charsString.data.scalars))
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

    let substring: PyStringDataSlice
    switch self.getSubstring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    switch substring.find(value: elementString.data) {
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

    let substring: PyStringDataSlice
    switch self.getSubstring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    switch substring.rfind(value: elementString.data) {
    case let .index(index: _, position: position):
      return .value(position)
    case .notFound:
      return .value(-1)
    }
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
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    return self.index(of: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index, doc = indexDoc
  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    guard let elementString = element as? PyString else {
      return .typeError("index arg must be str, not \(element.typeName)")
    }

    let substring: PyStringDataSlice
    switch self.getSubstring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    switch substring.find(value: elementString.data) {
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

    let substring: PyStringDataSlice
    switch self.getSubstring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    switch substring.rfind(value: elementString.data) {
    case let .index(index: _, position: position):
      return .value(position)
    case .notFound:
      return .valueError("substring not found")
    }
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  internal func lower() -> String {
    return self.data.lowerCased()
  }

  // sourcery: pymethod = upper
  internal func upper() -> String {
    return self.data.upperCased()
  }

  // sourcery: pymethod = title
  internal func title() -> String {
    return self.data.titleCased()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> String {
    return self.data.swapCase()
  }

  // sourcery: pymethod = casefold
  internal func casefold() -> String {
    return self.data.caseFold()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> String {
    return self.data.capitalize()
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "center") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let fill: UnicodeScalar
    switch self.parseJustFillChar(fillChar, fnName: "center") {
    case .default: fill = " "
    case let .value(s): fill  = s
    case let .error(e): return .error(e)
    }

    return .value(self.data.center(width: parsedWidth, fill: fill))
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "ljust") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let fill: UnicodeScalar
    switch self.parseJustFillChar(fillChar, fnName: "ljust") {
    case .default: fill = " "
    case let .value(s): fill  = s
    case let .error(e): return .error(e)
    }

    return .value(self.data.ljust(width: parsedWidth, fill: fill))
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "rjust") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let fill: UnicodeScalar
    switch self.parseJustFillChar(fillChar, fnName: "rjust") {
    case .default: fill = " "
    case let .value(s): fill  = s
    case let .error(e): return .error(e)
    }

    return .value(self.data.rjust(width: parsedWidth, fill: fill))
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

  private enum JustFillChar {
    case `default`
    case value(UnicodeScalar)
    case error(PyErrorEnum)
  }

  private func parseJustFillChar(_ fillChar: PyObject?,
                                 fnName: String) -> JustFillChar {
    guard let fillChar = fillChar else {
      return .default
    }

    guard let pyString = fillChar as? PyString else {
      let msg = "\(fnName) fillchar arg must be str, not \(fillChar.typeName)"
      return .error(.typeError(msg))
    }

    let scalars = pyString.data.scalars
    guard let first = scalars.first, scalars.count == 1 else {
      let msg = "The fill character must be exactly one character long"
      return .error(.valueError(msg))
    }

    return .value(first)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(separator: PyObject?,
                      maxCount: PyObject?) -> PyResult<[String]> {
    var sep: PyStringData
    switch self.parseSplitSeparator(separator) {
    case .whitespace: return self.splitWhitespace(maxCount)
    case let .some(s): sep = s
    case let .error(e): return .error(e)
    }

    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): count = c
    case let .error(e): return .error(e)
    }

    return .value(self.data.split(separator: sep, maxCount: count))
  }

  private func splitWhitespace(_ maxCount: PyObject?) -> PyResult<[String]> {
    if self.data.isEmpty {
      return .value([])
    }

    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): count = c
    case let .error(e): return .error(e)
    }

    return .value(self.data.splitWhitespace(maxCount: count))
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(separator: PyObject?,
                       maxCount: PyObject?) -> PyResult<[String]> {
    if self.data.isEmpty {
      return .value([])
    }

    var sep: PyStringData
    switch self.parseSplitSeparator(separator) {
    case .whitespace: return self.rsplitWhitespace(maxCount)
    case let .some(s): sep = s
    case let .error(e): return .error(e)
    }

    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): count = c
    case let .error(e): return .error(e)
    }

    return .value(self.data.rsplit(separator: sep, maxCount: count))
  }

  private func rsplitWhitespace(_ maxCount: PyObject?) -> PyResult<[String]> {
    if self.data.isEmpty {
      return .value([])
    }

    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .count(c): count = c
    case let .error(e): return .error(e)
    }

    return .value(self.data.rsplitWhitespace(maxCount: count))
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(keepEnds: PyObject) -> PyResult<[String]> {
    guard let keepEndsBool = keepEnds as? PyBool else {
      return .typeError("keepends must be bool, not \(keepEnds.typeName)")
    }

    let keepEnds = keepEndsBool.asBool()
    return .value(self.data.splitLines(keepEnds: keepEnds))
  }

  private enum SplitSeparator {
    case whitespace
    case some(PyStringData)
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

    if sep.data.isEmpty {
      return .error(.valueError("empty separator"))
    }

    return .some(sep.data)
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

    let result = self.data.partition(separator: separatorString.data)
    return self.toTuple(separator: separator, result: result)
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    guard let separatorString = separator as? PyString else {
      return .typeError("sep must be string, not \(separator.typeName)")
    }

    let result = self.data.rpartition(separator: separatorString.data)
    return self.toTuple(separator: separator, result: result)
  }

  private func toTuple(separator: PyObject,
                       result: StringPartitionResult) -> PyResult<PyTuple> {
    switch result {
    case .notFound:
      let empty = self.builtins.emptyString
      return .value(PyTuple(self.context, elements: [self, empty, empty]))
    case let .triple(before: before, after: after):
      let b = PyString(self.context, value: String(before))
      let a = PyString(self.context, value: String(after))
      return .value(PyTuple(self.context, elements: [b, separator, a]))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<String> {
    switch self.parseExpandTabsSize(tabSize) {
    case let .value(v):
      return .value(self.data.expandTabs(tabSize: v))
    case let .error(e):
      return .error(e)
    }
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

    switch self.getSubstring(start: start, end: end) {
    case let .value(substring):
      let result = substring.count(element: elementString.data)
      return .value(BigInt(result))
    case let .error(e):
      return .error(e)
    }
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

    var parsedCount: Int
    switch self.parseReplaceCount(count) {
    case let .value(c): parsedCount = c
    case let .error(e): return .error(e)
    }

    let result = self.data.replace(old: oldString.data,
                                   new: newString.data,
                                   count: parsedCount)

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

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<String> {
    guard let widthInt = width as? PyInt else {
      return .typeError("width must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("width is too big")
    }

    return .value(self.data.zfill(width: width))
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherStr = other as? PyString else {
      return .typeError("can only concatenate str (not '\(other.typeName)') to str")
    }

    let result = self.data.add(otherStr.data)
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

    let result = self.data.mul(int)
    return .value(PyString(self.context, value: result))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mul(other)
  }

  // MARK: - Helpers

  private func getSubstring(start: PyObject?,
                            end: PyObject?) -> PyResult<PyStringDataSlice> {

    let startIndex: PyStringData.Index
    switch self.extractIndex(start) {
    case .none: startIndex = self.data.startIndex
    case .index(let index): startIndex = index
    case .error(let e): return .error(e)
    }

    var endIndex: PyStringData.Index
    switch self.extractIndex(end) {
    case .none: endIndex = self.data.endIndex
    case .index(let index): endIndex = index
    case .error(let e): return .error(e)
    }

    return .value(self.data.substring(start: startIndex, end: endIndex))
  }

  private enum ExtractIndexResult {
    case none
    case index(PyStringData.Index)
    case error(PyErrorEnum)
  }

  private func extractIndex(_ value: PyObject?) -> ExtractIndexResult {
    guard let value = value else {
      return .none
    }

    if value is PyNone {
      return .none
    }

    switch SequenceHelper.getIndex(value) {
    case var .value(index):
      if index < 0 {
        index += self.data.count
        if index < 0 {
          index = 0
        }
      }

      let start = self.data.startIndex
      let end = self.data.endIndex
      let result = self.data.index(start, offsetBy: index, limitedBy: end)
      return .index(result ?? end)

    case let .error(e):
      return .error(e)
    }
  }
}
