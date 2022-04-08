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

  // sourcery: storedProperty
  internal var elements: Data { self.elementsPtr.pointee }

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
    let zelf = PyBytes(ptr: ptr)
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
    return py.newBytes(elements)
  }

  internal static func newObject(_ py: Py, result: Data) -> Self {
    return py.newBytes(result)
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

    let result = py.hasher.hash(zelf.elements)
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__repr__(py, zelf: zelf, prefix: "b", suffix: "")
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

  // MARK: - Get item

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

    let result = GetItemImpl.getItem(py, source: zelf.elements, index: index)
    switch result {
    case let .single(byte):
      let int = py.newInt(byte)
      return PyResult(int)
    case let .slice(data):
      let bytes = py.newBytes(data)
      return PyResult(bytes)
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
    case let .separatorFound(before: b, separator: _, after: a):
      // We can reuse 'separator' because bytes are immutable
      let before = Self.newObject(py, elements: b)
      let after = Self.newObject(py, elements: a)
      return PyResult(py, tuple: before.asObject, separator, after.asObject)

    case .separatorNotFound:
      let empty = py.emptyBytes.asObject
      return PyResult(py, tuple: zelf.asObject, empty, empty)

    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  internal static func rpartition(_ py: Py, zelf: PyObject, separator: PyObject) -> PyResult {
    switch Self.abstractRPartition(py, zelf: zelf, separator: separator) {
    case let .separatorFound(before: b, separator: _, after: a):
      // We can reuse 'separator' because bytes are immutable
      let before = Self.newObject(py, elements: b)
      let after = Self.newObject(py, elements: a)
      return PyResult(py, tuple: before.asObject, separator, after.asObject)

    case .separatorNotFound:
      let empty = py.emptyBytes.asObject
      return PyResult(py, tuple: empty, empty, zelf.asObject)

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

    let result = py.newBytesIterator(bytes: zelf)
    return PyResult(result)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["source", "encoding", "errors"],
    format: "|Oss:bytes"
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
      return PyBytes.__new__(py,
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
                              encoding: PyObject?,
                              errors: PyObject?) -> PyResult {
    let elements: Data
    switch Self.abstract__new__(py, object: object, encoding: encoding, errors: errors) {
    case let .value(e): elements = e
    case let .error(e): return .error(e)
    }

    let isBuiltin = type === py.types.bytes
    let result = isBuiltin ?
      py.newBytes(elements) : // There is a potential to re-use interned value!
      py.memory.newBytes(type: type, elements: elements)

    return PyResult(result)
  }
}
