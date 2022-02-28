import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytes, isDefault, isBaseType, isBytesSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyBytes: PyObjectMixin, AbstractBytes {

  // sourcery: pytypedoc
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

  internal enum Layout {
    internal static let elementsOffset = SizeOf.objectHeader
    internal static let elementsSize = SizeOf.data
    internal static let size = elementsOffset + elementsSize
  }

  private var elementsPtr: Ptr<Data> { self.ptr[Layout.elementsOffset] }
  internal var elements: Data { self.elementsPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, elements: Data) {
    self.header.initialize(type: type)
    self.elementsPtr.initialize(to: elements)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBytes(ptr: ptr)
    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyBytes(ptr: ptr)
    return "PyBytes(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - AbstractBytes

  internal typealias Element = UInt8
  internal typealias Elements = Data
  internal typealias Builder = BytesBuilder
  internal typealias SwiftType = PyBytes
  internal typealias ElementSwiftType = PyInt

  internal static func _toObject(element: UInt8) -> ElementSwiftType {
    return Py.newInt(element)
  }

  internal static func _toObject(elements: Elements) -> SwiftType {
    return Py.newBytes(elements)
  }

  internal static func _toObject(result: Elements) -> SwiftType {
    return Py.newBytes(result)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqualBytes(other: other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqualBytes(other: other)
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
  internal func hash() -> PyHash {
    return Py.hasher.hash(self.elements)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    let bytes = self._repr()
    return "b" + bytes
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return self._str()
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
    return self._length
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    return self._contains(object: object)
  }

  // MARK: - Get item

  private enum GetItemImpl: GetItemHelper {
    // swiftlint:disable nesting
    fileprivate typealias Source = Data
    fileprivate typealias SliceBuilder = BytesBuilder
    // swiftlint:enable nesting
  }

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    let result = GetItemImpl.getItem(source: self.elements, index: index)
    switch result {
    case let .single(byte):
      let int = Py.newInt(byte)
      return .value(int)
    case let .slice(data):
      let bytes = Py.newBytes(data)
      return .value(bytes)
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

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal func isDigit() -> Bool {
    return self._isDigit()
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
  internal func startsWith(prefix: PyObject,
                           start: PyObject?,
                           end: PyObject?) -> PyResult<Bool> {
    return self._startsWith(prefix: prefix, start: start, end: end)
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal func endsWith(suffix: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<Bool> {
    return self._endsWith(suffix: suffix, start: start, end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  internal func strip(chars: PyObject?) -> PyResult<PyBytes> {
    return self._strip(chars: chars)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(chars: PyObject?) -> PyResult<PyBytes> {
    return self._lstrip(chars: chars)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(chars: PyObject?) -> PyResult<PyBytes> {
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
  internal func find(object: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<BigInt> {
    return self._find(object: object, start: start, end: end)
  }

  internal static let rfindDoc = """
    S.rfind(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  // sourcery: pymethod = rfind, doc = rfindDoc
  internal func rfind(object: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self._rfind(object: object, start: start, end: end)
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
  internal func indexOf(object: PyObject,
                        start: PyObject?,
                        end: PyObject?) -> PyResult<BigInt> {
    return self._indexOf(object: object, start: start, end: end)
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  // sourcery: pymethod = rindex, doc = rindexDoc
  internal func rindexOf(object: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<BigInt> {
    return self._rindexOf(object: object, start: start, end: end)
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  internal func lower() -> PyBytes {
    return self._lowerCase()
  }

  // sourcery: pymethod = upper
  internal func upper() -> PyBytes {
    return self._upperCase()
  }

  // sourcery: pymethod = title
  internal func title() -> PyBytes {
    return self._titleCase()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> PyBytes {
    return self._swapCase()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> PyBytes {
    return self._capitalize()
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<PyBytes> {
    return self._center(width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<PyBytes> {
    return self._ljust(width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<PyBytes> {
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
    switch self._partition(separator: separator) {
    case let .separatorFound(before: before, separator: _, after: after):
      // We can reuse 'separator' because bytes are immutable
      let beforeObject = Self._toObject(elements: before)
      let afterObject = Self._toObject(elements: after)
      let result = Py.newTuple(beforeObject, separator, afterObject)
      return .value(result)

    case .separatorNotFound:
      let empty = Py.emptyBytes
      let result = Py.newTuple(self, empty, empty)
      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    switch self._rpartition(separator: separator) {
    case let .separatorFound(before: before, separator: _, after: after):
      // We can reuse 'separator' because bytes are immutable
      let beforeObject = Self._toObject(elements: before)
      let afterObject = Self._toObject(elements: after)
      let result = Py.newTuple(beforeObject, separator, afterObject)
      return .value(result)

    case .separatorNotFound:
      let empty = Py.emptyBytes
      let result = Py.newTuple(empty, empty, self)
      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<PyBytes> {
    return self._expandTabs(tabSize: tabSize)
  }

  // MARK: - Count

  internal static let countDoc = """
    S.count(sub[, start[, end]]) -> int

    Return the number of non-overlapping occurrences of substring sub in
    string S[start:end].  Optional arguments start and end are
    interpreted as in slice notation.
    """

  // sourcery: pymethod = count, doc = countDoc
  internal func count(object: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self._count(object: object, start: start, end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  internal func join(iterable: PyObject) -> PyResult<PyBytes> {
    return self._join(iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<PyBytes> {
    return self._replace(old: old, new: new, count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<PyBytes> {
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
    return PyMemory.newBytesIterator(bytes: self)
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
    let elements: Data
    switch Self._handleNewArgs(object: object, encoding: encoding, errors: errors) {
    case let .value(e): elements = e
    case let .error(e): return .error(e)
    }

    let isBuiltin = type === Py.types.bytes
    let result = isBuiltin ?
      Py.newBytes(elements) : // There is a potential to re-use interned value!
      PyMemory.newBytes(type: type, elements: elements)

    return .value(result)
  }
}

*/
