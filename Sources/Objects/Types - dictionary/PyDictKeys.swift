import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_keys, isDefault, hasGC
public struct PyDictKeys: PyObjectMixin, AbstractDictView {

  internal typealias OrderedDictionary = PyDict.OrderedDictionary
  internal typealias Element = OrderedDictionary.Element

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let dictOffset = SizeOf.objectHeader
    internal static let dictSize = SizeOf.object
    internal static let size = dictOffset + dictSize
  }

  private var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Layout.dictOffset) }
  internal var dict: PyDict { self.dictPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, dict: PyDict) {
    self.header.initialize(type: type)
    self.dictPtr.initialize(to: dict)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictKeys(ptr: ptr)
    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyDictKeys(ptr: ptr)
    return "PyDictKeys(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqual(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self._isLess(other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self._isLessEqual(other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self._isGreater(other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self._isGreaterEqual(other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return self._hash()
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return self._repr(typeName: "dict_keys", elementRepr: Self.repr(element:))
  }

  private static func repr(element: Element) -> PyResult<String> {
    // >>> d = {'a': 1, 'b': 2, 'c': 3}
    //
    // >>> k = d.keys()
    // >>> repr(k)
    // "dict_keys(['a', 'b', 'c'])"

    let key = element.key.object
    return Py.reprString(object: key)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return self._getLength()
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    return self.dict.contains(object: object)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newDictKeyIterator(dict: self.dict)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyDictKeys> {
    return .typeError("cannot create 'dict_keys' instances")
  }
}

*/
