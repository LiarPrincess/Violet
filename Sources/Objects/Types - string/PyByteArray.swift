import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytearray, default, baseType
public class PyByteArray: PyObject, PyBytesType {

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

  internal private(set) var data: PyBytesData

  internal var value: Data {
    return self.data.values
  }

  override public var description: String {
    return "PyByteArray(count: \(self.value.count))"
  }

  // MARK: - Init

  internal init(value: Data) {
    self.data = PyBytesData(value)
    super.init(type: Py.types.bytearray)
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
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    let result = "bytearray(b" + self.data.createRepr() + ")"
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
    return self.data.contains(element)
  }

  // MARK: - Get/set/del item

  // sourcery: pymethod = __getitem__
  public func getItem(index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index) {
    case let .item(int):
      return .value(Py.newInt(int))
    case let .slice(bytes):
      return .value(Py.newByteArray(bytes))
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __setitem__
  public func setItem(index: PyObject, value: PyObject) -> PyResult<PyNone> {
    return self.data.setItem(index: index, value: value)
  }

  // sourcery: pymethod = __delitem__
  public func delItem(index: PyObject) -> PyResult<PyNone> {
    return self.data.delItem(index: index)
  }

  // MARK: - Predicates

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
    return self.data.starts(with: element, start: start, end: end)
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
    return self.data.ends(with: element, start: start, end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  public func strip(_ chars: PyObject?) -> PyResult<PyByteArray> {
    let result = self.data.strip(chars)
    return self.asBytes(data: result)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  public func lstrip(_ chars: PyObject?) -> PyResult<PyByteArray> {
    let result = self.data.lstrip(chars)
    return self.asBytes(data: result)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  public func rstrip(_ chars: PyObject?) -> PyResult<PyByteArray> {
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
    return self.data.index(of: element, start: start, end: end)
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
    return self.data.rindex(element, start: start, end: end)
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  public func lower() -> PyByteArray {
    let result = self.data.lowerCased()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = upper
  public func upper() -> PyByteArray {
    let result = self.data.upperCased()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = title
  public func title() -> PyByteArray {
    let result = self.data.titleCased()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = swapcase
  public func swapcase() -> PyByteArray {
    let result = self.data.swapCase()
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = capitalize
  public func capitalize() -> PyByteArray {
    let result = self.data.capitalize()
    return self.asBytes(data: result)
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  public func center(width: PyObject, fillChar: PyObject?) -> PyResult<PyByteArray> {
    let result = self.data.center(width: width, fill: fillChar)
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = ljust
  public func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<PyByteArray> {
    let result = self.data.ljust(width: width, fill: fillChar)
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = rjust
  public func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<PyByteArray> {
    let result = self.data.rjust(width: width, fill: fillChar)
    return self.asBytes(data: result)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(args: [PyObject],
                      kwargs: PyDict?) -> PyResult<[PyByteArray]> {
    let result = self.data.split(args: args, kwargs: kwargs)
    return self.asBytes(data: result)
  }

  public func split(separator: PyObject?,
                    maxCount: PyObject?) -> PyResult<[PyByteArray]> {
    let result = self.data.split(separator: separator, maxCount: maxCount)
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(args: [PyObject],
                       kwargs: PyDict?) -> PyResult<[PyByteArray]> {
    let result = self.data.rsplit(args: args, kwargs: kwargs)
    return self.asBytes(data: result)
  }

  public func rsplit(separator: PyObject?,
                     maxCount: PyObject?) -> PyResult<[PyByteArray]> {
    let result = self.data.rsplit(separator: separator, maxCount: maxCount)
    return self.asBytes(data: result)
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<[PyByteArray]> {
    let result = self.data.splitLines(args: args, kwargs: kwargs)
    return self.asBytes(data: result)
  }

  public func splitLines(keepEnds: PyObject?) -> PyResult<[PyByteArray]> {
    let result = self.data.splitLines(keepEnds: keepEnds)
    return self.asBytes(data: result)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  public func partition(separator: PyObject) -> PyResult<PyTuple> {
    switch self.data.partition(separator: separator) {
    case .separatorNotFound:
      let empty1 = Py.newByteArray(Data())
      let empty2 = Py.newByteArray(Data())
      return .value(Py.newTuple(elements: self, empty1, empty2))
    case let .separatorFound(before, sep, after):
      let b = Py.newByteArray(before)
      let s = Py.newByteArray(sep) // Always new!
      let a = Py.newByteArray(after)
      return .value(Py.newTuple(elements: b, s, a))
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  public func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    switch self.data.rpartition(separator: separator) {
    case .separatorNotFound:
      let empty1 = Py.newByteArray(Data())
      let empty2 = Py.newByteArray(Data())
      return .value(Py.newTuple(elements: empty1, empty2, self))
    case let .separatorFound(before, sep, after):
      let b = Py.newByteArray(before)
      let s = Py.newByteArray(sep) // Always new!
      let a = Py.newByteArray(after)
      return .value(Py.newTuple(elements: b, s, a))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  public func expandTabs(tabSize: PyObject?) -> PyResult<PyByteArray> {
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
  public func count(element: PyObject) -> PyResult<BigInt> {
    return self.count(element: element, start: nil, end: nil)
  }

  // sourcery: pymethod = count, doc = countDoc
  public func count(element: PyObject,
                    start: PyObject?,
                    end: PyObject?) -> PyResult<BigInt> {
    return self.data.count(element, start: start, end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  public func join(iterable: PyObject) -> PyResult<PyByteArray> {
    let result = self.data.join(iterable: iterable)
    return self.asBytes(data: result)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  public func replace(old: PyObject,
                      new: PyObject,
                      count: PyObject?) -> PyResult<PyByteArray> {
    let result = self.data.replace(old: old, new: new, count: count)
    return self.asBytes(data: result)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  public func zfill(width: PyObject) -> PyResult<PyByteArray> {
    let result = self.data.zfill(width: width)
    return self.asBytes(data: result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.add(other)
    return self.asBytes(data: result).map { $0 as PyObject }
  }

  // sourcery: pymethod = __iadd__
  public func iadd(_ other: PyObject) -> PyResult<PyObject> {
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
  public func mul(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.mul(other)
    return self.asBytes(data: result).map { $0 as PyObject }
  }

  // sourcery: pymethod = __rmul__
  public func rmul(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.rmul(other)
    return self.asBytes(data: result).map { $0 as PyObject }
  }

  // sourcery: pymethod = __imul__
  public func imul(_ other: PyObject) -> PyResult<PyObject> {
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
  public func iter() -> PyObject {
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
  public func append(_ element: PyObject) -> PyResult<PyNone> {
    return self.data.append(object: element)
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  public func extend(iterable: PyObject) -> PyResult<PyNone> {
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
  public func insert(index: PyObject, item: PyObject) -> PyResult<PyNone> {
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
  public func remove(_ value: PyObject) -> PyResult<PyNone> {
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
  public func pop(index: PyObject?) -> PyResult<PyObject> {
    return self.data.pop(index: index).map(Py.newInt)
  }

  // MARK: - Clear

  internal static let clearDoc = """
    clear($self, /)
    --

    Remove all items from the bytearray.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  public func clear() -> PyNone {
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
  public func reverse() -> PyResult<PyNone> {
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
  public func copy() -> PyObject {
    return Py.newByteArray(self.data.values)
  }

  // MARK: - Check exact

  public func checkExact() -> Bool {
    return self.type === Py.types.bytearray
  }

  // MARK: - As bytes

  private func asBytes(data: Data) -> PyByteArray {
    return Py.newByteArray(data)
  }

  private func asBytes(data: PyResult<Data>) -> PyResult<PyByteArray> {
    return data.map(self.asBytes(data:))
  }

  private func asBytes(data: PyResult<[Data]>) -> PyResult<[PyByteArray]> {
    switch data {
    case let .value(ds):
      return .value(ds.map(self.asBytes(data:)))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyByteArray> {
    let isBuiltin = type === Py.types.bytes
    let alloca = isBuiltin ?
      self.newByteArray(type:value:) :
      PyByteArrayHeap.init(type:value:)

    let data = Data()
    return .value(alloca(type, data))
  }

  private static func newByteArray(type: PyType, value: Data) -> PyByteArray {
    return Py.newByteArray(value)
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

      switch PyBytesData.handleNewArgs(object: object,
                                       encoding: encoding,
                                       errors: errors) {
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
