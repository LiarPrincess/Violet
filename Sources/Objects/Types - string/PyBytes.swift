import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytes, default, baseType, bytesSubclass
public class PyBytes: PyObject, PyBytesType {

  internal static let doc = """
    bytes(iterable_of_ints) -> bytes
    bytes(string, encoding[, errors]) -> bytes
    bytes(bytes_or_buffer) -> immutable copy of bytes_or_buffer
    bytes(int) -> bytes object of size given by the parameter initialized with null bytes
    bytes() -> empty bytes object

    Construct an immutable array of bytes from:
      - an iterable yielding integers in range(256)
      - a text string encoded using the specified encoding
      - any object implementing the buffer API.
      - an integer
    """

  internal let data: PyBytesData

  internal var value: Data {
    return self.data.values
  }

  override public var description: String {
    return "PyBytes(count: \(self.value.count))"
  }

  // MARK: - Init

  internal init(value: Data) {
    self.data = PyBytesData(value)
    super.init(type: Py.types.bytes)
  }

  /// Use only in  `__new__`!
  internal init(type: PyType, value: Data) {
    self.data = PyBytesData(value)
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    if self === other {
      return .value(true)
    }

    return self.data.isEqual(other)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return self.data.isLess(other)
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.data.isLessEqual(other)
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return self.data.isGreater(other)
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.data.isGreaterEqual(other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    return .value(Py.hasher.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    let result = "b" + self.data.createRepr()
    return .value(result)
  }

  // sourcery: pymethod = __str__
  public func str() -> PyResult<String> {
    if let e = self.data.strWarnIfNeeded() {
      return .error(e)
    }
    return self.repr()
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  public func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  public func contains(element: PyObject) -> PyResult<Bool> {
    return self.data.contains(element: element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  public func getItem(index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index) {
    case let .item(int):
      let result = Py.newInt(int)
      return .value(result)
    case let .slice(bytes):
      let result = Py.newBytes(bytes)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Properties

  internal static let isalnumDoc = """
    Return True if the string is an alpha-numeric string, False otherwise.

    A string is alpha-numeric if all characters in the string are alpha-numeric and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isalnum, doc = isalnumDoc
  public func isAlphaNumeric() -> Bool {
    return self.data.isAlphaNumeric
  }

  internal static let isalphaDoc = """
    Return True if the string is an alphabetic string, False otherwise.

    A string is alphabetic if all characters in the string are alphabetic and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isalpha, doc = isalphaDoc
  public func isAlpha() -> Bool {
    return self.data.isAlpha
  }

  internal static let isasciiDoc = """
    Return True if all characters in the string are ASCII, False otherwise.

    ASCII characters have code points in the range U+0000-U+007F.
    Empty string is ASCII too.
    """

  // sourcery: pymethod = isascii, doc = isasciiDoc
  public func isAscii() -> Bool {
    return self.data.isAscii
  }

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  public func isDigit() -> Bool {
    return self.data.isDigit
  }

  internal static let islowerDoc = """
    Return True if the string is a lowercase string, False otherwise.

    A string is lowercase if all cased characters in the string are lowercase and
    there is at least one cased character in the string.
    """

  // sourcery: pymethod = islower, doc = islowerDoc
  public func isLower() -> Bool {
    return self.data.isLower
  }

  internal static let isspaceDoc = """
    Return True if the string is a whitespace string, False otherwise.

    A string is whitespace if all characters in the string are whitespace and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isspace, doc = isspaceDoc
  public func isSpace() -> Bool {
    return self.data.isSpace
  }

  internal static let istitleDoc = """
    Return True if the string is a title-cased string, False otherwise.

    In a title-cased string, upper- and title-case characters may only
    follow uncased characters and lowercase characters only cased ones.
    """

  // sourcery: pymethod = istitle, doc = istitleDoc
  public func isTitle() -> Bool {
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
  public func isUpper() -> Bool {
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

  public func startsWith(_ element: PyObject) -> PyResult<Bool> {
    return self.startsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = startswith, doc = startswithDoc
  public func startsWith(_ element: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<Bool> {
    return self.data.startsWith(element, start: start, end: end)
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  public func endsWith(_ element: PyObject) -> PyResult<Bool> {
    return self.endsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = endswith, doc = endswithDoc
  public func endsWith(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<Bool> {
    return self.data.endsWith(element, start: start, end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  public func strip(_ chars: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.strip(chars)
    return self.asBytes(data: result)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  public func lstrip(_ chars: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.lstrip(chars)
    return self.asBytes(data: result)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  public func rstrip(_ chars: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.rstrip(chars)
    return self.asBytes(data: result)
  }

  // MARK: - Find

  internal static let findDoc = """
    S.find(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  public func find(_ element: PyObject) -> PyResult<BigInt> {
    return self.find(element, start: nil, end: nil)
  }

  // sourcery: pymethod = find, doc = findDoc
  public func find(_ element: PyObject,
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

  public func rfind(_ element: PyObject) -> PyResult<BigInt> {
    return self.rfind(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rfind, doc = rfindDoc
  public func rfind(_ element: PyObject,
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
  public func index(of element: PyObject) -> PyResult<BigInt> {
    return self.index(of: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index, doc = indexDoc
  public func index(of element: PyObject,
                    start: PyObject?,
                    end: PyObject?) -> PyResult<BigInt> {
    return self.data.indexOf(element: element, start: start, end: end)
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  public func rindex(_ element: PyObject) -> PyResult<BigInt> {
    return self.rindex(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rindex, doc = rindexDoc
  public func rindex(_ element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<BigInt> {
    return self.data.rindexOf(element: element, start: start, end: end)
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  public func lower() -> PyBytes {
    let result = self.data.lowerCased()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = upper
  public func upper() -> PyBytes {
    let result = self.data.upperCased()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = title
  public func title() -> PyBytes {
    let result = self.data.titleCased()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = swapcase
  public func swapcase() -> PyBytes {
    let result = self.data.swapCase()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = capitalize
  public func capitalize() -> PyBytes {
    let result = self.data.capitalize()
    return self.asBytes(data: result)
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  public func center(width: PyObject,
                     fillChar: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.center(width: width, fillChar: fillChar)
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = ljust
  public func ljust(width: PyObject,
                    fillChar: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.ljust(width: width, fillChar: fillChar)
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = rjust
  public func rjust(width: PyObject,
                    fillChar: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.rjust(width: width, fillChar: fillChar)
    return self.asBytes(data: result)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(args: [PyObject],
                      kwargs: PyDict?) -> PyResult<[PyBytes]> {
    let result = self.data.split(args: args, kwargs: kwargs)
    return self.asByteList(data: result)
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(args: [PyObject],
                       kwargs: PyDict?) -> PyResult<[PyBytes]> {
    let result = self.data.rsplit(args: args, kwargs: kwargs)
    return self.asByteList(data: result)
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<[PyBytes]> {
    let result = self.data.splitLines(args: args, kwargs: kwargs)
    return self.asByteList(data: result)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  public func partition(separator: PyObject) -> PyResult<PyTuple> {
    switch self.data.partition(separator: separator) {
    case .separatorNotFound:
      let empty = Py.emptyBytes
      return .value(Py.newTuple(self, empty, empty))
    case let .separatorFound(before, _, after):
      let b = Py.newBytes(before)
      let a = Py.newBytes(after)
      return .value(Py.newTuple(b, separator, a)) // Reuse separator
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  public func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    switch self.data.rpartition(separator: separator) {
    case .separatorNotFound:
      let empty = Py.emptyBytes
      return .value(Py.newTuple(empty, empty, self))
    case let .separatorFound(before, _, after):
      let b = Py.newBytes(before)
      let a = Py.newBytes(after)
      return .value(Py.newTuple(b, separator, a)) // Reuse separator
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  public func expandTabs(tabSize: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.expandTabs(tabSize: tabSize)
    return self.asBytes(data: result)
  }

  // MARK: - Count

  internal static let countDoc = """
    S.count(sub[, start[, end]]) -> int

    Return the number of non-overlapping occurrences of substring sub in
    string S[start:end].  Optional arguments start and end are
    interpreted as in slice notation.
    """

  // Special overload for `CountOwner` protocol.
  public func count(_ element: PyObject) -> PyResult<BigInt> {
    return self.count(element, start: nil, end: nil)
  }

  // sourcery: pymethod = count, doc = countDoc
  public func count(_ element: PyObject,
                    start: PyObject?,
                    end: PyObject?) -> PyResult<BigInt> {
    return self.data.count(element: element, start: start, end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  public func join(iterable: PyObject) -> PyResult<PyBytes> {
    let result = self.data.join(iterable: iterable)
    return self.asBytes(data: result)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  public func replace(old: PyObject,
                      new: PyObject,
                      count: PyObject?) -> PyResult<PyBytes> {
    let result = self.data.replace(old: old, new: new, count: count)
    return self.asBytes(data: result)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  public func zfill(width: PyObject) -> PyResult<PyBytes> {
    let result = self.data.zfill(width: width)
    return self.asBytes(data: result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.add(other)
    return self.asBytes(data: result).map { $0 as PyObject }
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  public func mul(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.mul(other)
    return self.asBytes(data: result).map { $0 as PyObject }
  }

  // sourcery: pymethod = __rmul__
  public func rmul(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.rmul(other)
    return self.asBytes(data: result).map { $0 as PyObject }
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return PyBytesIterator(bytes: self)
  }

  // MARK: - Check exact

  public func checkExact() -> Bool {
    return self.type === Py.types.bytes
  }

  // MARK: - As bytes

  private func asBytes(data: Data) -> PyBytes {
    return Py.newBytes(data)
  }

  private func asBytes(data: PyResult<Data>) -> PyResult<PyBytes> {
    return data.map(self.asBytes(data:))
  }

  private func asByteList(data: PyResult<[Data]>) -> PyResult<[PyBytes]> {
    switch data {
    case let .value(ds):
      return .value(ds.map(self.asBytes(data:)))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["source", "encoding", "errors"],
    format: "|Oss:bytes"
  )

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyBytes> {
    switch self.newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let encoding = binding.optional(at: 1)
      let errors = binding.optional(at: 2)
      return PyBytes.pyNew(type: type,
                           object: object,
                           encoding: encoding,
                           errors: errors)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyNew(type: PyType,
                            object: PyObject?,
                            encoding: PyObject?,
                            errors: PyObject?) -> PyResult<PyBytes> {
    let isBuiltin = type === Py.types.bytes
    let alloca = isBuiltin ?
      self.newBytes(type:value:) :
      PyBytesHeap.init(type:value:)

    return PyBytesData
      .handleNewArgs(object: object, encoding: encoding, errors: errors)
      .map { alloca(type, $0) }
  }

  private static func newBytes(type: PyType, value: Data) -> PyBytes {
    return Py.newBytes(value) // Use cached empty bytes
  }
}
