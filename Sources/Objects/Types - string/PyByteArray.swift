import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytearray, isDefault, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyByteArray: PyObjectMixin, AbstractBytes {

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

  // sourcery: storedProperty
  internal var elements: Data {
    // Do not add 'nonmutating set/_modify' - the compiler could get confused
    // sometimes. Use 'self.elementsPtr.pointee' for modification.
    self.elementsPtr.pointee
  }

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, elements: Data) {
    self.initializeBase(py, type: type)
    self.elementsPtr.initialize(to: elements)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyByteArray(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "elements", value: zelf.elements)
    return result
  }

  // MARK: - AbstractBytes

  internal typealias Element = UInt8
  internal typealias Elements = Data
  internal typealias Builder = BytesBuilder
  internal typealias ElementSwiftType = PyInt

  internal static func newObject(_ py: Py, element: UInt8) -> ElementSwiftType {
    return py.newInt(element)
  }

  internal static func newObject(_ py: Py, elements: Data) -> Self {
    return py.newByteArray(elements)
  }

  internal static func newObject(_ py: Py, result: Data) -> Self {
    return py.newByteArray(result)
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__eq__bytes(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ne__bytes(py, zelf: zelf, other: other)
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

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    return .unhashable(zelf.asObject)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__repr__(py, zelf: zelf, prefix: "bytearray(b", suffix: ")")
  }

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__str__(py, zelf: zelf)
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

  // MARK: - Get/set/del item

  private enum GetItemImpl: GetItemHelper {
    // swiftlint:disable nesting
    fileprivate typealias Source = Data
    fileprivate typealias SliceBuilder = BytesBuilder
    // swiftlint:enable nesting
  }

  // sourcery: pymethod = __getitem__
  internal static func __getitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getitem__")
    }

    switch GetItemImpl.getItem(py, source: zelf.elements, index: index) {
    case let .single(byte):
      return PyResult(py, byte)
    case let .slice(data):
      let bytes = py.newByteArray(data)
      return PyResult(bytes)
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
      _ py: Py,
      object: PyObject
    ) -> PyResultGen<UInt8> {
      return PyByteArray.asByte(py, object: object)
    }

    fileprivate static func getElementsToSetAtSliceIndices(
      _ py: Py,
      object: PyObject
    ) -> PyResultGen<Data> {
      switch PyByteArray.getElementsFromIterable(py, iterable: object) {
      case .bytes(let data):
        return .value(data)
      case .notIterable:
        return .typeError(py, message: "can only assign an iterable")
      case .error(let e):
        return .error(e)
      }
    }
  }

  // sourcery: pymethod = __setitem__
  internal static func __setitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject,
                                   value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setitem__")
    }

    return SetItemImpl.setItem(py,
                               target: &zelf.elementsPtr.pointee,
                               index: index,
                               value: value)
  }

  private enum DelItemImpl: DelItemHelper {
    // swiftlint:disable:next nesting
    fileprivate typealias Target = Data
  }

  // sourcery: pymethod = __delitem__
  internal static func __delitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delitem__")
    }

    return DelItemImpl.delItem(py,
                               target: &zelf.elementsPtr.pointee,
                               index: index)
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

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal static func isdigit(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstractIsDigit(py, zelf: zelf)
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
    case let .separatorFound(before: b, separator: separator, after: a):
      let before = py.newByteArray(b)
      let separator = py.newByteArray(separator) // Always new!
      let after = py.newByteArray(a)
      return PyResult(py, tuple: before.asObject, separator.asObject, after.asObject)

    case .separatorNotFound:
      // 'bytearray' is mutable, so we have to create 2 separate objects
      let empty1 = py.newByteArray(Data())
      let empty2 = py.newByteArray(Data())
      return PyResult(py, tuple: zelf.asObject, empty1.asObject, empty2.asObject)

    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  internal static func rpartition(_ py: Py, zelf: PyObject, separator: PyObject) -> PyResult {
    switch Self.abstractRPartition(py, zelf: zelf, separator: separator) {
    case let .separatorFound(before: b, separator: separator, after: a):
      let before = py.newByteArray(b)
      let separator = py.newByteArray(separator) // Always new!
      let after = py.newByteArray(a)
      return PyResult(py, tuple: before.asObject, separator.asObject, after.asObject)

    case .separatorNotFound:
      // 'bytearray' is mutable, so we have to create 2 separate objects
      let empty1 = py.newByteArray(Data())
      let empty2 = py.newByteArray(Data())
      return PyResult(py, tuple: empty1.asObject, empty2.asObject, zelf.asObject)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal static func expandtabs(_ py: Py, zelf: PyObject, tabSize: PyObject?) -> PyResult {
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

  // sourcery: pymethod = __iadd__
  internal static func __iadd__(_ py: Py,
                                zelf _zelf: PyObject,
                                other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iadd__")
    }

    guard let otherElements = Self.getElements(py, object: other) else {
      let e = Self.abstractCreateAddTypeError(py, other: other)
      return .error(e.asBaseException)
    }

    zelf.elementsPtr.pointee.append(otherElements)
    return PyResult(zelf)
  }

  // sourcery: pymethod = __mul__
  internal static func __mul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__mul__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __rmul__
  internal static func __rmul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__rmul__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __imul__
  internal static func __imul__(_ py: Py,
                                zelf _zelf: PyObject,
                                other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__imul__")
    }

    let count: Int
    switch Self.abstractParseMulCount(py, object: other) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    // swiftlint:disable:next empty_count
    if count <= 0 {
      zelf.elementsPtr.pointee = Data()
      return PyResult(zelf)
    }

    // Anything multiplied by 1 -> no changes
    if count == 1 {
      return PyResult(zelf)
    }

    let capacity = zelf.count * count
    zelf.elementsPtr.pointee.reserveCapacity(capacity)

    // 'abc' * 2 = 'abcabc'
    // This means that we have to append 'count - 1' times
    let weAlreadyHave = 1
    let appendCount = count - weAlreadyHave

    let elementCount = zelf.count
    for _ in 0..<appendCount {
      for index in 0..<elementCount {
        let element = zelf.elements[index]
        zelf.elementsPtr.pointee.append(element)
      }
    }

    return PyResult(zelf)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newByteArrayIterator(bytes: zelf)
    return PyResult(result)
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
  internal static func append(_ py: Py,
                              zelf _zelf: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "append")
    }

    switch Self.asByte(py, object: object) {
    case let .value(byte):
      zelf.elementsPtr.pointee.append(byte)
      return .none(py)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal static func extend(_ py: Py,
                              zelf _zelf: PyObject,
                              iterable: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "extend")
    }

    // Do not modify `zelf.elements` until we finished iteration!
    switch Self.getElementsFromIterable(py, iterable: iterable) {
    case .bytes(let data):
      zelf.elementsPtr.pointee.append(data)
      return .none(py)
    case .notIterable:
      let message = "can't extend bytearray with \(iterable.typeName)"
      return .typeError(py, message: message)
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
  internal static func insert(_ py: Py,
                              zelf _zelf: PyObject,
                              index: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "insert")
    }

    let indexInt: Int
    let overflowMsg = "cannot add more objects to \(Self.pythonTypeName)"

    switch IndexHelper.int(py, object: index, onOverflow: .overflowError(message: overflowMsg)) {
    case let .value(i):
      indexInt = i
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
      return .error(e)
    }

    let byte: UInt8
    switch Self.asByte(py, object: object) {
    case let .value(b): byte = b
    case let .error(e): return .error(e)
    }

    zelf.insert(index: indexInt, byte: byte)
    return .none(py)
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

    self.elementsPtr.pointee.insert(byte, at: index)
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
  internal static func remove(_ py: Py,
                              zelf _zelf: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "remove")
    }

    switch Self.asByte(py, object: object) {
    case let .value(byte):
      guard let index = zelf.elements.firstIndex(of: byte) else {
        return .valueError(py, message: "value not found in bytearray")
      }

      zelf.elementsPtr.pointee.remove(at: index)
      return .none(py)

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
  internal static func pop(_ py: Py,
                           zelf _zelf: PyObject,
                           index indexObject: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "pop")
    }

    var index: Int
    switch Self.parsePopIndex(py, index: indexObject) {
    case let .value(i): index = i
    case let .error(e): return .error(e)
    }

    if zelf.isEmpty {
      return .indexError(py, message: "pop from empty bytearray")
    }

    if index < 0 {
      index += zelf.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= index && index < zelf.count else {
      return .indexError(py, message: "pop index out of range")
    }

    let result = zelf.elementsPtr.pointee.remove(at: index)
    return PyResult(py, result)
  }

  private static func parsePopIndex(_ py: Py, index: PyObject?) -> PyResultGen<Int> {
    guard let index = index else {
      return .value(-1)
    }

    let message = "pop index out of range"
    switch IndexHelper.int(py, object: index, onOverflow: .indexError(message: message)) {
    case let .value(int):
      return .value(int)
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
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
  internal static func clear(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "clear")
    }

    zelf.elementsPtr.pointee = Data()
    return .none(py)
  }

  // MARK: - Reverse

  internal static let reverseDoc = """
    reverse($self, /)
    --

    Reverse the order of the values in B in place.
    """

  // sourcery: pymethod = reverse, doc = reverseDoc
  internal static func reverse(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "reverse")
    }

    zelf.elementsPtr.pointee.reverse()
    return .none(py)
  }

  // MARK: - Copy

  internal static let copyDoc = """
    copy($self, /)
    --

    Return a copy of B.
    """

  // sourcery: pymethod = copy, doc = copyDoc
  internal static func copy(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "copy")
    }

    let result = py.newByteArray(zelf.elements)
    return PyResult(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let elements = Data()

    let isBuiltin = type === py.types.bytes
    let result = isBuiltin ?
      py.newByteArray(elements) :
      py.memory.newByteArray(type: type, elements: elements)

    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["source", "encoding", "errors"],
    format: "|Oss:bytearray"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    switch Self.initArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let encoding = binding.optional(at: 1)
      let errors = binding.optional(at: 2)

      switch Self.abstract__new__(py, object: object, encoding: encoding, errors: errors) {
      case let .value(data):
        zelf.elementsPtr.pointee = data
        return .none(py)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }
}
