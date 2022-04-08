import BigInt
import UnicodeData
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html
// https://www.python.org/dev/peps/pep-0393/

// sourcery: pytype = str, isDefault, isBaseType, isUnicodeSubclass
// sourcery: subclassInstancesHave__dict__
/// Textual data in Python is handled with str objects, or strings.
/// Strings are immutable sequences of Unicode code points.
public struct PyString: PyObjectMixin, AbstractString {

  // sourcery: pytypedoc
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

  // MARK: - Properties

  private static let invalidCount = -1
  // Empty string has hash '0', but this is trivial to recalculate.
  // If any other string hashes to '0' then we will accept defeat and recalculate
  // it on every call. It is still better than not caching at all.
  private static let invalidHash = PyHash.zero

  // sourcery: storedProperty
  /// Cache 'count' because 'String.unicodeScalars.count' is O(n)!
  /// (yes, on EVERY call!)
  ///
  /// So never, ever, use 'self.elements.count', use 'self.count'!
  ///
  /// We can do this because `str` is immutable.
  internal var cachedCount: Int {
    get { self.cachedCountPtr.pointee }
    nonmutating set { self.cachedCountPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// Cache hash value because `str` is very often used as `__dict__` key.
  ///
  /// We can do this because `str` is immutable.
  internal var cachedHash: PyHash {
    get { self.cachedHashPtr.pointee }
    nonmutating set { self.cachedHashPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var value: String { self.valuePtr.pointee }

  /// We work on scalars (Unicode code points) instead of graphemes because:
  /// - len("Cafe\u0301") = 5 (Swift: "Cafe\u{0301}".unicodeScalars.count)
  /// - len("Café")       = 4 (Swift: "Café".unicodeScalars.count)
  /// See: https://www.python.org/dev/peps/pep-0393/
  internal var elements: String.UnicodeScalarView {
    return self.value.unicodeScalars
  }

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    if self.cachedCount == PyString.invalidCount {
      self.cachedCount = self.elements.count
    }

    return self.cachedCount
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(_ py: Py, type: PyType, value: String) {
    self.initializeBase(py, type: type)
    self.valuePtr.initialize(to: value)
    self.cachedCountPtr.initialize(to: PyString.invalidCount)
    self.cachedHashPtr.initialize(to: PyString.invalidHash)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyString(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.cachedCount, includeInDescription: true)
    result.append(name: "hash", value: zelf.cachedHash, includeInDescription: true)
    result.append(name: "value", value: zelf.value, includeInDescription: true)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__eq__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ne__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__lt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__le__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__gt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ge__(py, zelf: zelf, other: other)
  }

  internal func isEqual(_ string: String) -> Bool {
    return Self.abstractIsEqual(zelf: self, other: string.unicodeScalars)
  }

  internal func isEqual(_ other: PyString) -> Bool {
    return Self.abstractIsEqual(zelf: self, other: other.elements)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    let result = zelf.getHash(py)
    return .value(result)
  }

  internal func getHash(_ py: Py) -> PyHash {
    if self.cachedHash == Self.invalidHash {
      self.cachedHash = py.hasher.hash(self.value)
    }

    return self.cachedHash
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let result = zelf.repr()
    return PyResult(py, result)
  }

  internal func repr() -> String {
    let quote = self.getReprQuoteChar()

    var result = String(quote)
    result.reserveCapacity(self.count)

    for element in self.elements {
      switch element {
      case quote,
        "\\":
        result.append("\\")
        result.append(element)
      case "\n":
        result.append("\\n")
      case "\t":
        result.append("\\t")
      case "\r":
        result.append("\\r")
      default:
        if Self.isPrintable(element: element) {
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
  internal static func __str__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__str__")
    }

    // We are immutable!
    return PyResult(zelf)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func __len__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__len__")
    }

    let result = zelf.count
    return PyResult(py, result)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal static func __contains__(_ py: Py, zelf: PyObject, object: PyObject) -> PyResult {
    return Self.abstract__contains__(py, zelf: zelf, object: object)
  }

  internal func contains(value: String) -> Bool {
    return self.abstractContains(elements: value.unicodeScalars)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal static func __getitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getitem__")
    }

    return Self.getItem(py, zelf: zelf, index: index)
  }

  // MARK: - Properties

  internal static let isalnumDoc = """
   Return True if the string is an alpha-numeric string, False otherwise.

   A string is alpha-numeric if all characters in the string are alpha-numeric and
   there is at least one character in the string.
   """

  // sourcery: pymethod = isalnum, doc = isalnumDoc
  internal static func isalnum(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsAlphaNumeric(py, zelf: zelf)
  }

  internal static let isalphaDoc = """
   Return True if the string is an alphabetic string, False otherwise.

   A string is alphabetic if all characters in the string are alphabetic and there
   is at least one character in the string.
   """

  // sourcery: pymethod = isalpha, doc = isalphaDoc
  internal static func isalpha(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsAlpha(py, zelf: zelf)
  }

  internal static let isasciiDoc = """
   Return True if all characters in the string are ASCII, False otherwise.

   ASCII characters have code points in the range U+0000-U+007F.
   Empty string is ASCII too.
   """

  // sourcery: pymethod = isascii, doc = isasciiDoc
  internal static func isascii(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsAscii(py, zelf: zelf)
  }

  internal static let isdecimalDoc = """
   Return True if the string is a decimal string, False otherwise.

   A string is a decimal string if all characters in the string are decimal and
   there is at least one character in the string.
   """

  // sourcery: pymethod = isdecimal, doc = isdecimalDoc
  internal static func isdecimal(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isdecimal")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isDecimal(element:))
    return PyResult(py, result)
  }

  internal static let isdigitDoc = """
   Return True if the string is a digit string, False otherwise.

   A string is a digit string if all characters in the string are digits and there
   is at least one character in the string.
   """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal static func isdigit(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsDigit(py, zelf: zelf)
  }

  internal static let isidentifierDoc = """
   Return True if the string is a valid Python identifier, False otherwise.

   Use keyword.iskeyword() to test for reserved identifiers such as "def" and
   "class".
   """

  // sourcery: pymethod = isidentifier, doc = isidentifierDoc
  internal static func isidentifier(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isidentifier")
    }

    /// https://docs.python.org/3/library/stdtypes.html#str.isidentifier
    switch zelf.elements.isValidIdentifier {
    case .yes:
      return PyResult(py, true)
    case .no,
        .emptyString:
      return PyResult(py, false)
    }
  }

  internal static let islowerDoc = """
   Return True if the string is a lowercase string, False otherwise.

   A string is lowercase if all cased characters in the string are lowercase and
   there is at least one cased character in the string.
   """

  // sourcery: pymethod = islower, doc = islowerDoc
  internal static func islower(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsLower(py, zelf: zelf)
  }

  internal static let isnumericDoc = """
   Return True if the string is a numeric string, False otherwise.

   A string is numeric if all characters in the string are numeric and there is at
   least one character in the string.
   """

  // sourcery: pymethod = isnumeric, doc = isnumericDoc
  internal static func isnumeric(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isnumeric")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isNumeric(element:))
    return PyResult(py, result)
  }

  internal static let isprintableDoc = """
   Return True if the string is printable, False otherwise.

   A string is printable if all of its characters are considered printable in
   repr() or if it is empty.
   """

  // sourcery: pymethod = isprintable, doc = isprintableDoc
  internal static func isprintable(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isprintable")
    }

    // We do not have to check if 'self.elements.isEmpty'!
    // Empty string is printable!
    let result = zelf.elements.allSatisfy(Self.isPrintable(element:))
    return PyResult(py, result)
  }

  internal static let isspaceDoc = """
   Return True if the string is a whitespace string, False otherwise.

   A string is whitespace if all characters in the string are whitespace and there
   is at least one character in the string.
   """

  // sourcery: pymethod = isspace, doc = isspaceDoc
  internal static func isspace(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsSpace(py, zelf: zelf)
  }

  internal static let istitleDoc = """
   Return True if the string is a title-cased string, False otherwise.

   In a title-cased string, upper- and title-case characters may only
   follow uncased characters and lowercase characters only cased ones.
   """

  // sourcery: pymethod = istitle, doc = istitleDoc
  internal static func istitle(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsTitle(py, zelf: zelf)
  }

  internal static let isupperDoc = """
   Return True if the string is an uppercase string, False otherwise.

   A string is uppercase if all cased characters in the string are uppercase and
   there is at least one cased character in the string.
   """

  // sourcery: pymethod = isupper, doc = isupperDoc
  internal static func isupper(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsUpper(py, zelf: zelf)
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
  internal static func startswith(_ py: Py,
                                  zelf: PyObject,
                                  prefix: PyObject,
                                  start: PyObject?,
                                  end: PyObject?) -> PyResult {
    return Self.abstractStartsWith(py,
                                   zelf: zelf,
                                   prefix: prefix,
                                   start: start,
                                   end: end)
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal static func endswith(_ py: Py,
                                zelf: PyObject,
                                suffix: PyObject,
                                start: PyObject?,
                                end: PyObject?) -> PyResult {
    return Self.abstractEndsWith(py,
                                 zelf: zelf,
                                 suffix: suffix,
                                 start: start,
                                 end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  internal static func strip(_ py: Py, zelf: PyObject, chars: PyObject?) -> PyResult {
    return Self.abstractStrip(py, zelf: zelf, chars: chars)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal static func lstrip(_ py: Py, zelf: PyObject, chars: PyObject?) -> PyResult {
    return Self.abstractLStrip(py, zelf: zelf, chars: chars)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal static func rstrip(_ py: Py, zelf: PyObject, chars: PyObject?) -> PyResult {
    return Self.abstractRStrip(py, zelf: zelf, chars: chars)
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
  internal static func find(_ py: Py,
                            zelf: PyObject,
                            object: PyObject,
                            start: PyObject?,
                            end: PyObject?) -> PyResult {
    return Self.abstractFind(py, zelf: zelf, object: object, start: start, end: end)
  }

  internal static let rfindDoc = """
    S.rfind(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  // sourcery: pymethod = rfind, doc = rfindDoc
  internal static func rfind(_ py: Py,
                             zelf: PyObject,
                             object: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult {
    return Self.abstractRfind(py, zelf: zelf, object: object, start: start, end: end)
  }

  // MARK: - Index

  internal static let indexDoc = """
    S.index(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  // sourcery: pymethod = index, doc = indexDoc
  internal static func index(_ py: Py,
                             zelf: PyObject,
                             object: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult {
    return Self.abstractIndex(py, zelf: zelf, object: object, start: start, end: end)
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  // sourcery: pymethod = rindex, doc = rindexDoc
  internal static func rindex(_ py: Py,
                              zelf: PyObject,
                              object: PyObject,
                              start: PyObject?,
                              end: PyObject?) -> PyResult {
    return Self.abstractRIndex(py, zelf: zelf, object: object, start: start, end: end)
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  internal static func lower(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractLower(py, zelf: zelf)
  }

  // sourcery: pymethod = upper
  internal static func upper(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractUpper(py, zelf: zelf)
  }

  // sourcery: pymethod = title
  internal static func title(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractTitle(py, zelf: zelf)
  }

  // sourcery: pymethod = swapcase
  internal static func swapcase(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractSwapcase(py, zelf: zelf)
  }

  // sourcery: pymethod = capitalize
  internal static func capitalize(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractCapitalize(py, zelf: zelf)
  }

  // sourcery: pymethod = casefold
  internal static func casefold(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "casefold")
    }

    var builder = Builder(capacity: zelf.count)

    for element in zelf.elements {
      let mapping = UnicodeData.toCasefold(element)
      builder.append(mapping: mapping)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal static func center(_ py: Py,
                              zelf: PyObject,
                              width: PyObject,
                              fillChar: PyObject?) -> PyResult {
    return Self.abstractCenter(py, zelf: zelf, width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = ljust
  internal static func ljust(_ py: Py,
                             zelf: PyObject,
                             width: PyObject,
                             fillChar: PyObject?) -> PyResult {
    return Self.abstractLJust(py, zelf: zelf, width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = rjust
  internal static func rjust(_ py: Py,
                             zelf: PyObject,
                             width: PyObject,
                             fillChar: PyObject?) -> PyResult {
    return Self.abstractRJust(py, zelf: zelf, width: width, fillChar: fillChar)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal static func split(_ py: Py,
                             zelf: PyObject,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult {
    return Self.abstractSplit(py, zelf: zelf, args: args, kwargs: kwargs)
  }

  // sourcery: pymethod = rsplit
  internal static func rsplit(_ py: Py,
                              zelf: PyObject,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult {
    return Self.abstractRSplit(py, zelf: zelf, args: args, kwargs: kwargs)
  }

  // sourcery: pymethod = splitlines
  internal static func splitlines(_ py: Py,
                                  zelf: PyObject,
                                  args: [PyObject],
                                  kwargs: PyDict?) -> PyResult {
    return Self.abstractSplitLines(py, zelf: zelf, args: args, kwargs: kwargs)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  internal static func partition(_ py: Py, zelf: PyObject, separator: PyObject) -> PyResult {
    switch Self.abstractPartition(py, zelf: zelf, separator: separator) {
    case let .separatorFound(before: before, separator: _, after: after):
      // We can reuse 'separator' because strings are immutable
      let beforeObject = Self.newObject(py, elements: before)
      let afterObject = Self.newObject(py, elements: after)
      return PyResult(py, tuple: beforeObject.asObject, separator, afterObject.asObject)

    case .separatorNotFound:
      let empty = py.emptyString.asObject
      return PyResult(py, tuple: zelf.asObject, empty, empty)

    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  internal static func rpartition(_ py: Py, zelf: PyObject, separator: PyObject) -> PyResult {
    switch Self.abstractRPartition(py, zelf: zelf, separator: separator) {
    case let .separatorFound(before: before, separator: _, after: after):
      // We can reuse 'separator' because strings are immutable
      let beforeObject = Self.newObject(py, elements: before)
      let afterObject = Self.newObject(py, elements: after)
      return PyResult(py, tuple: beforeObject.asObject, separator, afterObject.asObject)

    case .separatorNotFound:
      let empty = py.emptyString.asObject
      return PyResult(py, tuple: empty, empty, zelf.asObject)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal static func expandtabs(_ py: Py,
                                  zelf: PyObject,
                                  tabSize: PyObject?) -> PyResult {
    return Self.abstractExpandTabs(py, zelf: zelf, tabSize: tabSize)
  }

  // MARK: - Count

  internal static let countDoc = """
    S.count(sub[, start[, end]]) -> int

    Return the number of non-overlapping occurrences of substring sub in
    string S[start:end].  Optional arguments start and end are
    interpreted as in slice notation.
    """

  // sourcery: pymethod = count, doc = countDoc
  internal static func count(_ py: Py,
                             zelf: PyObject,
                             object: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult {
    return Self.abstractCount(py, zelf: zelf, object: object, start: start, end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  internal static func join(_ py: Py, zelf: PyObject, iterable: PyObject) -> PyResult {
    return Self.abstractJoin(py, zelf: zelf, iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal static func replace(_ py: Py,
                               zelf: PyObject,
                               old: PyObject,
                               new: PyObject,
                               count: PyObject?) -> PyResult {
    return Self.abstractReplace(py, zelf: zelf, old: old, new: new, count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal static func zfill(_ py: Py, zelf: PyObject, width: PyObject) -> PyResult {
    return Self.abstractZFill(py, zelf: zelf, width: width)
  }

  // MARK: - Add, mul

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__add__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __mul__
  internal static func __mul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__mul__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __rmul__
  internal static func __rmul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__rmul__(py, zelf: zelf, other: other)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newStringIterator(string: zelf)
    return PyResult(result)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["object", "encoding", "errors"],
    format: "|Oss:str"
  )

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    switch self.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let encoding = binding.optional(at: 1)
      let errors = binding.optional(at: 2)
      return Self.__new__(py,
                          type: type,
                          object: object,
                          encoding: encoding,
                          errors: errors)
    case let .error(e):
      return .error(e)
    }
  }

  private static func __new__(_ py: Py,
                              type: PyType,
                              object: PyObject?,
                              encoding encodingObject: PyObject?,
                              errors errorObject: PyObject?) -> PyResult {
    guard let object = object else {
      return Self.allocate(py, type: type, value: "")
    }

    // Fast path when we don't have encoding and kwargs
    if encodingObject == nil && errorObject == nil {
      // If we are builtin 'str' (not a subclass) -> return itself
      // (because str is immutable).
      // If we are a subclass then we have to do a proper 'str' dispatch, because
      // '__str__' may be overriden.
      if let str = py.cast.asExactlyString(object) {
        return PyResult(str)
      }

      switch py.str(object) {
      case let .value(str):
        return Self.allocate(py, type: type, value: str.value)
      case let .error(e):
        return .error(e)
      }
    }

    let encoding: Encoding
    switch Encoding.from(py, object: encodingObject) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errorHandling: ErrorHandling
    switch ErrorHandling.from(py, object: errorObject) {
    case let .value(e): errorHandling = e
    case let .error(e): return .error(e)
    }

    if let bytes = py.cast.asAnyBytes(object) {
      let string = encoding.decodeOrError(py, data: bytes.elements, onError: errorHandling)
      return string.flatMap { Self.allocate(py, type: type, value: $0) }
    }

    if py.cast.isString(object) {
      return .typeError(py, message: "decoding str is not supported")
    }

    let message = "decoding to str: need a bytes-like object, \(object.typeName) found"
    return .typeError(py, message: message)
  }

  private static func allocate(_ py: Py, type: PyType, value: String) -> PyResult {
    // If this is a builtin then try to re-use interned values
    let isBuiltin = type === py.types.str
    let result = isBuiltin ?
      py.newString(value) :
      py.memory.newString(type: type, value: value)

    return PyResult(result)
  }
}
