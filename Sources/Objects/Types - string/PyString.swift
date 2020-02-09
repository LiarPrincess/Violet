import Core

private typealias UnicodeScalarView = String.UnicodeScalarView
private typealias UnicodeScalarViewSub = UnicodeScalarView.SubSequence

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html

// swiftlint:disable file_length

// sourcery: pytype = str, default, baseType, unicodeSubclass
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

  internal var scalars: String.UnicodeScalarView {
    return self.data.scalars
  }

  override public var description: String {
    let shortCount = 50

    var short = self.value.prefix(shortCount)
    if self.value.count > shortCount {
      short += "..."
    }

    return "PyString('\(short)')"
  }

  // MARK: - Init

  internal init(value: String) {
    self.data = PyStringData(value)
    super.init(type: Py.types.str)
  }

  /// Use only in  `__new__`!
  internal init(type: PyType, value: String) {
    self.data = PyStringData(value)
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    if self === other {
      return .value(true)
    }

    return CompareResult(self.compare(other).map { $0 == .equal })
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return CompareResult(self.compare(other).map { $0 == .less })
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return CompareResult(self.compare(other).map { $0 == .less || $0 == .equal })
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return CompareResult(self.compare(other).map { $0 == .greater })
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return CompareResult(self.compare(other).map { $0 == .greater || $0 == .equal })
  }

  private func compare(_ other: PyObject) -> StringCompareResult? {
    guard let other = other as? PyString else {
      return nil
    }

    return self.data.compare(to: other.data)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .value(Py.hasher.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let result = self.data.createRepr()
    return .value(result)
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return .value(self.data.value)
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

  internal func getAttribute(name: String) -> PyResult<PyObject> {
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
    return self.data.contains(element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(at: index) {
    case let .item(scalar):
      let result = Py.newString(String(scalar))
      return .value(result)
    case let .slice(string):
      let result = Py.newString(string)
      return .value(result)
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
    return self.data.starts(with: element, start: start, end: end)
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  internal func endsWith(_ element: PyObject) -> PyResult<Bool> {
    return self.endsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal func endsWith(_ element: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<Bool> {
    return self.data.ends(with: element, start: start, end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  internal func strip(_ chars: PyObject?) -> PyResult<String> {
    return self.data.strip(chars).map(String.init)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(_ chars: PyObject) -> PyResult<String> {
    return self.data.lstrip(chars).map(String.init)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject) -> PyResult<String> {
    return self.data.rstrip(chars).map(String.init)
  }

  // MARK: - Find

  internal static let findDoc = """
    S.find(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  internal func find(_ element: PyObject) -> PyResult<BigInt> {
    return self.find(element, start: nil, end: nil)
  }

  // sourcery: pymethod = find, doc = findDoc
  internal func find(_ element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<BigInt> {
    return self.data.find(element, start: start, end: end)
  }

  internal static let rfindDoc = """
    S.rfind(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  internal func rfind(_ element: PyObject) -> PyResult<BigInt> {
    return self.rfind(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rfind, doc = rfindDoc
  internal func rfind(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self.data.rfind(element, start: start, end: end)
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
    return self.data.index(of: element, start: start, end: end)
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  internal func rindex(_ element: PyObject) -> PyResult<BigInt> {
    return self.rindex(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rindex, doc = rindexDoc
  internal func rindex(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    return self.data.rindex(element, start: start, end: end)
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
    return self.data.center(width: width, fill: fillChar)
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    return self.data.ljust(width: width, fill: fillChar)
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    return self.data.rjust(width: width, fill: fillChar)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(separator: PyObject?,
                      maxCount: PyObject?) -> PyResult<[String]> {
    return self.data.split(separator: separator, maxCount: maxCount)
      .map(self.toStringArray(_:))
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(separator: PyObject?,
                       maxCount: PyObject?) -> PyResult<[String]> {
    return self.data.rsplit(separator: separator, maxCount: maxCount)
      .map(self.toStringArray(_:))
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(keepEnds: PyObject) -> PyResult<[String]> {
    return self.data.splitLines(keepEnds: keepEnds)
      .map(self.toStringArray(_:))
  }

  private func toStringArray(_ values: [UnicodeScalarViewSub]) -> [String] {
    return values.map(String.init)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  internal func partition(separator: PyObject) -> PyResult<PyTuple> {
    return self.data.partition(separator: separator)
      .flatMap { self.toTuple(separator: separator, result: $0) }
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    return self.data.rpartition(separator: separator)
      .flatMap { self.toTuple(separator: separator, result: $0) }
  }

  private func toTuple(
    separator: PyObject,
    result: StringPartitionResult<UnicodeScalarViewSub>) -> PyResult<PyTuple> {

    switch result {
    case .separatorNotFound:
      let empty = Py.emptyString
      return .value(Py.newTuple(self, empty, empty))
    case let .separatorFound(before, after):
      let b = Py.newString(String(before))
      let a = Py.newString(String(after))
      return .value(Py.newTuple(b, separator, a))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<String> {
    return self.data.expandTabs(tabSize: tabSize)
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
    return self.data.count(element, start: start, end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  internal func join(iterable: PyObject) -> PyResult<String> {
    return self.data.join(iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<String> {
    return self.data.replace(old: old, new: new, count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<String> {
    return self.data.zfill(width: width)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    return self.data.add(other).map(Py.newString(_:))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    return self.data.mul(other).map(Py.newString(_:))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.data.rmul(other).map(Py.newString(_:))
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyStringIterator(string: self)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["object", "encoding", "errors"],
    format: "|Oss:str"
  )

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    switch newArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 3, "Invalid argument count returned from parser.")
      let arg0 = bind.count >= 1 ? bind[0] : nil
      let arg1 = bind.count >= 2 ? bind[1] : nil
      let arg2 = bind.count >= 3 ? bind[2] : nil
      return PyString.pyNew(type: type, object: arg0, encoding: arg1, errors: arg2)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyNew(type: PyType,
                            object: PyObject?,
                            encoding encodingObj: PyObject?,
                            errors errorObj: PyObject?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.str
    let alloca = isBuiltin ?
      newString(type:value:) :
      PyStringHeap.init(type:value:)

    guard let object = object else {
      return .value(alloca(type, ""))
    }

    // Fast path when we don't have encoding and kwargs
    if encodingObj == nil && errorObj == nil {
      return Py.strValue(object).map { alloca(type, $0) }
    }

    let encoding: PyStringEncoding
    switch PyStringEncoding.from(encodingObj) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errors: PyStringErrorHandler
    switch PyStringErrorHandler.from(errorObj) {
    case let .value(e): errors = e
    case let .error(e): return .error(e)
    }

    if let bytes = object as? PyBytesType {
      let data = bytes.data.values
      return encoding.decode(data: data, errors: errors).map { alloca(type, $0) }
    }

    if object is PyString {
      return .typeError("decoding str is not supported")
    }

    let t = object.typeName
    return .typeError("decoding to str: need a bytes-like object, \(t) found")
  }

  /// Allocate new PyString (it will use 'builtins' cache if possible).
  private static func newString(type: PyType, value: String) -> PyString {
    return Py.newString(value)
  }
}
