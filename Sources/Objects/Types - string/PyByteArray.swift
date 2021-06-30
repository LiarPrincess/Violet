import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytearray, default, baseType
public class PyByteArray: PyObject, AbstractBytes {

  internal static let doc = """
    bytearray(iterable_of_ints) -> bytearray
    bytearray(string, encoding[, errors]) -> bytearray
    bytearray(bytes_or_buffer) -> mutable copy of bytes_or_buffer
    bytearray(int) -> bytes array of size given by the parameter initialized with null bytes
    bytearray() -> empty bytes array

    Construct a mutable bytearray object from:
      - an iterable yielding integers in range(256)
      - a text string encoded using the specified encoding
      - a bytes or a buffer object
      - any object implementing the buffer API.
      - an integer
    """

  internal var elements: Data {
    return self.data.scalars
  }

  override public var description: String {
    return "PyByteArray(count: \(self.value.count))"
  }

  // MARK: - Init

  internal convenience init(value: Data) {
    let type = Py.types.bytearray
    self.init(type: type, value: value)
  }

  internal init(type: PyType, value: Data) {
    self.data = PyBytesData(value)
    super.init(type: type)
  }

  // MARK: - AbstractBytes

  internal typealias Element = UInt8
  internal typealias Elements = Data
  internal typealias Builder = BytesBuilder2
  internal typealias SwiftType = PyByteArray
  internal typealias ElementSwiftType = PyInt

  internal static func _toObject(element: UInt8) -> ElementSwiftType {
    return Py.newInt(element)
  }

  internal static func _toObject(elements: Elements) -> SwiftType {
    return Py.newByteArray(elements)
  }

  internal static func _toObject(result: Elements) -> SwiftType {
    return Py.newByteArray(result)
  }

  // MARK: - To remove

  internal private(set) var data: PyBytesData

  internal var value: Data {
    return self.data.values
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
  internal func hash() -> HashResult {
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let bytes = self._repr()
    let result = "bytearray(b" + bytes + ")"
    return .value(result)
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
    return self._count
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(element: PyObject) -> PyResult<Bool> {
    return self._contains(element: element)
  }

  // MARK: - Get/set/del item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    return self._getItem(index: index)
  }

  // sourcery: pymethod = __setitem__
  internal func setItem(index: PyObject, value: PyObject) -> PyResult<PyNone> {
    return self.data.setItem(index: index, value: value)
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(index: PyObject) -> PyResult<PyNone> {
    return self.data.delItem(index: index)
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
  internal func strip(_ chars: PyObject?) -> PyResult<PyByteArray> {
    return self._strip(chars: chars)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(_ chars: PyObject?) -> PyResult<PyByteArray> {
    return self._lstrip(chars: chars)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject?) -> PyResult<PyByteArray> {
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
  internal func lower() -> PyByteArray {
    return self._lowerCaseBytes()
  }

  // sourcery: pymethod = upper
  internal func upper() -> PyByteArray {
    return self._upperCaseBytes()
  }

  // sourcery: pymethod = title
  internal func title() -> PyByteArray {
    return self._titleCaseBytes()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> PyByteArray {
    return self._swapCaseBytes()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> PyByteArray {
    return self._capitalizeBytes()
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<PyByteArray> {
    return self._center(width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<PyByteArray> {
    return self._ljust(width: width, fillChar: fillChar)
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<PyByteArray> {
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
    case let .separatorFound(before: before, separator: separator, after: after):
      let beforeObject = Py.newByteArray(before)
      let separatorObject = Py.newByteArray(separator) // Always new!
      let afterObject = Py.newByteArray(after)
      let result = Py.newTuple(beforeObject, separatorObject, afterObject)
      return .value(result)

    case .separatorNotFound:
      // 'bytearray' is mutable, so we have to create 2 separate objects
      let empty1 = Py.newByteArray(Data())
      let empty2 = Py.newByteArray(Data())
      return .value(Py.newTuple(self, empty1, empty2))

    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    switch self._rpartition(separator: separator) {
    case let .separatorFound(before: before, separator: separator, after: after):
      let beforeObject = Py.newByteArray(before)
      let separatorObject = Py.newByteArray(separator) // Always new!
      let afterObject = Py.newByteArray(after)
      let result = Py.newTuple(beforeObject, separatorObject, afterObject)
      return .value(result)

    case .separatorNotFound:
      // 'bytearray' is mutable, so we have to create 2 separate objects
      let empty1 = Py.newByteArray(Data())
      let empty2 = Py.newByteArray(Data())
      return .value(Py.newTuple(empty1, empty2, self))

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<PyByteArray> {
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
  internal func join(iterable: PyObject) -> PyResult<PyByteArray> {
    return self._join(iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<PyByteArray> {
    return self._replace(old: old, new: new, count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<PyByteArray> {
    return self._zFill(width: width)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    return self._add(other: other).map { $0 as PyObject }
  }

  // sourcery: pymethod = __iadd__
  internal func iadd(_ other: PyObject) -> PyResult<PyObject> {
    switch self.data.add(other) {
    case let .value(data):
      self.data = PyBytesData(data)
      return .value(self)
    case let .error(e):
      return .error(e)
    }
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

  // sourcery: pymethod = __imul__
  internal func imul(_ other: PyObject) -> PyResult<PyObject> {
    switch self.data.mul(other) {
    case let .value(data):
      self.data = PyBytesData(data)
      return .value(self)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyByteArrayIterator(bytes: self)
  }

  // MARK: - Append

  internal static let appendDoc = """
    append($self, item, /)
    --

    Append a single item to the end of the bytearray.

      item
        The item to be appended.
    """

  // sourcery: pymethod = append, doc = appendDoc
  internal func append(_ element: PyObject) -> PyResult<PyNone> {
    return self.data.append(object: element)
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal func extend(iterable: PyObject) -> PyResult<PyNone> {
    return self.data.extend(with: iterable).map { _ in Py.none }
  }

  // MARK: - Insert

  internal static let insertDoc = """
    insert($self, index, item, /)
    --

    Insert a single item into the bytearray before the given index.

      index
        The index where the value is to be inserted.
      item
        The item to be inserted.
    """

  // sourcery: pymethod = insert, doc = insertDoc
  internal func insert(index: PyObject, item: PyObject) -> PyResult<PyNone> {
    let result = self.data.insert(index: index, item: item)
    return result.map { _ in Py.none }
  }

  // MARK: - Remove

  internal static let removeDoc = """
    remove($self, value, /)
    --

    Remove the first occurrence of a value in the bytearray.

      value
        The value to remove.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal func remove(_ value: PyObject) -> PyResult<PyNone> {
    return self.data.remove(value).map { _ in Py.none }
  }

  // MARK: - Pop

  internal static let popDoc = """
    pop($self, index=-1, /)
    --

    Remove and return a single item from B.

      index
        The index from where to remove the item.
        -1 (the default value) means remove the last item.

    If no index argument is given, will pop the last item.
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal func pop(index: PyObject?) -> PyResult<PyObject> {
    return self.data.pop(index: index).map(Py.newInt)
  }

  // MARK: - Clear

  internal static let clearDoc = """
    clear($self, /)
    --

    Remove all items from the bytearray.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyNone {
    self.data.clear()
    return Py.none
  }

  // MARK: - Reverse

  internal static let reverseDoc = """
    reverse($self, /)
    --

    Reverse the order of the values in B in place.
    """

  // sourcery: pymethod = reverse, doc = reverseDoc
  internal func reverse() -> PyResult<PyNone> {
    self.data.reverse()
    return .value(Py.none)
  }

  // MARK: - Copy

  internal static let copyDoc = """
    copy($self, /)
    --

    Return a copy of B.
    """

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return Py.newByteArray(self.data.values)
  }

  // MARK: - Check exact

  internal func checkExact() -> Bool {
    return self.type === Py.types.bytearray
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyByteArray> {
    let data = Data()

    let isBuiltin = type === Py.types.bytes
    let result = isBuiltin ?
      Py.newByteArray(data) :
      PyByteArrayHeap(type:type, value: data)

    return .value(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["source", "encoding", "errors"],
    format: "|Oss:bytearray"
  )

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    switch PyByteArray.initArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let encoding = binding.optional(at: 1)
      let errors = binding.optional(at: 2)

      switch Self._handleNewArgs(object: object, encoding: encoding, errors: errors) {
      case let .value(data):
        self.data = PyBytesData(data)
        return .value(Py.none)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }
}
