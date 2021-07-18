import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytearray, default, baseType
// sourcery: subclassInstancesHave__dict__
public class PyByteArray: PyObject, AbstractBytes {

  // sourcery: pytypedoc
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

  internal var elements: Data

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  override public var description: String {
    return "PyByteArray(count: \(self.count))"
  }

  // MARK: - Init

  internal convenience init(elements: Data) {
    let type = Py.types.bytearray
    self.init(type: type, elements: elements)
  }

  internal init(type: PyType, elements: Data) {
    self.elements = elements
    super.init(type: type)
  }

  // MARK: - AbstractBytes

  internal typealias Element = UInt8
  internal typealias Elements = Data
  internal typealias Builder = BytesBuilder
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
    return self._length
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(element: PyObject) -> PyResult<Bool> {
    return self._contains(element: element)
  }

  // MARK: - Get/set/del item

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
      let bytes = Py.newByteArray(data)
      return .value(bytes)
    case let .error(e):
      return .error(e)
    }
  }

  private enum SetItemImpl: SetItemHelper {
    // swiftlint:disable nesting
    fileprivate typealias Target = Data
    fileprivate typealias SliceSource = Data
    // swiftlint:enable nesting

    fileprivate static func getElementToSetAtIntIndex(
      object: PyObject
    ) -> PyResult<UInt8> {
      return PyByteArray._asByte(object: object)
    }

    fileprivate static func getElementsToSetAtSliceIndices(
      object: PyObject
    ) -> PyResult<Data> {
      let result = PyByteArray._getElementsFromIterable(iterable: object)
      switch result {
      case .bytes(let data):
        return .value(data)
      case .notIterable:
        return .typeError("can only assign an iterable")
      case .error(let e):
        return .error(e)
      }
    }
  }

  // sourcery: pymethod = __setitem__
  internal func setItem(index: PyObject, value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(target: &self.elements, index: index, value: value)
  }

  private enum DelItemImpl: DelItemHelper {
    // swiftlint:disable:next nesting
    fileprivate typealias Target = Data
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(index: PyObject) -> PyResult<PyNone> {
    return DelItemImpl.delItem(target: &self.elements, index: index)
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
    return self._lowerCase()
  }

  // sourcery: pymethod = upper
  internal func upper() -> PyByteArray {
    return self._upperCase()
  }

  // sourcery: pymethod = title
  internal func title() -> PyByteArray {
    return self._titleCase()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> PyByteArray {
    return self._swapCase()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> PyByteArray {
    return self._capitalize()
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
    guard let otherElements = Self._getElements(object: other) else {
      let e = self._createAddTypeError(other: other)
      return .error(e)
    }

    self.elements.append(otherElements)
    return .value(self)
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
    switch self._parseMulCount(object: other) {
    case let .value(count):
      return self.imul(count: count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func imul(count: Int) -> PyResult<PyObject> {
    // swiftlint:disable:next empty_count
    if count <= 0 {
      self.elements = Data()
      return .value(self)
    }

    // Anything multiplied by 1 -> no changes
    if count == 1 {
      return .value(self)
    }

    let minCapacity = self.count * count
    self.elements.reserveCapacity(minCapacity)

    // 'abc' * 2 = 'abcabc'
    // This means that we have to append 'count - 1' times
    let weAlreadyHave = 1
    let appendCount = count - weAlreadyHave

    let elementsToAppend = self.elements
    for _ in 0..<appendCount {
      self.elements.append(elementsToAppend)
    }

    return .value(self)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newByteArrayIterator(bytes: self)
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
  internal func append(object: PyObject) -> PyResult<PyNone> {
    switch Self._asByte(object: object) {
    case let .value(byte):
      self.elements.append(byte)
      return .value(Py.none)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal func extend(iterable: PyObject) -> PyResult<PyNone> {
    // Do not modify `self.values` until we finished iteration!
    switch Self._getElementsFromIterable(iterable: iterable) {
    case .bytes(let data):
      self.elements.append(data)
      return .value(Py.none)
    case .notIterable:
      return .typeError("can't extend bytearray with \(iterable.typeName)")
    case .error(let e):
      return .error(e)
    }
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
  internal func insert(index: PyObject, object: PyObject) -> PyResult<PyNone> {
    let indexInt: Int
    let overflowMsg = "cannot add more objects to \(Self._pythonTypeName)"

    switch IndexHelper.int(index, onOverflow: .overflowError(msg: overflowMsg)) {
    case let .value(i):
      indexInt = i
    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }

    let byte: UInt8
    switch Self._asByte(object: object) {
    case let .value(b): byte = b
    case let .error(e): return .error(e)
    }

    self.insert(index: indexInt, byte: byte)
    return .value(Py.none)
  }

  private func insert(index: Int, byte: UInt8) {
    var index = index

    if index < 0 {
      index += self.count
      if index < 0 {
        index = 0
      }
    }

    if index > self.count {
      index = self.count
    }

    self.elements.insert(byte, at: index)
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
  internal func remove(object: PyObject) -> PyResult<PyNone> {
    switch Self._asByte(object: object) {
    case let .value(byte):
      guard let index = self.elements.firstIndex(of: byte) else {
        return .valueError("value not found in bytearray")
      }

      self.elements.remove(at: index)
      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
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
    switch self.parsePopIndex(index: index) {
    case let .value(int):
      let byte = self.pop(index: int)
      return byte.map(Py.newInt)
    case let .error(e):
      return .error(e)
    }
  }

  private func pop(index: Int) -> PyResult<UInt8> {
    if self.isEmpty {
      return .indexError("pop from empty bytearray")
    }

    var index = index
    if index < 0 {
      index += self.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= index && index < self.count else {
      return .indexError("pop index out of range")
    }

    let result = self.elements.remove(at: index)
    return .value(result)
  }

  private func parsePopIndex(index: PyObject?) -> PyResult<Int> {
    guard let index = index else {
      return .value(-1)
    }

    let msg = "pop index out of range"
    switch IndexHelper.int(index, onOverflow: .indexError(msg: msg)) {
    case let .value(int):
      return .value(int)
    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal static let clearDoc = """
    clear($self, /)
    --

    Remove all items from the bytearray.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyNone {
    self.elements = Data()
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
    self.elements.reverse()
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
    return Py.newByteArray(self.elements)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyByteArray> {
    let elements = Data()

    let isBuiltin = type === Py.types.bytes
    let result = isBuiltin ?
      Py.newByteArray(elements) :
      PyMemory.newByteArray(type: type, elements: elements)

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
        self.elements = data
        return .value(Py.none)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }
}
