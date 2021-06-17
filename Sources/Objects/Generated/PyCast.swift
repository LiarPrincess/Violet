// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// swiftlint:disable force_cast
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
/// if let int = PyCast.asInt(object) {
///   things…
/// }
/// ```
public enum PyCast {

  private static func isInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type.isSubtype(of: type)
  }

  private static func isExactlyInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type === type
  }

  // MARK: - Bool

  /// Is this object an instance of python `bool` type (or its subclass)?
  public static func isBool(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.bool)
  }

  /// Is this object an instance of a python `bool` type?
  /// Subclasses will return `false`.
  public static func isExactlyBool(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.bool)
  }

  /// Cast this object to `PyBool` if it is an instance of python `bool` type
  /// (or its subclass).
  public static func asBool(_ object: PyObject) -> PyBool? {
    return Self.isBool(object) ? (object as! PyBool) : nil
  }

  /// Cast this object to `PyBool` if it is an instance of python `bool` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBool(_ object: PyObject) -> PyBool? {
    return Self.isExactlyBool(object) ? (object as! PyBool) : nil
  }

  // MARK: - BuiltinFunction

  /// Is this object an instance of python `builtinFunction` type (or its subclass)?
  public static func isBuiltinFunction(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.builtinFunction)
  }

  /// Is this object an instance of a python `builtinFunction` type?
  /// Subclasses will return `false`.
  public static func isExactlyBuiltinFunction(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.builtinFunction)
  }

  /// Cast this object to `PyBuiltinFunction` if it is an instance of python `builtinFunction` type
  /// (or its subclass).
  public static func asBuiltinFunction(_ object: PyObject) -> PyBuiltinFunction? {
    return Self.isBuiltinFunction(object) ? (object as! PyBuiltinFunction) : nil
  }

  /// Cast this object to `PyBuiltinFunction` if it is an instance of python `builtinFunction` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBuiltinFunction(_ object: PyObject) -> PyBuiltinFunction? {
    return Self.isExactlyBuiltinFunction(object) ? (object as! PyBuiltinFunction) : nil
  }

  // MARK: - BuiltinMethod

  /// Is this object an instance of python `builtinMethod` type (or its subclass)?
  public static func isBuiltinMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.builtinMethod)
  }

  /// Is this object an instance of a python `builtinMethod` type?
  /// Subclasses will return `false`.
  public static func isExactlyBuiltinMethod(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.builtinMethod)
  }

  /// Cast this object to `PyBuiltinMethod` if it is an instance of python `builtinMethod` type
  /// (or its subclass).
  public static func asBuiltinMethod(_ object: PyObject) -> PyBuiltinMethod? {
    return Self.isBuiltinMethod(object) ? (object as! PyBuiltinMethod) : nil
  }

  /// Cast this object to `PyBuiltinMethod` if it is an instance of python `builtinMethod` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBuiltinMethod(_ object: PyObject) -> PyBuiltinMethod? {
    return Self.isExactlyBuiltinMethod(object) ? (object as! PyBuiltinMethod) : nil
  }

  // MARK: - ByteArray

  /// Is this object an instance of python `bytearray` type (or its subclass)?
  public static func isByteArray(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.bytearray)
  }

  /// Is this object an instance of a python `bytearray` type?
  /// Subclasses will return `false`.
  public static func isExactlyByteArray(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.bytearray)
  }

  /// Cast this object to `PyByteArray` if it is an instance of python `bytearray` type
  /// (or its subclass).
  public static func asByteArray(_ object: PyObject) -> PyByteArray? {
    return Self.isByteArray(object) ? (object as! PyByteArray) : nil
  }

  /// Cast this object to `PyByteArray` if it is an instance of python `bytearray` type.
  /// Subclasses will return `nil`.
  public static func asExactlyByteArray(_ object: PyObject) -> PyByteArray? {
    return Self.isExactlyByteArray(object) ? (object as! PyByteArray) : nil
  }

  // MARK: - ByteArrayIterator

  /// Is this object an instance of python `bytearray_iterator` type (or its subclass)?
  public static func isByteArrayIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.bytearray_iterator)
  }

  /// Is this object an instance of a python `bytearray_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyByteArrayIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.bytearray_iterator)
  }

  /// Cast this object to `PyByteArrayIterator` if it is an instance of python `bytearray_iterator` type
  /// (or its subclass).
  public static func asByteArrayIterator(_ object: PyObject) -> PyByteArrayIterator? {
    return Self.isByteArrayIterator(object) ? (object as! PyByteArrayIterator) : nil
  }

  /// Cast this object to `PyByteArrayIterator` if it is an instance of python `bytearray_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyByteArrayIterator(_ object: PyObject) -> PyByteArrayIterator? {
    return Self.isExactlyByteArrayIterator(object) ? (object as! PyByteArrayIterator) : nil
  }

  // MARK: - Bytes

  /// Is this object an instance of python `bytes` type (or its subclass)?
  public static func isBytes(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.bytes)
  }

  /// Is this object an instance of a python `bytes` type?
  /// Subclasses will return `false`.
  public static func isExactlyBytes(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.bytes)
  }

  /// Cast this object to `PyBytes` if it is an instance of python `bytes` type
  /// (or its subclass).
  public static func asBytes(_ object: PyObject) -> PyBytes? {
    return Self.isBytes(object) ? (object as! PyBytes) : nil
  }

  /// Cast this object to `PyBytes` if it is an instance of python `bytes` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBytes(_ object: PyObject) -> PyBytes? {
    return Self.isExactlyBytes(object) ? (object as! PyBytes) : nil
  }

  // MARK: - BytesIterator

  /// Is this object an instance of python `bytes_iterator` type (or its subclass)?
  public static func isBytesIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.bytes_iterator)
  }

  /// Is this object an instance of a python `bytes_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyBytesIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.bytes_iterator)
  }

  /// Cast this object to `PyBytesIterator` if it is an instance of python `bytes_iterator` type
  /// (or its subclass).
  public static func asBytesIterator(_ object: PyObject) -> PyBytesIterator? {
    return Self.isBytesIterator(object) ? (object as! PyBytesIterator) : nil
  }

  /// Cast this object to `PyBytesIterator` if it is an instance of python `bytes_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBytesIterator(_ object: PyObject) -> PyBytesIterator? {
    return Self.isExactlyBytesIterator(object) ? (object as! PyBytesIterator) : nil
  }

  // MARK: - CallableIterator

  /// Is this object an instance of python `callable_iterator` type (or its subclass)?
  public static func isCallableIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.callable_iterator)
  }

  /// Is this object an instance of a python `callable_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyCallableIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.callable_iterator)
  }

  /// Cast this object to `PyCallableIterator` if it is an instance of python `callable_iterator` type
  /// (or its subclass).
  public static func asCallableIterator(_ object: PyObject) -> PyCallableIterator? {
    return Self.isCallableIterator(object) ? (object as! PyCallableIterator) : nil
  }

  /// Cast this object to `PyCallableIterator` if it is an instance of python `callable_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyCallableIterator(_ object: PyObject) -> PyCallableIterator? {
    return Self.isExactlyCallableIterator(object) ? (object as! PyCallableIterator) : nil
  }

  // MARK: - Cell

  /// Is this object an instance of python `cell` type (or its subclass)?
  public static func isCell(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.cell)
  }

  /// Is this object an instance of a python `cell` type?
  /// Subclasses will return `false`.
  public static func isExactlyCell(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.cell)
  }

  /// Cast this object to `PyCell` if it is an instance of python `cell` type
  /// (or its subclass).
  public static func asCell(_ object: PyObject) -> PyCell? {
    return Self.isCell(object) ? (object as! PyCell) : nil
  }

  /// Cast this object to `PyCell` if it is an instance of python `cell` type.
  /// Subclasses will return `nil`.
  public static func asExactlyCell(_ object: PyObject) -> PyCell? {
    return Self.isExactlyCell(object) ? (object as! PyCell) : nil
  }

  // MARK: - ClassMethod

  /// Is this object an instance of python `classmethod` type (or its subclass)?
  public static func isClassMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.classmethod)
  }

  /// Is this object an instance of a python `classmethod` type?
  /// Subclasses will return `false`.
  public static func isExactlyClassMethod(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.classmethod)
  }

  /// Cast this object to `PyClassMethod` if it is an instance of python `classmethod` type
  /// (or its subclass).
  public static func asClassMethod(_ object: PyObject) -> PyClassMethod? {
    return Self.isClassMethod(object) ? (object as! PyClassMethod) : nil
  }

  /// Cast this object to `PyClassMethod` if it is an instance of python `classmethod` type.
  /// Subclasses will return `nil`.
  public static func asExactlyClassMethod(_ object: PyObject) -> PyClassMethod? {
    return Self.isExactlyClassMethod(object) ? (object as! PyClassMethod) : nil
  }

  // MARK: - Code

  /// Is this object an instance of python `code` type (or its subclass)?
  public static func isCode(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.code)
  }

  /// Is this object an instance of a python `code` type?
  /// Subclasses will return `false`.
  public static func isExactlyCode(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.code)
  }

  /// Cast this object to `PyCode` if it is an instance of python `code` type
  /// (or its subclass).
  public static func asCode(_ object: PyObject) -> PyCode? {
    return Self.isCode(object) ? (object as! PyCode) : nil
  }

  /// Cast this object to `PyCode` if it is an instance of python `code` type.
  /// Subclasses will return `nil`.
  public static func asExactlyCode(_ object: PyObject) -> PyCode? {
    return Self.isExactlyCode(object) ? (object as! PyCode) : nil
  }

  // MARK: - Complex

  /// Is this object an instance of python `complex` type (or its subclass)?
  public static func isComplex(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.complex)
  }

  /// Is this object an instance of a python `complex` type?
  /// Subclasses will return `false`.
  public static func isExactlyComplex(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.complex)
  }

  /// Cast this object to `PyComplex` if it is an instance of python `complex` type
  /// (or its subclass).
  public static func asComplex(_ object: PyObject) -> PyComplex? {
    return Self.isComplex(object) ? (object as! PyComplex) : nil
  }

  /// Cast this object to `PyComplex` if it is an instance of python `complex` type.
  /// Subclasses will return `nil`.
  public static func asExactlyComplex(_ object: PyObject) -> PyComplex? {
    return Self.isExactlyComplex(object) ? (object as! PyComplex) : nil
  }

  // MARK: - Dict

  /// Is this object an instance of python `dict` type (or its subclass)?
  public static func isDict(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict)
  }

  /// Is this object an instance of a python `dict` type?
  /// Subclasses will return `false`.
  public static func isExactlyDict(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict)
  }

  /// Cast this object to `PyDict` if it is an instance of python `dict` type
  /// (or its subclass).
  public static func asDict(_ object: PyObject) -> PyDict? {
    return Self.isDict(object) ? (object as! PyDict) : nil
  }

  /// Cast this object to `PyDict` if it is an instance of python `dict` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDict(_ object: PyObject) -> PyDict? {
    return Self.isExactlyDict(object) ? (object as! PyDict) : nil
  }

  // MARK: - DictItemIterator

  /// Is this object an instance of python `dict_itemiterator` type (or its subclass)?
  public static func isDictItemIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict_itemiterator)
  }

  /// Is this object an instance of a python `dict_itemiterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyDictItemIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict_itemiterator)
  }

  /// Cast this object to `PyDictItemIterator` if it is an instance of python `dict_itemiterator` type
  /// (or its subclass).
  public static func asDictItemIterator(_ object: PyObject) -> PyDictItemIterator? {
    return Self.isDictItemIterator(object) ? (object as! PyDictItemIterator) : nil
  }

  /// Cast this object to `PyDictItemIterator` if it is an instance of python `dict_itemiterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDictItemIterator(_ object: PyObject) -> PyDictItemIterator? {
    return Self.isExactlyDictItemIterator(object) ? (object as! PyDictItemIterator) : nil
  }

  // MARK: - DictItems

  /// Is this object an instance of python `dict_items` type (or its subclass)?
  public static func isDictItems(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict_items)
  }

  /// Is this object an instance of a python `dict_items` type?
  /// Subclasses will return `false`.
  public static func isExactlyDictItems(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict_items)
  }

  /// Cast this object to `PyDictItems` if it is an instance of python `dict_items` type
  /// (or its subclass).
  public static func asDictItems(_ object: PyObject) -> PyDictItems? {
    return Self.isDictItems(object) ? (object as! PyDictItems) : nil
  }

  /// Cast this object to `PyDictItems` if it is an instance of python `dict_items` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDictItems(_ object: PyObject) -> PyDictItems? {
    return Self.isExactlyDictItems(object) ? (object as! PyDictItems) : nil
  }

  // MARK: - DictKeyIterator

  /// Is this object an instance of python `dict_keyiterator` type (or its subclass)?
  public static func isDictKeyIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict_keyiterator)
  }

  /// Is this object an instance of a python `dict_keyiterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyDictKeyIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict_keyiterator)
  }

  /// Cast this object to `PyDictKeyIterator` if it is an instance of python `dict_keyiterator` type
  /// (or its subclass).
  public static func asDictKeyIterator(_ object: PyObject) -> PyDictKeyIterator? {
    return Self.isDictKeyIterator(object) ? (object as! PyDictKeyIterator) : nil
  }

  /// Cast this object to `PyDictKeyIterator` if it is an instance of python `dict_keyiterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDictKeyIterator(_ object: PyObject) -> PyDictKeyIterator? {
    return Self.isExactlyDictKeyIterator(object) ? (object as! PyDictKeyIterator) : nil
  }

  // MARK: - DictKeys

  /// Is this object an instance of python `dict_keys` type (or its subclass)?
  public static func isDictKeys(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict_keys)
  }

  /// Is this object an instance of a python `dict_keys` type?
  /// Subclasses will return `false`.
  public static func isExactlyDictKeys(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict_keys)
  }

  /// Cast this object to `PyDictKeys` if it is an instance of python `dict_keys` type
  /// (or its subclass).
  public static func asDictKeys(_ object: PyObject) -> PyDictKeys? {
    return Self.isDictKeys(object) ? (object as! PyDictKeys) : nil
  }

  /// Cast this object to `PyDictKeys` if it is an instance of python `dict_keys` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDictKeys(_ object: PyObject) -> PyDictKeys? {
    return Self.isExactlyDictKeys(object) ? (object as! PyDictKeys) : nil
  }

  // MARK: - DictValueIterator

  /// Is this object an instance of python `dict_valueiterator` type (or its subclass)?
  public static func isDictValueIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict_valueiterator)
  }

  /// Is this object an instance of a python `dict_valueiterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyDictValueIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict_valueiterator)
  }

  /// Cast this object to `PyDictValueIterator` if it is an instance of python `dict_valueiterator` type
  /// (or its subclass).
  public static func asDictValueIterator(_ object: PyObject) -> PyDictValueIterator? {
    return Self.isDictValueIterator(object) ? (object as! PyDictValueIterator) : nil
  }

  /// Cast this object to `PyDictValueIterator` if it is an instance of python `dict_valueiterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDictValueIterator(_ object: PyObject) -> PyDictValueIterator? {
    return Self.isExactlyDictValueIterator(object) ? (object as! PyDictValueIterator) : nil
  }

  // MARK: - DictValues

  /// Is this object an instance of python `dict_values` type (or its subclass)?
  public static func isDictValues(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.dict_values)
  }

  /// Is this object an instance of a python `dict_values` type?
  /// Subclasses will return `false`.
  public static func isExactlyDictValues(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.dict_values)
  }

  /// Cast this object to `PyDictValues` if it is an instance of python `dict_values` type
  /// (or its subclass).
  public static func asDictValues(_ object: PyObject) -> PyDictValues? {
    return Self.isDictValues(object) ? (object as! PyDictValues) : nil
  }

  /// Cast this object to `PyDictValues` if it is an instance of python `dict_values` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDictValues(_ object: PyObject) -> PyDictValues? {
    return Self.isExactlyDictValues(object) ? (object as! PyDictValues) : nil
  }

  // MARK: - Ellipsis

  /// Is this object an instance of python `ellipsis` type (or its subclass)?
  public static func isEllipsis(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.ellipsis)
  }

  /// Is this object an instance of a python `ellipsis` type?
  /// Subclasses will return `false`.
  public static func isExactlyEllipsis(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.ellipsis)
  }

  /// Cast this object to `PyEllipsis` if it is an instance of python `ellipsis` type
  /// (or its subclass).
  public static func asEllipsis(_ object: PyObject) -> PyEllipsis? {
    return Self.isEllipsis(object) ? (object as! PyEllipsis) : nil
  }

  /// Cast this object to `PyEllipsis` if it is an instance of python `ellipsis` type.
  /// Subclasses will return `nil`.
  public static func asExactlyEllipsis(_ object: PyObject) -> PyEllipsis? {
    return Self.isExactlyEllipsis(object) ? (object as! PyEllipsis) : nil
  }

  // MARK: - Enumerate

  /// Is this object an instance of python `enumerate` type (or its subclass)?
  public static func isEnumerate(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.enumerate)
  }

  /// Is this object an instance of a python `enumerate` type?
  /// Subclasses will return `false`.
  public static func isExactlyEnumerate(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.enumerate)
  }

  /// Cast this object to `PyEnumerate` if it is an instance of python `enumerate` type
  /// (or its subclass).
  public static func asEnumerate(_ object: PyObject) -> PyEnumerate? {
    return Self.isEnumerate(object) ? (object as! PyEnumerate) : nil
  }

  /// Cast this object to `PyEnumerate` if it is an instance of python `enumerate` type.
  /// Subclasses will return `nil`.
  public static func asExactlyEnumerate(_ object: PyObject) -> PyEnumerate? {
    return Self.isExactlyEnumerate(object) ? (object as! PyEnumerate) : nil
  }

  // MARK: - Filter

  /// Is this object an instance of python `filter` type (or its subclass)?
  public static func isFilter(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.filter)
  }

  /// Is this object an instance of a python `filter` type?
  /// Subclasses will return `false`.
  public static func isExactlyFilter(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.filter)
  }

  /// Cast this object to `PyFilter` if it is an instance of python `filter` type
  /// (or its subclass).
  public static func asFilter(_ object: PyObject) -> PyFilter? {
    return Self.isFilter(object) ? (object as! PyFilter) : nil
  }

  /// Cast this object to `PyFilter` if it is an instance of python `filter` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFilter(_ object: PyObject) -> PyFilter? {
    return Self.isExactlyFilter(object) ? (object as! PyFilter) : nil
  }

  // MARK: - Float

  /// Is this object an instance of python `float` type (or its subclass)?
  public static func isFloat(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.float)
  }

  /// Is this object an instance of a python `float` type?
  /// Subclasses will return `false`.
  public static func isExactlyFloat(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.float)
  }

  /// Cast this object to `PyFloat` if it is an instance of python `float` type
  /// (or its subclass).
  public static func asFloat(_ object: PyObject) -> PyFloat? {
    return Self.isFloat(object) ? (object as! PyFloat) : nil
  }

  /// Cast this object to `PyFloat` if it is an instance of python `float` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFloat(_ object: PyObject) -> PyFloat? {
    return Self.isExactlyFloat(object) ? (object as! PyFloat) : nil
  }

  // MARK: - Frame

  /// Is this object an instance of python `frame` type (or its subclass)?
  public static func isFrame(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.frame)
  }

  /// Is this object an instance of a python `frame` type?
  /// Subclasses will return `false`.
  public static func isExactlyFrame(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.frame)
  }

  /// Cast this object to `PyFrame` if it is an instance of python `frame` type
  /// (or its subclass).
  public static func asFrame(_ object: PyObject) -> PyFrame? {
    return Self.isFrame(object) ? (object as! PyFrame) : nil
  }

  /// Cast this object to `PyFrame` if it is an instance of python `frame` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFrame(_ object: PyObject) -> PyFrame? {
    return Self.isExactlyFrame(object) ? (object as! PyFrame) : nil
  }

  // MARK: - FrozenSet

  /// Is this object an instance of python `frozenset` type (or its subclass)?
  public static func isFrozenSet(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.frozenset)
  }

  /// Is this object an instance of a python `frozenset` type?
  /// Subclasses will return `false`.
  public static func isExactlyFrozenSet(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.frozenset)
  }

  /// Cast this object to `PyFrozenSet` if it is an instance of python `frozenset` type
  /// (or its subclass).
  public static func asFrozenSet(_ object: PyObject) -> PyFrozenSet? {
    return Self.isFrozenSet(object) ? (object as! PyFrozenSet) : nil
  }

  /// Cast this object to `PyFrozenSet` if it is an instance of python `frozenset` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFrozenSet(_ object: PyObject) -> PyFrozenSet? {
    return Self.isExactlyFrozenSet(object) ? (object as! PyFrozenSet) : nil
  }

  // MARK: - Function

  /// Is this object an instance of python `function` type (or its subclass)?
  public static func isFunction(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.function)
  }

  /// Is this object an instance of a python `function` type?
  /// Subclasses will return `false`.
  public static func isExactlyFunction(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.function)
  }

  /// Cast this object to `PyFunction` if it is an instance of python `function` type
  /// (or its subclass).
  public static func asFunction(_ object: PyObject) -> PyFunction? {
    return Self.isFunction(object) ? (object as! PyFunction) : nil
  }

  /// Cast this object to `PyFunction` if it is an instance of python `function` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFunction(_ object: PyObject) -> PyFunction? {
    return Self.isExactlyFunction(object) ? (object as! PyFunction) : nil
  }

  // MARK: - Int

  /// Is this object an instance of python `int` type (or its subclass)?
  public static func isInt(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.int)
  }

  /// Is this object an instance of a python `int` type?
  /// Subclasses will return `false`.
  public static func isExactlyInt(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.int)
  }

  /// Cast this object to `PyInt` if it is an instance of python `int` type
  /// (or its subclass).
  public static func asInt(_ object: PyObject) -> PyInt? {
    return Self.isInt(object) ? (object as! PyInt) : nil
  }

  /// Cast this object to `PyInt` if it is an instance of python `int` type.
  /// Subclasses will return `nil`.
  public static func asExactlyInt(_ object: PyObject) -> PyInt? {
    return Self.isExactlyInt(object) ? (object as! PyInt) : nil
  }

  // MARK: - Iterator

  /// Is this object an instance of python `iterator` type (or its subclass)?
  public static func isIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.iterator)
  }

  /// Is this object an instance of a python `iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.iterator)
  }

  /// Cast this object to `PyIterator` if it is an instance of python `iterator` type
  /// (or its subclass).
  public static func asIterator(_ object: PyObject) -> PyIterator? {
    return Self.isIterator(object) ? (object as! PyIterator) : nil
  }

  /// Cast this object to `PyIterator` if it is an instance of python `iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyIterator(_ object: PyObject) -> PyIterator? {
    return Self.isExactlyIterator(object) ? (object as! PyIterator) : nil
  }

  // MARK: - List

  /// Is this object an instance of python `list` type (or its subclass)?
  public static func isList(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.list)
  }

  /// Is this object an instance of a python `list` type?
  /// Subclasses will return `false`.
  public static func isExactlyList(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.list)
  }

  /// Cast this object to `PyList` if it is an instance of python `list` type
  /// (or its subclass).
  public static func asList(_ object: PyObject) -> PyList? {
    return Self.isList(object) ? (object as! PyList) : nil
  }

  /// Cast this object to `PyList` if it is an instance of python `list` type.
  /// Subclasses will return `nil`.
  public static func asExactlyList(_ object: PyObject) -> PyList? {
    return Self.isExactlyList(object) ? (object as! PyList) : nil
  }

  // MARK: - ListIterator

  /// Is this object an instance of python `list_iterator` type (or its subclass)?
  public static func isListIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.list_iterator)
  }

  /// Is this object an instance of a python `list_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyListIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.list_iterator)
  }

  /// Cast this object to `PyListIterator` if it is an instance of python `list_iterator` type
  /// (or its subclass).
  public static func asListIterator(_ object: PyObject) -> PyListIterator? {
    return Self.isListIterator(object) ? (object as! PyListIterator) : nil
  }

  /// Cast this object to `PyListIterator` if it is an instance of python `list_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyListIterator(_ object: PyObject) -> PyListIterator? {
    return Self.isExactlyListIterator(object) ? (object as! PyListIterator) : nil
  }

  // MARK: - ListReverseIterator

  /// Is this object an instance of python `list_reverseiterator` type (or its subclass)?
  public static func isListReverseIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.list_reverseiterator)
  }

  /// Is this object an instance of a python `list_reverseiterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyListReverseIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.list_reverseiterator)
  }

  /// Cast this object to `PyListReverseIterator` if it is an instance of python `list_reverseiterator` type
  /// (or its subclass).
  public static func asListReverseIterator(_ object: PyObject) -> PyListReverseIterator? {
    return Self.isListReverseIterator(object) ? (object as! PyListReverseIterator) : nil
  }

  /// Cast this object to `PyListReverseIterator` if it is an instance of python `list_reverseiterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyListReverseIterator(_ object: PyObject) -> PyListReverseIterator? {
    return Self.isExactlyListReverseIterator(object) ? (object as! PyListReverseIterator) : nil
  }

  // MARK: - Map

  /// Is this object an instance of python `map` type (or its subclass)?
  public static func isMap(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.map)
  }

  /// Is this object an instance of a python `map` type?
  /// Subclasses will return `false`.
  public static func isExactlyMap(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.map)
  }

  /// Cast this object to `PyMap` if it is an instance of python `map` type
  /// (or its subclass).
  public static func asMap(_ object: PyObject) -> PyMap? {
    return Self.isMap(object) ? (object as! PyMap) : nil
  }

  /// Cast this object to `PyMap` if it is an instance of python `map` type.
  /// Subclasses will return `nil`.
  public static func asExactlyMap(_ object: PyObject) -> PyMap? {
    return Self.isExactlyMap(object) ? (object as! PyMap) : nil
  }

  // MARK: - Method

  /// Is this object an instance of python `method` type (or its subclass)?
  public static func isMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.method)
  }

  /// Is this object an instance of a python `method` type?
  /// Subclasses will return `false`.
  public static func isExactlyMethod(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.method)
  }

  /// Cast this object to `PyMethod` if it is an instance of python `method` type
  /// (or its subclass).
  public static func asMethod(_ object: PyObject) -> PyMethod? {
    return Self.isMethod(object) ? (object as! PyMethod) : nil
  }

  /// Cast this object to `PyMethod` if it is an instance of python `method` type.
  /// Subclasses will return `nil`.
  public static func asExactlyMethod(_ object: PyObject) -> PyMethod? {
    return Self.isExactlyMethod(object) ? (object as! PyMethod) : nil
  }

  // MARK: - Module

  /// Is this object an instance of python `module` type (or its subclass)?
  public static func isModule(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.module)
  }

  /// Is this object an instance of a python `module` type?
  /// Subclasses will return `false`.
  public static func isExactlyModule(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.module)
  }

  /// Cast this object to `PyModule` if it is an instance of python `module` type
  /// (or its subclass).
  public static func asModule(_ object: PyObject) -> PyModule? {
    return Self.isModule(object) ? (object as! PyModule) : nil
  }

  /// Cast this object to `PyModule` if it is an instance of python `module` type.
  /// Subclasses will return `nil`.
  public static func asExactlyModule(_ object: PyObject) -> PyModule? {
    return Self.isExactlyModule(object) ? (object as! PyModule) : nil
  }

  // MARK: - Namespace

  /// Is this object an instance of python `types.SimpleNamespace` type (or its subclass)?
  public static func isNamespace(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.simpleNamespace)
  }

  /// Is this object an instance of a python `types.SimpleNamespace` type?
  /// Subclasses will return `false`.
  public static func isExactlyNamespace(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.simpleNamespace)
  }

  /// Cast this object to `PyNamespace` if it is an instance of python `types.SimpleNamespace` type
  /// (or its subclass).
  public static func asNamespace(_ object: PyObject) -> PyNamespace? {
    return Self.isNamespace(object) ? (object as! PyNamespace) : nil
  }

  /// Cast this object to `PyNamespace` if it is an instance of python `types.SimpleNamespace` type.
  /// Subclasses will return `nil`.
  public static func asExactlyNamespace(_ object: PyObject) -> PyNamespace? {
    return Self.isExactlyNamespace(object) ? (object as! PyNamespace) : nil
  }

  // MARK: - None

  /// Is this object an instance of python `NoneType` type (or its subclass)?
  public static func isNone(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.none)
  }

  /// Is this object an instance of a python `NoneType` type?
  /// Subclasses will return `false`.
  public static func isExactlyNone(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.none)
  }

  /// Cast this object to `PyNone` if it is an instance of python `NoneType` type
  /// (or its subclass).
  public static func asNone(_ object: PyObject) -> PyNone? {
    return Self.isNone(object) ? (object as! PyNone) : nil
  }

  /// Cast this object to `PyNone` if it is an instance of python `NoneType` type.
  /// Subclasses will return `nil`.
  public static func asExactlyNone(_ object: PyObject) -> PyNone? {
    return Self.isExactlyNone(object) ? (object as! PyNone) : nil
  }

  // MARK: - NotImplemented

  /// Is this object an instance of python `NotImplementedType` type (or its subclass)?
  public static func isNotImplemented(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.notImplemented)
  }

  /// Is this object an instance of a python `NotImplementedType` type?
  /// Subclasses will return `false`.
  public static func isExactlyNotImplemented(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.notImplemented)
  }

  /// Cast this object to `PyNotImplemented` if it is an instance of python `NotImplementedType` type
  /// (or its subclass).
  public static func asNotImplemented(_ object: PyObject) -> PyNotImplemented? {
    return Self.isNotImplemented(object) ? (object as! PyNotImplemented) : nil
  }

  /// Cast this object to `PyNotImplemented` if it is an instance of python `NotImplementedType` type.
  /// Subclasses will return `nil`.
  public static func asExactlyNotImplemented(_ object: PyObject) -> PyNotImplemented? {
    return Self.isExactlyNotImplemented(object) ? (object as! PyNotImplemented) : nil
  }

  // MARK: - Property

  /// Is this object an instance of python `property` type (or its subclass)?
  public static func isProperty(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.property)
  }

  /// Is this object an instance of a python `property` type?
  /// Subclasses will return `false`.
  public static func isExactlyProperty(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.property)
  }

  /// Cast this object to `PyProperty` if it is an instance of python `property` type
  /// (or its subclass).
  public static func asProperty(_ object: PyObject) -> PyProperty? {
    return Self.isProperty(object) ? (object as! PyProperty) : nil
  }

  /// Cast this object to `PyProperty` if it is an instance of python `property` type.
  /// Subclasses will return `nil`.
  public static func asExactlyProperty(_ object: PyObject) -> PyProperty? {
    return Self.isExactlyProperty(object) ? (object as! PyProperty) : nil
  }

  // MARK: - Range

  /// Is this object an instance of python `range` type (or its subclass)?
  public static func isRange(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.range)
  }

  /// Is this object an instance of a python `range` type?
  /// Subclasses will return `false`.
  public static func isExactlyRange(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.range)
  }

  /// Cast this object to `PyRange` if it is an instance of python `range` type
  /// (or its subclass).
  public static func asRange(_ object: PyObject) -> PyRange? {
    return Self.isRange(object) ? (object as! PyRange) : nil
  }

  /// Cast this object to `PyRange` if it is an instance of python `range` type.
  /// Subclasses will return `nil`.
  public static func asExactlyRange(_ object: PyObject) -> PyRange? {
    return Self.isExactlyRange(object) ? (object as! PyRange) : nil
  }

  // MARK: - RangeIterator

  /// Is this object an instance of python `range_iterator` type (or its subclass)?
  public static func isRangeIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.range_iterator)
  }

  /// Is this object an instance of a python `range_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyRangeIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.range_iterator)
  }

  /// Cast this object to `PyRangeIterator` if it is an instance of python `range_iterator` type
  /// (or its subclass).
  public static func asRangeIterator(_ object: PyObject) -> PyRangeIterator? {
    return Self.isRangeIterator(object) ? (object as! PyRangeIterator) : nil
  }

  /// Cast this object to `PyRangeIterator` if it is an instance of python `range_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyRangeIterator(_ object: PyObject) -> PyRangeIterator? {
    return Self.isExactlyRangeIterator(object) ? (object as! PyRangeIterator) : nil
  }

  // MARK: - Reversed

  /// Is this object an instance of python `reversed` type (or its subclass)?
  public static func isReversed(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.reversed)
  }

  /// Is this object an instance of a python `reversed` type?
  /// Subclasses will return `false`.
  public static func isExactlyReversed(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.reversed)
  }

  /// Cast this object to `PyReversed` if it is an instance of python `reversed` type
  /// (or its subclass).
  public static func asReversed(_ object: PyObject) -> PyReversed? {
    return Self.isReversed(object) ? (object as! PyReversed) : nil
  }

  /// Cast this object to `PyReversed` if it is an instance of python `reversed` type.
  /// Subclasses will return `nil`.
  public static func asExactlyReversed(_ object: PyObject) -> PyReversed? {
    return Self.isExactlyReversed(object) ? (object as! PyReversed) : nil
  }

  // MARK: - Set

  /// Is this object an instance of python `set` type (or its subclass)?
  public static func isSet(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.set)
  }

  /// Is this object an instance of a python `set` type?
  /// Subclasses will return `false`.
  public static func isExactlySet(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.set)
  }

  /// Cast this object to `PySet` if it is an instance of python `set` type
  /// (or its subclass).
  public static func asSet(_ object: PyObject) -> PySet? {
    return Self.isSet(object) ? (object as! PySet) : nil
  }

  /// Cast this object to `PySet` if it is an instance of python `set` type.
  /// Subclasses will return `nil`.
  public static func asExactlySet(_ object: PyObject) -> PySet? {
    return Self.isExactlySet(object) ? (object as! PySet) : nil
  }

  // MARK: - SetIterator

  /// Is this object an instance of python `set_iterator` type (or its subclass)?
  public static func isSetIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.set_iterator)
  }

  /// Is this object an instance of a python `set_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlySetIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.set_iterator)
  }

  /// Cast this object to `PySetIterator` if it is an instance of python `set_iterator` type
  /// (or its subclass).
  public static func asSetIterator(_ object: PyObject) -> PySetIterator? {
    return Self.isSetIterator(object) ? (object as! PySetIterator) : nil
  }

  /// Cast this object to `PySetIterator` if it is an instance of python `set_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlySetIterator(_ object: PyObject) -> PySetIterator? {
    return Self.isExactlySetIterator(object) ? (object as! PySetIterator) : nil
  }

  // MARK: - Slice

  /// Is this object an instance of python `slice` type (or its subclass)?
  public static func isSlice(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.slice)
  }

  /// Is this object an instance of a python `slice` type?
  /// Subclasses will return `false`.
  public static func isExactlySlice(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.slice)
  }

  /// Cast this object to `PySlice` if it is an instance of python `slice` type
  /// (or its subclass).
  public static func asSlice(_ object: PyObject) -> PySlice? {
    return Self.isSlice(object) ? (object as! PySlice) : nil
  }

  /// Cast this object to `PySlice` if it is an instance of python `slice` type.
  /// Subclasses will return `nil`.
  public static func asExactlySlice(_ object: PyObject) -> PySlice? {
    return Self.isExactlySlice(object) ? (object as! PySlice) : nil
  }

  // MARK: - StaticMethod

  /// Is this object an instance of python `staticmethod` type (or its subclass)?
  public static func isStaticMethod(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.staticmethod)
  }

  /// Is this object an instance of a python `staticmethod` type?
  /// Subclasses will return `false`.
  public static func isExactlyStaticMethod(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.staticmethod)
  }

  /// Cast this object to `PyStaticMethod` if it is an instance of python `staticmethod` type
  /// (or its subclass).
  public static func asStaticMethod(_ object: PyObject) -> PyStaticMethod? {
    return Self.isStaticMethod(object) ? (object as! PyStaticMethod) : nil
  }

  /// Cast this object to `PyStaticMethod` if it is an instance of python `staticmethod` type.
  /// Subclasses will return `nil`.
  public static func asExactlyStaticMethod(_ object: PyObject) -> PyStaticMethod? {
    return Self.isExactlyStaticMethod(object) ? (object as! PyStaticMethod) : nil
  }

  // MARK: - String

  /// Is this object an instance of python `str` type (or its subclass)?
  public static func isString(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.str)
  }

  /// Is this object an instance of a python `str` type?
  /// Subclasses will return `false`.
  public static func isExactlyString(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.str)
  }

  /// Cast this object to `PyString` if it is an instance of python `str` type
  /// (or its subclass).
  public static func asString(_ object: PyObject) -> PyString? {
    return Self.isString(object) ? (object as! PyString) : nil
  }

  /// Cast this object to `PyString` if it is an instance of python `str` type.
  /// Subclasses will return `nil`.
  public static func asExactlyString(_ object: PyObject) -> PyString? {
    return Self.isExactlyString(object) ? (object as! PyString) : nil
  }

  // MARK: - StringIterator

  /// Is this object an instance of python `str_iterator` type (or its subclass)?
  public static func isStringIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.str_iterator)
  }

  /// Is this object an instance of a python `str_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyStringIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.str_iterator)
  }

  /// Cast this object to `PyStringIterator` if it is an instance of python `str_iterator` type
  /// (or its subclass).
  public static func asStringIterator(_ object: PyObject) -> PyStringIterator? {
    return Self.isStringIterator(object) ? (object as! PyStringIterator) : nil
  }

  /// Cast this object to `PyStringIterator` if it is an instance of python `str_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyStringIterator(_ object: PyObject) -> PyStringIterator? {
    return Self.isExactlyStringIterator(object) ? (object as! PyStringIterator) : nil
  }

  // MARK: - Super

  /// Is this object an instance of python `super` type (or its subclass)?
  public static func isSuper(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.`super`)
  }

  /// Is this object an instance of a python `super` type?
  /// Subclasses will return `false`.
  public static func isExactlySuper(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.`super`)
  }

  /// Cast this object to `PySuper` if it is an instance of python `super` type
  /// (or its subclass).
  public static func asSuper(_ object: PyObject) -> PySuper? {
    return Self.isSuper(object) ? (object as! PySuper) : nil
  }

  /// Cast this object to `PySuper` if it is an instance of python `super` type.
  /// Subclasses will return `nil`.
  public static func asExactlySuper(_ object: PyObject) -> PySuper? {
    return Self.isExactlySuper(object) ? (object as! PySuper) : nil
  }

  // MARK: - TextFile

  /// Is this object an instance of python `TextFile` type (or its subclass)?
  public static func isTextFile(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.textFile)
  }

  /// Is this object an instance of a python `TextFile` type?
  /// Subclasses will return `false`.
  public static func isExactlyTextFile(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.textFile)
  }

  /// Cast this object to `PyTextFile` if it is an instance of python `TextFile` type
  /// (or its subclass).
  public static func asTextFile(_ object: PyObject) -> PyTextFile? {
    return Self.isTextFile(object) ? (object as! PyTextFile) : nil
  }

  /// Cast this object to `PyTextFile` if it is an instance of python `TextFile` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTextFile(_ object: PyObject) -> PyTextFile? {
    return Self.isExactlyTextFile(object) ? (object as! PyTextFile) : nil
  }

  // MARK: - Traceback

  /// Is this object an instance of python `traceback` type (or its subclass)?
  public static func isTraceback(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.traceback)
  }

  /// Is this object an instance of a python `traceback` type?
  /// Subclasses will return `false`.
  public static func isExactlyTraceback(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.traceback)
  }

  /// Cast this object to `PyTraceback` if it is an instance of python `traceback` type
  /// (or its subclass).
  public static func asTraceback(_ object: PyObject) -> PyTraceback? {
    return Self.isTraceback(object) ? (object as! PyTraceback) : nil
  }

  /// Cast this object to `PyTraceback` if it is an instance of python `traceback` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTraceback(_ object: PyObject) -> PyTraceback? {
    return Self.isExactlyTraceback(object) ? (object as! PyTraceback) : nil
  }

  // MARK: - Tuple

  /// Is this object an instance of python `tuple` type (or its subclass)?
  public static func isTuple(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.tuple)
  }

  /// Is this object an instance of a python `tuple` type?
  /// Subclasses will return `false`.
  public static func isExactlyTuple(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.tuple)
  }

  /// Cast this object to `PyTuple` if it is an instance of python `tuple` type
  /// (or its subclass).
  public static func asTuple(_ object: PyObject) -> PyTuple? {
    return Self.isTuple(object) ? (object as! PyTuple) : nil
  }

  /// Cast this object to `PyTuple` if it is an instance of python `tuple` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTuple(_ object: PyObject) -> PyTuple? {
    return Self.isExactlyTuple(object) ? (object as! PyTuple) : nil
  }

  // MARK: - TupleIterator

  /// Is this object an instance of python `tuple_iterator` type (or its subclass)?
  public static func isTupleIterator(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.tuple_iterator)
  }

  /// Is this object an instance of a python `tuple_iterator` type?
  /// Subclasses will return `false`.
  public static func isExactlyTupleIterator(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.tuple_iterator)
  }

  /// Cast this object to `PyTupleIterator` if it is an instance of python `tuple_iterator` type
  /// (or its subclass).
  public static func asTupleIterator(_ object: PyObject) -> PyTupleIterator? {
    return Self.isTupleIterator(object) ? (object as! PyTupleIterator) : nil
  }

  /// Cast this object to `PyTupleIterator` if it is an instance of python `tuple_iterator` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTupleIterator(_ object: PyObject) -> PyTupleIterator? {
    return Self.isExactlyTupleIterator(object) ? (object as! PyTupleIterator) : nil
  }

  // MARK: - Type

  /// Is this object an instance of python `type` type (or its subclass)?
  public static func isType(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.type)
  }

  /// Is this object an instance of a python `type` type?
  /// Subclasses will return `false`.
  public static func isExactlyType(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.type)
  }

  /// Cast this object to `PyType` if it is an instance of python `type` type
  /// (or its subclass).
  public static func asType(_ object: PyObject) -> PyType? {
    return Self.isType(object) ? (object as! PyType) : nil
  }

  /// Cast this object to `PyType` if it is an instance of python `type` type.
  /// Subclasses will return `nil`.
  public static func asExactlyType(_ object: PyObject) -> PyType? {
    return Self.isExactlyType(object) ? (object as! PyType) : nil
  }

  // MARK: - Zip

  /// Is this object an instance of python `zip` type (or its subclass)?
  public static func isZip(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.types.zip)
  }

  /// Is this object an instance of a python `zip` type?
  /// Subclasses will return `false`.
  public static func isExactlyZip(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.types.zip)
  }

  /// Cast this object to `PyZip` if it is an instance of python `zip` type
  /// (or its subclass).
  public static func asZip(_ object: PyObject) -> PyZip? {
    return Self.isZip(object) ? (object as! PyZip) : nil
  }

  /// Cast this object to `PyZip` if it is an instance of python `zip` type.
  /// Subclasses will return `nil`.
  public static func asExactlyZip(_ object: PyObject) -> PyZip? {
    return Self.isExactlyZip(object) ? (object as! PyZip) : nil
  }

  // MARK: - ArithmeticError

  /// Is this object an instance of python `ArithmeticError` type (or its subclass)?
  public static func isArithmeticError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.arithmeticError)
  }

  /// Is this object an instance of a python `ArithmeticError` type?
  /// Subclasses will return `false`.
  public static func isExactlyArithmeticError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.arithmeticError)
  }

  /// Cast this object to `PyArithmeticError` if it is an instance of python `ArithmeticError` type
  /// (or its subclass).
  public static func asArithmeticError(_ object: PyObject) -> PyArithmeticError? {
    return Self.isArithmeticError(object) ? (object as! PyArithmeticError) : nil
  }

  /// Cast this object to `PyArithmeticError` if it is an instance of python `ArithmeticError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyArithmeticError(_ object: PyObject) -> PyArithmeticError? {
    return Self.isExactlyArithmeticError(object) ? (object as! PyArithmeticError) : nil
  }

  // MARK: - AssertionError

  /// Is this object an instance of python `AssertionError` type (or its subclass)?
  public static func isAssertionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.assertionError)
  }

  /// Is this object an instance of a python `AssertionError` type?
  /// Subclasses will return `false`.
  public static func isExactlyAssertionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.assertionError)
  }

  /// Cast this object to `PyAssertionError` if it is an instance of python `AssertionError` type
  /// (or its subclass).
  public static func asAssertionError(_ object: PyObject) -> PyAssertionError? {
    return Self.isAssertionError(object) ? (object as! PyAssertionError) : nil
  }

  /// Cast this object to `PyAssertionError` if it is an instance of python `AssertionError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyAssertionError(_ object: PyObject) -> PyAssertionError? {
    return Self.isExactlyAssertionError(object) ? (object as! PyAssertionError) : nil
  }

  // MARK: - AttributeError

  /// Is this object an instance of python `AttributeError` type (or its subclass)?
  public static func isAttributeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.attributeError)
  }

  /// Is this object an instance of a python `AttributeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyAttributeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.attributeError)
  }

  /// Cast this object to `PyAttributeError` if it is an instance of python `AttributeError` type
  /// (or its subclass).
  public static func asAttributeError(_ object: PyObject) -> PyAttributeError? {
    return Self.isAttributeError(object) ? (object as! PyAttributeError) : nil
  }

  /// Cast this object to `PyAttributeError` if it is an instance of python `AttributeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyAttributeError(_ object: PyObject) -> PyAttributeError? {
    return Self.isExactlyAttributeError(object) ? (object as! PyAttributeError) : nil
  }

  // MARK: - BaseException

  /// Is this object an instance of python `BaseException` type (or its subclass)?
  public static func isBaseException(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.baseException)
  }

  /// Is this object an instance of a python `BaseException` type?
  /// Subclasses will return `false`.
  public static func isExactlyBaseException(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.baseException)
  }

  /// Cast this object to `PyBaseException` if it is an instance of python `BaseException` type
  /// (or its subclass).
  public static func asBaseException(_ object: PyObject) -> PyBaseException? {
    return Self.isBaseException(object) ? (object as! PyBaseException) : nil
  }

  /// Cast this object to `PyBaseException` if it is an instance of python `BaseException` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBaseException(_ object: PyObject) -> PyBaseException? {
    return Self.isExactlyBaseException(object) ? (object as! PyBaseException) : nil
  }

  // MARK: - BlockingIOError

  /// Is this object an instance of python `BlockingIOError` type (or its subclass)?
  public static func isBlockingIOError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.blockingIOError)
  }

  /// Is this object an instance of a python `BlockingIOError` type?
  /// Subclasses will return `false`.
  public static func isExactlyBlockingIOError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.blockingIOError)
  }

  /// Cast this object to `PyBlockingIOError` if it is an instance of python `BlockingIOError` type
  /// (or its subclass).
  public static func asBlockingIOError(_ object: PyObject) -> PyBlockingIOError? {
    return Self.isBlockingIOError(object) ? (object as! PyBlockingIOError) : nil
  }

  /// Cast this object to `PyBlockingIOError` if it is an instance of python `BlockingIOError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBlockingIOError(_ object: PyObject) -> PyBlockingIOError? {
    return Self.isExactlyBlockingIOError(object) ? (object as! PyBlockingIOError) : nil
  }

  // MARK: - BrokenPipeError

  /// Is this object an instance of python `BrokenPipeError` type (or its subclass)?
  public static func isBrokenPipeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.brokenPipeError)
  }

  /// Is this object an instance of a python `BrokenPipeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyBrokenPipeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.brokenPipeError)
  }

  /// Cast this object to `PyBrokenPipeError` if it is an instance of python `BrokenPipeError` type
  /// (or its subclass).
  public static func asBrokenPipeError(_ object: PyObject) -> PyBrokenPipeError? {
    return Self.isBrokenPipeError(object) ? (object as! PyBrokenPipeError) : nil
  }

  /// Cast this object to `PyBrokenPipeError` if it is an instance of python `BrokenPipeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBrokenPipeError(_ object: PyObject) -> PyBrokenPipeError? {
    return Self.isExactlyBrokenPipeError(object) ? (object as! PyBrokenPipeError) : nil
  }

  // MARK: - BufferError

  /// Is this object an instance of python `BufferError` type (or its subclass)?
  public static func isBufferError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.bufferError)
  }

  /// Is this object an instance of a python `BufferError` type?
  /// Subclasses will return `false`.
  public static func isExactlyBufferError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.bufferError)
  }

  /// Cast this object to `PyBufferError` if it is an instance of python `BufferError` type
  /// (or its subclass).
  public static func asBufferError(_ object: PyObject) -> PyBufferError? {
    return Self.isBufferError(object) ? (object as! PyBufferError) : nil
  }

  /// Cast this object to `PyBufferError` if it is an instance of python `BufferError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBufferError(_ object: PyObject) -> PyBufferError? {
    return Self.isExactlyBufferError(object) ? (object as! PyBufferError) : nil
  }

  // MARK: - BytesWarning

  /// Is this object an instance of python `BytesWarning` type (or its subclass)?
  public static func isBytesWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.bytesWarning)
  }

  /// Is this object an instance of a python `BytesWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyBytesWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.bytesWarning)
  }

  /// Cast this object to `PyBytesWarning` if it is an instance of python `BytesWarning` type
  /// (or its subclass).
  public static func asBytesWarning(_ object: PyObject) -> PyBytesWarning? {
    return Self.isBytesWarning(object) ? (object as! PyBytesWarning) : nil
  }

  /// Cast this object to `PyBytesWarning` if it is an instance of python `BytesWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyBytesWarning(_ object: PyObject) -> PyBytesWarning? {
    return Self.isExactlyBytesWarning(object) ? (object as! PyBytesWarning) : nil
  }

  // MARK: - ChildProcessError

  /// Is this object an instance of python `ChildProcessError` type (or its subclass)?
  public static func isChildProcessError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.childProcessError)
  }

  /// Is this object an instance of a python `ChildProcessError` type?
  /// Subclasses will return `false`.
  public static func isExactlyChildProcessError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.childProcessError)
  }

  /// Cast this object to `PyChildProcessError` if it is an instance of python `ChildProcessError` type
  /// (or its subclass).
  public static func asChildProcessError(_ object: PyObject) -> PyChildProcessError? {
    return Self.isChildProcessError(object) ? (object as! PyChildProcessError) : nil
  }

  /// Cast this object to `PyChildProcessError` if it is an instance of python `ChildProcessError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyChildProcessError(_ object: PyObject) -> PyChildProcessError? {
    return Self.isExactlyChildProcessError(object) ? (object as! PyChildProcessError) : nil
  }

  // MARK: - ConnectionAbortedError

  /// Is this object an instance of python `ConnectionAbortedError` type (or its subclass)?
  public static func isConnectionAbortedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.connectionAbortedError)
  }

  /// Is this object an instance of a python `ConnectionAbortedError` type?
  /// Subclasses will return `false`.
  public static func isExactlyConnectionAbortedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.connectionAbortedError)
  }

  /// Cast this object to `PyConnectionAbortedError` if it is an instance of python `ConnectionAbortedError` type
  /// (or its subclass).
  public static func asConnectionAbortedError(_ object: PyObject) -> PyConnectionAbortedError? {
    return Self.isConnectionAbortedError(object) ? (object as! PyConnectionAbortedError) : nil
  }

  /// Cast this object to `PyConnectionAbortedError` if it is an instance of python `ConnectionAbortedError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyConnectionAbortedError(_ object: PyObject) -> PyConnectionAbortedError? {
    return Self.isExactlyConnectionAbortedError(object) ? (object as! PyConnectionAbortedError) : nil
  }

  // MARK: - ConnectionError

  /// Is this object an instance of python `ConnectionError` type (or its subclass)?
  public static func isConnectionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.connectionError)
  }

  /// Is this object an instance of a python `ConnectionError` type?
  /// Subclasses will return `false`.
  public static func isExactlyConnectionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.connectionError)
  }

  /// Cast this object to `PyConnectionError` if it is an instance of python `ConnectionError` type
  /// (or its subclass).
  public static func asConnectionError(_ object: PyObject) -> PyConnectionError? {
    return Self.isConnectionError(object) ? (object as! PyConnectionError) : nil
  }

  /// Cast this object to `PyConnectionError` if it is an instance of python `ConnectionError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyConnectionError(_ object: PyObject) -> PyConnectionError? {
    return Self.isExactlyConnectionError(object) ? (object as! PyConnectionError) : nil
  }

  // MARK: - ConnectionRefusedError

  /// Is this object an instance of python `ConnectionRefusedError` type (or its subclass)?
  public static func isConnectionRefusedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.connectionRefusedError)
  }

  /// Is this object an instance of a python `ConnectionRefusedError` type?
  /// Subclasses will return `false`.
  public static func isExactlyConnectionRefusedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.connectionRefusedError)
  }

  /// Cast this object to `PyConnectionRefusedError` if it is an instance of python `ConnectionRefusedError` type
  /// (or its subclass).
  public static func asConnectionRefusedError(_ object: PyObject) -> PyConnectionRefusedError? {
    return Self.isConnectionRefusedError(object) ? (object as! PyConnectionRefusedError) : nil
  }

  /// Cast this object to `PyConnectionRefusedError` if it is an instance of python `ConnectionRefusedError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyConnectionRefusedError(_ object: PyObject) -> PyConnectionRefusedError? {
    return Self.isExactlyConnectionRefusedError(object) ? (object as! PyConnectionRefusedError) : nil
  }

  // MARK: - ConnectionResetError

  /// Is this object an instance of python `ConnectionResetError` type (or its subclass)?
  public static func isConnectionResetError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.connectionResetError)
  }

  /// Is this object an instance of a python `ConnectionResetError` type?
  /// Subclasses will return `false`.
  public static func isExactlyConnectionResetError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.connectionResetError)
  }

  /// Cast this object to `PyConnectionResetError` if it is an instance of python `ConnectionResetError` type
  /// (or its subclass).
  public static func asConnectionResetError(_ object: PyObject) -> PyConnectionResetError? {
    return Self.isConnectionResetError(object) ? (object as! PyConnectionResetError) : nil
  }

  /// Cast this object to `PyConnectionResetError` if it is an instance of python `ConnectionResetError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyConnectionResetError(_ object: PyObject) -> PyConnectionResetError? {
    return Self.isExactlyConnectionResetError(object) ? (object as! PyConnectionResetError) : nil
  }

  // MARK: - DeprecationWarning

  /// Is this object an instance of python `DeprecationWarning` type (or its subclass)?
  public static func isDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.deprecationWarning)
  }

  /// Is this object an instance of a python `DeprecationWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.deprecationWarning)
  }

  /// Cast this object to `PyDeprecationWarning` if it is an instance of python `DeprecationWarning` type
  /// (or its subclass).
  public static func asDeprecationWarning(_ object: PyObject) -> PyDeprecationWarning? {
    return Self.isDeprecationWarning(object) ? (object as! PyDeprecationWarning) : nil
  }

  /// Cast this object to `PyDeprecationWarning` if it is an instance of python `DeprecationWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyDeprecationWarning(_ object: PyObject) -> PyDeprecationWarning? {
    return Self.isExactlyDeprecationWarning(object) ? (object as! PyDeprecationWarning) : nil
  }

  // MARK: - EOFError

  /// Is this object an instance of python `EOFError` type (or its subclass)?
  public static func isEOFError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.eofError)
  }

  /// Is this object an instance of a python `EOFError` type?
  /// Subclasses will return `false`.
  public static func isExactlyEOFError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.eofError)
  }

  /// Cast this object to `PyEOFError` if it is an instance of python `EOFError` type
  /// (or its subclass).
  public static func asEOFError(_ object: PyObject) -> PyEOFError? {
    return Self.isEOFError(object) ? (object as! PyEOFError) : nil
  }

  /// Cast this object to `PyEOFError` if it is an instance of python `EOFError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyEOFError(_ object: PyObject) -> PyEOFError? {
    return Self.isExactlyEOFError(object) ? (object as! PyEOFError) : nil
  }

  // MARK: - Exception

  /// Is this object an instance of python `Exception` type (or its subclass)?
  public static func isException(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.exception)
  }

  /// Is this object an instance of a python `Exception` type?
  /// Subclasses will return `false`.
  public static func isExactlyException(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.exception)
  }

  /// Cast this object to `PyException` if it is an instance of python `Exception` type
  /// (or its subclass).
  public static func asException(_ object: PyObject) -> PyException? {
    return Self.isException(object) ? (object as! PyException) : nil
  }

  /// Cast this object to `PyException` if it is an instance of python `Exception` type.
  /// Subclasses will return `nil`.
  public static func asExactlyException(_ object: PyObject) -> PyException? {
    return Self.isExactlyException(object) ? (object as! PyException) : nil
  }

  // MARK: - FileExistsError

  /// Is this object an instance of python `FileExistsError` type (or its subclass)?
  public static func isFileExistsError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.fileExistsError)
  }

  /// Is this object an instance of a python `FileExistsError` type?
  /// Subclasses will return `false`.
  public static func isExactlyFileExistsError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.fileExistsError)
  }

  /// Cast this object to `PyFileExistsError` if it is an instance of python `FileExistsError` type
  /// (or its subclass).
  public static func asFileExistsError(_ object: PyObject) -> PyFileExistsError? {
    return Self.isFileExistsError(object) ? (object as! PyFileExistsError) : nil
  }

  /// Cast this object to `PyFileExistsError` if it is an instance of python `FileExistsError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFileExistsError(_ object: PyObject) -> PyFileExistsError? {
    return Self.isExactlyFileExistsError(object) ? (object as! PyFileExistsError) : nil
  }

  // MARK: - FileNotFoundError

  /// Is this object an instance of python `FileNotFoundError` type (or its subclass)?
  public static func isFileNotFoundError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.fileNotFoundError)
  }

  /// Is this object an instance of a python `FileNotFoundError` type?
  /// Subclasses will return `false`.
  public static func isExactlyFileNotFoundError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.fileNotFoundError)
  }

  /// Cast this object to `PyFileNotFoundError` if it is an instance of python `FileNotFoundError` type
  /// (or its subclass).
  public static func asFileNotFoundError(_ object: PyObject) -> PyFileNotFoundError? {
    return Self.isFileNotFoundError(object) ? (object as! PyFileNotFoundError) : nil
  }

  /// Cast this object to `PyFileNotFoundError` if it is an instance of python `FileNotFoundError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFileNotFoundError(_ object: PyObject) -> PyFileNotFoundError? {
    return Self.isExactlyFileNotFoundError(object) ? (object as! PyFileNotFoundError) : nil
  }

  // MARK: - FloatingPointError

  /// Is this object an instance of python `FloatingPointError` type (or its subclass)?
  public static func isFloatingPointError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.floatingPointError)
  }

  /// Is this object an instance of a python `FloatingPointError` type?
  /// Subclasses will return `false`.
  public static func isExactlyFloatingPointError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.floatingPointError)
  }

  /// Cast this object to `PyFloatingPointError` if it is an instance of python `FloatingPointError` type
  /// (or its subclass).
  public static func asFloatingPointError(_ object: PyObject) -> PyFloatingPointError? {
    return Self.isFloatingPointError(object) ? (object as! PyFloatingPointError) : nil
  }

  /// Cast this object to `PyFloatingPointError` if it is an instance of python `FloatingPointError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFloatingPointError(_ object: PyObject) -> PyFloatingPointError? {
    return Self.isExactlyFloatingPointError(object) ? (object as! PyFloatingPointError) : nil
  }

  // MARK: - FutureWarning

  /// Is this object an instance of python `FutureWarning` type (or its subclass)?
  public static func isFutureWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.futureWarning)
  }

  /// Is this object an instance of a python `FutureWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyFutureWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.futureWarning)
  }

  /// Cast this object to `PyFutureWarning` if it is an instance of python `FutureWarning` type
  /// (or its subclass).
  public static func asFutureWarning(_ object: PyObject) -> PyFutureWarning? {
    return Self.isFutureWarning(object) ? (object as! PyFutureWarning) : nil
  }

  /// Cast this object to `PyFutureWarning` if it is an instance of python `FutureWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyFutureWarning(_ object: PyObject) -> PyFutureWarning? {
    return Self.isExactlyFutureWarning(object) ? (object as! PyFutureWarning) : nil
  }

  // MARK: - GeneratorExit

  /// Is this object an instance of python `GeneratorExit` type (or its subclass)?
  public static func isGeneratorExit(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.generatorExit)
  }

  /// Is this object an instance of a python `GeneratorExit` type?
  /// Subclasses will return `false`.
  public static func isExactlyGeneratorExit(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.generatorExit)
  }

  /// Cast this object to `PyGeneratorExit` if it is an instance of python `GeneratorExit` type
  /// (or its subclass).
  public static func asGeneratorExit(_ object: PyObject) -> PyGeneratorExit? {
    return Self.isGeneratorExit(object) ? (object as! PyGeneratorExit) : nil
  }

  /// Cast this object to `PyGeneratorExit` if it is an instance of python `GeneratorExit` type.
  /// Subclasses will return `nil`.
  public static func asExactlyGeneratorExit(_ object: PyObject) -> PyGeneratorExit? {
    return Self.isExactlyGeneratorExit(object) ? (object as! PyGeneratorExit) : nil
  }

  // MARK: - ImportError

  /// Is this object an instance of python `ImportError` type (or its subclass)?
  public static func isImportError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.importError)
  }

  /// Is this object an instance of a python `ImportError` type?
  /// Subclasses will return `false`.
  public static func isExactlyImportError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.importError)
  }

  /// Cast this object to `PyImportError` if it is an instance of python `ImportError` type
  /// (or its subclass).
  public static func asImportError(_ object: PyObject) -> PyImportError? {
    return Self.isImportError(object) ? (object as! PyImportError) : nil
  }

  /// Cast this object to `PyImportError` if it is an instance of python `ImportError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyImportError(_ object: PyObject) -> PyImportError? {
    return Self.isExactlyImportError(object) ? (object as! PyImportError) : nil
  }

  // MARK: - ImportWarning

  /// Is this object an instance of python `ImportWarning` type (or its subclass)?
  public static func isImportWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.importWarning)
  }

  /// Is this object an instance of a python `ImportWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyImportWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.importWarning)
  }

  /// Cast this object to `PyImportWarning` if it is an instance of python `ImportWarning` type
  /// (or its subclass).
  public static func asImportWarning(_ object: PyObject) -> PyImportWarning? {
    return Self.isImportWarning(object) ? (object as! PyImportWarning) : nil
  }

  /// Cast this object to `PyImportWarning` if it is an instance of python `ImportWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyImportWarning(_ object: PyObject) -> PyImportWarning? {
    return Self.isExactlyImportWarning(object) ? (object as! PyImportWarning) : nil
  }

  // MARK: - IndentationError

  /// Is this object an instance of python `IndentationError` type (or its subclass)?
  public static func isIndentationError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.indentationError)
  }

  /// Is this object an instance of a python `IndentationError` type?
  /// Subclasses will return `false`.
  public static func isExactlyIndentationError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.indentationError)
  }

  /// Cast this object to `PyIndentationError` if it is an instance of python `IndentationError` type
  /// (or its subclass).
  public static func asIndentationError(_ object: PyObject) -> PyIndentationError? {
    return Self.isIndentationError(object) ? (object as! PyIndentationError) : nil
  }

  /// Cast this object to `PyIndentationError` if it is an instance of python `IndentationError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyIndentationError(_ object: PyObject) -> PyIndentationError? {
    return Self.isExactlyIndentationError(object) ? (object as! PyIndentationError) : nil
  }

  // MARK: - IndexError

  /// Is this object an instance of python `IndexError` type (or its subclass)?
  public static func isIndexError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.indexError)
  }

  /// Is this object an instance of a python `IndexError` type?
  /// Subclasses will return `false`.
  public static func isExactlyIndexError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.indexError)
  }

  /// Cast this object to `PyIndexError` if it is an instance of python `IndexError` type
  /// (or its subclass).
  public static func asIndexError(_ object: PyObject) -> PyIndexError? {
    return Self.isIndexError(object) ? (object as! PyIndexError) : nil
  }

  /// Cast this object to `PyIndexError` if it is an instance of python `IndexError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyIndexError(_ object: PyObject) -> PyIndexError? {
    return Self.isExactlyIndexError(object) ? (object as! PyIndexError) : nil
  }

  // MARK: - InterruptedError

  /// Is this object an instance of python `InterruptedError` type (or its subclass)?
  public static func isInterruptedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.interruptedError)
  }

  /// Is this object an instance of a python `InterruptedError` type?
  /// Subclasses will return `false`.
  public static func isExactlyInterruptedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.interruptedError)
  }

  /// Cast this object to `PyInterruptedError` if it is an instance of python `InterruptedError` type
  /// (or its subclass).
  public static func asInterruptedError(_ object: PyObject) -> PyInterruptedError? {
    return Self.isInterruptedError(object) ? (object as! PyInterruptedError) : nil
  }

  /// Cast this object to `PyInterruptedError` if it is an instance of python `InterruptedError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyInterruptedError(_ object: PyObject) -> PyInterruptedError? {
    return Self.isExactlyInterruptedError(object) ? (object as! PyInterruptedError) : nil
  }

  // MARK: - IsADirectoryError

  /// Is this object an instance of python `IsADirectoryError` type (or its subclass)?
  public static func isIsADirectoryError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.isADirectoryError)
  }

  /// Is this object an instance of a python `IsADirectoryError` type?
  /// Subclasses will return `false`.
  public static func isExactlyIsADirectoryError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.isADirectoryError)
  }

  /// Cast this object to `PyIsADirectoryError` if it is an instance of python `IsADirectoryError` type
  /// (or its subclass).
  public static func asIsADirectoryError(_ object: PyObject) -> PyIsADirectoryError? {
    return Self.isIsADirectoryError(object) ? (object as! PyIsADirectoryError) : nil
  }

  /// Cast this object to `PyIsADirectoryError` if it is an instance of python `IsADirectoryError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyIsADirectoryError(_ object: PyObject) -> PyIsADirectoryError? {
    return Self.isExactlyIsADirectoryError(object) ? (object as! PyIsADirectoryError) : nil
  }

  // MARK: - KeyError

  /// Is this object an instance of python `KeyError` type (or its subclass)?
  public static func isKeyError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.keyError)
  }

  /// Is this object an instance of a python `KeyError` type?
  /// Subclasses will return `false`.
  public static func isExactlyKeyError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.keyError)
  }

  /// Cast this object to `PyKeyError` if it is an instance of python `KeyError` type
  /// (or its subclass).
  public static func asKeyError(_ object: PyObject) -> PyKeyError? {
    return Self.isKeyError(object) ? (object as! PyKeyError) : nil
  }

  /// Cast this object to `PyKeyError` if it is an instance of python `KeyError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyKeyError(_ object: PyObject) -> PyKeyError? {
    return Self.isExactlyKeyError(object) ? (object as! PyKeyError) : nil
  }

  // MARK: - KeyboardInterrupt

  /// Is this object an instance of python `KeyboardInterrupt` type (or its subclass)?
  public static func isKeyboardInterrupt(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.keyboardInterrupt)
  }

  /// Is this object an instance of a python `KeyboardInterrupt` type?
  /// Subclasses will return `false`.
  public static func isExactlyKeyboardInterrupt(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.keyboardInterrupt)
  }

  /// Cast this object to `PyKeyboardInterrupt` if it is an instance of python `KeyboardInterrupt` type
  /// (or its subclass).
  public static func asKeyboardInterrupt(_ object: PyObject) -> PyKeyboardInterrupt? {
    return Self.isKeyboardInterrupt(object) ? (object as! PyKeyboardInterrupt) : nil
  }

  /// Cast this object to `PyKeyboardInterrupt` if it is an instance of python `KeyboardInterrupt` type.
  /// Subclasses will return `nil`.
  public static func asExactlyKeyboardInterrupt(_ object: PyObject) -> PyKeyboardInterrupt? {
    return Self.isExactlyKeyboardInterrupt(object) ? (object as! PyKeyboardInterrupt) : nil
  }

  // MARK: - LookupError

  /// Is this object an instance of python `LookupError` type (or its subclass)?
  public static func isLookupError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.lookupError)
  }

  /// Is this object an instance of a python `LookupError` type?
  /// Subclasses will return `false`.
  public static func isExactlyLookupError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.lookupError)
  }

  /// Cast this object to `PyLookupError` if it is an instance of python `LookupError` type
  /// (or its subclass).
  public static func asLookupError(_ object: PyObject) -> PyLookupError? {
    return Self.isLookupError(object) ? (object as! PyLookupError) : nil
  }

  /// Cast this object to `PyLookupError` if it is an instance of python `LookupError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyLookupError(_ object: PyObject) -> PyLookupError? {
    return Self.isExactlyLookupError(object) ? (object as! PyLookupError) : nil
  }

  // MARK: - MemoryError

  /// Is this object an instance of python `MemoryError` type (or its subclass)?
  public static func isMemoryError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.memoryError)
  }

  /// Is this object an instance of a python `MemoryError` type?
  /// Subclasses will return `false`.
  public static func isExactlyMemoryError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.memoryError)
  }

  /// Cast this object to `PyMemoryError` if it is an instance of python `MemoryError` type
  /// (or its subclass).
  public static func asMemoryError(_ object: PyObject) -> PyMemoryError? {
    return Self.isMemoryError(object) ? (object as! PyMemoryError) : nil
  }

  /// Cast this object to `PyMemoryError` if it is an instance of python `MemoryError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyMemoryError(_ object: PyObject) -> PyMemoryError? {
    return Self.isExactlyMemoryError(object) ? (object as! PyMemoryError) : nil
  }

  // MARK: - ModuleNotFoundError

  /// Is this object an instance of python `ModuleNotFoundError` type (or its subclass)?
  public static func isModuleNotFoundError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.moduleNotFoundError)
  }

  /// Is this object an instance of a python `ModuleNotFoundError` type?
  /// Subclasses will return `false`.
  public static func isExactlyModuleNotFoundError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.moduleNotFoundError)
  }

  /// Cast this object to `PyModuleNotFoundError` if it is an instance of python `ModuleNotFoundError` type
  /// (or its subclass).
  public static func asModuleNotFoundError(_ object: PyObject) -> PyModuleNotFoundError? {
    return Self.isModuleNotFoundError(object) ? (object as! PyModuleNotFoundError) : nil
  }

  /// Cast this object to `PyModuleNotFoundError` if it is an instance of python `ModuleNotFoundError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyModuleNotFoundError(_ object: PyObject) -> PyModuleNotFoundError? {
    return Self.isExactlyModuleNotFoundError(object) ? (object as! PyModuleNotFoundError) : nil
  }

  // MARK: - NameError

  /// Is this object an instance of python `NameError` type (or its subclass)?
  public static func isNameError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.nameError)
  }

  /// Is this object an instance of a python `NameError` type?
  /// Subclasses will return `false`.
  public static func isExactlyNameError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.nameError)
  }

  /// Cast this object to `PyNameError` if it is an instance of python `NameError` type
  /// (or its subclass).
  public static func asNameError(_ object: PyObject) -> PyNameError? {
    return Self.isNameError(object) ? (object as! PyNameError) : nil
  }

  /// Cast this object to `PyNameError` if it is an instance of python `NameError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyNameError(_ object: PyObject) -> PyNameError? {
    return Self.isExactlyNameError(object) ? (object as! PyNameError) : nil
  }

  // MARK: - NotADirectoryError

  /// Is this object an instance of python `NotADirectoryError` type (or its subclass)?
  public static func isNotADirectoryError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.notADirectoryError)
  }

  /// Is this object an instance of a python `NotADirectoryError` type?
  /// Subclasses will return `false`.
  public static func isExactlyNotADirectoryError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.notADirectoryError)
  }

  /// Cast this object to `PyNotADirectoryError` if it is an instance of python `NotADirectoryError` type
  /// (or its subclass).
  public static func asNotADirectoryError(_ object: PyObject) -> PyNotADirectoryError? {
    return Self.isNotADirectoryError(object) ? (object as! PyNotADirectoryError) : nil
  }

  /// Cast this object to `PyNotADirectoryError` if it is an instance of python `NotADirectoryError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyNotADirectoryError(_ object: PyObject) -> PyNotADirectoryError? {
    return Self.isExactlyNotADirectoryError(object) ? (object as! PyNotADirectoryError) : nil
  }

  // MARK: - NotImplementedError

  /// Is this object an instance of python `NotImplementedError` type (or its subclass)?
  public static func isNotImplementedError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.notImplementedError)
  }

  /// Is this object an instance of a python `NotImplementedError` type?
  /// Subclasses will return `false`.
  public static func isExactlyNotImplementedError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.notImplementedError)
  }

  /// Cast this object to `PyNotImplementedError` if it is an instance of python `NotImplementedError` type
  /// (or its subclass).
  public static func asNotImplementedError(_ object: PyObject) -> PyNotImplementedError? {
    return Self.isNotImplementedError(object) ? (object as! PyNotImplementedError) : nil
  }

  /// Cast this object to `PyNotImplementedError` if it is an instance of python `NotImplementedError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyNotImplementedError(_ object: PyObject) -> PyNotImplementedError? {
    return Self.isExactlyNotImplementedError(object) ? (object as! PyNotImplementedError) : nil
  }

  // MARK: - OSError

  /// Is this object an instance of python `OSError` type (or its subclass)?
  public static func isOSError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.osError)
  }

  /// Is this object an instance of a python `OSError` type?
  /// Subclasses will return `false`.
  public static func isExactlyOSError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.osError)
  }

  /// Cast this object to `PyOSError` if it is an instance of python `OSError` type
  /// (or its subclass).
  public static func asOSError(_ object: PyObject) -> PyOSError? {
    return Self.isOSError(object) ? (object as! PyOSError) : nil
  }

  /// Cast this object to `PyOSError` if it is an instance of python `OSError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyOSError(_ object: PyObject) -> PyOSError? {
    return Self.isExactlyOSError(object) ? (object as! PyOSError) : nil
  }

  // MARK: - OverflowError

  /// Is this object an instance of python `OverflowError` type (or its subclass)?
  public static func isOverflowError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.overflowError)
  }

  /// Is this object an instance of a python `OverflowError` type?
  /// Subclasses will return `false`.
  public static func isExactlyOverflowError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.overflowError)
  }

  /// Cast this object to `PyOverflowError` if it is an instance of python `OverflowError` type
  /// (or its subclass).
  public static func asOverflowError(_ object: PyObject) -> PyOverflowError? {
    return Self.isOverflowError(object) ? (object as! PyOverflowError) : nil
  }

  /// Cast this object to `PyOverflowError` if it is an instance of python `OverflowError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyOverflowError(_ object: PyObject) -> PyOverflowError? {
    return Self.isExactlyOverflowError(object) ? (object as! PyOverflowError) : nil
  }

  // MARK: - PendingDeprecationWarning

  /// Is this object an instance of python `PendingDeprecationWarning` type (or its subclass)?
  public static func isPendingDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.pendingDeprecationWarning)
  }

  /// Is this object an instance of a python `PendingDeprecationWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyPendingDeprecationWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.pendingDeprecationWarning)
  }

  /// Cast this object to `PyPendingDeprecationWarning` if it is an instance of python `PendingDeprecationWarning` type
  /// (or its subclass).
  public static func asPendingDeprecationWarning(_ object: PyObject) -> PyPendingDeprecationWarning? {
    return Self.isPendingDeprecationWarning(object) ? (object as! PyPendingDeprecationWarning) : nil
  }

  /// Cast this object to `PyPendingDeprecationWarning` if it is an instance of python `PendingDeprecationWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyPendingDeprecationWarning(_ object: PyObject) -> PyPendingDeprecationWarning? {
    return Self.isExactlyPendingDeprecationWarning(object) ? (object as! PyPendingDeprecationWarning) : nil
  }

  // MARK: - PermissionError

  /// Is this object an instance of python `PermissionError` type (or its subclass)?
  public static func isPermissionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.permissionError)
  }

  /// Is this object an instance of a python `PermissionError` type?
  /// Subclasses will return `false`.
  public static func isExactlyPermissionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.permissionError)
  }

  /// Cast this object to `PyPermissionError` if it is an instance of python `PermissionError` type
  /// (or its subclass).
  public static func asPermissionError(_ object: PyObject) -> PyPermissionError? {
    return Self.isPermissionError(object) ? (object as! PyPermissionError) : nil
  }

  /// Cast this object to `PyPermissionError` if it is an instance of python `PermissionError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyPermissionError(_ object: PyObject) -> PyPermissionError? {
    return Self.isExactlyPermissionError(object) ? (object as! PyPermissionError) : nil
  }

  // MARK: - ProcessLookupError

  /// Is this object an instance of python `ProcessLookupError` type (or its subclass)?
  public static func isProcessLookupError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.processLookupError)
  }

  /// Is this object an instance of a python `ProcessLookupError` type?
  /// Subclasses will return `false`.
  public static func isExactlyProcessLookupError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.processLookupError)
  }

  /// Cast this object to `PyProcessLookupError` if it is an instance of python `ProcessLookupError` type
  /// (or its subclass).
  public static func asProcessLookupError(_ object: PyObject) -> PyProcessLookupError? {
    return Self.isProcessLookupError(object) ? (object as! PyProcessLookupError) : nil
  }

  /// Cast this object to `PyProcessLookupError` if it is an instance of python `ProcessLookupError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyProcessLookupError(_ object: PyObject) -> PyProcessLookupError? {
    return Self.isExactlyProcessLookupError(object) ? (object as! PyProcessLookupError) : nil
  }

  // MARK: - RecursionError

  /// Is this object an instance of python `RecursionError` type (or its subclass)?
  public static func isRecursionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.recursionError)
  }

  /// Is this object an instance of a python `RecursionError` type?
  /// Subclasses will return `false`.
  public static func isExactlyRecursionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.recursionError)
  }

  /// Cast this object to `PyRecursionError` if it is an instance of python `RecursionError` type
  /// (or its subclass).
  public static func asRecursionError(_ object: PyObject) -> PyRecursionError? {
    return Self.isRecursionError(object) ? (object as! PyRecursionError) : nil
  }

  /// Cast this object to `PyRecursionError` if it is an instance of python `RecursionError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyRecursionError(_ object: PyObject) -> PyRecursionError? {
    return Self.isExactlyRecursionError(object) ? (object as! PyRecursionError) : nil
  }

  // MARK: - ReferenceError

  /// Is this object an instance of python `ReferenceError` type (or its subclass)?
  public static func isReferenceError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.referenceError)
  }

  /// Is this object an instance of a python `ReferenceError` type?
  /// Subclasses will return `false`.
  public static func isExactlyReferenceError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.referenceError)
  }

  /// Cast this object to `PyReferenceError` if it is an instance of python `ReferenceError` type
  /// (or its subclass).
  public static func asReferenceError(_ object: PyObject) -> PyReferenceError? {
    return Self.isReferenceError(object) ? (object as! PyReferenceError) : nil
  }

  /// Cast this object to `PyReferenceError` if it is an instance of python `ReferenceError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyReferenceError(_ object: PyObject) -> PyReferenceError? {
    return Self.isExactlyReferenceError(object) ? (object as! PyReferenceError) : nil
  }

  // MARK: - ResourceWarning

  /// Is this object an instance of python `ResourceWarning` type (or its subclass)?
  public static func isResourceWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.resourceWarning)
  }

  /// Is this object an instance of a python `ResourceWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyResourceWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.resourceWarning)
  }

  /// Cast this object to `PyResourceWarning` if it is an instance of python `ResourceWarning` type
  /// (or its subclass).
  public static func asResourceWarning(_ object: PyObject) -> PyResourceWarning? {
    return Self.isResourceWarning(object) ? (object as! PyResourceWarning) : nil
  }

  /// Cast this object to `PyResourceWarning` if it is an instance of python `ResourceWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyResourceWarning(_ object: PyObject) -> PyResourceWarning? {
    return Self.isExactlyResourceWarning(object) ? (object as! PyResourceWarning) : nil
  }

  // MARK: - RuntimeError

  /// Is this object an instance of python `RuntimeError` type (or its subclass)?
  public static func isRuntimeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.runtimeError)
  }

  /// Is this object an instance of a python `RuntimeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyRuntimeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.runtimeError)
  }

  /// Cast this object to `PyRuntimeError` if it is an instance of python `RuntimeError` type
  /// (or its subclass).
  public static func asRuntimeError(_ object: PyObject) -> PyRuntimeError? {
    return Self.isRuntimeError(object) ? (object as! PyRuntimeError) : nil
  }

  /// Cast this object to `PyRuntimeError` if it is an instance of python `RuntimeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyRuntimeError(_ object: PyObject) -> PyRuntimeError? {
    return Self.isExactlyRuntimeError(object) ? (object as! PyRuntimeError) : nil
  }

  // MARK: - RuntimeWarning

  /// Is this object an instance of python `RuntimeWarning` type (or its subclass)?
  public static func isRuntimeWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.runtimeWarning)
  }

  /// Is this object an instance of a python `RuntimeWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyRuntimeWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.runtimeWarning)
  }

  /// Cast this object to `PyRuntimeWarning` if it is an instance of python `RuntimeWarning` type
  /// (or its subclass).
  public static func asRuntimeWarning(_ object: PyObject) -> PyRuntimeWarning? {
    return Self.isRuntimeWarning(object) ? (object as! PyRuntimeWarning) : nil
  }

  /// Cast this object to `PyRuntimeWarning` if it is an instance of python `RuntimeWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyRuntimeWarning(_ object: PyObject) -> PyRuntimeWarning? {
    return Self.isExactlyRuntimeWarning(object) ? (object as! PyRuntimeWarning) : nil
  }

  // MARK: - StopAsyncIteration

  /// Is this object an instance of python `StopAsyncIteration` type (or its subclass)?
  public static func isStopAsyncIteration(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.stopAsyncIteration)
  }

  /// Is this object an instance of a python `StopAsyncIteration` type?
  /// Subclasses will return `false`.
  public static func isExactlyStopAsyncIteration(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.stopAsyncIteration)
  }

  /// Cast this object to `PyStopAsyncIteration` if it is an instance of python `StopAsyncIteration` type
  /// (or its subclass).
  public static func asStopAsyncIteration(_ object: PyObject) -> PyStopAsyncIteration? {
    return Self.isStopAsyncIteration(object) ? (object as! PyStopAsyncIteration) : nil
  }

  /// Cast this object to `PyStopAsyncIteration` if it is an instance of python `StopAsyncIteration` type.
  /// Subclasses will return `nil`.
  public static func asExactlyStopAsyncIteration(_ object: PyObject) -> PyStopAsyncIteration? {
    return Self.isExactlyStopAsyncIteration(object) ? (object as! PyStopAsyncIteration) : nil
  }

  // MARK: - StopIteration

  /// Is this object an instance of python `StopIteration` type (or its subclass)?
  public static func isStopIteration(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.stopIteration)
  }

  /// Is this object an instance of a python `StopIteration` type?
  /// Subclasses will return `false`.
  public static func isExactlyStopIteration(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.stopIteration)
  }

  /// Cast this object to `PyStopIteration` if it is an instance of python `StopIteration` type
  /// (or its subclass).
  public static func asStopIteration(_ object: PyObject) -> PyStopIteration? {
    return Self.isStopIteration(object) ? (object as! PyStopIteration) : nil
  }

  /// Cast this object to `PyStopIteration` if it is an instance of python `StopIteration` type.
  /// Subclasses will return `nil`.
  public static func asExactlyStopIteration(_ object: PyObject) -> PyStopIteration? {
    return Self.isExactlyStopIteration(object) ? (object as! PyStopIteration) : nil
  }

  // MARK: - SyntaxError

  /// Is this object an instance of python `SyntaxError` type (or its subclass)?
  public static func isSyntaxError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.syntaxError)
  }

  /// Is this object an instance of a python `SyntaxError` type?
  /// Subclasses will return `false`.
  public static func isExactlySyntaxError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.syntaxError)
  }

  /// Cast this object to `PySyntaxError` if it is an instance of python `SyntaxError` type
  /// (or its subclass).
  public static func asSyntaxError(_ object: PyObject) -> PySyntaxError? {
    return Self.isSyntaxError(object) ? (object as! PySyntaxError) : nil
  }

  /// Cast this object to `PySyntaxError` if it is an instance of python `SyntaxError` type.
  /// Subclasses will return `nil`.
  public static func asExactlySyntaxError(_ object: PyObject) -> PySyntaxError? {
    return Self.isExactlySyntaxError(object) ? (object as! PySyntaxError) : nil
  }

  // MARK: - SyntaxWarning

  /// Is this object an instance of python `SyntaxWarning` type (or its subclass)?
  public static func isSyntaxWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.syntaxWarning)
  }

  /// Is this object an instance of a python `SyntaxWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlySyntaxWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.syntaxWarning)
  }

  /// Cast this object to `PySyntaxWarning` if it is an instance of python `SyntaxWarning` type
  /// (or its subclass).
  public static func asSyntaxWarning(_ object: PyObject) -> PySyntaxWarning? {
    return Self.isSyntaxWarning(object) ? (object as! PySyntaxWarning) : nil
  }

  /// Cast this object to `PySyntaxWarning` if it is an instance of python `SyntaxWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlySyntaxWarning(_ object: PyObject) -> PySyntaxWarning? {
    return Self.isExactlySyntaxWarning(object) ? (object as! PySyntaxWarning) : nil
  }

  // MARK: - SystemError

  /// Is this object an instance of python `SystemError` type (or its subclass)?
  public static func isSystemError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.systemError)
  }

  /// Is this object an instance of a python `SystemError` type?
  /// Subclasses will return `false`.
  public static func isExactlySystemError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.systemError)
  }

  /// Cast this object to `PySystemError` if it is an instance of python `SystemError` type
  /// (or its subclass).
  public static func asSystemError(_ object: PyObject) -> PySystemError? {
    return Self.isSystemError(object) ? (object as! PySystemError) : nil
  }

  /// Cast this object to `PySystemError` if it is an instance of python `SystemError` type.
  /// Subclasses will return `nil`.
  public static func asExactlySystemError(_ object: PyObject) -> PySystemError? {
    return Self.isExactlySystemError(object) ? (object as! PySystemError) : nil
  }

  // MARK: - SystemExit

  /// Is this object an instance of python `SystemExit` type (or its subclass)?
  public static func isSystemExit(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.systemExit)
  }

  /// Is this object an instance of a python `SystemExit` type?
  /// Subclasses will return `false`.
  public static func isExactlySystemExit(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.systemExit)
  }

  /// Cast this object to `PySystemExit` if it is an instance of python `SystemExit` type
  /// (or its subclass).
  public static func asSystemExit(_ object: PyObject) -> PySystemExit? {
    return Self.isSystemExit(object) ? (object as! PySystemExit) : nil
  }

  /// Cast this object to `PySystemExit` if it is an instance of python `SystemExit` type.
  /// Subclasses will return `nil`.
  public static func asExactlySystemExit(_ object: PyObject) -> PySystemExit? {
    return Self.isExactlySystemExit(object) ? (object as! PySystemExit) : nil
  }

  // MARK: - TabError

  /// Is this object an instance of python `TabError` type (or its subclass)?
  public static func isTabError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.tabError)
  }

  /// Is this object an instance of a python `TabError` type?
  /// Subclasses will return `false`.
  public static func isExactlyTabError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.tabError)
  }

  /// Cast this object to `PyTabError` if it is an instance of python `TabError` type
  /// (or its subclass).
  public static func asTabError(_ object: PyObject) -> PyTabError? {
    return Self.isTabError(object) ? (object as! PyTabError) : nil
  }

  /// Cast this object to `PyTabError` if it is an instance of python `TabError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTabError(_ object: PyObject) -> PyTabError? {
    return Self.isExactlyTabError(object) ? (object as! PyTabError) : nil
  }

  // MARK: - TimeoutError

  /// Is this object an instance of python `TimeoutError` type (or its subclass)?
  public static func isTimeoutError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.timeoutError)
  }

  /// Is this object an instance of a python `TimeoutError` type?
  /// Subclasses will return `false`.
  public static func isExactlyTimeoutError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.timeoutError)
  }

  /// Cast this object to `PyTimeoutError` if it is an instance of python `TimeoutError` type
  /// (or its subclass).
  public static func asTimeoutError(_ object: PyObject) -> PyTimeoutError? {
    return Self.isTimeoutError(object) ? (object as! PyTimeoutError) : nil
  }

  /// Cast this object to `PyTimeoutError` if it is an instance of python `TimeoutError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTimeoutError(_ object: PyObject) -> PyTimeoutError? {
    return Self.isExactlyTimeoutError(object) ? (object as! PyTimeoutError) : nil
  }

  // MARK: - TypeError

  /// Is this object an instance of python `TypeError` type (or its subclass)?
  public static func isTypeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.typeError)
  }

  /// Is this object an instance of a python `TypeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyTypeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.typeError)
  }

  /// Cast this object to `PyTypeError` if it is an instance of python `TypeError` type
  /// (or its subclass).
  public static func asTypeError(_ object: PyObject) -> PyTypeError? {
    return Self.isTypeError(object) ? (object as! PyTypeError) : nil
  }

  /// Cast this object to `PyTypeError` if it is an instance of python `TypeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyTypeError(_ object: PyObject) -> PyTypeError? {
    return Self.isExactlyTypeError(object) ? (object as! PyTypeError) : nil
  }

  // MARK: - UnboundLocalError

  /// Is this object an instance of python `UnboundLocalError` type (or its subclass)?
  public static func isUnboundLocalError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.unboundLocalError)
  }

  /// Is this object an instance of a python `UnboundLocalError` type?
  /// Subclasses will return `false`.
  public static func isExactlyUnboundLocalError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.unboundLocalError)
  }

  /// Cast this object to `PyUnboundLocalError` if it is an instance of python `UnboundLocalError` type
  /// (or its subclass).
  public static func asUnboundLocalError(_ object: PyObject) -> PyUnboundLocalError? {
    return Self.isUnboundLocalError(object) ? (object as! PyUnboundLocalError) : nil
  }

  /// Cast this object to `PyUnboundLocalError` if it is an instance of python `UnboundLocalError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUnboundLocalError(_ object: PyObject) -> PyUnboundLocalError? {
    return Self.isExactlyUnboundLocalError(object) ? (object as! PyUnboundLocalError) : nil
  }

  // MARK: - UnicodeDecodeError

  /// Is this object an instance of python `UnicodeDecodeError` type (or its subclass)?
  public static func isUnicodeDecodeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.unicodeDecodeError)
  }

  /// Is this object an instance of a python `UnicodeDecodeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyUnicodeDecodeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.unicodeDecodeError)
  }

  /// Cast this object to `PyUnicodeDecodeError` if it is an instance of python `UnicodeDecodeError` type
  /// (or its subclass).
  public static func asUnicodeDecodeError(_ object: PyObject) -> PyUnicodeDecodeError? {
    return Self.isUnicodeDecodeError(object) ? (object as! PyUnicodeDecodeError) : nil
  }

  /// Cast this object to `PyUnicodeDecodeError` if it is an instance of python `UnicodeDecodeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUnicodeDecodeError(_ object: PyObject) -> PyUnicodeDecodeError? {
    return Self.isExactlyUnicodeDecodeError(object) ? (object as! PyUnicodeDecodeError) : nil
  }

  // MARK: - UnicodeEncodeError

  /// Is this object an instance of python `UnicodeEncodeError` type (or its subclass)?
  public static func isUnicodeEncodeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.unicodeEncodeError)
  }

  /// Is this object an instance of a python `UnicodeEncodeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyUnicodeEncodeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.unicodeEncodeError)
  }

  /// Cast this object to `PyUnicodeEncodeError` if it is an instance of python `UnicodeEncodeError` type
  /// (or its subclass).
  public static func asUnicodeEncodeError(_ object: PyObject) -> PyUnicodeEncodeError? {
    return Self.isUnicodeEncodeError(object) ? (object as! PyUnicodeEncodeError) : nil
  }

  /// Cast this object to `PyUnicodeEncodeError` if it is an instance of python `UnicodeEncodeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUnicodeEncodeError(_ object: PyObject) -> PyUnicodeEncodeError? {
    return Self.isExactlyUnicodeEncodeError(object) ? (object as! PyUnicodeEncodeError) : nil
  }

  // MARK: - UnicodeError

  /// Is this object an instance of python `UnicodeError` type (or its subclass)?
  public static func isUnicodeError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.unicodeError)
  }

  /// Is this object an instance of a python `UnicodeError` type?
  /// Subclasses will return `false`.
  public static func isExactlyUnicodeError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.unicodeError)
  }

  /// Cast this object to `PyUnicodeError` if it is an instance of python `UnicodeError` type
  /// (or its subclass).
  public static func asUnicodeError(_ object: PyObject) -> PyUnicodeError? {
    return Self.isUnicodeError(object) ? (object as! PyUnicodeError) : nil
  }

  /// Cast this object to `PyUnicodeError` if it is an instance of python `UnicodeError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUnicodeError(_ object: PyObject) -> PyUnicodeError? {
    return Self.isExactlyUnicodeError(object) ? (object as! PyUnicodeError) : nil
  }

  // MARK: - UnicodeTranslateError

  /// Is this object an instance of python `UnicodeTranslateError` type (or its subclass)?
  public static func isUnicodeTranslateError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.unicodeTranslateError)
  }

  /// Is this object an instance of a python `UnicodeTranslateError` type?
  /// Subclasses will return `false`.
  public static func isExactlyUnicodeTranslateError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.unicodeTranslateError)
  }

  /// Cast this object to `PyUnicodeTranslateError` if it is an instance of python `UnicodeTranslateError` type
  /// (or its subclass).
  public static func asUnicodeTranslateError(_ object: PyObject) -> PyUnicodeTranslateError? {
    return Self.isUnicodeTranslateError(object) ? (object as! PyUnicodeTranslateError) : nil
  }

  /// Cast this object to `PyUnicodeTranslateError` if it is an instance of python `UnicodeTranslateError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUnicodeTranslateError(_ object: PyObject) -> PyUnicodeTranslateError? {
    return Self.isExactlyUnicodeTranslateError(object) ? (object as! PyUnicodeTranslateError) : nil
  }

  // MARK: - UnicodeWarning

  /// Is this object an instance of python `UnicodeWarning` type (or its subclass)?
  public static func isUnicodeWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.unicodeWarning)
  }

  /// Is this object an instance of a python `UnicodeWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyUnicodeWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.unicodeWarning)
  }

  /// Cast this object to `PyUnicodeWarning` if it is an instance of python `UnicodeWarning` type
  /// (or its subclass).
  public static func asUnicodeWarning(_ object: PyObject) -> PyUnicodeWarning? {
    return Self.isUnicodeWarning(object) ? (object as! PyUnicodeWarning) : nil
  }

  /// Cast this object to `PyUnicodeWarning` if it is an instance of python `UnicodeWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUnicodeWarning(_ object: PyObject) -> PyUnicodeWarning? {
    return Self.isExactlyUnicodeWarning(object) ? (object as! PyUnicodeWarning) : nil
  }

  // MARK: - UserWarning

  /// Is this object an instance of python `UserWarning` type (or its subclass)?
  public static func isUserWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.userWarning)
  }

  /// Is this object an instance of a python `UserWarning` type?
  /// Subclasses will return `false`.
  public static func isExactlyUserWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.userWarning)
  }

  /// Cast this object to `PyUserWarning` if it is an instance of python `UserWarning` type
  /// (or its subclass).
  public static func asUserWarning(_ object: PyObject) -> PyUserWarning? {
    return Self.isUserWarning(object) ? (object as! PyUserWarning) : nil
  }

  /// Cast this object to `PyUserWarning` if it is an instance of python `UserWarning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyUserWarning(_ object: PyObject) -> PyUserWarning? {
    return Self.isExactlyUserWarning(object) ? (object as! PyUserWarning) : nil
  }

  // MARK: - ValueError

  /// Is this object an instance of python `ValueError` type (or its subclass)?
  public static func isValueError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.valueError)
  }

  /// Is this object an instance of a python `ValueError` type?
  /// Subclasses will return `false`.
  public static func isExactlyValueError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.valueError)
  }

  /// Cast this object to `PyValueError` if it is an instance of python `ValueError` type
  /// (or its subclass).
  public static func asValueError(_ object: PyObject) -> PyValueError? {
    return Self.isValueError(object) ? (object as! PyValueError) : nil
  }

  /// Cast this object to `PyValueError` if it is an instance of python `ValueError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyValueError(_ object: PyObject) -> PyValueError? {
    return Self.isExactlyValueError(object) ? (object as! PyValueError) : nil
  }

  // MARK: - Warning

  /// Is this object an instance of python `Warning` type (or its subclass)?
  public static func isWarning(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.warning)
  }

  /// Is this object an instance of a python `Warning` type?
  /// Subclasses will return `false`.
  public static func isExactlyWarning(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.warning)
  }

  /// Cast this object to `PyWarning` if it is an instance of python `Warning` type
  /// (or its subclass).
  public static func asWarning(_ object: PyObject) -> PyWarning? {
    return Self.isWarning(object) ? (object as! PyWarning) : nil
  }

  /// Cast this object to `PyWarning` if it is an instance of python `Warning` type.
  /// Subclasses will return `nil`.
  public static func asExactlyWarning(_ object: PyObject) -> PyWarning? {
    return Self.isExactlyWarning(object) ? (object as! PyWarning) : nil
  }

  // MARK: - ZeroDivisionError

  /// Is this object an instance of python `ZeroDivisionError` type (or its subclass)?
  public static func isZeroDivisionError(_ object: PyObject) -> Bool {
    return self.isInstance(object, of: Py.errorTypes.zeroDivisionError)
  }

  /// Is this object an instance of a python `ZeroDivisionError` type?
  /// Subclasses will return `false`.
  public static func isExactlyZeroDivisionError(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: Py.errorTypes.zeroDivisionError)
  }

  /// Cast this object to `PyZeroDivisionError` if it is an instance of python `ZeroDivisionError` type
  /// (or its subclass).
  public static func asZeroDivisionError(_ object: PyObject) -> PyZeroDivisionError? {
    return Self.isZeroDivisionError(object) ? (object as! PyZeroDivisionError) : nil
  }

  /// Cast this object to `PyZeroDivisionError` if it is an instance of python `ZeroDivisionError` type.
  /// Subclasses will return `nil`.
  public static func asExactlyZeroDivisionError(_ object: PyObject) -> PyZeroDivisionError? {
    return Self.isExactlyZeroDivisionError(object) ? (object as! PyZeroDivisionError) : nil
  }
}
