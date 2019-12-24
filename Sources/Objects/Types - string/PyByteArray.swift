import Core
import Foundation

// swiftlint:disable file_length

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

  // MARK: - Init

  internal init(_ context: PyContext, value: Data) {
    self.data = PyBytesData(value)
    super.init(type: context.builtins.types.bytes)
  }

  /// Use only in  `__new__`!
  internal init(type: PyType, value: Data) {
    self.data = PyBytesData(value)
    super.init(type: type)
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

  private func compare(_ other: PyObject) -> PyResultOrNot<StringCompareResult> {
    guard let other = other as? PyBytes else {
      return .notImplemented
    }

    return .value(self.data.compare(to: other.data))
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .typeError("unhashable type: 'bytearray'")
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let result = "bytearray(b" + self.data.createRepr() + ")"
    return .value(result)
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return self.repr()
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
    return self.data.contains(element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(at: index) {
    case let .item(int):
      let result = self.builtins.newInt(int)
      return .value(result)
    case let .slice(bytes):
      let result = self.builtins.newBytes(bytes)
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

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal func isDigit() -> Bool {
    return self.data.isDigit
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
  internal func strip(_ chars: PyObject?) -> PyResult<Data> {
    return self.data.strip(chars)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(_ chars: PyObject) -> PyResult<Data> {
    return self.data.lstrip(chars)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject) -> PyResult<Data> {
    return self.data.rstrip(chars)
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
  internal func lower() -> Data {
    return self.data.lowerCased()
  }

  // sourcery: pymethod = upper
  internal func upper() -> Data {
    return self.data.upperCased()
  }

  // sourcery: pymethod = title
  internal func title() -> Data {
    return self.data.titleCased()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> Data {
    return self.data.swapCase()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> Data {
    return self.data.capitalize()
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<Data> {
    return self.data.center(width: width, fill: fillChar)
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<Data> {
    return self.data.ljust(width: width, fill: fillChar)
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<Data> {
    return self.data.rjust(width: width, fill: fillChar)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(separator: PyObject?,
                      maxCount: PyObject?) -> PyResult<[Data]> {
    return self.data.split(separator: separator, maxCount: maxCount)
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(separator: PyObject?,
                       maxCount: PyObject?) -> PyResult<[Data]> {
    return self.data.rsplit(separator: separator, maxCount: maxCount)
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(keepEnds: PyObject) -> PyResult<[Data]> {
    return self.data.splitLines(keepEnds: keepEnds)
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

  private func toTuple(separator: PyObject,
                       result: StringPartitionResult<Data>) -> PyResult<PyTuple> {
    switch result {
    case .separatorNotFound:
      let empty = self.builtins.emptyString
      return .value(PyTuple(self.context, elements: [self, empty, empty]))
    case let .separatorFound(before, after):
      let b = self.builtins.newBytes(before)
      let a = self.builtins.newBytes(after)
      return .value(PyTuple(self.context, elements: [b, separator, a]))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<Data> {
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
  internal func join(iterable: PyObject) -> PyResult<Data> {
    return self.data.join(iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<Data> {
    return self.data.replace(old: old, new: new, count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<Data> {
    return self.data.zfill(width: width)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.data.add(other).map(self.builtins.newBytes(_:))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.data.mul(other).map(self.builtins.newBytes(_:))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.data.rmul(other).map(self.builtins.newBytes(_:))
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyByteArrayIterator(bytes: self)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.bytes
    let alloca = isBuiltin ? newByteArray(type:value:) : PyByteArrayHeap.init(type:value:)

    let data = Data()
    return .value(alloca(type, data))
  }

  private static func newByteArray(type: PyType, value: Data) -> PyByteArray {
    return type.builtins.newByteArray(value)
  }

  // MARK: - Python init

  private static let initArgumentsParser = ArgumentParser.createOrFatal(
    arguments: ["source", "encoding", "errors"],
    format: "|Oss:bytearray"
  )

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyByteArray,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    switch PyByteArray.initArgumentsParser.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 3, "Invalid argument count returned from parser.")
      let arg0 = bind.count >= 1 ? bind[0] : nil
      let arg1 = bind.count >= 2 ? bind[1] : nil
      let arg2 = bind.count >= 3 ? bind[2] : nil
      return PyByteArray.pyInit(zelf: zelf,
                                object: arg0,
                                encoding: arg1,
                                errors: arg2)

    case let .error(e):
      return .error(e)
    }
  }

  private static func pyInit(zelf: PyByteArray,
                             object: PyObject?,
                             encoding: PyObject?,
                             errors: PyObject?) -> PyResult<PyNone> {
    switch PyBytesData.handleNewArgs(object: object,
                                     encoding: encoding,
                                     errors: errors) {
    case let .value(data):
      zelf.data = PyBytesData(data)
      return .value(zelf.builtins.none)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: Methods that are not in PyBytes

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
    return self.data.append(element).map { _ in self.builtins.none }
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal func extend(iterable: PyObject) -> PyResult<PyNone> {
    return self.data.extend(iterable: iterable).map { _ in self.builtins.none }
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
  internal func insert(at index: PyObject, item: PyObject) -> PyResult<PyNone> {
    return self.data.insert(at: index, item: item).map { _ in self.builtins.none }
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
    return self.data.remove(value).map { _ in self.builtins.none }
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
    return self.data.pop(index: index).map(self.builtins.newInt)
  }

  // MARK: - Set/del item

  // sourcery: pymethod = __setitem__
  internal func setItem(at index: PyObject,
                        to value: PyObject) -> PyResult<PyNone> {
    return self.data.setItem(at: index, to: value)
      .map { _ in self.builtins.none }
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(at index: PyObject) -> PyResult<PyNone> {
    return self.data.delItem(at: index)
      .map { _ in self.builtins.none }
  }

  // MARK: - Clear

  internal static let clearDoc = """
    clear($self, /)
    --

    Remove all items from the bytearray.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyResult<PyNone> {
    self.data.clear()
    return .value(self.builtins.none)
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
    return .value(self.builtins.none)
  }

  // MARK: - Copy

  internal static let copyDoc = """
    copy($self, /)
    --

    Return a copy of B.
    """

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return self.builtins.newByteArray(self.data.values)
  }
}
