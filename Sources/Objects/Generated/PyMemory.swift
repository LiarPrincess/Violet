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

  // MARK: - ArithmeticError

  /// Allocate new instance of `ArithmeticError` type.
  internal static func newArithmeticError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyArithmeticError {
    return PyArithmeticError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ArithmeticError` type.
  internal static func newArithmeticError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyArithmeticError {
    return PyArithmeticError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - AssertionError

  /// Allocate new instance of `AssertionError` type.
  internal static func newAssertionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyAssertionError {
    return PyAssertionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `AssertionError` type.
  internal static func newAssertionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyAssertionError {
    return PyAssertionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - AttributeError

  /// Allocate new instance of `AttributeError` type.
  internal static func newAttributeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyAttributeError {
    return PyAttributeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `AttributeError` type.
  internal static func newAttributeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyAttributeError {
    return PyAttributeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - BaseException

  /// Allocate new instance of `BaseException` type.
  internal static func newBaseException(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBaseException {
    return PyBaseException(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `BaseException` type.
  internal static func newBaseException(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBaseException {
    return PyBaseException(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - BlockingIOError

  /// Allocate new instance of `BlockingIOError` type.
  internal static func newBlockingIOError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBlockingIOError {
    return PyBlockingIOError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `BlockingIOError` type.
  internal static func newBlockingIOError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBlockingIOError {
    return PyBlockingIOError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - BrokenPipeError

  /// Allocate new instance of `BrokenPipeError` type.
  internal static func newBrokenPipeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBrokenPipeError {
    return PyBrokenPipeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `BrokenPipeError` type.
  internal static func newBrokenPipeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBrokenPipeError {
    return PyBrokenPipeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - BufferError

  /// Allocate new instance of `BufferError` type.
  internal static func newBufferError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBufferError {
    return PyBufferError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `BufferError` type.
  internal static func newBufferError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBufferError {
    return PyBufferError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - BytesWarning

  /// Allocate new instance of `BytesWarning` type.
  internal static func newBytesWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBytesWarning {
    return PyBytesWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `BytesWarning` type.
  internal static func newBytesWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyBytesWarning {
    return PyBytesWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ChildProcessError

  /// Allocate new instance of `ChildProcessError` type.
  internal static func newChildProcessError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyChildProcessError {
    return PyChildProcessError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ChildProcessError` type.
  internal static func newChildProcessError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyChildProcessError {
    return PyChildProcessError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ConnectionAbortedError

  /// Allocate new instance of `ConnectionAbortedError` type.
  internal static func newConnectionAbortedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionAbortedError {
    return PyConnectionAbortedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ConnectionAbortedError` type.
  internal static func newConnectionAbortedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionAbortedError {
    return PyConnectionAbortedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ConnectionError

  /// Allocate new instance of `ConnectionError` type.
  internal static func newConnectionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionError {
    return PyConnectionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ConnectionError` type.
  internal static func newConnectionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionError {
    return PyConnectionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ConnectionRefusedError

  /// Allocate new instance of `ConnectionRefusedError` type.
  internal static func newConnectionRefusedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionRefusedError {
    return PyConnectionRefusedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ConnectionRefusedError` type.
  internal static func newConnectionRefusedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionRefusedError {
    return PyConnectionRefusedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ConnectionResetError

  /// Allocate new instance of `ConnectionResetError` type.
  internal static func newConnectionResetError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionResetError {
    return PyConnectionResetError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ConnectionResetError` type.
  internal static func newConnectionResetError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyConnectionResetError {
    return PyConnectionResetError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - DeprecationWarning

  /// Allocate new instance of `DeprecationWarning` type.
  internal static func newDeprecationWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyDeprecationWarning {
    return PyDeprecationWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `DeprecationWarning` type.
  internal static func newDeprecationWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyDeprecationWarning {
    return PyDeprecationWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - EOFError

  /// Allocate new instance of `EOFError` type.
  internal static func newEOFError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyEOFError {
    return PyEOFError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `EOFError` type.
  internal static func newEOFError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyEOFError {
    return PyEOFError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - Exception

  /// Allocate new instance of `Exception` type.
  internal static func newException(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyException {
    return PyException(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `Exception` type.
  internal static func newException(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyException {
    return PyException(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - FileExistsError

  /// Allocate new instance of `FileExistsError` type.
  internal static func newFileExistsError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFileExistsError {
    return PyFileExistsError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `FileExistsError` type.
  internal static func newFileExistsError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFileExistsError {
    return PyFileExistsError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - FileNotFoundError

  /// Allocate new instance of `FileNotFoundError` type.
  internal static func newFileNotFoundError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFileNotFoundError {
    return PyFileNotFoundError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `FileNotFoundError` type.
  internal static func newFileNotFoundError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFileNotFoundError {
    return PyFileNotFoundError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - FloatingPointError

  /// Allocate new instance of `FloatingPointError` type.
  internal static func newFloatingPointError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFloatingPointError {
    return PyFloatingPointError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `FloatingPointError` type.
  internal static func newFloatingPointError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFloatingPointError {
    return PyFloatingPointError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - FutureWarning

  /// Allocate new instance of `FutureWarning` type.
  internal static func newFutureWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFutureWarning {
    return PyFutureWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `FutureWarning` type.
  internal static func newFutureWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyFutureWarning {
    return PyFutureWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - GeneratorExit

  /// Allocate new instance of `GeneratorExit` type.
  internal static func newGeneratorExit(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyGeneratorExit {
    return PyGeneratorExit(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `GeneratorExit` type.
  internal static func newGeneratorExit(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyGeneratorExit {
    return PyGeneratorExit(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ImportError

  /// Allocate new instance of `ImportError` type.
  internal static func newImportError(
    msg: String?,
    moduleName: String?,
    modulePath: String?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyImportError {
    return PyImportError(
      msg: msg,
      moduleName: moduleName,
      modulePath: modulePath,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ImportError` type.
  internal static func newImportError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyImportError {
    return PyImportError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ImportWarning

  /// Allocate new instance of `ImportWarning` type.
  internal static func newImportWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyImportWarning {
    return PyImportWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ImportWarning` type.
  internal static func newImportWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyImportWarning {
    return PyImportWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - IndentationError

  /// Allocate new instance of `IndentationError` type.
  internal static func newIndentationError(
    msg: String?,
    filename: String?,
    lineno: BigInt?,
    offset: BigInt?,
    text: String?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIndentationError {
    return PyIndentationError(
      msg: msg,
      filename: filename,
      lineno: lineno,
      offset: offset,
      text: text,
      printFileAndLine: printFileAndLine,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `IndentationError` type.
  internal static func newIndentationError(
    msg: PyString?,
    filename: PyString?,
    lineno: PyInt?,
    offset: PyInt?,
    text: PyString?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIndentationError {
    return PyIndentationError(
      msg: msg,
      filename: filename,
      lineno: lineno,
      offset: offset,
      text: text,
      printFileAndLine: printFileAndLine,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `IndentationError` type.
  internal static func newIndentationError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIndentationError {
    return PyIndentationError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - IndexError

  /// Allocate new instance of `IndexError` type.
  internal static func newIndexError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIndexError {
    return PyIndexError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `IndexError` type.
  internal static func newIndexError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIndexError {
    return PyIndexError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - InterruptedError

  /// Allocate new instance of `InterruptedError` type.
  internal static func newInterruptedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyInterruptedError {
    return PyInterruptedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `InterruptedError` type.
  internal static func newInterruptedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyInterruptedError {
    return PyInterruptedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - IsADirectoryError

  /// Allocate new instance of `IsADirectoryError` type.
  internal static func newIsADirectoryError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIsADirectoryError {
    return PyIsADirectoryError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `IsADirectoryError` type.
  internal static func newIsADirectoryError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyIsADirectoryError {
    return PyIsADirectoryError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - KeyError

  /// Allocate new instance of `KeyError` type.
  internal static func newKeyError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyKeyError {
    return PyKeyError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `KeyError` type.
  internal static func newKeyError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyKeyError {
    return PyKeyError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - KeyboardInterrupt

  /// Allocate new instance of `KeyboardInterrupt` type.
  internal static func newKeyboardInterrupt(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyKeyboardInterrupt {
    return PyKeyboardInterrupt(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `KeyboardInterrupt` type.
  internal static func newKeyboardInterrupt(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyKeyboardInterrupt {
    return PyKeyboardInterrupt(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - LookupError

  /// Allocate new instance of `LookupError` type.
  internal static func newLookupError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyLookupError {
    return PyLookupError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `LookupError` type.
  internal static func newLookupError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyLookupError {
    return PyLookupError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - MemoryError

  /// Allocate new instance of `MemoryError` type.
  internal static func newMemoryError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyMemoryError {
    return PyMemoryError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `MemoryError` type.
  internal static func newMemoryError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyMemoryError {
    return PyMemoryError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ModuleNotFoundError

  /// Allocate new instance of `ModuleNotFoundError` type.
  internal static func newModuleNotFoundError(
    msg: String?,
    moduleName: String?,
    modulePath: String?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyModuleNotFoundError {
    return PyModuleNotFoundError(
      msg: msg,
      moduleName: moduleName,
      modulePath: modulePath,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ModuleNotFoundError` type.
  internal static func newModuleNotFoundError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyModuleNotFoundError {
    return PyModuleNotFoundError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - NameError

  /// Allocate new instance of `NameError` type.
  internal static func newNameError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyNameError {
    return PyNameError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `NameError` type.
  internal static func newNameError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyNameError {
    return PyNameError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - NotADirectoryError

  /// Allocate new instance of `NotADirectoryError` type.
  internal static func newNotADirectoryError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyNotADirectoryError {
    return PyNotADirectoryError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `NotADirectoryError` type.
  internal static func newNotADirectoryError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyNotADirectoryError {
    return PyNotADirectoryError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - NotImplementedError

  /// Allocate new instance of `NotImplementedError` type.
  internal static func newNotImplementedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyNotImplementedError {
    return PyNotImplementedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `NotImplementedError` type.
  internal static func newNotImplementedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyNotImplementedError {
    return PyNotImplementedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - OSError

  /// Allocate new instance of `OSError` type.
  internal static func newOSError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyOSError {
    return PyOSError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `OSError` type.
  internal static func newOSError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyOSError {
    return PyOSError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - OverflowError

  /// Allocate new instance of `OverflowError` type.
  internal static func newOverflowError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyOverflowError {
    return PyOverflowError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `OverflowError` type.
  internal static func newOverflowError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyOverflowError {
    return PyOverflowError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - PendingDeprecationWarning

  /// Allocate new instance of `PendingDeprecationWarning` type.
  internal static func newPendingDeprecationWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyPendingDeprecationWarning {
    return PyPendingDeprecationWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `PendingDeprecationWarning` type.
  internal static func newPendingDeprecationWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyPendingDeprecationWarning {
    return PyPendingDeprecationWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - PermissionError

  /// Allocate new instance of `PermissionError` type.
  internal static func newPermissionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyPermissionError {
    return PyPermissionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `PermissionError` type.
  internal static func newPermissionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyPermissionError {
    return PyPermissionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ProcessLookupError

  /// Allocate new instance of `ProcessLookupError` type.
  internal static func newProcessLookupError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyProcessLookupError {
    return PyProcessLookupError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ProcessLookupError` type.
  internal static func newProcessLookupError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyProcessLookupError {
    return PyProcessLookupError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - RecursionError

  /// Allocate new instance of `RecursionError` type.
  internal static func newRecursionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyRecursionError {
    return PyRecursionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `RecursionError` type.
  internal static func newRecursionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyRecursionError {
    return PyRecursionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ReferenceError

  /// Allocate new instance of `ReferenceError` type.
  internal static func newReferenceError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyReferenceError {
    return PyReferenceError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ReferenceError` type.
  internal static func newReferenceError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyReferenceError {
    return PyReferenceError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ResourceWarning

  /// Allocate new instance of `ResourceWarning` type.
  internal static func newResourceWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyResourceWarning {
    return PyResourceWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ResourceWarning` type.
  internal static func newResourceWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyResourceWarning {
    return PyResourceWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - RuntimeError

  /// Allocate new instance of `RuntimeError` type.
  internal static func newRuntimeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyRuntimeError {
    return PyRuntimeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `RuntimeError` type.
  internal static func newRuntimeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyRuntimeError {
    return PyRuntimeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - RuntimeWarning

  /// Allocate new instance of `RuntimeWarning` type.
  internal static func newRuntimeWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyRuntimeWarning {
    return PyRuntimeWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `RuntimeWarning` type.
  internal static func newRuntimeWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyRuntimeWarning {
    return PyRuntimeWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - StopAsyncIteration

  /// Allocate new instance of `StopAsyncIteration` type.
  internal static func newStopAsyncIteration(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyStopAsyncIteration {
    return PyStopAsyncIteration(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `StopAsyncIteration` type.
  internal static func newStopAsyncIteration(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyStopAsyncIteration {
    return PyStopAsyncIteration(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - StopIteration

  /// Allocate new instance of `StopIteration` type.
  internal static func newStopIteration(
    value: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyStopIteration {
    return PyStopIteration(
      value: value,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `StopIteration` type.
  internal static func newStopIteration(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyStopIteration {
    return PyStopIteration(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - SyntaxError

  /// Allocate new instance of `SyntaxError` type.
  internal static func newSyntaxError(
    msg: String?,
    filename: String?,
    lineno: BigInt?,
    offset: BigInt?,
    text: String?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySyntaxError {
    return PySyntaxError(
      msg: msg,
      filename: filename,
      lineno: lineno,
      offset: offset,
      text: text,
      printFileAndLine: printFileAndLine,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `SyntaxError` type.
  internal static func newSyntaxError(
    msg: PyString?,
    filename: PyString?,
    lineno: PyInt?,
    offset: PyInt?,
    text: PyString?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySyntaxError {
    return PySyntaxError(
      msg: msg,
      filename: filename,
      lineno: lineno,
      offset: offset,
      text: text,
      printFileAndLine: printFileAndLine,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `SyntaxError` type.
  internal static func newSyntaxError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySyntaxError {
    return PySyntaxError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - SyntaxWarning

  /// Allocate new instance of `SyntaxWarning` type.
  internal static func newSyntaxWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySyntaxWarning {
    return PySyntaxWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `SyntaxWarning` type.
  internal static func newSyntaxWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySyntaxWarning {
    return PySyntaxWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - SystemError

  /// Allocate new instance of `SystemError` type.
  internal static func newSystemError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySystemError {
    return PySystemError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `SystemError` type.
  internal static func newSystemError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySystemError {
    return PySystemError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - SystemExit

  /// Allocate new instance of `SystemExit` type.
  internal static func newSystemExit(
    code: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySystemExit {
    return PySystemExit(
      code: code,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `SystemExit` type.
  internal static func newSystemExit(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PySystemExit {
    return PySystemExit(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - TabError

  /// Allocate new instance of `TabError` type.
  internal static func newTabError(
    msg: String?,
    filename: String?,
    lineno: BigInt?,
    offset: BigInt?,
    text: String?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTabError {
    return PyTabError(
      msg: msg,
      filename: filename,
      lineno: lineno,
      offset: offset,
      text: text,
      printFileAndLine: printFileAndLine,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `TabError` type.
  internal static func newTabError(
    msg: PyString?,
    filename: PyString?,
    lineno: PyInt?,
    offset: PyInt?,
    text: PyString?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTabError {
    return PyTabError(
      msg: msg,
      filename: filename,
      lineno: lineno,
      offset: offset,
      text: text,
      printFileAndLine: printFileAndLine,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `TabError` type.
  internal static func newTabError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTabError {
    return PyTabError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - TimeoutError

  /// Allocate new instance of `TimeoutError` type.
  internal static func newTimeoutError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTimeoutError {
    return PyTimeoutError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `TimeoutError` type.
  internal static func newTimeoutError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTimeoutError {
    return PyTimeoutError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - TypeError

  /// Allocate new instance of `TypeError` type.
  internal static func newTypeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTypeError {
    return PyTypeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `TypeError` type.
  internal static func newTypeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyTypeError {
    return PyTypeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UnboundLocalError

  /// Allocate new instance of `UnboundLocalError` type.
  internal static func newUnboundLocalError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnboundLocalError {
    return PyUnboundLocalError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UnboundLocalError` type.
  internal static func newUnboundLocalError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnboundLocalError {
    return PyUnboundLocalError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UnicodeDecodeError

  /// Allocate new instance of `UnicodeDecodeError` type.
  internal static func newUnicodeDecodeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeDecodeError {
    return PyUnicodeDecodeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UnicodeDecodeError` type.
  internal static func newUnicodeDecodeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeDecodeError {
    return PyUnicodeDecodeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UnicodeEncodeError

  /// Allocate new instance of `UnicodeEncodeError` type.
  internal static func newUnicodeEncodeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeEncodeError {
    return PyUnicodeEncodeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UnicodeEncodeError` type.
  internal static func newUnicodeEncodeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeEncodeError {
    return PyUnicodeEncodeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UnicodeError

  /// Allocate new instance of `UnicodeError` type.
  internal static func newUnicodeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeError {
    return PyUnicodeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UnicodeError` type.
  internal static func newUnicodeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeError {
    return PyUnicodeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UnicodeTranslateError

  /// Allocate new instance of `UnicodeTranslateError` type.
  internal static func newUnicodeTranslateError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeTranslateError {
    return PyUnicodeTranslateError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UnicodeTranslateError` type.
  internal static func newUnicodeTranslateError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeTranslateError {
    return PyUnicodeTranslateError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UnicodeWarning

  /// Allocate new instance of `UnicodeWarning` type.
  internal static func newUnicodeWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeWarning {
    return PyUnicodeWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UnicodeWarning` type.
  internal static func newUnicodeWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUnicodeWarning {
    return PyUnicodeWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - UserWarning

  /// Allocate new instance of `UserWarning` type.
  internal static func newUserWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUserWarning {
    return PyUserWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `UserWarning` type.
  internal static func newUserWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyUserWarning {
    return PyUserWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ValueError

  /// Allocate new instance of `ValueError` type.
  internal static func newValueError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyValueError {
    return PyValueError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ValueError` type.
  internal static func newValueError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyValueError {
    return PyValueError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - Warning

  /// Allocate new instance of `Warning` type.
  internal static func newWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyWarning {
    return PyWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `Warning` type.
  internal static func newWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyWarning {
    return PyWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  // MARK: - ZeroDivisionError

  /// Allocate new instance of `ZeroDivisionError` type.
  internal static func newZeroDivisionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyZeroDivisionError {
    return PyZeroDivisionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

  /// Allocate new instance of `ZeroDivisionError` type.
  internal static func newZeroDivisionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false,
    type: PyType? = nil
  ) -> PyZeroDivisionError {
    return PyZeroDivisionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext,
      type: type
    )
  }

}
