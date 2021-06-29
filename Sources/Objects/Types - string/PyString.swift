import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html

private typealias UnicodeScalarView = String.UnicodeScalarView
private typealias UnicodeScalarViewSub = UnicodeScalarView.SubSequence

// sourcery: pytype = str, default, baseType, unicodeSubclass
/// Textual data in Python is handled with str objects, or strings.
/// Strings are immutable sequences of Unicode code points.
public class PyString: PyObject, AbstractString {

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

  public let value: String

  /// We work on scalars (Unicode code points) instead of graphemes because:
  /// - len("Cafe\u0301") = 5 (Swift: "Cafe\u{0301}".unicodeScalars.count)
  /// - len("Café")       = 4 (Swift: "Café".unicodeScalars.count)
  /// See: https://www.python.org/dev/peps/pep-0393/
  internal var elements: Elements {
    return self.value.unicodeScalars
  }

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    return self.elements.count
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

  internal convenience init(value: String) {
    let type = Py.types.str
    self.init(type: type, value: value)
  }

  internal init(type: PyType, value: String) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - AbstractString

  internal typealias Element = UnicodeScalar
  internal typealias Elements = String.UnicodeScalarView
  internal typealias Builder = UnicodeScalarBuilder

  internal static let _pythonTypeName = "str"
  internal static let _defaultFill: UnicodeScalar = " "
  internal static let _zFill: UnicodeScalar = "0"

  internal static func _getEmptyObject() -> Self {
    // swiftlint:disable:next force_cast
    return Py.emptyString as! Self
  }

  internal static func _toObject(element: Element) -> Self {
    // swiftlint:disable:next force_cast
    return Py.newString(element) as! Self
  }

  internal static func _toObject(elements: Elements) -> Self {
    // swiftlint:disable:next force_cast
    return Py.newString(elements) as! Self
  }

  internal static func _toObject(elements: Elements.SubSequence) -> Self {
    let string = String(elements)
    // swiftlint:disable:next force_cast
    return Py.newString(string) as! Self
  }

  internal static func _toObject(result: String) -> Self {
    // swiftlint:disable:next force_cast
    return Py.newString(result) as! Self
  }

  internal static func _getElements(object: PyObject) -> Elements? {
    if let string = PyCast.asString(object) {
      return string.elements
    }

    return nil
  }

  internal static func _getElementsForFindCountContainsIndexOf(
    object: PyObject
  ) -> AbstractString_ElementsForFindCountContainsIndexOf<Elements> {
    // Nothing special here, only 'str' can be used in 'find', 'count' etc… '.
    if let string = PyCast.asString(object) {
      return .value(string.elements)
    }

    return .invalidObjectType
  }

  internal static func _asUnicodeScalar(element: UnicodeScalar) -> UnicodeScalar {
    return element
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other: other)
  }

  internal func isEqual(_ other: PyString) -> Bool {
    return self._isEqual(other: other)
  }

  internal func isEqual(_ other: String) -> Bool {
    return self._isEqual(other: other.unicodeScalars)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqual(other: other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self._isLess(other: other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self._isLessEqual(other: other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self._isGreater(other: other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self._isGreaterEqual(other: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  /// In Swift use `hashImpl` instead.
  internal func hash() -> HashResult {
    let result = self.hashRaw()
    return .value(result)
  }

  internal func hashRaw() -> PyHash {
    return Py.hasher.hash(self.value)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  /// In Swift use `reprImpl` instead.
  internal func repr() -> PyResult<String> {
    let result = self.reprRaw()
    return .value(result)
  }

  internal func reprRaw() -> String {
    let quote = self.getReprQuoteChar()

    var result = String(quote)
    result.reserveCapacity(self.elements.count)

    for element in self.elements {
      switch element {
      case quote, "\\":
        result.append("\\")
        result.append(element)
      case "\n":
        result.append("\\n")
      case "\t":
        result.append("\\t")
      case "\r":
        result.append("\\r")
      default:
        if StringImplementation.isPrintable(scalar: element) {
          result.append(element)
        } else {
          let repr = self.createNonPrintableRepr(scalar: element)
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

    for element in self.elements {
      switch element {
      case "'": singleCount += 1
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
      // Map 16-bit characters to '\uxxxx' // cSpell:disable-line
      result.append("u")
      result.append(self.hex((value >> 12) & 0xf))
      result.append(self.hex((value >> 8) & 0xf))
      result.append(self.hex((value >> 4) & 0xf))
      result.append(self.hex((value >> 0) & 0xf))
    } else {
      // Map 21-bit characters to '\U00xxxxxx'
      result.append("U")
      result.append(self.hex((value >> 28) & 0xf))
      result.append(self.hex((value >> 24) & 0xf))
      result.append(self.hex((value >> 20) & 0xf))
      result.append(self.hex((value >> 16) & 0xf))
      result.append(self.hex((value >> 12) & 0xf))
      result.append(self.hex((value >> 8) & 0xf))
      result.append(self.hex((value >> 4) & 0xf))
      result.append(self.hex((value >> 0) & 0xf))
    }

    return result
  }

  private func hex(_ value: UInt32) -> String {
    return String(value, radix: 16, uppercase: false)
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
    return self._count
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(element: PyObject) -> PyResult<Bool> {
    return self._contains(object: element)
  }

  internal func contains(value: String) -> Bool {
    return self._contains(value: value.unicodeScalars)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    return self._getItem(index: index).map { $0 as PyObject }
  }

  // MARK: - Properties

  internal static let isalnumDoc = """
    Return True if the string is an alpha-numeric string, False otherwise.

    A string is alpha-numeric if all characters in the string are alpha-numeric and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isalnum, doc = isalnumDoc
  internal func isAlphaNumeric() -> Bool {
    return self._isAlphaNumeric()
  }

  internal static let isalphaDoc = """
    Return True if the string is an alphabetic string, False otherwise.

    A string is alphabetic if all characters in the string are alphabetic and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isalpha, doc = isalphaDoc
  internal func isAlpha() -> Bool {
    return self._isAlpha()
  }

  internal static let isasciiDoc = """
    Return True if all characters in the string are ASCII, False otherwise.

    ASCII characters have code points in the range U+0000-U+007F.
    Empty string is ASCII too.
    """

  // sourcery: pymethod = isascii, doc = isasciiDoc
  internal func isAscii() -> Bool {
    return self._isAscii()
  }

  internal static let isdecimalDoc = """
    Return True if the string is a decimal string, False otherwise.

    A string is a decimal string if all characters in the string are decimal and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isdecimal, doc = isdecimalDoc
  internal func isDecimal() -> Bool {
    return self._isDecimal()
  }

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal func isDigit() -> Bool {
    return self._isDigit()
  }

  internal static let isidentifierDoc = """
    Return True if the string is a valid Python identifier, False otherwise.

    Use keyword.iskeyword() to test for reserved identifiers such as "def" and
    "class".
    """

  // sourcery: pymethod = isidentifier, doc = isidentifierDoc
  internal func isIdentifier() -> Bool {
    /// https://docs.python.org/3/library/stdtypes.html#str.isidentifier
    switch self.elements.isValidIdentifier {
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
  internal func isLower() -> Bool {
    return self._isLower()
  }

  internal static let isnumericDoc = """
    Return True if the string is a numeric string, False otherwise.

    A string is numeric if all characters in the string are numeric and there is at
    least one character in the string.
    """

  // sourcery: pymethod = isnumeric, doc = isnumericDoc
  internal func isNumeric() -> Bool {
    return self._isNumeric()
  }

  internal static let isprintableDoc = """
    Return True if the string is printable, False otherwise.

    A string is printable if all of its characters are considered printable in
    repr() or if it is empty.
    """

  // sourcery: pymethod = isprintable, doc = isprintableDoc
  internal func isPrintable() -> Bool {
    return self._isPrintable()
  }

  internal static let isspaceDoc = """
    Return True if the string is a whitespace string, False otherwise.

    A string is whitespace if all characters in the string are whitespace and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isspace, doc = isspaceDoc
  internal func isSpace() -> Bool {
    return self._isSpace()
  }

  internal static let istitleDoc = """
    Return True if the string is a title-cased string, False otherwise.

    In a title-cased string, upper- and title-case characters may only
    follow uncased characters and lowercase characters only cased ones.
    """

  // sourcery: pymethod = istitle, doc = istitleDoc
  internal func isTitle() -> Bool {
    return self._isTitle()
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
    return self._isUpper()
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
  internal func startsWith(_ element: PyObject,
                           start: PyObject?,
                           end: PyObject?) -> PyResult<Bool> {
    return self._startsWith(prefix: element, start: start, end: end)
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal func endsWith(_ element: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<Bool> {
    return self._endsWith(suffix: element, start: start, end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  internal func strip(_ chars: PyObject?) -> PyResult<PyString> {
    return self._strip(chars: chars)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(_ chars: PyObject?) -> PyResult<PyString> {
    return self._lstrip(chars: chars)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject?) -> PyResult<PyString> {
    return self._rstrip(chars: chars)
  }

  // MARK: - Find

  internal static let findDoc = """
    S.find(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  // sourcery: pymethod = find, doc = findDoc
  internal func find(_ element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<BigInt> {
    return self._find(object: element, start: start, end: end)
  }

  internal static let rfindDoc = """
    S.rfind(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  // sourcery: pymethod = rfind, doc = rfindDoc
  internal func rfind(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self._rfind(object: element, start: start, end: end)
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
    return self._indexOf(object: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index, doc = indexDoc
  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self._indexOf(object: element, start: start, end: end)
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  // sourcery: pymethod = rindex, doc = rindexDoc
  internal func rindex(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    return self._rindexOf(object: element, start: start, end: end)
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  internal func lower() -> String {
    return self._lowerCase()
  }

  // sourcery: pymethod = upper
  internal func upper() -> String {
    return self._upperCase()
  }

  // sourcery: pymethod = title
  internal func title() -> String {
    return self._titleCase()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> String {
    return self._swapCase()
  }

  // sourcery: pymethod = casefold
  internal func casefold() -> String {
    return self._caseFold()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> String {
    return self._capitalize()
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<PyString> {
    return self._center(width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<PyString> {
    return self._ljust(width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<PyString> {
    return self._rjust(width: width, fillChar: fillChar)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(args: [PyObject], kwargs: PyDict?) -> PyResult<PyList> {
    return self._split(args: args, kwargs: kwargs)
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyList> {
    return self._rsplit(args: args, kwargs: kwargs)
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(args: [PyObject], kwargs: PyDict?) -> PyResult<PyList> {
    return self._splitLines(args: args, kwargs: kwargs)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  internal func partition(separator: PyObject) -> PyResult<PyTuple> {
    return self._partition(separator: separator)
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    return self._rpartition(separator: separator)
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<PyString> {
    return self._expandTabs(tabSize: tabSize)
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
    return self._count(object: element, start: nil, end: nil)
  }

  // sourcery: pymethod = count, doc = countDoc
  internal func count(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self._count(object: element, start: start, end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  internal func join(iterable: PyObject) -> PyResult<PyString> {
    return self._join(iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<PyString> {
    return self._replace(old: old, new: new, count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<PyString> {
    return self._zFill(width: width)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    return self._add(other: other).map { $0 as PyObject }
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    return self._mul(count: other).map { $0 as PyObject }
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self._rmul(count: other).map { $0 as PyObject }
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

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyString> {
    switch self.newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let encoding = binding.optional(at: 1)
      let errors = binding.optional(at: 2)
      return PyString.pyNew(type: type,
                            object: object,
                            encoding: encoding,
                            errors: errors)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyNew(type: PyType,
                            object: PyObject?,
                            encoding encodingObj: PyObject?,
                            errors errorObj: PyObject?) -> PyResult<PyString> {
    let isBuiltin = type === Py.types.str
    let alloca = isBuiltin ?
      self.newString(type:value:) :
      PyStringHeap.init(type:value:)

    guard let object = object else {
      return .value(alloca(type, ""))
    }

    // Fast path when we don't have encoding and kwargs
    if encodingObj == nil && errorObj == nil {
      // Is this object already a 'str'?
      if let str = PyCast.asString(object) {
        // If we are builtin 'str' (not a subclass) -> return itself
        if PyCast.isExactlyString(str) {
          return .value(str)
        }

        let result = Py.newString(str.value)
        return .value(result)
      }

      // 'str' of a str-subtype should be a 'str', not this subtype
      return Py.strValue(object: object).map { alloca(type, $0) }
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

    if PyCast.isString(object) {
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
