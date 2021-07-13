// =====================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyMemory.py
// DO NOT EDIT!
// =====================================================================

import Foundation
import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

/// Helper type for allocating new object instances.
///
/// Please note that with every call of `new` method a new Python object will be
/// allocated! It will not reuse existing instances or do any fancy checks.
/// This is basically the same thing as calling `init` on Swift type.
internal enum PyMemory {

  // MARK: - Object

  /// Allocate new instance of `object` type.
  internal static func newObject(
    type: PyType
  ) -> PyObject {
    return PyObject(
      type: type
    )
  }

  /// Allocate new instance of `object` type.
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.
  internal static func newObject(
  ) -> PyObject {
    return PyObject(
    )
  }

  // MARK: - Bool

  /// Allocate new instance of `bool` type.
  internal static func newBool(
    value: Bool
  ) -> PyBool {
    return PyBool(
      value: value
    )
  }

  // MARK: - BuiltinFunction

  /// Allocate new instance of `builtinFunction` type.
  internal static func newBuiltinFunction(
    fn: FunctionWrapper,
    module: PyString? = nil,
    doc: String? = nil
  ) -> PyBuiltinFunction {
    return PyBuiltinFunction(
      fn: fn,
      module: module,
      doc: doc
    )
  }

  // MARK: - BuiltinMethod

  /// Allocate new instance of `builtinMethod` type.
  internal static func newBuiltinMethod(
    fn: FunctionWrapper,
    object: PyObject,
    module: PyObject? = nil,
    doc: String? = nil
  ) -> PyBuiltinMethod {
    return PyBuiltinMethod(
      fn: fn,
      object: object,
      module: module,
      doc: doc
    )
  }

  // MARK: - ByteArray

  /// Allocate new instance of `bytearray` type.
  internal static func newByteArray(
    elements: Data
  ) -> PyByteArray {
    return PyByteArray(
      elements: elements
    )
  }

  /// Allocate new instance of `bytearray` type.
  internal static func newByteArray(
    type: PyType,
    elements: Data
  ) -> PyByteArray {
    return PyByteArray(
      type: type,
      elements: elements
    )
  }

  // MARK: - ByteArrayIterator

  /// Allocate new instance of `bytearray_iterator` type.
  internal static func newByteArrayIterator(
    bytes: PyByteArray
  ) -> PyByteArrayIterator {
    return PyByteArrayIterator(
      bytes: bytes
    )
  }

  // MARK: - Bytes

  /// Allocate new instance of `bytes` type.
  internal static func newBytes(
    elements: Data
  ) -> PyBytes {
    return PyBytes(
      elements: elements
    )
  }

  /// Allocate new instance of `bytes` type.
  internal static func newBytes(
    type: PyType,
    elements: Data
  ) -> PyBytes {
    return PyBytes(
      type: type,
      elements: elements
    )
  }

  // MARK: - BytesIterator

  /// Allocate new instance of `bytes_iterator` type.
  internal static func newBytesIterator(
    bytes: PyBytes
  ) -> PyBytesIterator {
    return PyBytesIterator(
      bytes: bytes
    )
  }

  // MARK: - CallableIterator

  /// Allocate new instance of `callable_iterator` type.
  internal static func newCallableIterator(
    callable: PyObject,
    sentinel: PyObject
  ) -> PyCallableIterator {
    return PyCallableIterator(
      callable: callable,
      sentinel: sentinel
    )
  }

  // MARK: - Cell

  /// Allocate new instance of `cell` type.
  internal static func newCell(
    content: PyObject?
  ) -> PyCell {
    return PyCell(
      content: content
    )
  }

  // MARK: - ClassMethod

  /// Allocate new instance of `classmethod` type.
  internal static func newClassMethod(
    callable: PyObject
  ) -> PyClassMethod {
    return PyClassMethod(
      callable: callable
    )
  }

  /// Allocate new instance of `classmethod` type.
  internal static func newClassMethod(
    type: PyType,
    callable: PyObject?
  ) -> PyClassMethod {
    return PyClassMethod(
      type: type,
      callable: callable
    )
  }

  // MARK: - Code

  /// Allocate new instance of `code` type.
  internal static func newCode(
    code: CodeObject
  ) -> PyCode {
    return PyCode(
      code: code
    )
  }

  // MARK: - Complex

  /// Allocate new instance of `complex` type.
  internal static func newComplex(
    real: Double,
    imag: Double
  ) -> PyComplex {
    return PyComplex(
      real: real,
      imag: imag
    )
  }

  /// Allocate new instance of `complex` type.
  internal static func newComplex(
    type: PyType,
    real: Double,
    imag: Double
  ) -> PyComplex {
    return PyComplex(
      type: type,
      real: real,
      imag: imag
    )
  }

  // MARK: - Dict

  /// Allocate new instance of `dict` type.
  internal static func newDict(
    elements: PyDict.OrderedDictionary
  ) -> PyDict {
    return PyDict(
      elements: elements
    )
  }

  /// Allocate new instance of `dict` type.
  internal static func newDict(
    type: PyType,
    elements: PyDict.OrderedDictionary
  ) -> PyDict {
    return PyDict(
      type: type,
      elements: elements
    )
  }

  // MARK: - DictItemIterator

  /// Allocate new instance of `dict_itemiterator` type.
  internal static func newDictItemIterator(
    dict: PyDict
  ) -> PyDictItemIterator {
    return PyDictItemIterator(
      dict: dict
    )
  }

  // MARK: - DictItems

  /// Allocate new instance of `dict_items` type.
  internal static func newDictItems(
    dict: PyDict
  ) -> PyDictItems {
    return PyDictItems(
      dict: dict
    )
  }

  // MARK: - DictKeyIterator

  /// Allocate new instance of `dict_keyiterator` type.
  internal static func newDictKeyIterator(
    dict: PyDict
  ) -> PyDictKeyIterator {
    return PyDictKeyIterator(
      dict: dict
    )
  }

  // MARK: - DictKeys

  /// Allocate new instance of `dict_keys` type.
  internal static func newDictKeys(
    dict: PyDict
  ) -> PyDictKeys {
    return PyDictKeys(
      dict: dict
    )
  }

  // MARK: - DictValueIterator

  /// Allocate new instance of `dict_valueiterator` type.
  internal static func newDictValueIterator(
    dict: PyDict
  ) -> PyDictValueIterator {
    return PyDictValueIterator(
      dict: dict
    )
  }

  // MARK: - DictValues

  /// Allocate new instance of `dict_values` type.
  internal static func newDictValues(
    dict: PyDict
  ) -> PyDictValues {
    return PyDictValues(
      dict: dict
    )
  }

  // MARK: - Ellipsis

  /// Allocate new instance of `ellipsis` type.
  internal static func newEllipsis(
  ) -> PyEllipsis {
    return PyEllipsis(
    )
  }

  // MARK: - Enumerate

  /// Allocate new instance of `enumerate` type.
  internal static func newEnumerate(
    iterator: PyObject,
    startFrom index: BigInt
  ) -> PyEnumerate {
    return PyEnumerate(
      iterator: iterator,
      startFrom: index
    )
  }

  /// Allocate new instance of `enumerate` type.
  internal static func newEnumerate(
    type: PyType,
    iterator: PyObject,
    startFrom index: BigInt
  ) -> PyEnumerate {
    return PyEnumerate(
      type: type,
      iterator: iterator,
      startFrom: index
    )
  }

  // MARK: - Filter

  /// Allocate new instance of `filter` type.
  internal static func newFilter(
    fn: PyObject,
    iterator: PyObject
  ) -> PyFilter {
    return PyFilter(
      fn: fn,
      iterator: iterator
    )
  }

  /// Allocate new instance of `filter` type.
  internal static func newFilter(
    type: PyType,
    fn: PyObject,
    iterator: PyObject
  ) -> PyFilter {
    return PyFilter(
      type: type,
      fn: fn,
      iterator: iterator
    )
  }

  // MARK: - Float

  /// Allocate new instance of `float` type.
  internal static func newFloat(
    value: Double
  ) -> PyFloat {
    return PyFloat(
      value: value
    )
  }

  /// Allocate new instance of `float` type.
  internal static func newFloat(
    type: PyType,
    value: Double
  ) -> PyFloat {
    return PyFloat(
      type: type,
      value: value
    )
  }

  // MARK: - Frame

  /// Allocate new instance of `frame` type.
  internal static func newFrame(
    code: PyCode,
    locals: PyDict,
    globals: PyDict,
    parent: PyFrame?
  ) -> PyFrame {
    return PyFrame(
      code: code,
      locals: locals,
      globals: globals,
      parent: parent
    )
  }

  // MARK: - FrozenSet

  /// Allocate new instance of `frozenset` type.
  internal static func newFrozenSet(
    elements: PyFrozenSet.OrderedSet
  ) -> PyFrozenSet {
    return PyFrozenSet(
      elements: elements
    )
  }

  /// Allocate new instance of `frozenset` type.
  internal static func newFrozenSet(
    type: PyType,
    elements: PyFrozenSet.OrderedSet
  ) -> PyFrozenSet {
    return PyFrozenSet(
      type: type,
      elements: elements
    )
  }

  // MARK: - Function

  /// Allocate new instance of `function` type.
  internal static func newFunction(
    qualname: PyString?,
    module: PyObject,
    code: PyCode,
    globals: PyDict
  ) -> PyFunction {
    return PyFunction(
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )
  }

  // MARK: - Int

  /// Allocate new instance of `int` type.
  internal static func newInt(
    value: BigInt
  ) -> PyInt {
    return PyInt(
      value: value
    )
  }

  /// Allocate new instance of `int` type.
  internal static func newInt(
    type: PyType,
    value: BigInt
  ) -> PyInt {
    return PyInt(
      type: type,
      value: value
    )
  }

  // MARK: - Iterator

  /// Allocate new instance of `iterator` type.
  internal static func newIterator(
    sequence: PyObject
  ) -> PyIterator {
    return PyIterator(
      sequence: sequence
    )
  }

  // MARK: - List

  /// Allocate new instance of `list` type.
  internal static func newList(
    elements: [PyObject]
  ) -> PyList {
    return PyList(
      elements: elements
    )
  }

  /// Allocate new instance of `list` type.
  internal static func newList(
    type: PyType,
    elements: [PyObject]
  ) -> PyList {
    return PyList(
      type: type,
      elements: elements
    )
  }

  // MARK: - ListIterator

  /// Allocate new instance of `list_iterator` type.
  internal static func newListIterator(
    list: PyList
  ) -> PyListIterator {
    return PyListIterator(
      list: list
    )
  }

  // MARK: - ListReverseIterator

  /// Allocate new instance of `list_reverseiterator` type.
  internal static func newListReverseIterator(
    list: PyList
  ) -> PyListReverseIterator {
    return PyListReverseIterator(
      list: list
    )
  }

  // MARK: - Map

  /// Allocate new instance of `map` type.
  internal static func newMap(
    fn: PyObject,
    iterators: [PyObject]
  ) -> PyMap {
    return PyMap(
      fn: fn,
      iterators: iterators
    )
  }

  /// Allocate new instance of `map` type.
  internal static func newMap(
    type: PyType,
    fn: PyObject,
    iterators: [PyObject]
  ) -> PyMap {
    return PyMap(
      type: type,
      fn: fn,
      iterators: iterators
    )
  }

  // MARK: - Method

  /// Allocate new instance of `method` type.
  internal static func newMethod(
    fn: PyFunction,
    object: PyObject
  ) -> PyMethod {
    return PyMethod(
      fn: fn,
      object: object
    )
  }

  // MARK: - Module

  /// Allocate new instance of `module` type.
  internal static func newModule(
    name: PyObject,
    doc: PyObject?,
    dict: PyDict? = nil
  ) -> PyModule {
    return PyModule(
      name: name,
      doc: doc,
      dict: dict
    )
  }

  /// Allocate new instance of `module` type.
  internal static func newModule(
    type: PyType,
    name: PyObject?,
    doc: PyObject?,
    dict: PyDict? = nil
  ) -> PyModule {
    return PyModule(
      type: type,
      name: name,
      doc: doc,
      dict: dict
    )
  }

  // MARK: - Namespace

  /// Allocate new instance of `types.SimpleNamespace` type.
  internal static func newNamespace(
    dict: PyDict
  ) -> PyNamespace {
    return PyNamespace(
      dict: dict
    )
  }

  // MARK: - None

  /// Allocate new instance of `NoneType` type.
  internal static func newNone(
  ) -> PyNone {
    return PyNone(
    )
  }

  // MARK: - NotImplemented

  /// Allocate new instance of `NotImplementedType` type.
  internal static func newNotImplemented(
  ) -> PyNotImplemented {
    return PyNotImplemented(
    )
  }

  // MARK: - Property

  /// Allocate new instance of `property` type.
  internal static func newProperty(
    get: PyObject?,
    set: PyObject?,
    del: PyObject?
  ) -> PyProperty {
    return PyProperty(
      get: get,
      set: set,
      del: del
    )
  }

  /// Allocate new instance of `property` type.
  internal static func newProperty(
    type: PyType,
    get: PyObject?,
    set: PyObject?,
    del: PyObject?
  ) -> PyProperty {
    return PyProperty(
      type: type,
      get: get,
      set: set,
      del: del
    )
  }

  // MARK: - Range

  /// Allocate new instance of `range` type.
  internal static func newRange(
    start: PyInt,
    stop: PyInt,
    step: PyInt?
  ) -> PyRange {
    return PyRange(
      start: start,
      stop: stop,
      step: step
    )
  }

  // MARK: - RangeIterator

  /// Allocate new instance of `range_iterator` type.
  internal static func newRangeIterator(
    start: BigInt,
    step: BigInt,
    length: BigInt
  ) -> PyRangeIterator {
    return PyRangeIterator(
      start: start,
      step: step,
      length: length
    )
  }

  // MARK: - Reversed

  /// Allocate new instance of `reversed` type.
  internal static func newReversed(
    sequence: PyObject,
    count: Int
  ) -> PyReversed {
    return PyReversed(
      sequence: sequence,
      count: count
    )
  }

  /// Allocate new instance of `reversed` type.
  internal static func newReversed(
    type: PyType,
    sequence: PyObject,
    count: Int
  ) -> PyReversed {
    return PyReversed(
      type: type,
      sequence: sequence,
      count: count
    )
  }

  // MARK: - Set

  /// Allocate new instance of `set` type.
  internal static func newSet(
    elements: PySet.OrderedSet
  ) -> PySet {
    return PySet(
      elements: elements
    )
  }

  /// Allocate new instance of `set` type.
  internal static func newSet(
    type: PyType,
    elements: PySet.OrderedSet
  ) -> PySet {
    return PySet(
      type: type,
      elements: elements
    )
  }

  // MARK: - SetIterator

  /// Allocate new instance of `set_iterator` type.
  internal static func newSetIterator(
    set: PySet
  ) -> PySetIterator {
    return PySetIterator(
      set: set
    )
  }

  /// Allocate new instance of `set_iterator` type.
  internal static func newSetIterator(
    frozenSet: PyFrozenSet
  ) -> PySetIterator {
    return PySetIterator(
      frozenSet: frozenSet
    )
  }

  // MARK: - Slice

  /// Allocate new instance of `slice` type.
  internal static func newSlice(
    start: PyObject,
    stop: PyObject,
    step: PyObject
  ) -> PySlice {
    return PySlice(
      start: start,
      stop: stop,
      step: step
    )
  }

  // MARK: - StaticMethod

  /// Allocate new instance of `staticmethod` type.
  internal static func newStaticMethod(
    callable: PyObject
  ) -> PyStaticMethod {
    return PyStaticMethod(
      callable: callable
    )
  }

  /// Allocate new instance of `staticmethod` type.
  internal static func newStaticMethod(
    type: PyType,
    callable: PyObject?
  ) -> PyStaticMethod {
    return PyStaticMethod(
      type: type,
      callable: callable
    )
  }

  // MARK: - String

  /// Allocate new instance of `str` type.
  internal static func newString(
    value: String
  ) -> PyString {
    return PyString(
      value: value
    )
  }

  /// Allocate new instance of `str` type.
  internal static func newString(
    type: PyType,
    value: String
  ) -> PyString {
    return PyString(
      type: type,
      value: value
    )
  }

  // MARK: - StringIterator

  /// Allocate new instance of `str_iterator` type.
  internal static func newStringIterator(
    string: PyString
  ) -> PyStringIterator {
    return PyStringIterator(
      string: string
    )
  }

  // MARK: - Super

  /// Allocate new instance of `super` type.
  internal static func newSuper(
    requestedType: PyType?,
    object: PyObject?,
    objectType: PyType?
  ) -> PySuper {
    return PySuper(
      requestedType: requestedType,
      object: object,
      objectType: objectType
    )
  }

  /// Allocate new instance of `super` type.
  internal static func newSuper(
    type: PyType,
    requestedType: PyType?,
    object: PyObject?,
    objectType: PyType?
  ) -> PySuper {
    return PySuper(
      type: type,
      requestedType: requestedType,
      object: object,
      objectType: objectType
    )
  }

  // MARK: - TextFile

  /// Allocate new instance of `TextFile` type.
  internal static func newTextFile(
    fd: FileDescriptorType,
    mode: FileMode,
    encoding: PyString.Encoding,
    errorHandling: PyString.ErrorHandling,
    closeOnDealloc: Bool
  ) -> PyTextFile {
    return PyTextFile(
      fd: fd,
      mode: mode,
      encoding: encoding,
      errorHandling: errorHandling,
      closeOnDealloc: closeOnDealloc
    )
  }

  /// Allocate new instance of `TextFile` type.
  internal static func newTextFile(
    name: String?,
    fd: FileDescriptorType,
    mode: FileMode,
    encoding: PyString.Encoding,
    errorHandling: PyString.ErrorHandling,
    closeOnDealloc: Bool
  ) -> PyTextFile {
    return PyTextFile(
      name: name,
      fd: fd,
      mode: mode,
      encoding: encoding,
      errorHandling: errorHandling,
      closeOnDealloc: closeOnDealloc
    )
  }

  // MARK: - Tuple

  /// Allocate new instance of `tuple` type.
  internal static func newTuple(
    elements: [PyObject]
  ) -> PyTuple {
    return PyTuple(
      elements: elements
    )
  }

  /// Allocate new instance of `tuple` type.
  internal static func newTuple(
    type: PyType,
    elements: [PyObject]
  ) -> PyTuple {
    return PyTuple(
      type: type,
      elements: elements
    )
  }

  // MARK: - TupleIterator

  /// Allocate new instance of `tuple_iterator` type.
  internal static func newTupleIterator(
    tuple: PyTuple
  ) -> PyTupleIterator {
    return PyTupleIterator(
      tuple: tuple
    )
  }

  // MARK: - Type

  /// Allocate new instance of `type` type.
  internal static func newType(
    name: String,
    qualname: String,
    metatype: PyType,
    base: PyType,
    mro: MRO,
    layout: PyType.MemoryLayout
  ) -> PyType {
    return PyType(
      name: name,
      qualname: qualname,
      metatype: metatype,
      base: base,
      mro: mro,
      layout: layout
    )
  }

  /// Allocate new instance of `type` type.
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.
  internal static func newType(
    name: String,
    qualname: String,
    base: PyType?,
    mro: MRO?,
    layout: PyType.MemoryLayout
  ) -> PyType {
    return PyType(
      name: name,
      qualname: qualname,
      base: base,
      mro: mro,
      layout: layout
    )
  }

  // MARK: - Zip

  /// Allocate new instance of `zip` type.
  internal static func newZip(
    iterators: [PyObject]
  ) -> PyZip {
    return PyZip(
      iterators: iterators
    )
  }

  /// Allocate new instance of `zip` type.
  internal static func newZip(
    type: PyType,
    iterators: [PyObject]
  ) -> PyZip {
    return PyZip(
      type: type,
      iterators: iterators
    )
  }

}
