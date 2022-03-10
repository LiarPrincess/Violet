/* MARKER
// =====================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyMemory.py
// Use 'make gen' in repository root to regenerate.
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

  /// Allocate a new instance of `object` type.
  internal static func newObject(
    type: PyType
  ) -> PyObject {
    return PyObject(
      type: type
    )
  }

  /// Allocate a new instance of `object` type.
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.
  internal static func newObject(
  ) -> PyObject {
    return PyObject(
    )
  }

  // MARK: - Bool

  /// Allocate a new instance of `bool` type.
  internal static func newBool(
    value: Bool
  ) -> PyBool {
    return PyBool(
      value: value
    )
  }

  // MARK: - BuiltinFunction

  /// Allocate a new instance of `builtinFunction` type.
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

  /// Allocate a new instance of `builtinMethod` type.
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

  /// Allocate a new instance of `bytearray` type.
  internal static func newByteArray(
    elements: Data
  ) -> PyByteArray {
    return PyByteArray(
      elements: elements
    )
  }

  /// Allocate a new instance of `bytearray` type.
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

  /// Allocate a new instance of `bytearray_iterator` type.
  internal static func newByteArrayIterator(
    bytes: PyByteArray
  ) -> PyByteArrayIterator {
    return PyByteArrayIterator(
      bytes: bytes
    )
  }

  // MARK: - Bytes

  /// Allocate a new instance of `bytes` type.
  internal static func newBytes(
    elements: Data
  ) -> PyBytes {
    return PyBytes(
      elements: elements
    )
  }

  /// Allocate a new instance of `bytes` type.
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

  /// Allocate a new instance of `bytes_iterator` type.
  internal static func newBytesIterator(
    bytes: PyBytes
  ) -> PyBytesIterator {
    return PyBytesIterator(
      bytes: bytes
    )
  }

  // MARK: - CallableIterator

  /// Allocate a new instance of `callable_iterator` type.
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

  /// Allocate a new instance of `cell` type.
  internal static func newCell(
    content: PyObject?
  ) -> PyCell {
    return PyCell(
      content: content
    )
  }

  // MARK: - ClassMethod

  /// Allocate a new instance of `classmethod` type.
  internal static func newClassMethod(
    callable: PyObject
  ) -> PyClassMethod {
    return PyClassMethod(
      callable: callable
    )
  }

  /// Allocate a new instance of `classmethod` type.
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

  /// Allocate a new instance of `code` type.
  internal static func newCode(
    code: CodeObject
  ) -> PyCode {
    return PyCode(
      code: code
    )
  }

  // MARK: - Complex

  /// Allocate a new instance of `complex` type.
  internal static func newComplex(
    real: Double,
    imag: Double
  ) -> PyComplex {
    return PyComplex(
      real: real,
      imag: imag
    )
  }

  /// Allocate a new instance of `complex` type.
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

  /// Allocate a new instance of `dict` type.
  internal static func newDict(
    elements: PyDict.OrderedDictionary
  ) -> PyDict {
    return PyDict(
      elements: elements
    )
  }

  /// Allocate a new instance of `dict` type.
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

  /// Allocate a new instance of `dict_itemiterator` type.
  internal static func newDictItemIterator(
    dict: PyDict
  ) -> PyDictItemIterator {
    return PyDictItemIterator(
      dict: dict
    )
  }

  // MARK: - DictItems

  /// Allocate a new instance of `dict_items` type.
  internal static func newDictItems(
    dict: PyDict
  ) -> PyDictItems {
    return PyDictItems(
      dict: dict
    )
  }

  // MARK: - DictKeyIterator

  /// Allocate a new instance of `dict_keyiterator` type.
  internal static func newDictKeyIterator(
    dict: PyDict
  ) -> PyDictKeyIterator {
    return PyDictKeyIterator(
      dict: dict
    )
  }

  // MARK: - DictKeys

  /// Allocate a new instance of `dict_keys` type.
  internal static func newDictKeys(
    dict: PyDict
  ) -> PyDictKeys {
    return PyDictKeys(
      dict: dict
    )
  }

  // MARK: - DictValueIterator

  /// Allocate a new instance of `dict_valueiterator` type.
  internal static func newDictValueIterator(
    dict: PyDict
  ) -> PyDictValueIterator {
    return PyDictValueIterator(
      dict: dict
    )
  }

  // MARK: - DictValues

  /// Allocate a new instance of `dict_values` type.
  internal static func newDictValues(
    dict: PyDict
  ) -> PyDictValues {
    return PyDictValues(
      dict: dict
    )
  }

  // MARK: - Ellipsis

  /// Allocate a new instance of `ellipsis` type.
  internal static func newEllipsis(
  ) -> PyEllipsis {
    return PyEllipsis(
    )
  }

  // MARK: - Enumerate

  /// Allocate a new instance of `enumerate` type.
  internal static func newEnumerate(
    iterator: PyObject,
    startFrom index: BigInt
  ) -> PyEnumerate {
    return PyEnumerate(
      iterator: iterator,
      startFrom: index
    )
  }

  /// Allocate a new instance of `enumerate` type.
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

  /// Allocate a new instance of `filter` type.
  internal static func newFilter(
    fn: PyObject,
    iterator: PyObject
  ) -> PyFilter {
    return PyFilter(
      fn: fn,
      iterator: iterator
    )
  }

  /// Allocate a new instance of `filter` type.
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

  /// Allocate a new instance of `float` type.
  internal static func newFloat(
    value: Double
  ) -> PyFloat {
    return PyFloat(
      value: value
    )
  }

  /// Allocate a new instance of `float` type.
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

  /// Allocate a new instance of `frame` type.
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

  /// Allocate a new instance of `frozenset` type.
  internal static func newFrozenSet(
    elements: PyFrozenSet.OrderedSet
  ) -> PyFrozenSet {
    return PyFrozenSet(
      elements: elements
    )
  }

  /// Allocate a new instance of `frozenset` type.
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

  /// Allocate a new instance of `function` type.
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

  /// Allocate a new instance of `int` type.
  internal static func newInt(
    value: BigInt
  ) -> PyInt {
    return PyInt(
      value: value
    )
  }

  /// Allocate a new instance of `int` type.
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

  /// Allocate a new instance of `iterator` type.
  internal static func newIterator(
    sequence: PyObject
  ) -> PyIterator {
    return PyIterator(
      sequence: sequence
    )
  }

  // MARK: - List

  /// Allocate a new instance of `list` type.
  internal static func newList(
    elements: [PyObject]
  ) -> PyList {
    return PyList(
      elements: elements
    )
  }

  /// Allocate a new instance of `list` type.
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

  /// Allocate a new instance of `list_iterator` type.
  internal static func newListIterator(
    list: PyList
  ) -> PyListIterator {
    return PyListIterator(
      list: list
    )
  }

  // MARK: - ListReverseIterator

  /// Allocate a new instance of `list_reverseiterator` type.
  internal static func newListReverseIterator(
    list: PyList
  ) -> PyListReverseIterator {
    return PyListReverseIterator(
      list: list
    )
  }

  // MARK: - Map

  /// Allocate a new instance of `map` type.
  internal static func newMap(
    fn: PyObject,
    iterators: [PyObject]
  ) -> PyMap {
    return PyMap(
      fn: fn,
      iterators: iterators
    )
  }

  /// Allocate a new instance of `map` type.
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

  /// Allocate a new instance of `method` type.
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

  /// Allocate a new instance of `module` type.
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

  /// Allocate a new instance of `module` type.
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

  /// Allocate a new instance of `SimpleNamespace` type.
  internal static func newNamespace(
    dict: PyDict
  ) -> PyNamespace {
    return PyNamespace(
      dict: dict
    )
  }

  /// Allocate a new instance of `SimpleNamespace` type.
  internal static func newNamespace(
    type: PyType,
    dict: PyDict
  ) -> PyNamespace {
    return PyNamespace(
      type: type,
      dict: dict
    )
  }

  // MARK: - None

  /// Allocate a new instance of `NoneType` type.
  internal static func newNone(
  ) -> PyNone {
    return PyNone(
    )
  }

  // MARK: - NotImplemented

  /// Allocate a new instance of `NotImplementedType` type.
  internal static func newNotImplemented(
  ) -> PyNotImplemented {
    return PyNotImplemented(
    )
  }

  // MARK: - Property

  /// Allocate a new instance of `property` type.
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

  /// Allocate a new instance of `property` type.
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

  /// Allocate a new instance of `range` type.
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

  /// Allocate a new instance of `range_iterator` type.
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

  /// Allocate a new instance of `reversed` type.
  internal static func newReversed(
    sequence: PyObject,
    count: Int
  ) -> PyReversed {
    return PyReversed(
      sequence: sequence,
      count: count
    )
  }

  /// Allocate a new instance of `reversed` type.
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

  /// Allocate a new instance of `set` type.
  internal static func newSet(
    elements: PySet.OrderedSet
  ) -> PySet {
    return PySet(
      elements: elements
    )
  }

  /// Allocate a new instance of `set` type.
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

  /// Allocate a new instance of `set_iterator` type.
  internal static func newSetIterator(
    set: PySet
  ) -> PySetIterator {
    return PySetIterator(
      set: set
    )
  }

  /// Allocate a new instance of `set_iterator` type.
  internal static func newSetIterator(
    frozenSet: PyFrozenSet
  ) -> PySetIterator {
    return PySetIterator(
      frozenSet: frozenSet
    )
  }

  // MARK: - Slice

  /// Allocate a new instance of `slice` type.
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

  /// Allocate a new instance of `staticmethod` type.
  internal static func newStaticMethod(
    callable: PyObject
  ) -> PyStaticMethod {
    return PyStaticMethod(
      callable: callable
    )
  }

  /// Allocate a new instance of `staticmethod` type.
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

  /// Allocate a new instance of `str` type.
  internal static func newString(
    value: String
  ) -> PyString {
    return PyString(
      value: value
    )
  }

  /// Allocate a new instance of `str` type.
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

  /// Allocate a new instance of `str_iterator` type.
  internal static func newStringIterator(
    string: PyString
  ) -> PyStringIterator {
    return PyStringIterator(
      string: string
    )
  }

  // MARK: - Super

  /// Allocate a new instance of `super` type.
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

  /// Allocate a new instance of `super` type.
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

  /// Allocate a new instance of `TextFile` type.
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

  /// Allocate a new instance of `TextFile` type.
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

  // MARK: - Traceback

  /// Allocate a new instance of `traceback` type.
  internal static func newTraceback(
    next: PyTraceback?,
    frame: PyFrame,
    lastInstruction: PyInt,
    lineNo: PyInt
  ) -> PyTraceback {
    return PyTraceback(
      next: next,
      frame: frame,
      lastInstruction: lastInstruction,
      lineNo: lineNo
    )
  }

  // MARK: - Tuple

  /// Allocate a new instance of `tuple` type.
  internal static func newTuple(
    elements: [PyObject]
  ) -> PyTuple {
    return PyTuple(
      elements: elements
    )
  }

  /// Allocate a new instance of `tuple` type.
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

  /// Allocate a new instance of `tuple_iterator` type.
  internal static func newTupleIterator(
    tuple: PyTuple
  ) -> PyTupleIterator {
    return PyTupleIterator(
      tuple: tuple
    )
  }

  // MARK: - Type

  /// Allocate a new instance of `type` type.
  internal static func newType(
    name: String,
    qualname: String,
    metatype: PyType,
    base: PyType,
    mro: MRO,
    typeFlags: PyType.TypeFlags,
    staticMethods: PyType.StaticallyKnownNotOverriddenMethods,
    layout: PyType.MemoryLayout
  ) -> PyType {
    return PyType(
      name: name,
      qualname: qualname,
      metatype: metatype,
      base: base,
      mro: mro,
      typeFlags: typeFlags,
      staticMethods: staticMethods,
      layout: layout
    )
  }

  /// Allocate a new instance of `type` type.
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.
  internal static func newType(
    name: String,
    qualname: String,
    base: PyType?,
    mro: MRO?,
    typeFlags: PyType.TypeFlags,
    staticMethods: PyType.StaticallyKnownNotOverriddenMethods,
    layout: PyType.MemoryLayout
  ) -> PyType {
    return PyType(
      name: name,
      qualname: qualname,
      base: base,
      mro: mro,
      typeFlags: typeFlags,
      staticMethods: staticMethods,
      layout: layout
    )
  }

  // MARK: - Zip

  /// Allocate a new instance of `zip` type.
  internal static func newZip(
    iterators: [PyObject]
  ) -> PyZip {
    return PyZip(
      iterators: iterators
    )
  }

  /// Allocate a new instance of `zip` type.
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

  /// Allocate a new instance of `ArithmeticError` type.
  internal static func newArithmeticError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyArithmeticError {
    return PyArithmeticError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ArithmeticError` type.
  internal static func newArithmeticError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyArithmeticError {
    return PyArithmeticError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ArithmeticError` type.
  internal static func newArithmeticError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyArithmeticError {
    return PyArithmeticError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - AssertionError

  /// Allocate a new instance of `AssertionError` type.
  internal static func newAssertionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyAssertionError {
    return PyAssertionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `AssertionError` type.
  internal static func newAssertionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyAssertionError {
    return PyAssertionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `AssertionError` type.
  internal static func newAssertionError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyAssertionError {
    return PyAssertionError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - AttributeError

  /// Allocate a new instance of `AttributeError` type.
  internal static func newAttributeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyAttributeError {
    return PyAttributeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `AttributeError` type.
  internal static func newAttributeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyAttributeError {
    return PyAttributeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `AttributeError` type.
  internal static func newAttributeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyAttributeError {
    return PyAttributeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - BaseException

  /// Allocate a new instance of `BaseException` type.
  internal static func newBaseException(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBaseException {
    return PyBaseException(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BaseException` type.
  internal static func newBaseException(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBaseException {
    return PyBaseException(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BaseException` type.
  internal static func newBaseException(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBaseException {
    return PyBaseException(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - BlockingIOError

  /// Allocate a new instance of `BlockingIOError` type.
  internal static func newBlockingIOError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBlockingIOError {
    return PyBlockingIOError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BlockingIOError` type.
  internal static func newBlockingIOError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBlockingIOError {
    return PyBlockingIOError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BlockingIOError` type.
  internal static func newBlockingIOError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBlockingIOError {
    return PyBlockingIOError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - BrokenPipeError

  /// Allocate a new instance of `BrokenPipeError` type.
  internal static func newBrokenPipeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBrokenPipeError {
    return PyBrokenPipeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BrokenPipeError` type.
  internal static func newBrokenPipeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBrokenPipeError {
    return PyBrokenPipeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BrokenPipeError` type.
  internal static func newBrokenPipeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBrokenPipeError {
    return PyBrokenPipeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - BufferError

  /// Allocate a new instance of `BufferError` type.
  internal static func newBufferError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBufferError {
    return PyBufferError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BufferError` type.
  internal static func newBufferError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBufferError {
    return PyBufferError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BufferError` type.
  internal static func newBufferError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBufferError {
    return PyBufferError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - BytesWarning

  /// Allocate a new instance of `BytesWarning` type.
  internal static func newBytesWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBytesWarning {
    return PyBytesWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BytesWarning` type.
  internal static func newBytesWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBytesWarning {
    return PyBytesWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `BytesWarning` type.
  internal static func newBytesWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyBytesWarning {
    return PyBytesWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ChildProcessError

  /// Allocate a new instance of `ChildProcessError` type.
  internal static func newChildProcessError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyChildProcessError {
    return PyChildProcessError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ChildProcessError` type.
  internal static func newChildProcessError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyChildProcessError {
    return PyChildProcessError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ChildProcessError` type.
  internal static func newChildProcessError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyChildProcessError {
    return PyChildProcessError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ConnectionAbortedError

  /// Allocate a new instance of `ConnectionAbortedError` type.
  internal static func newConnectionAbortedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionAbortedError {
    return PyConnectionAbortedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionAbortedError` type.
  internal static func newConnectionAbortedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionAbortedError {
    return PyConnectionAbortedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionAbortedError` type.
  internal static func newConnectionAbortedError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionAbortedError {
    return PyConnectionAbortedError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ConnectionError

  /// Allocate a new instance of `ConnectionError` type.
  internal static func newConnectionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionError {
    return PyConnectionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionError` type.
  internal static func newConnectionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionError {
    return PyConnectionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionError` type.
  internal static func newConnectionError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionError {
    return PyConnectionError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ConnectionRefusedError

  /// Allocate a new instance of `ConnectionRefusedError` type.
  internal static func newConnectionRefusedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionRefusedError {
    return PyConnectionRefusedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionRefusedError` type.
  internal static func newConnectionRefusedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionRefusedError {
    return PyConnectionRefusedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionRefusedError` type.
  internal static func newConnectionRefusedError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionRefusedError {
    return PyConnectionRefusedError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ConnectionResetError

  /// Allocate a new instance of `ConnectionResetError` type.
  internal static func newConnectionResetError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionResetError {
    return PyConnectionResetError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionResetError` type.
  internal static func newConnectionResetError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionResetError {
    return PyConnectionResetError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ConnectionResetError` type.
  internal static func newConnectionResetError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyConnectionResetError {
    return PyConnectionResetError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - DeprecationWarning

  /// Allocate a new instance of `DeprecationWarning` type.
  internal static func newDeprecationWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyDeprecationWarning {
    return PyDeprecationWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `DeprecationWarning` type.
  internal static func newDeprecationWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyDeprecationWarning {
    return PyDeprecationWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `DeprecationWarning` type.
  internal static func newDeprecationWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyDeprecationWarning {
    return PyDeprecationWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - EOFError

  /// Allocate a new instance of `EOFError` type.
  internal static func newEOFError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyEOFError {
    return PyEOFError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `EOFError` type.
  internal static func newEOFError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyEOFError {
    return PyEOFError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `EOFError` type.
  internal static func newEOFError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyEOFError {
    return PyEOFError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - Exception

  /// Allocate a new instance of `Exception` type.
  internal static func newException(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyException {
    return PyException(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `Exception` type.
  internal static func newException(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyException {
    return PyException(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `Exception` type.
  internal static func newException(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyException {
    return PyException(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - FileExistsError

  /// Allocate a new instance of `FileExistsError` type.
  internal static func newFileExistsError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFileExistsError {
    return PyFileExistsError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FileExistsError` type.
  internal static func newFileExistsError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFileExistsError {
    return PyFileExistsError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FileExistsError` type.
  internal static func newFileExistsError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFileExistsError {
    return PyFileExistsError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - FileNotFoundError

  /// Allocate a new instance of `FileNotFoundError` type.
  internal static func newFileNotFoundError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFileNotFoundError {
    return PyFileNotFoundError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FileNotFoundError` type.
  internal static func newFileNotFoundError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFileNotFoundError {
    return PyFileNotFoundError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FileNotFoundError` type.
  internal static func newFileNotFoundError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFileNotFoundError {
    return PyFileNotFoundError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - FloatingPointError

  /// Allocate a new instance of `FloatingPointError` type.
  internal static func newFloatingPointError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFloatingPointError {
    return PyFloatingPointError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FloatingPointError` type.
  internal static func newFloatingPointError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFloatingPointError {
    return PyFloatingPointError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FloatingPointError` type.
  internal static func newFloatingPointError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFloatingPointError {
    return PyFloatingPointError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - FutureWarning

  /// Allocate a new instance of `FutureWarning` type.
  internal static func newFutureWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFutureWarning {
    return PyFutureWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FutureWarning` type.
  internal static func newFutureWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFutureWarning {
    return PyFutureWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `FutureWarning` type.
  internal static func newFutureWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyFutureWarning {
    return PyFutureWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - GeneratorExit

  /// Allocate a new instance of `GeneratorExit` type.
  internal static func newGeneratorExit(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyGeneratorExit {
    return PyGeneratorExit(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `GeneratorExit` type.
  internal static func newGeneratorExit(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyGeneratorExit {
    return PyGeneratorExit(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `GeneratorExit` type.
  internal static func newGeneratorExit(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyGeneratorExit {
    return PyGeneratorExit(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ImportError

  /// Allocate a new instance of `ImportError` type.
  internal static func newImportError(
    msg: String?,
    moduleName: String?,
    modulePath: String?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyImportError {
    return PyImportError(
      msg: msg,
      moduleName: moduleName,
      modulePath: modulePath,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ImportError` type.
  internal static func newImportError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyImportError {
    return PyImportError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ImportWarning

  /// Allocate a new instance of `ImportWarning` type.
  internal static func newImportWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyImportWarning {
    return PyImportWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ImportWarning` type.
  internal static func newImportWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyImportWarning {
    return PyImportWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ImportWarning` type.
  internal static func newImportWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyImportWarning {
    return PyImportWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - IndentationError

  /// Allocate a new instance of `IndentationError` type.
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
    suppressContext: Bool = false
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
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `IndentationError` type.
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
    suppressContext: Bool = false
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
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `IndentationError` type.
  internal static func newIndentationError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIndentationError {
    return PyIndentationError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - IndexError

  /// Allocate a new instance of `IndexError` type.
  internal static func newIndexError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIndexError {
    return PyIndexError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `IndexError` type.
  internal static func newIndexError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIndexError {
    return PyIndexError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `IndexError` type.
  internal static func newIndexError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIndexError {
    return PyIndexError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - InterruptedError

  /// Allocate a new instance of `InterruptedError` type.
  internal static func newInterruptedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyInterruptedError {
    return PyInterruptedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `InterruptedError` type.
  internal static func newInterruptedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyInterruptedError {
    return PyInterruptedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `InterruptedError` type.
  internal static func newInterruptedError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyInterruptedError {
    return PyInterruptedError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - IsADirectoryError

  /// Allocate a new instance of `IsADirectoryError` type.
  internal static func newIsADirectoryError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIsADirectoryError {
    return PyIsADirectoryError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `IsADirectoryError` type.
  internal static func newIsADirectoryError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIsADirectoryError {
    return PyIsADirectoryError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `IsADirectoryError` type.
  internal static func newIsADirectoryError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyIsADirectoryError {
    return PyIsADirectoryError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - KeyError

  /// Allocate a new instance of `KeyError` type.
  internal static func newKeyError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyKeyError {
    return PyKeyError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `KeyError` type.
  internal static func newKeyError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyKeyError {
    return PyKeyError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `KeyError` type.
  internal static func newKeyError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyKeyError {
    return PyKeyError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - KeyboardInterrupt

  /// Allocate a new instance of `KeyboardInterrupt` type.
  internal static func newKeyboardInterrupt(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyKeyboardInterrupt {
    return PyKeyboardInterrupt(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `KeyboardInterrupt` type.
  internal static func newKeyboardInterrupt(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyKeyboardInterrupt {
    return PyKeyboardInterrupt(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `KeyboardInterrupt` type.
  internal static func newKeyboardInterrupt(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyKeyboardInterrupt {
    return PyKeyboardInterrupt(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - LookupError

  /// Allocate a new instance of `LookupError` type.
  internal static func newLookupError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyLookupError {
    return PyLookupError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `LookupError` type.
  internal static func newLookupError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyLookupError {
    return PyLookupError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `LookupError` type.
  internal static func newLookupError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyLookupError {
    return PyLookupError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - MemoryError

  /// Allocate a new instance of `MemoryError` type.
  internal static func newMemoryError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyMemoryError {
    return PyMemoryError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `MemoryError` type.
  internal static func newMemoryError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyMemoryError {
    return PyMemoryError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `MemoryError` type.
  internal static func newMemoryError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyMemoryError {
    return PyMemoryError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ModuleNotFoundError

  /// Allocate a new instance of `ModuleNotFoundError` type.
  internal static func newModuleNotFoundError(
    msg: String?,
    moduleName: String?,
    modulePath: String?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyModuleNotFoundError {
    return PyModuleNotFoundError(
      msg: msg,
      moduleName: moduleName,
      modulePath: modulePath,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ModuleNotFoundError` type.
  internal static func newModuleNotFoundError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyModuleNotFoundError {
    return PyModuleNotFoundError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - NameError

  /// Allocate a new instance of `NameError` type.
  internal static func newNameError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNameError {
    return PyNameError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `NameError` type.
  internal static func newNameError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNameError {
    return PyNameError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `NameError` type.
  internal static func newNameError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNameError {
    return PyNameError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - NotADirectoryError

  /// Allocate a new instance of `NotADirectoryError` type.
  internal static func newNotADirectoryError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNotADirectoryError {
    return PyNotADirectoryError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `NotADirectoryError` type.
  internal static func newNotADirectoryError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNotADirectoryError {
    return PyNotADirectoryError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `NotADirectoryError` type.
  internal static func newNotADirectoryError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNotADirectoryError {
    return PyNotADirectoryError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - NotImplementedError

  /// Allocate a new instance of `NotImplementedError` type.
  internal static func newNotImplementedError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNotImplementedError {
    return PyNotImplementedError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `NotImplementedError` type.
  internal static func newNotImplementedError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNotImplementedError {
    return PyNotImplementedError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `NotImplementedError` type.
  internal static func newNotImplementedError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyNotImplementedError {
    return PyNotImplementedError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - OSError

  /// Allocate a new instance of `OSError` type.
  internal static func newOSError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyOSError {
    return PyOSError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `OSError` type.
  internal static func newOSError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyOSError {
    return PyOSError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `OSError` type.
  internal static func newOSError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyOSError {
    return PyOSError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - OverflowError

  /// Allocate a new instance of `OverflowError` type.
  internal static func newOverflowError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyOverflowError {
    return PyOverflowError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `OverflowError` type.
  internal static func newOverflowError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyOverflowError {
    return PyOverflowError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `OverflowError` type.
  internal static func newOverflowError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyOverflowError {
    return PyOverflowError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - PendingDeprecationWarning

  /// Allocate a new instance of `PendingDeprecationWarning` type.
  internal static func newPendingDeprecationWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyPendingDeprecationWarning {
    return PyPendingDeprecationWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `PendingDeprecationWarning` type.
  internal static func newPendingDeprecationWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyPendingDeprecationWarning {
    return PyPendingDeprecationWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `PendingDeprecationWarning` type.
  internal static func newPendingDeprecationWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyPendingDeprecationWarning {
    return PyPendingDeprecationWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - PermissionError

  /// Allocate a new instance of `PermissionError` type.
  internal static func newPermissionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyPermissionError {
    return PyPermissionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `PermissionError` type.
  internal static func newPermissionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyPermissionError {
    return PyPermissionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `PermissionError` type.
  internal static func newPermissionError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyPermissionError {
    return PyPermissionError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ProcessLookupError

  /// Allocate a new instance of `ProcessLookupError` type.
  internal static func newProcessLookupError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyProcessLookupError {
    return PyProcessLookupError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ProcessLookupError` type.
  internal static func newProcessLookupError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyProcessLookupError {
    return PyProcessLookupError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ProcessLookupError` type.
  internal static func newProcessLookupError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyProcessLookupError {
    return PyProcessLookupError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - RecursionError

  /// Allocate a new instance of `RecursionError` type.
  internal static func newRecursionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRecursionError {
    return PyRecursionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `RecursionError` type.
  internal static func newRecursionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRecursionError {
    return PyRecursionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `RecursionError` type.
  internal static func newRecursionError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRecursionError {
    return PyRecursionError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ReferenceError

  /// Allocate a new instance of `ReferenceError` type.
  internal static func newReferenceError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyReferenceError {
    return PyReferenceError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ReferenceError` type.
  internal static func newReferenceError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyReferenceError {
    return PyReferenceError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ReferenceError` type.
  internal static func newReferenceError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyReferenceError {
    return PyReferenceError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ResourceWarning

  /// Allocate a new instance of `ResourceWarning` type.
  internal static func newResourceWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyResourceWarning {
    return PyResourceWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ResourceWarning` type.
  internal static func newResourceWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyResourceWarning {
    return PyResourceWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ResourceWarning` type.
  internal static func newResourceWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyResourceWarning {
    return PyResourceWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - RuntimeError

  /// Allocate a new instance of `RuntimeError` type.
  internal static func newRuntimeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRuntimeError {
    return PyRuntimeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `RuntimeError` type.
  internal static func newRuntimeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRuntimeError {
    return PyRuntimeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `RuntimeError` type.
  internal static func newRuntimeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRuntimeError {
    return PyRuntimeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - RuntimeWarning

  /// Allocate a new instance of `RuntimeWarning` type.
  internal static func newRuntimeWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRuntimeWarning {
    return PyRuntimeWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `RuntimeWarning` type.
  internal static func newRuntimeWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRuntimeWarning {
    return PyRuntimeWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `RuntimeWarning` type.
  internal static func newRuntimeWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyRuntimeWarning {
    return PyRuntimeWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - StopAsyncIteration

  /// Allocate a new instance of `StopAsyncIteration` type.
  internal static func newStopAsyncIteration(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyStopAsyncIteration {
    return PyStopAsyncIteration(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `StopAsyncIteration` type.
  internal static func newStopAsyncIteration(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyStopAsyncIteration {
    return PyStopAsyncIteration(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `StopAsyncIteration` type.
  internal static func newStopAsyncIteration(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyStopAsyncIteration {
    return PyStopAsyncIteration(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - StopIteration

  /// Allocate a new instance of `StopIteration` type.
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

  /// Allocate a new instance of `StopIteration` type.
  internal static func newStopIteration(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyStopIteration {
    return PyStopIteration(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - SyntaxError

  /// Allocate a new instance of `SyntaxError` type.
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
    suppressContext: Bool = false
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
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `SyntaxError` type.
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
    suppressContext: Bool = false
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
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `SyntaxError` type.
  internal static func newSyntaxError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySyntaxError {
    return PySyntaxError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - SyntaxWarning

  /// Allocate a new instance of `SyntaxWarning` type.
  internal static func newSyntaxWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySyntaxWarning {
    return PySyntaxWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `SyntaxWarning` type.
  internal static func newSyntaxWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySyntaxWarning {
    return PySyntaxWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `SyntaxWarning` type.
  internal static func newSyntaxWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySyntaxWarning {
    return PySyntaxWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - SystemError

  /// Allocate a new instance of `SystemError` type.
  internal static func newSystemError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySystemError {
    return PySystemError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `SystemError` type.
  internal static func newSystemError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySystemError {
    return PySystemError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `SystemError` type.
  internal static func newSystemError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySystemError {
    return PySystemError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - SystemExit

  /// Allocate a new instance of `SystemExit` type.
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

  /// Allocate a new instance of `SystemExit` type.
  internal static func newSystemExit(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PySystemExit {
    return PySystemExit(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - TabError

  /// Allocate a new instance of `TabError` type.
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
    suppressContext: Bool = false
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
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `TabError` type.
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
    suppressContext: Bool = false
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
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `TabError` type.
  internal static func newTabError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTabError {
    return PyTabError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - TimeoutError

  /// Allocate a new instance of `TimeoutError` type.
  internal static func newTimeoutError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTimeoutError {
    return PyTimeoutError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `TimeoutError` type.
  internal static func newTimeoutError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTimeoutError {
    return PyTimeoutError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `TimeoutError` type.
  internal static func newTimeoutError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTimeoutError {
    return PyTimeoutError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - TypeError

  /// Allocate a new instance of `TypeError` type.
  internal static func newTypeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTypeError {
    return PyTypeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `TypeError` type.
  internal static func newTypeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTypeError {
    return PyTypeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `TypeError` type.
  internal static func newTypeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyTypeError {
    return PyTypeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UnboundLocalError

  /// Allocate a new instance of `UnboundLocalError` type.
  internal static func newUnboundLocalError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnboundLocalError {
    return PyUnboundLocalError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnboundLocalError` type.
  internal static func newUnboundLocalError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnboundLocalError {
    return PyUnboundLocalError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnboundLocalError` type.
  internal static func newUnboundLocalError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnboundLocalError {
    return PyUnboundLocalError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UnicodeDecodeError

  /// Allocate a new instance of `UnicodeDecodeError` type.
  internal static func newUnicodeDecodeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeDecodeError {
    return PyUnicodeDecodeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeDecodeError` type.
  internal static func newUnicodeDecodeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeDecodeError {
    return PyUnicodeDecodeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeDecodeError` type.
  internal static func newUnicodeDecodeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeDecodeError {
    return PyUnicodeDecodeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UnicodeEncodeError

  /// Allocate a new instance of `UnicodeEncodeError` type.
  internal static func newUnicodeEncodeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeEncodeError {
    return PyUnicodeEncodeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeEncodeError` type.
  internal static func newUnicodeEncodeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeEncodeError {
    return PyUnicodeEncodeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeEncodeError` type.
  internal static func newUnicodeEncodeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeEncodeError {
    return PyUnicodeEncodeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UnicodeError

  /// Allocate a new instance of `UnicodeError` type.
  internal static func newUnicodeError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeError {
    return PyUnicodeError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeError` type.
  internal static func newUnicodeError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeError {
    return PyUnicodeError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeError` type.
  internal static func newUnicodeError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeError {
    return PyUnicodeError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UnicodeTranslateError

  /// Allocate a new instance of `UnicodeTranslateError` type.
  internal static func newUnicodeTranslateError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeTranslateError {
    return PyUnicodeTranslateError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeTranslateError` type.
  internal static func newUnicodeTranslateError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeTranslateError {
    return PyUnicodeTranslateError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeTranslateError` type.
  internal static func newUnicodeTranslateError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeTranslateError {
    return PyUnicodeTranslateError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UnicodeWarning

  /// Allocate a new instance of `UnicodeWarning` type.
  internal static func newUnicodeWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeWarning {
    return PyUnicodeWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeWarning` type.
  internal static func newUnicodeWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeWarning {
    return PyUnicodeWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UnicodeWarning` type.
  internal static func newUnicodeWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUnicodeWarning {
    return PyUnicodeWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - UserWarning

  /// Allocate a new instance of `UserWarning` type.
  internal static func newUserWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUserWarning {
    return PyUserWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UserWarning` type.
  internal static func newUserWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUserWarning {
    return PyUserWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `UserWarning` type.
  internal static func newUserWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyUserWarning {
    return PyUserWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ValueError

  /// Allocate a new instance of `ValueError` type.
  internal static func newValueError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyValueError {
    return PyValueError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ValueError` type.
  internal static func newValueError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyValueError {
    return PyValueError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ValueError` type.
  internal static func newValueError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyValueError {
    return PyValueError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - Warning

  /// Allocate a new instance of `Warning` type.
  internal static func newWarning(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyWarning {
    return PyWarning(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `Warning` type.
  internal static func newWarning(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyWarning {
    return PyWarning(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `Warning` type.
  internal static func newWarning(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyWarning {
    return PyWarning(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  // MARK: - ZeroDivisionError

  /// Allocate a new instance of `ZeroDivisionError` type.
  internal static func newZeroDivisionError(
    msg: String,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyZeroDivisionError {
    return PyZeroDivisionError(
      msg: msg,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ZeroDivisionError` type.
  internal static func newZeroDivisionError(
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyZeroDivisionError {
    return PyZeroDivisionError(
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

  /// Allocate a new instance of `ZeroDivisionError` type.
  internal static func newZeroDivisionError(
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = false
  ) -> PyZeroDivisionError {
    return PyZeroDivisionError(
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )
  }

}

*/