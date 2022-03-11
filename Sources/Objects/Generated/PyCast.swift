// ===================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyCast.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ===================================================================

import VioletCore

// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Helper type used to safely downcast Python objects to specific Swift type.
///
/// For example:
/// On the `VM` stack we hold `PyObject`, at some point we may want to convert
/// it to `PyInt`:
///
/// ```Swift
/// if let int = py.cast.asInt(object) {
///   things…
/// }
/// ```
public struct PyCast {

  private let types: Py.Types
  private let errorTypes: Py.ErrorTypes

  internal init(types: Py.Types, errorTypes: Py.ErrorTypes) {
    self.types = types
    self.errorTypes = errorTypes
  }

  private func isInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type.isSubtype(of: type)
  }

  private func isExactlyInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type === type
  }

  // MARK: - Bool

  // 'bool' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `bool`?
  public func isBool(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.bool)
  }

  /// Cast this object to `PyBool` if it is a `bool`.
  public func asBool(_ object: PyObject) -> PyBool? {
    return self.isBool(object) ? PyBool(ptr: object.ptr) : nil
  }

  // MARK: - BuiltinFunction

  // 'builtinFunction' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `builtinFunction`?
  public func isBuiltinFunction(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.builtinFunction)
  }

  /// Cast this object to `PyBuiltinFunction` if it is a `builtinFunction`.
  public func asBuiltinFunction(_ object: PyObject) -> PyBuiltinFunction? {
    return self.isBuiltinFunction(object) ? PyBuiltinFunction(ptr: object.ptr) : nil
  }

  // MARK: - BuiltinMethod

  // 'builtinMethod' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `builtinMethod`?
  public func isBuiltinMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.builtinMethod)
  }

  /// Cast this object to `PyBuiltinMethod` if it is a `builtinMethod`.
  public func asBuiltinMethod(_ object: PyObject) -> PyBuiltinMethod? {
    return self.isBuiltinMethod(object) ? PyBuiltinMethod(ptr: object.ptr) : nil
  }

  // MARK: - ByteArray

  /// Is this object an instance of `bytearray` (or its subclass)?
  public func isByteArray(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.bytearray)
  }

  /// Is this object an instance of `bytearray` (but not its subclass)?
  public func isExactlyByteArray(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.bytearray)
  }

  /// Cast this object to `PyByteArray` if it is a `bytearray` (or its subclass).
  public func asByteArray(_ object: PyObject) -> PyByteArray? {
    return self.isByteArray(object) ? PyByteArray(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyByteArray` if it is a `bytearray` (but not its subclass).
  public func asExactlyByteArray(_ object: PyObject) -> PyByteArray? {
    return self.isExactlyByteArray(object) ? PyByteArray(ptr: object.ptr) : nil
  }

  // MARK: - ByteArrayIterator

  // 'bytearray_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `bytearray_iterator`?
  public func isByteArrayIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.bytearray_iterator)
  }

  /// Cast this object to `PyByteArrayIterator` if it is a `bytearray_iterator`.
  public func asByteArrayIterator(_ object: PyObject) -> PyByteArrayIterator? {
    return self.isByteArrayIterator(object) ? PyByteArrayIterator(ptr: object.ptr) : nil
  }

  // MARK: - Bytes

  /// Is this object an instance of `bytes` (or its subclass)?
  public func isBytes(_ object: PyObject) -> Bool {
    // 'bytes' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isBytesSubclass
  }

  /// Is this object an instance of `bytes` (but not its subclass)?
  public func isExactlyBytes(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.bytes)
  }

  /// Cast this object to `PyBytes` if it is a `bytes` (or its subclass).
  public func asBytes(_ object: PyObject) -> PyBytes? {
    return self.isBytes(object) ? PyBytes(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyBytes` if it is a `bytes` (but not its subclass).
  public func asExactlyBytes(_ object: PyObject) -> PyBytes? {
    return self.isExactlyBytes(object) ? PyBytes(ptr: object.ptr) : nil
  }

  // MARK: - BytesIterator

  // 'bytes_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `bytes_iterator`?
  public func isBytesIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.bytes_iterator)
  }

  /// Cast this object to `PyBytesIterator` if it is a `bytes_iterator`.
  public func asBytesIterator(_ object: PyObject) -> PyBytesIterator? {
    return self.isBytesIterator(object) ? PyBytesIterator(ptr: object.ptr) : nil
  }

  // MARK: - CallableIterator

  // 'callable_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `callable_iterator`?
  public func isCallableIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.callable_iterator)
  }

  /// Cast this object to `PyCallableIterator` if it is a `callable_iterator`.
  public func asCallableIterator(_ object: PyObject) -> PyCallableIterator? {
    return self.isCallableIterator(object) ? PyCallableIterator(ptr: object.ptr) : nil
  }

  // MARK: - Cell

  // 'cell' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `cell`?
  public func isCell(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.cell)
  }

  /// Cast this object to `PyCell` if it is a `cell`.
  public func asCell(_ object: PyObject) -> PyCell? {
    return self.isCell(object) ? PyCell(ptr: object.ptr) : nil
  }

  // MARK: - ClassMethod

  /// Is this object an instance of `classmethod` (or its subclass)?
  public func isClassMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.classmethod)
  }

  /// Is this object an instance of `classmethod` (but not its subclass)?
  public func isExactlyClassMethod(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.classmethod)
  }

  /// Cast this object to `PyClassMethod` if it is a `classmethod` (or its subclass).
  public func asClassMethod(_ object: PyObject) -> PyClassMethod? {
    return self.isClassMethod(object) ? PyClassMethod(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyClassMethod` if it is a `classmethod` (but not its subclass).
  public func asExactlyClassMethod(_ object: PyObject) -> PyClassMethod? {
    return self.isExactlyClassMethod(object) ? PyClassMethod(ptr: object.ptr) : nil
  }

  // MARK: - Code

  // 'code' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `code`?
  public func isCode(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.code)
  }

  /// Cast this object to `PyCode` if it is a `code`.
  public func asCode(_ object: PyObject) -> PyCode? {
    return self.isCode(object) ? PyCode(ptr: object.ptr) : nil
  }

  // MARK: - Complex

  /// Is this object an instance of `complex` (or its subclass)?
  public func isComplex(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.complex)
  }

  /// Is this object an instance of `complex` (but not its subclass)?
  public func isExactlyComplex(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.complex)
  }

  /// Cast this object to `PyComplex` if it is a `complex` (or its subclass).
  public func asComplex(_ object: PyObject) -> PyComplex? {
    return self.isComplex(object) ? PyComplex(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyComplex` if it is a `complex` (but not its subclass).
  public func asExactlyComplex(_ object: PyObject) -> PyComplex? {
    return self.isExactlyComplex(object) ? PyComplex(ptr: object.ptr) : nil
  }

  // MARK: - Dict

  /// Is this object an instance of `dict` (or its subclass)?
  public func isDict(_ object: PyObject) -> Bool {
    // 'dict' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isDictSubclass
  }

  /// Is this object an instance of `dict` (but not its subclass)?
  public func isExactlyDict(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.dict)
  }

  /// Cast this object to `PyDict` if it is a `dict` (or its subclass).
  public func asDict(_ object: PyObject) -> PyDict? {
    return self.isDict(object) ? PyDict(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyDict` if it is a `dict` (but not its subclass).
  public func asExactlyDict(_ object: PyObject) -> PyDict? {
    return self.isExactlyDict(object) ? PyDict(ptr: object.ptr) : nil
  }

  // MARK: - DictItemIterator

  // 'dict_itemiterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `dict_itemiterator`?
  public func isDictItemIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.dict_itemiterator)
  }

  /// Cast this object to `PyDictItemIterator` if it is a `dict_itemiterator`.
  public func asDictItemIterator(_ object: PyObject) -> PyDictItemIterator? {
    return self.isDictItemIterator(object) ? PyDictItemIterator(ptr: object.ptr) : nil
  }

  // MARK: - DictItems

  // 'dict_items' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `dict_items`?
  public func isDictItems(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.dict_items)
  }

  /// Cast this object to `PyDictItems` if it is a `dict_items`.
  public func asDictItems(_ object: PyObject) -> PyDictItems? {
    return self.isDictItems(object) ? PyDictItems(ptr: object.ptr) : nil
  }

  // MARK: - DictKeyIterator

  // 'dict_keyiterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `dict_keyiterator`?
  public func isDictKeyIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.dict_keyiterator)
  }

  /// Cast this object to `PyDictKeyIterator` if it is a `dict_keyiterator`.
  public func asDictKeyIterator(_ object: PyObject) -> PyDictKeyIterator? {
    return self.isDictKeyIterator(object) ? PyDictKeyIterator(ptr: object.ptr) : nil
  }

  // MARK: - DictKeys

  // 'dict_keys' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `dict_keys`?
  public func isDictKeys(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.dict_keys)
  }

  /// Cast this object to `PyDictKeys` if it is a `dict_keys`.
  public func asDictKeys(_ object: PyObject) -> PyDictKeys? {
    return self.isDictKeys(object) ? PyDictKeys(ptr: object.ptr) : nil
  }

  // MARK: - DictValueIterator

  // 'dict_valueiterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `dict_valueiterator`?
  public func isDictValueIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.dict_valueiterator)
  }

  /// Cast this object to `PyDictValueIterator` if it is a `dict_valueiterator`.
  public func asDictValueIterator(_ object: PyObject) -> PyDictValueIterator? {
    return self.isDictValueIterator(object) ? PyDictValueIterator(ptr: object.ptr) : nil
  }

  // MARK: - DictValues

  // 'dict_values' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `dict_values`?
  public func isDictValues(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.dict_values)
  }

  /// Cast this object to `PyDictValues` if it is a `dict_values`.
  public func asDictValues(_ object: PyObject) -> PyDictValues? {
    return self.isDictValues(object) ? PyDictValues(ptr: object.ptr) : nil
  }

  // MARK: - Ellipsis

  // 'ellipsis' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `ellipsis`?
  public func isEllipsis(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.ellipsis)
  }

  /// Cast this object to `PyEllipsis` if it is an `ellipsis`.
  public func asEllipsis(_ object: PyObject) -> PyEllipsis? {
    return self.isEllipsis(object) ? PyEllipsis(ptr: object.ptr) : nil
  }

  // MARK: - Enumerate

  /// Is this object an instance of `enumerate` (or its subclass)?
  public func isEnumerate(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.enumerate)
  }

  /// Is this object an instance of `enumerate` (but not its subclass)?
  public func isExactlyEnumerate(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.enumerate)
  }

  /// Cast this object to `PyEnumerate` if it is an `enumerate` (or its subclass).
  public func asEnumerate(_ object: PyObject) -> PyEnumerate? {
    return self.isEnumerate(object) ? PyEnumerate(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyEnumerate` if it is an `enumerate` (but not its subclass).
  public func asExactlyEnumerate(_ object: PyObject) -> PyEnumerate? {
    return self.isExactlyEnumerate(object) ? PyEnumerate(ptr: object.ptr) : nil
  }

  // MARK: - Filter

  /// Is this object an instance of `filter` (or its subclass)?
  public func isFilter(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.filter)
  }

  /// Is this object an instance of `filter` (but not its subclass)?
  public func isExactlyFilter(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.filter)
  }

  /// Cast this object to `PyFilter` if it is a `filter` (or its subclass).
  public func asFilter(_ object: PyObject) -> PyFilter? {
    return self.isFilter(object) ? PyFilter(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFilter` if it is a `filter` (but not its subclass).
  public func asExactlyFilter(_ object: PyObject) -> PyFilter? {
    return self.isExactlyFilter(object) ? PyFilter(ptr: object.ptr) : nil
  }

  // MARK: - Float

  /// Is this object an instance of `float` (or its subclass)?
  public func isFloat(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.float)
  }

  /// Is this object an instance of `float` (but not its subclass)?
  public func isExactlyFloat(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.float)
  }

  /// Cast this object to `PyFloat` if it is a `float` (or its subclass).
  public func asFloat(_ object: PyObject) -> PyFloat? {
    return self.isFloat(object) ? PyFloat(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFloat` if it is a `float` (but not its subclass).
  public func asExactlyFloat(_ object: PyObject) -> PyFloat? {
    return self.isExactlyFloat(object) ? PyFloat(ptr: object.ptr) : nil
  }

  // MARK: - Frame

  // 'frame' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `frame`?
  public func isFrame(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.frame)
  }

  /// Cast this object to `PyFrame` if it is a `frame`.
  public func asFrame(_ object: PyObject) -> PyFrame? {
    return self.isFrame(object) ? PyFrame(ptr: object.ptr) : nil
  }

  // MARK: - FrozenSet

  /// Is this object an instance of `frozenset` (or its subclass)?
  public func isFrozenSet(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.frozenset)
  }

  /// Is this object an instance of `frozenset` (but not its subclass)?
  public func isExactlyFrozenSet(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.frozenset)
  }

  /// Cast this object to `PyFrozenSet` if it is a `frozenset` (or its subclass).
  public func asFrozenSet(_ object: PyObject) -> PyFrozenSet? {
    return self.isFrozenSet(object) ? PyFrozenSet(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFrozenSet` if it is a `frozenset` (but not its subclass).
  public func asExactlyFrozenSet(_ object: PyObject) -> PyFrozenSet? {
    return self.isExactlyFrozenSet(object) ? PyFrozenSet(ptr: object.ptr) : nil
  }

  // MARK: - Function

  // 'function' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `function`?
  public func isFunction(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.function)
  }

  /// Cast this object to `PyFunction` if it is a `function`.
  public func asFunction(_ object: PyObject) -> PyFunction? {
    return self.isFunction(object) ? PyFunction(ptr: object.ptr) : nil
  }

  // MARK: - Int

  /// Is this object an instance of `int` (or its subclass)?
  public func isInt(_ object: PyObject) -> Bool {
    // 'int' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isLongSubclass
  }

  /// Is this object an instance of `int` (but not its subclass)?
  public func isExactlyInt(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.int)
  }

  /// Cast this object to `PyInt` if it is an `int` (or its subclass).
  public func asInt(_ object: PyObject) -> PyInt? {
    return self.isInt(object) ? PyInt(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyInt` if it is an `int` (but not its subclass).
  public func asExactlyInt(_ object: PyObject) -> PyInt? {
    return self.isExactlyInt(object) ? PyInt(ptr: object.ptr) : nil
  }

  // MARK: - Iterator

  // 'iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `iterator`?
  public func isIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.iterator)
  }

  /// Cast this object to `PyIterator` if it is an `iterator`.
  public func asIterator(_ object: PyObject) -> PyIterator? {
    return self.isIterator(object) ? PyIterator(ptr: object.ptr) : nil
  }

  // MARK: - List

  /// Is this object an instance of `list` (or its subclass)?
  public func isList(_ object: PyObject) -> Bool {
    // 'list' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isListSubclass
  }

  /// Is this object an instance of `list` (but not its subclass)?
  public func isExactlyList(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.list)
  }

  /// Cast this object to `PyList` if it is a `list` (or its subclass).
  public func asList(_ object: PyObject) -> PyList? {
    return self.isList(object) ? PyList(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyList` if it is a `list` (but not its subclass).
  public func asExactlyList(_ object: PyObject) -> PyList? {
    return self.isExactlyList(object) ? PyList(ptr: object.ptr) : nil
  }

  // MARK: - ListIterator

  // 'list_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `list_iterator`?
  public func isListIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.list_iterator)
  }

  /// Cast this object to `PyListIterator` if it is a `list_iterator`.
  public func asListIterator(_ object: PyObject) -> PyListIterator? {
    return self.isListIterator(object) ? PyListIterator(ptr: object.ptr) : nil
  }

  // MARK: - ListReverseIterator

  // 'list_reverseiterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `list_reverseiterator`?
  public func isListReverseIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.list_reverseiterator)
  }

  /// Cast this object to `PyListReverseIterator` if it is a `list_reverseiterator`.
  public func asListReverseIterator(_ object: PyObject) -> PyListReverseIterator? {
    return self.isListReverseIterator(object) ? PyListReverseIterator(ptr: object.ptr) : nil
  }

  // MARK: - Map

  /// Is this object an instance of `map` (or its subclass)?
  public func isMap(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.map)
  }

  /// Is this object an instance of `map` (but not its subclass)?
  public func isExactlyMap(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.map)
  }

  /// Cast this object to `PyMap` if it is a `map` (or its subclass).
  public func asMap(_ object: PyObject) -> PyMap? {
    return self.isMap(object) ? PyMap(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyMap` if it is a `map` (but not its subclass).
  public func asExactlyMap(_ object: PyObject) -> PyMap? {
    return self.isExactlyMap(object) ? PyMap(ptr: object.ptr) : nil
  }

  // MARK: - Method

  // 'method' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `method`?
  public func isMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.method)
  }

  /// Cast this object to `PyMethod` if it is a `method`.
  public func asMethod(_ object: PyObject) -> PyMethod? {
    return self.isMethod(object) ? PyMethod(ptr: object.ptr) : nil
  }

  // MARK: - Module

  /// Is this object an instance of `module` (or its subclass)?
  public func isModule(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.module)
  }

  /// Is this object an instance of `module` (but not its subclass)?
  public func isExactlyModule(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.module)
  }

  /// Cast this object to `PyModule` if it is a `module` (or its subclass).
  public func asModule(_ object: PyObject) -> PyModule? {
    return self.isModule(object) ? PyModule(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyModule` if it is a `module` (but not its subclass).
  public func asExactlyModule(_ object: PyObject) -> PyModule? {
    return self.isExactlyModule(object) ? PyModule(ptr: object.ptr) : nil
  }

  // MARK: - Namespace

  /// Is this object an instance of `SimpleNamespace` (or its subclass)?
  public func isNamespace(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.simpleNamespace)
  }

  /// Is this object an instance of `SimpleNamespace` (but not its subclass)?
  public func isExactlyNamespace(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.simpleNamespace)
  }

  /// Cast this object to `PyNamespace` if it is a `SimpleNamespace` (or its subclass).
  public func asNamespace(_ object: PyObject) -> PyNamespace? {
    return self.isNamespace(object) ? PyNamespace(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyNamespace` if it is a `SimpleNamespace` (but not its subclass).
  public func asExactlyNamespace(_ object: PyObject) -> PyNamespace? {
    return self.isExactlyNamespace(object) ? PyNamespace(ptr: object.ptr) : nil
  }

  // MARK: - None

  // 'NoneType' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `NoneType`?
  public func isNone(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.none)
  }

  /// Cast this object to `PyNone` if it is a `NoneType`.
  public func asNone(_ object: PyObject) -> PyNone? {
    return self.isNone(object) ? PyNone(ptr: object.ptr) : nil
  }

  /// Is this object Swift `nil` or an instance of `NoneType`?
  public func isNilOrNone(_ object: PyObject?) -> Bool {
    guard let object = object else {
      return true
    }

    return self.isNone(object)
  }

  // MARK: - NotImplemented

  // 'NotImplementedType' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `NotImplementedType`?
  public func isNotImplemented(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.notImplemented)
  }

  /// Cast this object to `PyNotImplemented` if it is a `NotImplementedType`.
  public func asNotImplemented(_ object: PyObject) -> PyNotImplemented? {
    return self.isNotImplemented(object) ? PyNotImplemented(ptr: object.ptr) : nil
  }

  // MARK: - Property

  /// Is this object an instance of `property` (or its subclass)?
  public func isProperty(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.property)
  }

  /// Is this object an instance of `property` (but not its subclass)?
  public func isExactlyProperty(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.property)
  }

  /// Cast this object to `PyProperty` if it is a `property` (or its subclass).
  public func asProperty(_ object: PyObject) -> PyProperty? {
    return self.isProperty(object) ? PyProperty(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyProperty` if it is a `property` (but not its subclass).
  public func asExactlyProperty(_ object: PyObject) -> PyProperty? {
    return self.isExactlyProperty(object) ? PyProperty(ptr: object.ptr) : nil
  }

  // MARK: - Range

  // 'range' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `range`?
  public func isRange(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.range)
  }

  /// Cast this object to `PyRange` if it is a `range`.
  public func asRange(_ object: PyObject) -> PyRange? {
    return self.isRange(object) ? PyRange(ptr: object.ptr) : nil
  }

  // MARK: - RangeIterator

  // 'range_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `range_iterator`?
  public func isRangeIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.range_iterator)
  }

  /// Cast this object to `PyRangeIterator` if it is a `range_iterator`.
  public func asRangeIterator(_ object: PyObject) -> PyRangeIterator? {
    return self.isRangeIterator(object) ? PyRangeIterator(ptr: object.ptr) : nil
  }

  // MARK: - Reversed

  /// Is this object an instance of `reversed` (or its subclass)?
  public func isReversed(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.reversed)
  }

  /// Is this object an instance of `reversed` (but not its subclass)?
  public func isExactlyReversed(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.reversed)
  }

  /// Cast this object to `PyReversed` if it is a `reversed` (or its subclass).
  public func asReversed(_ object: PyObject) -> PyReversed? {
    return self.isReversed(object) ? PyReversed(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyReversed` if it is a `reversed` (but not its subclass).
  public func asExactlyReversed(_ object: PyObject) -> PyReversed? {
    return self.isExactlyReversed(object) ? PyReversed(ptr: object.ptr) : nil
  }

  // MARK: - Set

  /// Is this object an instance of `set` (or its subclass)?
  public func isSet(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.set)
  }

  /// Is this object an instance of `set` (but not its subclass)?
  public func isExactlySet(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.set)
  }

  /// Cast this object to `PySet` if it is a `set` (or its subclass).
  public func asSet(_ object: PyObject) -> PySet? {
    return self.isSet(object) ? PySet(ptr: object.ptr) : nil
  }

  /// Cast this object to `PySet` if it is a `set` (but not its subclass).
  public func asExactlySet(_ object: PyObject) -> PySet? {
    return self.isExactlySet(object) ? PySet(ptr: object.ptr) : nil
  }

  // MARK: - SetIterator

  // 'set_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `set_iterator`?
  public func isSetIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.set_iterator)
  }

  /// Cast this object to `PySetIterator` if it is a `set_iterator`.
  public func asSetIterator(_ object: PyObject) -> PySetIterator? {
    return self.isSetIterator(object) ? PySetIterator(ptr: object.ptr) : nil
  }

  // MARK: - Slice

  // 'slice' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `slice`?
  public func isSlice(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.slice)
  }

  /// Cast this object to `PySlice` if it is a `slice`.
  public func asSlice(_ object: PyObject) -> PySlice? {
    return self.isSlice(object) ? PySlice(ptr: object.ptr) : nil
  }

  // MARK: - StaticMethod

  /// Is this object an instance of `staticmethod` (or its subclass)?
  public func isStaticMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.staticmethod)
  }

  /// Is this object an instance of `staticmethod` (but not its subclass)?
  public func isExactlyStaticMethod(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.staticmethod)
  }

  /// Cast this object to `PyStaticMethod` if it is a `staticmethod` (or its subclass).
  public func asStaticMethod(_ object: PyObject) -> PyStaticMethod? {
    return self.isStaticMethod(object) ? PyStaticMethod(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyStaticMethod` if it is a `staticmethod` (but not its subclass).
  public func asExactlyStaticMethod(_ object: PyObject) -> PyStaticMethod? {
    return self.isExactlyStaticMethod(object) ? PyStaticMethod(ptr: object.ptr) : nil
  }

  // MARK: - String

  /// Is this object an instance of `str` (or its subclass)?
  public func isString(_ object: PyObject) -> Bool {
    // 'str' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isUnicodeSubclass
  }

  /// Is this object an instance of `str` (but not its subclass)?
  public func isExactlyString(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.str)
  }

  /// Cast this object to `PyString` if it is a `str` (or its subclass).
  public func asString(_ object: PyObject) -> PyString? {
    return self.isString(object) ? PyString(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyString` if it is a `str` (but not its subclass).
  public func asExactlyString(_ object: PyObject) -> PyString? {
    return self.isExactlyString(object) ? PyString(ptr: object.ptr) : nil
  }

  // MARK: - StringIterator

  // 'str_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `str_iterator`?
  public func isStringIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.str_iterator)
  }

  /// Cast this object to `PyStringIterator` if it is a `str_iterator`.
  public func asStringIterator(_ object: PyObject) -> PyStringIterator? {
    return self.isStringIterator(object) ? PyStringIterator(ptr: object.ptr) : nil
  }

  // MARK: - Super

  /// Is this object an instance of `super` (or its subclass)?
  public func isSuper(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.super)
  }

  /// Is this object an instance of `super` (but not its subclass)?
  public func isExactlySuper(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.super)
  }

  /// Cast this object to `PySuper` if it is a `super` (or its subclass).
  public func asSuper(_ object: PyObject) -> PySuper? {
    return self.isSuper(object) ? PySuper(ptr: object.ptr) : nil
  }

  /// Cast this object to `PySuper` if it is a `super` (but not its subclass).
  public func asExactlySuper(_ object: PyObject) -> PySuper? {
    return self.isExactlySuper(object) ? PySuper(ptr: object.ptr) : nil
  }

  // MARK: - TextFile

  // 'TextFile' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `TextFile`?
  public func isTextFile(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.textFile)
  }

  /// Cast this object to `PyTextFile` if it is a `TextFile`.
  public func asTextFile(_ object: PyObject) -> PyTextFile? {
    return self.isTextFile(object) ? PyTextFile(ptr: object.ptr) : nil
  }

  // MARK: - Traceback

  // 'traceback' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `traceback`?
  public func isTraceback(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.traceback)
  }

  /// Cast this object to `PyTraceback` if it is a `traceback`.
  public func asTraceback(_ object: PyObject) -> PyTraceback? {
    return self.isTraceback(object) ? PyTraceback(ptr: object.ptr) : nil
  }

  // MARK: - Tuple

  /// Is this object an instance of `tuple` (or its subclass)?
  public func isTuple(_ object: PyObject) -> Bool {
    // 'tuple' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isTupleSubclass
  }

  /// Is this object an instance of `tuple` (but not its subclass)?
  public func isExactlyTuple(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.tuple)
  }

  /// Cast this object to `PyTuple` if it is a `tuple` (or its subclass).
  public func asTuple(_ object: PyObject) -> PyTuple? {
    return self.isTuple(object) ? PyTuple(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyTuple` if it is a `tuple` (but not its subclass).
  public func asExactlyTuple(_ object: PyObject) -> PyTuple? {
    return self.isExactlyTuple(object) ? PyTuple(ptr: object.ptr) : nil
  }

  // MARK: - TupleIterator

  // 'tuple_iterator' does not allow subclassing, so we do not need 'exactly' methods.

  /// Is this object an instance of `tuple_iterator`?
  public func isTupleIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.tuple_iterator)
  }

  /// Cast this object to `PyTupleIterator` if it is a `tuple_iterator`.
  public func asTupleIterator(_ object: PyObject) -> PyTupleIterator? {
    return self.isTupleIterator(object) ? PyTupleIterator(ptr: object.ptr) : nil
  }

  // MARK: - Type

  /// Is this object an instance of `type` (or its subclass)?
  public func isType(_ object: PyObject) -> Bool {
    // 'type' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isTypeSubclass
  }

  /// Is this object an instance of `type` (but not its subclass)?
  public func isExactlyType(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.type)
  }

  /// Cast this object to `PyType` if it is a `type` (or its subclass).
  public func asType(_ object: PyObject) -> PyType? {
    return self.isType(object) ? PyType(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyType` if it is a `type` (but not its subclass).
  public func asExactlyType(_ object: PyObject) -> PyType? {
    return self.isExactlyType(object) ? PyType(ptr: object.ptr) : nil
  }

  // MARK: - Zip

  /// Is this object an instance of `zip` (or its subclass)?
  public func isZip(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.types.zip)
  }

  /// Is this object an instance of `zip` (but not its subclass)?
  public func isExactlyZip(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.zip)
  }

  /// Cast this object to `PyZip` if it is a `zip` (or its subclass).
  public func asZip(_ object: PyObject) -> PyZip? {
    return self.isZip(object) ? PyZip(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyZip` if it is a `zip` (but not its subclass).
  public func asExactlyZip(_ object: PyObject) -> PyZip? {
    return self.isExactlyZip(object) ? PyZip(ptr: object.ptr) : nil
  }

  // MARK: - ArithmeticError

  /// Is this object an instance of `ArithmeticError` (or its subclass)?
  public func isArithmeticError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.arithmeticError)
  }

  /// Is this object an instance of `ArithmeticError` (but not its subclass)?
  public func isExactlyArithmeticError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.arithmeticError)
  }

  /// Cast this object to `PyArithmeticError` if it is an `ArithmeticError` (or its subclass).
  public func asArithmeticError(_ object: PyObject) -> PyArithmeticError? {
    return self.isArithmeticError(object) ? PyArithmeticError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyArithmeticError` if it is an `ArithmeticError` (but not its subclass).
  public func asExactlyArithmeticError(_ object: PyObject) -> PyArithmeticError? {
    return self.isExactlyArithmeticError(object) ? PyArithmeticError(ptr: object.ptr) : nil
  }

  // MARK: - AssertionError

  /// Is this object an instance of `AssertionError` (or its subclass)?
  public func isAssertionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.assertionError)
  }

  /// Is this object an instance of `AssertionError` (but not its subclass)?
  public func isExactlyAssertionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.assertionError)
  }

  /// Cast this object to `PyAssertionError` if it is an `AssertionError` (or its subclass).
  public func asAssertionError(_ object: PyObject) -> PyAssertionError? {
    return self.isAssertionError(object) ? PyAssertionError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyAssertionError` if it is an `AssertionError` (but not its subclass).
  public func asExactlyAssertionError(_ object: PyObject) -> PyAssertionError? {
    return self.isExactlyAssertionError(object) ? PyAssertionError(ptr: object.ptr) : nil
  }

  // MARK: - AttributeError

  /// Is this object an instance of `AttributeError` (or its subclass)?
  public func isAttributeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.attributeError)
  }

  /// Is this object an instance of `AttributeError` (but not its subclass)?
  public func isExactlyAttributeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.attributeError)
  }

  /// Cast this object to `PyAttributeError` if it is an `AttributeError` (or its subclass).
  public func asAttributeError(_ object: PyObject) -> PyAttributeError? {
    return self.isAttributeError(object) ? PyAttributeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyAttributeError` if it is an `AttributeError` (but not its subclass).
  public func asExactlyAttributeError(_ object: PyObject) -> PyAttributeError? {
    return self.isExactlyAttributeError(object) ? PyAttributeError(ptr: object.ptr) : nil
  }

  // MARK: - BaseException

  /// Is this object an instance of `BaseException` (or its subclass)?
  public func isBaseException(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.baseException)
  }

  /// Is this object an instance of `BaseException` (but not its subclass)?
  public func isExactlyBaseException(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.baseException)
  }

  /// Cast this object to `PyBaseException` if it is a `BaseException` (or its subclass).
  public func asBaseException(_ object: PyObject) -> PyBaseException? {
    return self.isBaseException(object) ? PyBaseException(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyBaseException` if it is a `BaseException` (but not its subclass).
  public func asExactlyBaseException(_ object: PyObject) -> PyBaseException? {
    return self.isExactlyBaseException(object) ? PyBaseException(ptr: object.ptr) : nil
  }

  // MARK: - BlockingIOError

  /// Is this object an instance of `BlockingIOError` (or its subclass)?
  public func isBlockingIOError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.blockingIOError)
  }

  /// Is this object an instance of `BlockingIOError` (but not its subclass)?
  public func isExactlyBlockingIOError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.blockingIOError)
  }

  /// Cast this object to `PyBlockingIOError` if it is a `BlockingIOError` (or its subclass).
  public func asBlockingIOError(_ object: PyObject) -> PyBlockingIOError? {
    return self.isBlockingIOError(object) ? PyBlockingIOError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyBlockingIOError` if it is a `BlockingIOError` (but not its subclass).
  public func asExactlyBlockingIOError(_ object: PyObject) -> PyBlockingIOError? {
    return self.isExactlyBlockingIOError(object) ? PyBlockingIOError(ptr: object.ptr) : nil
  }

  // MARK: - BrokenPipeError

  /// Is this object an instance of `BrokenPipeError` (or its subclass)?
  public func isBrokenPipeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.brokenPipeError)
  }

  /// Is this object an instance of `BrokenPipeError` (but not its subclass)?
  public func isExactlyBrokenPipeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.brokenPipeError)
  }

  /// Cast this object to `PyBrokenPipeError` if it is a `BrokenPipeError` (or its subclass).
  public func asBrokenPipeError(_ object: PyObject) -> PyBrokenPipeError? {
    return self.isBrokenPipeError(object) ? PyBrokenPipeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyBrokenPipeError` if it is a `BrokenPipeError` (but not its subclass).
  public func asExactlyBrokenPipeError(_ object: PyObject) -> PyBrokenPipeError? {
    return self.isExactlyBrokenPipeError(object) ? PyBrokenPipeError(ptr: object.ptr) : nil
  }

  // MARK: - BufferError

  /// Is this object an instance of `BufferError` (or its subclass)?
  public func isBufferError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.bufferError)
  }

  /// Is this object an instance of `BufferError` (but not its subclass)?
  public func isExactlyBufferError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.bufferError)
  }

  /// Cast this object to `PyBufferError` if it is a `BufferError` (or its subclass).
  public func asBufferError(_ object: PyObject) -> PyBufferError? {
    return self.isBufferError(object) ? PyBufferError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyBufferError` if it is a `BufferError` (but not its subclass).
  public func asExactlyBufferError(_ object: PyObject) -> PyBufferError? {
    return self.isExactlyBufferError(object) ? PyBufferError(ptr: object.ptr) : nil
  }

  // MARK: - BytesWarning

  /// Is this object an instance of `BytesWarning` (or its subclass)?
  public func isBytesWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.bytesWarning)
  }

  /// Is this object an instance of `BytesWarning` (but not its subclass)?
  public func isExactlyBytesWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.bytesWarning)
  }

  /// Cast this object to `PyBytesWarning` if it is a `BytesWarning` (or its subclass).
  public func asBytesWarning(_ object: PyObject) -> PyBytesWarning? {
    return self.isBytesWarning(object) ? PyBytesWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyBytesWarning` if it is a `BytesWarning` (but not its subclass).
  public func asExactlyBytesWarning(_ object: PyObject) -> PyBytesWarning? {
    return self.isExactlyBytesWarning(object) ? PyBytesWarning(ptr: object.ptr) : nil
  }

  // MARK: - ChildProcessError

  /// Is this object an instance of `ChildProcessError` (or its subclass)?
  public func isChildProcessError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.childProcessError)
  }

  /// Is this object an instance of `ChildProcessError` (but not its subclass)?
  public func isExactlyChildProcessError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.childProcessError)
  }

  /// Cast this object to `PyChildProcessError` if it is a `ChildProcessError` (or its subclass).
  public func asChildProcessError(_ object: PyObject) -> PyChildProcessError? {
    return self.isChildProcessError(object) ? PyChildProcessError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyChildProcessError` if it is a `ChildProcessError` (but not its subclass).
  public func asExactlyChildProcessError(_ object: PyObject) -> PyChildProcessError? {
    return self.isExactlyChildProcessError(object) ? PyChildProcessError(ptr: object.ptr) : nil
  }

  // MARK: - ConnectionAbortedError

  /// Is this object an instance of `ConnectionAbortedError` (or its subclass)?
  public func isConnectionAbortedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.connectionAbortedError)
  }

  /// Is this object an instance of `ConnectionAbortedError` (but not its subclass)?
  public func isExactlyConnectionAbortedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.connectionAbortedError)
  }

  /// Cast this object to `PyConnectionAbortedError` if it is a `ConnectionAbortedError` (or its subclass).
  public func asConnectionAbortedError(_ object: PyObject) -> PyConnectionAbortedError? {
    return self.isConnectionAbortedError(object) ? PyConnectionAbortedError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyConnectionAbortedError` if it is a `ConnectionAbortedError` (but not its subclass).
  public func asExactlyConnectionAbortedError(_ object: PyObject) -> PyConnectionAbortedError? {
    return self.isExactlyConnectionAbortedError(object) ? PyConnectionAbortedError(ptr: object.ptr) : nil
  }

  // MARK: - ConnectionError

  /// Is this object an instance of `ConnectionError` (or its subclass)?
  public func isConnectionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.connectionError)
  }

  /// Is this object an instance of `ConnectionError` (but not its subclass)?
  public func isExactlyConnectionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.connectionError)
  }

  /// Cast this object to `PyConnectionError` if it is a `ConnectionError` (or its subclass).
  public func asConnectionError(_ object: PyObject) -> PyConnectionError? {
    return self.isConnectionError(object) ? PyConnectionError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyConnectionError` if it is a `ConnectionError` (but not its subclass).
  public func asExactlyConnectionError(_ object: PyObject) -> PyConnectionError? {
    return self.isExactlyConnectionError(object) ? PyConnectionError(ptr: object.ptr) : nil
  }

  // MARK: - ConnectionRefusedError

  /// Is this object an instance of `ConnectionRefusedError` (or its subclass)?
  public func isConnectionRefusedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.connectionRefusedError)
  }

  /// Is this object an instance of `ConnectionRefusedError` (but not its subclass)?
  public func isExactlyConnectionRefusedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.connectionRefusedError)
  }

  /// Cast this object to `PyConnectionRefusedError` if it is a `ConnectionRefusedError` (or its subclass).
  public func asConnectionRefusedError(_ object: PyObject) -> PyConnectionRefusedError? {
    return self.isConnectionRefusedError(object) ? PyConnectionRefusedError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyConnectionRefusedError` if it is a `ConnectionRefusedError` (but not its subclass).
  public func asExactlyConnectionRefusedError(_ object: PyObject) -> PyConnectionRefusedError? {
    return self.isExactlyConnectionRefusedError(object) ? PyConnectionRefusedError(ptr: object.ptr) : nil
  }

  // MARK: - ConnectionResetError

  /// Is this object an instance of `ConnectionResetError` (or its subclass)?
  public func isConnectionResetError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.connectionResetError)
  }

  /// Is this object an instance of `ConnectionResetError` (but not its subclass)?
  public func isExactlyConnectionResetError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.connectionResetError)
  }

  /// Cast this object to `PyConnectionResetError` if it is a `ConnectionResetError` (or its subclass).
  public func asConnectionResetError(_ object: PyObject) -> PyConnectionResetError? {
    return self.isConnectionResetError(object) ? PyConnectionResetError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyConnectionResetError` if it is a `ConnectionResetError` (but not its subclass).
  public func asExactlyConnectionResetError(_ object: PyObject) -> PyConnectionResetError? {
    return self.isExactlyConnectionResetError(object) ? PyConnectionResetError(ptr: object.ptr) : nil
  }

  // MARK: - DeprecationWarning

  /// Is this object an instance of `DeprecationWarning` (or its subclass)?
  public func isDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.deprecationWarning)
  }

  /// Is this object an instance of `DeprecationWarning` (but not its subclass)?
  public func isExactlyDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.deprecationWarning)
  }

  /// Cast this object to `PyDeprecationWarning` if it is a `DeprecationWarning` (or its subclass).
  public func asDeprecationWarning(_ object: PyObject) -> PyDeprecationWarning? {
    return self.isDeprecationWarning(object) ? PyDeprecationWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyDeprecationWarning` if it is a `DeprecationWarning` (but not its subclass).
  public func asExactlyDeprecationWarning(_ object: PyObject) -> PyDeprecationWarning? {
    return self.isExactlyDeprecationWarning(object) ? PyDeprecationWarning(ptr: object.ptr) : nil
  }

  // MARK: - EOFError

  /// Is this object an instance of `EOFError` (or its subclass)?
  public func isEOFError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.eofError)
  }

  /// Is this object an instance of `EOFError` (but not its subclass)?
  public func isExactlyEOFError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.eofError)
  }

  /// Cast this object to `PyEOFError` if it is an `EOFError` (or its subclass).
  public func asEOFError(_ object: PyObject) -> PyEOFError? {
    return self.isEOFError(object) ? PyEOFError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyEOFError` if it is an `EOFError` (but not its subclass).
  public func asExactlyEOFError(_ object: PyObject) -> PyEOFError? {
    return self.isExactlyEOFError(object) ? PyEOFError(ptr: object.ptr) : nil
  }

  // MARK: - Exception

  /// Is this object an instance of `Exception` (or its subclass)?
  public func isException(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.exception)
  }

  /// Is this object an instance of `Exception` (but not its subclass)?
  public func isExactlyException(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.exception)
  }

  /// Cast this object to `PyException` if it is an `Exception` (or its subclass).
  public func asException(_ object: PyObject) -> PyException? {
    return self.isException(object) ? PyException(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyException` if it is an `Exception` (but not its subclass).
  public func asExactlyException(_ object: PyObject) -> PyException? {
    return self.isExactlyException(object) ? PyException(ptr: object.ptr) : nil
  }

  // MARK: - FileExistsError

  /// Is this object an instance of `FileExistsError` (or its subclass)?
  public func isFileExistsError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.fileExistsError)
  }

  /// Is this object an instance of `FileExistsError` (but not its subclass)?
  public func isExactlyFileExistsError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.fileExistsError)
  }

  /// Cast this object to `PyFileExistsError` if it is a `FileExistsError` (or its subclass).
  public func asFileExistsError(_ object: PyObject) -> PyFileExistsError? {
    return self.isFileExistsError(object) ? PyFileExistsError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFileExistsError` if it is a `FileExistsError` (but not its subclass).
  public func asExactlyFileExistsError(_ object: PyObject) -> PyFileExistsError? {
    return self.isExactlyFileExistsError(object) ? PyFileExistsError(ptr: object.ptr) : nil
  }

  // MARK: - FileNotFoundError

  /// Is this object an instance of `FileNotFoundError` (or its subclass)?
  public func isFileNotFoundError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.fileNotFoundError)
  }

  /// Is this object an instance of `FileNotFoundError` (but not its subclass)?
  public func isExactlyFileNotFoundError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.fileNotFoundError)
  }

  /// Cast this object to `PyFileNotFoundError` if it is a `FileNotFoundError` (or its subclass).
  public func asFileNotFoundError(_ object: PyObject) -> PyFileNotFoundError? {
    return self.isFileNotFoundError(object) ? PyFileNotFoundError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFileNotFoundError` if it is a `FileNotFoundError` (but not its subclass).
  public func asExactlyFileNotFoundError(_ object: PyObject) -> PyFileNotFoundError? {
    return self.isExactlyFileNotFoundError(object) ? PyFileNotFoundError(ptr: object.ptr) : nil
  }

  // MARK: - FloatingPointError

  /// Is this object an instance of `FloatingPointError` (or its subclass)?
  public func isFloatingPointError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.floatingPointError)
  }

  /// Is this object an instance of `FloatingPointError` (but not its subclass)?
  public func isExactlyFloatingPointError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.floatingPointError)
  }

  /// Cast this object to `PyFloatingPointError` if it is a `FloatingPointError` (or its subclass).
  public func asFloatingPointError(_ object: PyObject) -> PyFloatingPointError? {
    return self.isFloatingPointError(object) ? PyFloatingPointError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFloatingPointError` if it is a `FloatingPointError` (but not its subclass).
  public func asExactlyFloatingPointError(_ object: PyObject) -> PyFloatingPointError? {
    return self.isExactlyFloatingPointError(object) ? PyFloatingPointError(ptr: object.ptr) : nil
  }

  // MARK: - FutureWarning

  /// Is this object an instance of `FutureWarning` (or its subclass)?
  public func isFutureWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.futureWarning)
  }

  /// Is this object an instance of `FutureWarning` (but not its subclass)?
  public func isExactlyFutureWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.futureWarning)
  }

  /// Cast this object to `PyFutureWarning` if it is a `FutureWarning` (or its subclass).
  public func asFutureWarning(_ object: PyObject) -> PyFutureWarning? {
    return self.isFutureWarning(object) ? PyFutureWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyFutureWarning` if it is a `FutureWarning` (but not its subclass).
  public func asExactlyFutureWarning(_ object: PyObject) -> PyFutureWarning? {
    return self.isExactlyFutureWarning(object) ? PyFutureWarning(ptr: object.ptr) : nil
  }

  // MARK: - GeneratorExit

  /// Is this object an instance of `GeneratorExit` (or its subclass)?
  public func isGeneratorExit(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.generatorExit)
  }

  /// Is this object an instance of `GeneratorExit` (but not its subclass)?
  public func isExactlyGeneratorExit(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.generatorExit)
  }

  /// Cast this object to `PyGeneratorExit` if it is a `GeneratorExit` (or its subclass).
  public func asGeneratorExit(_ object: PyObject) -> PyGeneratorExit? {
    return self.isGeneratorExit(object) ? PyGeneratorExit(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyGeneratorExit` if it is a `GeneratorExit` (but not its subclass).
  public func asExactlyGeneratorExit(_ object: PyObject) -> PyGeneratorExit? {
    return self.isExactlyGeneratorExit(object) ? PyGeneratorExit(ptr: object.ptr) : nil
  }

  // MARK: - ImportError

  /// Is this object an instance of `ImportError` (or its subclass)?
  public func isImportError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.importError)
  }

  /// Is this object an instance of `ImportError` (but not its subclass)?
  public func isExactlyImportError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.importError)
  }

  /// Cast this object to `PyImportError` if it is an `ImportError` (or its subclass).
  public func asImportError(_ object: PyObject) -> PyImportError? {
    return self.isImportError(object) ? PyImportError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyImportError` if it is an `ImportError` (but not its subclass).
  public func asExactlyImportError(_ object: PyObject) -> PyImportError? {
    return self.isExactlyImportError(object) ? PyImportError(ptr: object.ptr) : nil
  }

  // MARK: - ImportWarning

  /// Is this object an instance of `ImportWarning` (or its subclass)?
  public func isImportWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.importWarning)
  }

  /// Is this object an instance of `ImportWarning` (but not its subclass)?
  public func isExactlyImportWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.importWarning)
  }

  /// Cast this object to `PyImportWarning` if it is an `ImportWarning` (or its subclass).
  public func asImportWarning(_ object: PyObject) -> PyImportWarning? {
    return self.isImportWarning(object) ? PyImportWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyImportWarning` if it is an `ImportWarning` (but not its subclass).
  public func asExactlyImportWarning(_ object: PyObject) -> PyImportWarning? {
    return self.isExactlyImportWarning(object) ? PyImportWarning(ptr: object.ptr) : nil
  }

  // MARK: - IndentationError

  /// Is this object an instance of `IndentationError` (or its subclass)?
  public func isIndentationError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.indentationError)
  }

  /// Is this object an instance of `IndentationError` (but not its subclass)?
  public func isExactlyIndentationError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.indentationError)
  }

  /// Cast this object to `PyIndentationError` if it is an `IndentationError` (or its subclass).
  public func asIndentationError(_ object: PyObject) -> PyIndentationError? {
    return self.isIndentationError(object) ? PyIndentationError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyIndentationError` if it is an `IndentationError` (but not its subclass).
  public func asExactlyIndentationError(_ object: PyObject) -> PyIndentationError? {
    return self.isExactlyIndentationError(object) ? PyIndentationError(ptr: object.ptr) : nil
  }

  // MARK: - IndexError

  /// Is this object an instance of `IndexError` (or its subclass)?
  public func isIndexError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.indexError)
  }

  /// Is this object an instance of `IndexError` (but not its subclass)?
  public func isExactlyIndexError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.indexError)
  }

  /// Cast this object to `PyIndexError` if it is an `IndexError` (or its subclass).
  public func asIndexError(_ object: PyObject) -> PyIndexError? {
    return self.isIndexError(object) ? PyIndexError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyIndexError` if it is an `IndexError` (but not its subclass).
  public func asExactlyIndexError(_ object: PyObject) -> PyIndexError? {
    return self.isExactlyIndexError(object) ? PyIndexError(ptr: object.ptr) : nil
  }

  // MARK: - InterruptedError

  /// Is this object an instance of `InterruptedError` (or its subclass)?
  public func isInterruptedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.interruptedError)
  }

  /// Is this object an instance of `InterruptedError` (but not its subclass)?
  public func isExactlyInterruptedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.interruptedError)
  }

  /// Cast this object to `PyInterruptedError` if it is an `InterruptedError` (or its subclass).
  public func asInterruptedError(_ object: PyObject) -> PyInterruptedError? {
    return self.isInterruptedError(object) ? PyInterruptedError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyInterruptedError` if it is an `InterruptedError` (but not its subclass).
  public func asExactlyInterruptedError(_ object: PyObject) -> PyInterruptedError? {
    return self.isExactlyInterruptedError(object) ? PyInterruptedError(ptr: object.ptr) : nil
  }

  // MARK: - IsADirectoryError

  /// Is this object an instance of `IsADirectoryError` (or its subclass)?
  public func isIsADirectoryError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.isADirectoryError)
  }

  /// Is this object an instance of `IsADirectoryError` (but not its subclass)?
  public func isExactlyIsADirectoryError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.isADirectoryError)
  }

  /// Cast this object to `PyIsADirectoryError` if it is an `IsADirectoryError` (or its subclass).
  public func asIsADirectoryError(_ object: PyObject) -> PyIsADirectoryError? {
    return self.isIsADirectoryError(object) ? PyIsADirectoryError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyIsADirectoryError` if it is an `IsADirectoryError` (but not its subclass).
  public func asExactlyIsADirectoryError(_ object: PyObject) -> PyIsADirectoryError? {
    return self.isExactlyIsADirectoryError(object) ? PyIsADirectoryError(ptr: object.ptr) : nil
  }

  // MARK: - KeyError

  /// Is this object an instance of `KeyError` (or its subclass)?
  public func isKeyError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.keyError)
  }

  /// Is this object an instance of `KeyError` (but not its subclass)?
  public func isExactlyKeyError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.keyError)
  }

  /// Cast this object to `PyKeyError` if it is a `KeyError` (or its subclass).
  public func asKeyError(_ object: PyObject) -> PyKeyError? {
    return self.isKeyError(object) ? PyKeyError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyKeyError` if it is a `KeyError` (but not its subclass).
  public func asExactlyKeyError(_ object: PyObject) -> PyKeyError? {
    return self.isExactlyKeyError(object) ? PyKeyError(ptr: object.ptr) : nil
  }

  // MARK: - KeyboardInterrupt

  /// Is this object an instance of `KeyboardInterrupt` (or its subclass)?
  public func isKeyboardInterrupt(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.keyboardInterrupt)
  }

  /// Is this object an instance of `KeyboardInterrupt` (but not its subclass)?
  public func isExactlyKeyboardInterrupt(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.keyboardInterrupt)
  }

  /// Cast this object to `PyKeyboardInterrupt` if it is a `KeyboardInterrupt` (or its subclass).
  public func asKeyboardInterrupt(_ object: PyObject) -> PyKeyboardInterrupt? {
    return self.isKeyboardInterrupt(object) ? PyKeyboardInterrupt(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyKeyboardInterrupt` if it is a `KeyboardInterrupt` (but not its subclass).
  public func asExactlyKeyboardInterrupt(_ object: PyObject) -> PyKeyboardInterrupt? {
    return self.isExactlyKeyboardInterrupt(object) ? PyKeyboardInterrupt(ptr: object.ptr) : nil
  }

  // MARK: - LookupError

  /// Is this object an instance of `LookupError` (or its subclass)?
  public func isLookupError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.lookupError)
  }

  /// Is this object an instance of `LookupError` (but not its subclass)?
  public func isExactlyLookupError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.lookupError)
  }

  /// Cast this object to `PyLookupError` if it is a `LookupError` (or its subclass).
  public func asLookupError(_ object: PyObject) -> PyLookupError? {
    return self.isLookupError(object) ? PyLookupError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyLookupError` if it is a `LookupError` (but not its subclass).
  public func asExactlyLookupError(_ object: PyObject) -> PyLookupError? {
    return self.isExactlyLookupError(object) ? PyLookupError(ptr: object.ptr) : nil
  }

  // MARK: - MemoryError

  /// Is this object an instance of `MemoryError` (or its subclass)?
  public func isMemoryError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.memoryError)
  }

  /// Is this object an instance of `MemoryError` (but not its subclass)?
  public func isExactlyMemoryError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.memoryError)
  }

  /// Cast this object to `PyMemoryError` if it is a `MemoryError` (or its subclass).
  public func asMemoryError(_ object: PyObject) -> PyMemoryError? {
    return self.isMemoryError(object) ? PyMemoryError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyMemoryError` if it is a `MemoryError` (but not its subclass).
  public func asExactlyMemoryError(_ object: PyObject) -> PyMemoryError? {
    return self.isExactlyMemoryError(object) ? PyMemoryError(ptr: object.ptr) : nil
  }

  // MARK: - ModuleNotFoundError

  /// Is this object an instance of `ModuleNotFoundError` (or its subclass)?
  public func isModuleNotFoundError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.moduleNotFoundError)
  }

  /// Is this object an instance of `ModuleNotFoundError` (but not its subclass)?
  public func isExactlyModuleNotFoundError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.moduleNotFoundError)
  }

  /// Cast this object to `PyModuleNotFoundError` if it is a `ModuleNotFoundError` (or its subclass).
  public func asModuleNotFoundError(_ object: PyObject) -> PyModuleNotFoundError? {
    return self.isModuleNotFoundError(object) ? PyModuleNotFoundError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyModuleNotFoundError` if it is a `ModuleNotFoundError` (but not its subclass).
  public func asExactlyModuleNotFoundError(_ object: PyObject) -> PyModuleNotFoundError? {
    return self.isExactlyModuleNotFoundError(object) ? PyModuleNotFoundError(ptr: object.ptr) : nil
  }

  // MARK: - NameError

  /// Is this object an instance of `NameError` (or its subclass)?
  public func isNameError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.nameError)
  }

  /// Is this object an instance of `NameError` (but not its subclass)?
  public func isExactlyNameError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.nameError)
  }

  /// Cast this object to `PyNameError` if it is a `NameError` (or its subclass).
  public func asNameError(_ object: PyObject) -> PyNameError? {
    return self.isNameError(object) ? PyNameError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyNameError` if it is a `NameError` (but not its subclass).
  public func asExactlyNameError(_ object: PyObject) -> PyNameError? {
    return self.isExactlyNameError(object) ? PyNameError(ptr: object.ptr) : nil
  }

  // MARK: - NotADirectoryError

  /// Is this object an instance of `NotADirectoryError` (or its subclass)?
  public func isNotADirectoryError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.notADirectoryError)
  }

  /// Is this object an instance of `NotADirectoryError` (but not its subclass)?
  public func isExactlyNotADirectoryError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.notADirectoryError)
  }

  /// Cast this object to `PyNotADirectoryError` if it is a `NotADirectoryError` (or its subclass).
  public func asNotADirectoryError(_ object: PyObject) -> PyNotADirectoryError? {
    return self.isNotADirectoryError(object) ? PyNotADirectoryError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyNotADirectoryError` if it is a `NotADirectoryError` (but not its subclass).
  public func asExactlyNotADirectoryError(_ object: PyObject) -> PyNotADirectoryError? {
    return self.isExactlyNotADirectoryError(object) ? PyNotADirectoryError(ptr: object.ptr) : nil
  }

  // MARK: - NotImplementedError

  /// Is this object an instance of `NotImplementedError` (or its subclass)?
  public func isNotImplementedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.notImplementedError)
  }

  /// Is this object an instance of `NotImplementedError` (but not its subclass)?
  public func isExactlyNotImplementedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.notImplementedError)
  }

  /// Cast this object to `PyNotImplementedError` if it is a `NotImplementedError` (or its subclass).
  public func asNotImplementedError(_ object: PyObject) -> PyNotImplementedError? {
    return self.isNotImplementedError(object) ? PyNotImplementedError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyNotImplementedError` if it is a `NotImplementedError` (but not its subclass).
  public func asExactlyNotImplementedError(_ object: PyObject) -> PyNotImplementedError? {
    return self.isExactlyNotImplementedError(object) ? PyNotImplementedError(ptr: object.ptr) : nil
  }

  // MARK: - OSError

  /// Is this object an instance of `OSError` (or its subclass)?
  public func isOSError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.osError)
  }

  /// Is this object an instance of `OSError` (but not its subclass)?
  public func isExactlyOSError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.osError)
  }

  /// Cast this object to `PyOSError` if it is an `OSError` (or its subclass).
  public func asOSError(_ object: PyObject) -> PyOSError? {
    return self.isOSError(object) ? PyOSError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyOSError` if it is an `OSError` (but not its subclass).
  public func asExactlyOSError(_ object: PyObject) -> PyOSError? {
    return self.isExactlyOSError(object) ? PyOSError(ptr: object.ptr) : nil
  }

  // MARK: - OverflowError

  /// Is this object an instance of `OverflowError` (or its subclass)?
  public func isOverflowError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.overflowError)
  }

  /// Is this object an instance of `OverflowError` (but not its subclass)?
  public func isExactlyOverflowError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.overflowError)
  }

  /// Cast this object to `PyOverflowError` if it is an `OverflowError` (or its subclass).
  public func asOverflowError(_ object: PyObject) -> PyOverflowError? {
    return self.isOverflowError(object) ? PyOverflowError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyOverflowError` if it is an `OverflowError` (but not its subclass).
  public func asExactlyOverflowError(_ object: PyObject) -> PyOverflowError? {
    return self.isExactlyOverflowError(object) ? PyOverflowError(ptr: object.ptr) : nil
  }

  // MARK: - PendingDeprecationWarning

  /// Is this object an instance of `PendingDeprecationWarning` (or its subclass)?
  public func isPendingDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.pendingDeprecationWarning)
  }

  /// Is this object an instance of `PendingDeprecationWarning` (but not its subclass)?
  public func isExactlyPendingDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.pendingDeprecationWarning)
  }

  /// Cast this object to `PyPendingDeprecationWarning` if it is a `PendingDeprecationWarning` (or its subclass).
  public func asPendingDeprecationWarning(_ object: PyObject) -> PyPendingDeprecationWarning? {
    return self.isPendingDeprecationWarning(object) ? PyPendingDeprecationWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyPendingDeprecationWarning` if it is a `PendingDeprecationWarning` (but not its subclass).
  public func asExactlyPendingDeprecationWarning(_ object: PyObject) -> PyPendingDeprecationWarning? {
    return self.isExactlyPendingDeprecationWarning(object) ? PyPendingDeprecationWarning(ptr: object.ptr) : nil
  }

  // MARK: - PermissionError

  /// Is this object an instance of `PermissionError` (or its subclass)?
  public func isPermissionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.permissionError)
  }

  /// Is this object an instance of `PermissionError` (but not its subclass)?
  public func isExactlyPermissionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.permissionError)
  }

  /// Cast this object to `PyPermissionError` if it is a `PermissionError` (or its subclass).
  public func asPermissionError(_ object: PyObject) -> PyPermissionError? {
    return self.isPermissionError(object) ? PyPermissionError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyPermissionError` if it is a `PermissionError` (but not its subclass).
  public func asExactlyPermissionError(_ object: PyObject) -> PyPermissionError? {
    return self.isExactlyPermissionError(object) ? PyPermissionError(ptr: object.ptr) : nil
  }

  // MARK: - ProcessLookupError

  /// Is this object an instance of `ProcessLookupError` (or its subclass)?
  public func isProcessLookupError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.processLookupError)
  }

  /// Is this object an instance of `ProcessLookupError` (but not its subclass)?
  public func isExactlyProcessLookupError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.processLookupError)
  }

  /// Cast this object to `PyProcessLookupError` if it is a `ProcessLookupError` (or its subclass).
  public func asProcessLookupError(_ object: PyObject) -> PyProcessLookupError? {
    return self.isProcessLookupError(object) ? PyProcessLookupError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyProcessLookupError` if it is a `ProcessLookupError` (but not its subclass).
  public func asExactlyProcessLookupError(_ object: PyObject) -> PyProcessLookupError? {
    return self.isExactlyProcessLookupError(object) ? PyProcessLookupError(ptr: object.ptr) : nil
  }

  // MARK: - RecursionError

  /// Is this object an instance of `RecursionError` (or its subclass)?
  public func isRecursionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.recursionError)
  }

  /// Is this object an instance of `RecursionError` (but not its subclass)?
  public func isExactlyRecursionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.recursionError)
  }

  /// Cast this object to `PyRecursionError` if it is a `RecursionError` (or its subclass).
  public func asRecursionError(_ object: PyObject) -> PyRecursionError? {
    return self.isRecursionError(object) ? PyRecursionError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyRecursionError` if it is a `RecursionError` (but not its subclass).
  public func asExactlyRecursionError(_ object: PyObject) -> PyRecursionError? {
    return self.isExactlyRecursionError(object) ? PyRecursionError(ptr: object.ptr) : nil
  }

  // MARK: - ReferenceError

  /// Is this object an instance of `ReferenceError` (or its subclass)?
  public func isReferenceError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.referenceError)
  }

  /// Is this object an instance of `ReferenceError` (but not its subclass)?
  public func isExactlyReferenceError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.referenceError)
  }

  /// Cast this object to `PyReferenceError` if it is a `ReferenceError` (or its subclass).
  public func asReferenceError(_ object: PyObject) -> PyReferenceError? {
    return self.isReferenceError(object) ? PyReferenceError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyReferenceError` if it is a `ReferenceError` (but not its subclass).
  public func asExactlyReferenceError(_ object: PyObject) -> PyReferenceError? {
    return self.isExactlyReferenceError(object) ? PyReferenceError(ptr: object.ptr) : nil
  }

  // MARK: - ResourceWarning

  /// Is this object an instance of `ResourceWarning` (or its subclass)?
  public func isResourceWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.resourceWarning)
  }

  /// Is this object an instance of `ResourceWarning` (but not its subclass)?
  public func isExactlyResourceWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.resourceWarning)
  }

  /// Cast this object to `PyResourceWarning` if it is a `ResourceWarning` (or its subclass).
  public func asResourceWarning(_ object: PyObject) -> PyResourceWarning? {
    return self.isResourceWarning(object) ? PyResourceWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyResourceWarning` if it is a `ResourceWarning` (but not its subclass).
  public func asExactlyResourceWarning(_ object: PyObject) -> PyResourceWarning? {
    return self.isExactlyResourceWarning(object) ? PyResourceWarning(ptr: object.ptr) : nil
  }

  // MARK: - RuntimeError

  /// Is this object an instance of `RuntimeError` (or its subclass)?
  public func isRuntimeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.runtimeError)
  }

  /// Is this object an instance of `RuntimeError` (but not its subclass)?
  public func isExactlyRuntimeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.runtimeError)
  }

  /// Cast this object to `PyRuntimeError` if it is a `RuntimeError` (or its subclass).
  public func asRuntimeError(_ object: PyObject) -> PyRuntimeError? {
    return self.isRuntimeError(object) ? PyRuntimeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyRuntimeError` if it is a `RuntimeError` (but not its subclass).
  public func asExactlyRuntimeError(_ object: PyObject) -> PyRuntimeError? {
    return self.isExactlyRuntimeError(object) ? PyRuntimeError(ptr: object.ptr) : nil
  }

  // MARK: - RuntimeWarning

  /// Is this object an instance of `RuntimeWarning` (or its subclass)?
  public func isRuntimeWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.runtimeWarning)
  }

  /// Is this object an instance of `RuntimeWarning` (but not its subclass)?
  public func isExactlyRuntimeWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.runtimeWarning)
  }

  /// Cast this object to `PyRuntimeWarning` if it is a `RuntimeWarning` (or its subclass).
  public func asRuntimeWarning(_ object: PyObject) -> PyRuntimeWarning? {
    return self.isRuntimeWarning(object) ? PyRuntimeWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyRuntimeWarning` if it is a `RuntimeWarning` (but not its subclass).
  public func asExactlyRuntimeWarning(_ object: PyObject) -> PyRuntimeWarning? {
    return self.isExactlyRuntimeWarning(object) ? PyRuntimeWarning(ptr: object.ptr) : nil
  }

  // MARK: - StopAsyncIteration

  /// Is this object an instance of `StopAsyncIteration` (or its subclass)?
  public func isStopAsyncIteration(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.stopAsyncIteration)
  }

  /// Is this object an instance of `StopAsyncIteration` (but not its subclass)?
  public func isExactlyStopAsyncIteration(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.stopAsyncIteration)
  }

  /// Cast this object to `PyStopAsyncIteration` if it is a `StopAsyncIteration` (or its subclass).
  public func asStopAsyncIteration(_ object: PyObject) -> PyStopAsyncIteration? {
    return self.isStopAsyncIteration(object) ? PyStopAsyncIteration(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyStopAsyncIteration` if it is a `StopAsyncIteration` (but not its subclass).
  public func asExactlyStopAsyncIteration(_ object: PyObject) -> PyStopAsyncIteration? {
    return self.isExactlyStopAsyncIteration(object) ? PyStopAsyncIteration(ptr: object.ptr) : nil
  }

  // MARK: - StopIteration

  /// Is this object an instance of `StopIteration` (or its subclass)?
  public func isStopIteration(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.stopIteration)
  }

  /// Is this object an instance of `StopIteration` (but not its subclass)?
  public func isExactlyStopIteration(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.stopIteration)
  }

  /// Cast this object to `PyStopIteration` if it is a `StopIteration` (or its subclass).
  public func asStopIteration(_ object: PyObject) -> PyStopIteration? {
    return self.isStopIteration(object) ? PyStopIteration(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyStopIteration` if it is a `StopIteration` (but not its subclass).
  public func asExactlyStopIteration(_ object: PyObject) -> PyStopIteration? {
    return self.isExactlyStopIteration(object) ? PyStopIteration(ptr: object.ptr) : nil
  }

  // MARK: - SyntaxError

  /// Is this object an instance of `SyntaxError` (or its subclass)?
  public func isSyntaxError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.syntaxError)
  }

  /// Is this object an instance of `SyntaxError` (but not its subclass)?
  public func isExactlySyntaxError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.syntaxError)
  }

  /// Cast this object to `PySyntaxError` if it is a `SyntaxError` (or its subclass).
  public func asSyntaxError(_ object: PyObject) -> PySyntaxError? {
    return self.isSyntaxError(object) ? PySyntaxError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PySyntaxError` if it is a `SyntaxError` (but not its subclass).
  public func asExactlySyntaxError(_ object: PyObject) -> PySyntaxError? {
    return self.isExactlySyntaxError(object) ? PySyntaxError(ptr: object.ptr) : nil
  }

  // MARK: - SyntaxWarning

  /// Is this object an instance of `SyntaxWarning` (or its subclass)?
  public func isSyntaxWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.syntaxWarning)
  }

  /// Is this object an instance of `SyntaxWarning` (but not its subclass)?
  public func isExactlySyntaxWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.syntaxWarning)
  }

  /// Cast this object to `PySyntaxWarning` if it is a `SyntaxWarning` (or its subclass).
  public func asSyntaxWarning(_ object: PyObject) -> PySyntaxWarning? {
    return self.isSyntaxWarning(object) ? PySyntaxWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PySyntaxWarning` if it is a `SyntaxWarning` (but not its subclass).
  public func asExactlySyntaxWarning(_ object: PyObject) -> PySyntaxWarning? {
    return self.isExactlySyntaxWarning(object) ? PySyntaxWarning(ptr: object.ptr) : nil
  }

  // MARK: - SystemError

  /// Is this object an instance of `SystemError` (or its subclass)?
  public func isSystemError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.systemError)
  }

  /// Is this object an instance of `SystemError` (but not its subclass)?
  public func isExactlySystemError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.systemError)
  }

  /// Cast this object to `PySystemError` if it is a `SystemError` (or its subclass).
  public func asSystemError(_ object: PyObject) -> PySystemError? {
    return self.isSystemError(object) ? PySystemError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PySystemError` if it is a `SystemError` (but not its subclass).
  public func asExactlySystemError(_ object: PyObject) -> PySystemError? {
    return self.isExactlySystemError(object) ? PySystemError(ptr: object.ptr) : nil
  }

  // MARK: - SystemExit

  /// Is this object an instance of `SystemExit` (or its subclass)?
  public func isSystemExit(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.systemExit)
  }

  /// Is this object an instance of `SystemExit` (but not its subclass)?
  public func isExactlySystemExit(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.systemExit)
  }

  /// Cast this object to `PySystemExit` if it is a `SystemExit` (or its subclass).
  public func asSystemExit(_ object: PyObject) -> PySystemExit? {
    return self.isSystemExit(object) ? PySystemExit(ptr: object.ptr) : nil
  }

  /// Cast this object to `PySystemExit` if it is a `SystemExit` (but not its subclass).
  public func asExactlySystemExit(_ object: PyObject) -> PySystemExit? {
    return self.isExactlySystemExit(object) ? PySystemExit(ptr: object.ptr) : nil
  }

  // MARK: - TabError

  /// Is this object an instance of `TabError` (or its subclass)?
  public func isTabError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.tabError)
  }

  /// Is this object an instance of `TabError` (but not its subclass)?
  public func isExactlyTabError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.tabError)
  }

  /// Cast this object to `PyTabError` if it is a `TabError` (or its subclass).
  public func asTabError(_ object: PyObject) -> PyTabError? {
    return self.isTabError(object) ? PyTabError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyTabError` if it is a `TabError` (but not its subclass).
  public func asExactlyTabError(_ object: PyObject) -> PyTabError? {
    return self.isExactlyTabError(object) ? PyTabError(ptr: object.ptr) : nil
  }

  // MARK: - TimeoutError

  /// Is this object an instance of `TimeoutError` (or its subclass)?
  public func isTimeoutError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.timeoutError)
  }

  /// Is this object an instance of `TimeoutError` (but not its subclass)?
  public func isExactlyTimeoutError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.timeoutError)
  }

  /// Cast this object to `PyTimeoutError` if it is a `TimeoutError` (or its subclass).
  public func asTimeoutError(_ object: PyObject) -> PyTimeoutError? {
    return self.isTimeoutError(object) ? PyTimeoutError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyTimeoutError` if it is a `TimeoutError` (but not its subclass).
  public func asExactlyTimeoutError(_ object: PyObject) -> PyTimeoutError? {
    return self.isExactlyTimeoutError(object) ? PyTimeoutError(ptr: object.ptr) : nil
  }

  // MARK: - TypeError

  /// Is this object an instance of `TypeError` (or its subclass)?
  public func isTypeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.typeError)
  }

  /// Is this object an instance of `TypeError` (but not its subclass)?
  public func isExactlyTypeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.typeError)
  }

  /// Cast this object to `PyTypeError` if it is a `TypeError` (or its subclass).
  public func asTypeError(_ object: PyObject) -> PyTypeError? {
    return self.isTypeError(object) ? PyTypeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyTypeError` if it is a `TypeError` (but not its subclass).
  public func asExactlyTypeError(_ object: PyObject) -> PyTypeError? {
    return self.isExactlyTypeError(object) ? PyTypeError(ptr: object.ptr) : nil
  }

  // MARK: - UnboundLocalError

  /// Is this object an instance of `UnboundLocalError` (or its subclass)?
  public func isUnboundLocalError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.unboundLocalError)
  }

  /// Is this object an instance of `UnboundLocalError` (but not its subclass)?
  public func isExactlyUnboundLocalError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.unboundLocalError)
  }

  /// Cast this object to `PyUnboundLocalError` if it is an `UnboundLocalError` (or its subclass).
  public func asUnboundLocalError(_ object: PyObject) -> PyUnboundLocalError? {
    return self.isUnboundLocalError(object) ? PyUnboundLocalError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUnboundLocalError` if it is an `UnboundLocalError` (but not its subclass).
  public func asExactlyUnboundLocalError(_ object: PyObject) -> PyUnboundLocalError? {
    return self.isExactlyUnboundLocalError(object) ? PyUnboundLocalError(ptr: object.ptr) : nil
  }

  // MARK: - UnicodeDecodeError

  /// Is this object an instance of `UnicodeDecodeError` (or its subclass)?
  public func isUnicodeDecodeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.unicodeDecodeError)
  }

  /// Is this object an instance of `UnicodeDecodeError` (but not its subclass)?
  public func isExactlyUnicodeDecodeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.unicodeDecodeError)
  }

  /// Cast this object to `PyUnicodeDecodeError` if it is an `UnicodeDecodeError` (or its subclass).
  public func asUnicodeDecodeError(_ object: PyObject) -> PyUnicodeDecodeError? {
    return self.isUnicodeDecodeError(object) ? PyUnicodeDecodeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUnicodeDecodeError` if it is an `UnicodeDecodeError` (but not its subclass).
  public func asExactlyUnicodeDecodeError(_ object: PyObject) -> PyUnicodeDecodeError? {
    return self.isExactlyUnicodeDecodeError(object) ? PyUnicodeDecodeError(ptr: object.ptr) : nil
  }

  // MARK: - UnicodeEncodeError

  /// Is this object an instance of `UnicodeEncodeError` (or its subclass)?
  public func isUnicodeEncodeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.unicodeEncodeError)
  }

  /// Is this object an instance of `UnicodeEncodeError` (but not its subclass)?
  public func isExactlyUnicodeEncodeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.unicodeEncodeError)
  }

  /// Cast this object to `PyUnicodeEncodeError` if it is an `UnicodeEncodeError` (or its subclass).
  public func asUnicodeEncodeError(_ object: PyObject) -> PyUnicodeEncodeError? {
    return self.isUnicodeEncodeError(object) ? PyUnicodeEncodeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUnicodeEncodeError` if it is an `UnicodeEncodeError` (but not its subclass).
  public func asExactlyUnicodeEncodeError(_ object: PyObject) -> PyUnicodeEncodeError? {
    return self.isExactlyUnicodeEncodeError(object) ? PyUnicodeEncodeError(ptr: object.ptr) : nil
  }

  // MARK: - UnicodeError

  /// Is this object an instance of `UnicodeError` (or its subclass)?
  public func isUnicodeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.unicodeError)
  }

  /// Is this object an instance of `UnicodeError` (but not its subclass)?
  public func isExactlyUnicodeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.unicodeError)
  }

  /// Cast this object to `PyUnicodeError` if it is an `UnicodeError` (or its subclass).
  public func asUnicodeError(_ object: PyObject) -> PyUnicodeError? {
    return self.isUnicodeError(object) ? PyUnicodeError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUnicodeError` if it is an `UnicodeError` (but not its subclass).
  public func asExactlyUnicodeError(_ object: PyObject) -> PyUnicodeError? {
    return self.isExactlyUnicodeError(object) ? PyUnicodeError(ptr: object.ptr) : nil
  }

  // MARK: - UnicodeTranslateError

  /// Is this object an instance of `UnicodeTranslateError` (or its subclass)?
  public func isUnicodeTranslateError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.unicodeTranslateError)
  }

  /// Is this object an instance of `UnicodeTranslateError` (but not its subclass)?
  public func isExactlyUnicodeTranslateError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.unicodeTranslateError)
  }

  /// Cast this object to `PyUnicodeTranslateError` if it is an `UnicodeTranslateError` (or its subclass).
  public func asUnicodeTranslateError(_ object: PyObject) -> PyUnicodeTranslateError? {
    return self.isUnicodeTranslateError(object) ? PyUnicodeTranslateError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUnicodeTranslateError` if it is an `UnicodeTranslateError` (but not its subclass).
  public func asExactlyUnicodeTranslateError(_ object: PyObject) -> PyUnicodeTranslateError? {
    return self.isExactlyUnicodeTranslateError(object) ? PyUnicodeTranslateError(ptr: object.ptr) : nil
  }

  // MARK: - UnicodeWarning

  /// Is this object an instance of `UnicodeWarning` (or its subclass)?
  public func isUnicodeWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.unicodeWarning)
  }

  /// Is this object an instance of `UnicodeWarning` (but not its subclass)?
  public func isExactlyUnicodeWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.unicodeWarning)
  }

  /// Cast this object to `PyUnicodeWarning` if it is an `UnicodeWarning` (or its subclass).
  public func asUnicodeWarning(_ object: PyObject) -> PyUnicodeWarning? {
    return self.isUnicodeWarning(object) ? PyUnicodeWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUnicodeWarning` if it is an `UnicodeWarning` (but not its subclass).
  public func asExactlyUnicodeWarning(_ object: PyObject) -> PyUnicodeWarning? {
    return self.isExactlyUnicodeWarning(object) ? PyUnicodeWarning(ptr: object.ptr) : nil
  }

  // MARK: - UserWarning

  /// Is this object an instance of `UserWarning` (or its subclass)?
  public func isUserWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.userWarning)
  }

  /// Is this object an instance of `UserWarning` (but not its subclass)?
  public func isExactlyUserWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.userWarning)
  }

  /// Cast this object to `PyUserWarning` if it is an `UserWarning` (or its subclass).
  public func asUserWarning(_ object: PyObject) -> PyUserWarning? {
    return self.isUserWarning(object) ? PyUserWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyUserWarning` if it is an `UserWarning` (but not its subclass).
  public func asExactlyUserWarning(_ object: PyObject) -> PyUserWarning? {
    return self.isExactlyUserWarning(object) ? PyUserWarning(ptr: object.ptr) : nil
  }

  // MARK: - ValueError

  /// Is this object an instance of `ValueError` (or its subclass)?
  public func isValueError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.valueError)
  }

  /// Is this object an instance of `ValueError` (but not its subclass)?
  public func isExactlyValueError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.valueError)
  }

  /// Cast this object to `PyValueError` if it is a `ValueError` (or its subclass).
  public func asValueError(_ object: PyObject) -> PyValueError? {
    return self.isValueError(object) ? PyValueError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyValueError` if it is a `ValueError` (but not its subclass).
  public func asExactlyValueError(_ object: PyObject) -> PyValueError? {
    return self.isExactlyValueError(object) ? PyValueError(ptr: object.ptr) : nil
  }

  // MARK: - Warning

  /// Is this object an instance of `Warning` (or its subclass)?
  public func isWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.warning)
  }

  /// Is this object an instance of `Warning` (but not its subclass)?
  public func isExactlyWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.warning)
  }

  /// Cast this object to `PyWarning` if it is a `Warning` (or its subclass).
  public func asWarning(_ object: PyObject) -> PyWarning? {
    return self.isWarning(object) ? PyWarning(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyWarning` if it is a `Warning` (but not its subclass).
  public func asExactlyWarning(_ object: PyObject) -> PyWarning? {
    return self.isExactlyWarning(object) ? PyWarning(ptr: object.ptr) : nil
  }

  // MARK: - ZeroDivisionError

  /// Is this object an instance of `ZeroDivisionError` (or its subclass)?
  public func isZeroDivisionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: self.errorTypes.zeroDivisionError)
  }

  /// Is this object an instance of `ZeroDivisionError` (but not its subclass)?
  public func isExactlyZeroDivisionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.errorTypes.zeroDivisionError)
  }

  /// Cast this object to `PyZeroDivisionError` if it is a `ZeroDivisionError` (or its subclass).
  public func asZeroDivisionError(_ object: PyObject) -> PyZeroDivisionError? {
    return self.isZeroDivisionError(object) ? PyZeroDivisionError(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyZeroDivisionError` if it is a `ZeroDivisionError` (but not its subclass).
  public func asExactlyZeroDivisionError(_ object: PyObject) -> PyZeroDivisionError? {
    return self.isExactlyZeroDivisionError(object) ? PyZeroDivisionError(ptr: object.ptr) : nil
  }
}
