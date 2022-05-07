// ============================================================================
// Automatically generated from: ./Sources/Objects/Generated/Types+Generated.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ============================================================================

import Foundation
import BigInt
import VioletCore
import VioletBytecode

// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

// This file contains:
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - Then for each type:
//   - static let pythonTypeName - name of the type in Python
//   - static let layout - field offsets for memory layout
//   - var xxxPtr - pointer to property (with offset from layout)
//   - var xxx - property from base class
//   - func initializeBase(...) - call base initializer
//   - static func deinitialize(ptr: RawPtr) - to deinitialize this object before deletion
//   - static func downcast(py: Py, object: PyObject) -> [TYPE_NAME]?
//   - static func invalidZelfArgument<T>(py: Py, object: PyObject, fnName: String) -> PyResult<T>
//   - PyMemory.new[TYPE_NAME] - to create new object of this type

// MARK: - Type/object types init

extension PyMemory {

  /// Those types require a special treatment because:
  /// - `object` type has `type` type
  /// - `type` type has `type` type (self reference) and `object` type as base
  public func newTypeAndObjectTypes(_ py: Py) -> (objectType: PyType, typeType: PyType) {
    let layout = PyType.layout
    let typeTypePtr = self.allocateObject(size: layout.size, alignment: layout.alignment)
    let objectTypePtr = self.allocateObject(size: layout.size, alignment: layout.alignment)

    let typeType = PyType(ptr: typeTypePtr)
    let objectType = PyType(ptr: objectTypePtr)

    PyType.initialize(
      typeType: typeType,
      typeTypeFlags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag, .isTypeSubclassFlag],
      objectType: objectType,
      objectTypeFlags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag]
    )

    return (objectType, typeType)
  }
}

// MARK: - PyBool

extension PyBool {

  /// Name of the type in Python.
  public static let pythonTypeName = "bool"

  /// Arrangement of fields in memory.
  ///
  /// `PyBool` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyInt`.
  internal typealias Layout = PyInt.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyInt.value`.
  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: PyInt.layout.valueOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyInt.value`.
  internal var value: BigInt { self.valuePtr.pointee }

  internal func initializeBase(_ py: Py, type: PyType, value: BigInt) {
    let base = PyInt(ptr: self.ptr)
    base.initialize(py, type: type, value: value)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBool(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyInt.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBool? {
    return py.cast.asBool(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bool` type.
  public func newBool(type: PyType, value: Bool) -> PyBool {
    let typeLayout = PyBool.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBool(ptr: ptr)
    result.initialize(self.py, type: type, value: value)

    return result
  }
}

// MARK: - PyBuiltinFunction

extension PyBuiltinFunction {

  /// Name of the type in Python.
  public static let pythonTypeName = "builtinFunction"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBuiltinFunction` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyBuiltinFunction>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(FunctionWrapper.self), // PyBuiltinFunction.function
          GenericLayout.Field(PyObject?.self), // PyBuiltinFunction.module
          GenericLayout.Field(String?.self) // PyBuiltinFunction.doc
        ]
      )

      assert(layout.offsets.count == 3)
      self.functionOffset = layout.offsets[0]
      self.moduleOffset = layout.offsets[1]
      self.docOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyBuiltinFunction.function`.
  internal var functionPtr: Ptr<FunctionWrapper> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  /// Property: `PyBuiltinFunction.module`.
  internal var modulePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  /// Property: `PyBuiltinFunction.doc`.
  internal var docPtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBuiltinFunction(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.functionPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBuiltinFunction? {
    return py.cast.asBuiltinFunction(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `builtinFunction` type.
  public func newBuiltinFunction(type: PyType,
                                 function: FunctionWrapper,
                                 module: PyObject?,
                                 doc: String?) -> PyBuiltinFunction {
    let typeLayout = PyBuiltinFunction.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBuiltinFunction(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      function: function,
                      module: module,
                      doc: doc)

    return result
  }
}

// MARK: - PyBuiltinMethod

extension PyBuiltinMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "builtinMethod"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBuiltinMethod` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyBuiltinMethod>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(FunctionWrapper.self), // PyBuiltinMethod.function
          GenericLayout.Field(PyObject.self), // PyBuiltinMethod.object
          GenericLayout.Field(PyObject?.self), // PyBuiltinMethod.module
          GenericLayout.Field(String?.self) // PyBuiltinMethod.doc
        ]
      )

      assert(layout.offsets.count == 4)
      self.functionOffset = layout.offsets[0]
      self.objectOffset = layout.offsets[1]
      self.moduleOffset = layout.offsets[2]
      self.docOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyBuiltinMethod.function`.
  internal var functionPtr: Ptr<FunctionWrapper> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  /// Property: `PyBuiltinMethod.object`.
  internal var objectPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.objectOffset) }
  /// Property: `PyBuiltinMethod.module`.
  internal var modulePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  /// Property: `PyBuiltinMethod.doc`.
  internal var docPtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBuiltinMethod(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBuiltinMethod? {
    return py.cast.asBuiltinMethod(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `builtinMethod` type.
  public func newBuiltinMethod(type: PyType,
                               function: FunctionWrapper,
                               object: PyObject,
                               module: PyObject?,
                               doc: String?) -> PyBuiltinMethod {
    let typeLayout = PyBuiltinMethod.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBuiltinMethod(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      function: function,
                      object: object,
                      module: module,
                      doc: doc)

    return result
  }
}

// MARK: - PyByteArray

extension PyByteArray {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytearray"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyByteArray` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyByteArray>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(Data.self) // PyByteArray.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyByteArray.elements`.
  internal var elementsPtr: Ptr<Data> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyByteArray(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyByteArray? {
    return py.cast.asByteArray(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytearray` type.
  public func newByteArray(type: PyType, elements: Data) -> PyByteArray {
    let typeLayout = PyByteArray.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyByteArray(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PyByteArrayIterator

extension PyByteArrayIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytearray_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyByteArrayIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyByteArrayIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyByteArray.self), // PyByteArrayIterator.bytes
          GenericLayout.Field(Int.self) // PyByteArrayIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.bytesOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyByteArrayIterator.bytes`.
  internal var bytesPtr: Ptr<PyByteArray> { Ptr(self.ptr, offset: Self.layout.bytesOffset) }
  /// Property: `PyByteArrayIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyByteArrayIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyByteArrayIterator? {
    return py.cast.asByteArrayIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytearray_iterator` type.
  public func newByteArrayIterator(type: PyType, bytes: PyByteArray) -> PyByteArrayIterator {
    let typeLayout = PyByteArrayIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyByteArrayIterator(ptr: ptr)
    result.initialize(self.py, type: type, bytes: bytes)

    return result
  }
}

// MARK: - PyBytes

extension PyBytes {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytes"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBytes` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyBytes>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(Data.self) // PyBytes.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyBytes.elements`.
  internal var elementsPtr: Ptr<Data> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBytes(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBytes? {
    return py.cast.asBytes(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytes` type.
  public func newBytes(type: PyType, elements: Data) -> PyBytes {
    let typeLayout = PyBytes.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBytes(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PyBytesIterator

extension PyBytesIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytes_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBytesIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyBytesIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyBytes.self), // PyBytesIterator.bytes
          GenericLayout.Field(Int.self) // PyBytesIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.bytesOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyBytesIterator.bytes`.
  internal var bytesPtr: Ptr<PyBytes> { Ptr(self.ptr, offset: Self.layout.bytesOffset) }
  /// Property: `PyBytesIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBytesIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBytesIterator? {
    return py.cast.asBytesIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytes_iterator` type.
  public func newBytesIterator(type: PyType, bytes: PyBytes) -> PyBytesIterator {
    let typeLayout = PyBytesIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBytesIterator(ptr: ptr)
    result.initialize(self.py, type: type, bytes: bytes)

    return result
  }
}

// MARK: - PyCallableIterator

extension PyCallableIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "callable_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyCallableIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let sentinelOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyCallableIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PyCallableIterator.callable
          GenericLayout.Field(PyObject.self) // PyCallableIterator.sentinel
        ]
      )

      assert(layout.offsets.count == 2)
      self.callableOffset = layout.offsets[0]
      self.sentinelOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyCallableIterator.callable`.
  internal var callablePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.callableOffset) }
  /// Property: `PyCallableIterator.sentinel`.
  internal var sentinelPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sentinelOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyCallableIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.callablePtr.deinitialize()
    zelf.sentinelPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyCallableIterator? {
    return py.cast.asCallableIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `callable_iterator` type.
  public func newCallableIterator(type: PyType, callable: PyObject, sentinel: PyObject) -> PyCallableIterator {
    let typeLayout = PyCallableIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyCallableIterator(ptr: ptr)
    result.initialize(self.py, type: type, callable: callable, sentinel: sentinel)

    return result
  }
}

// MARK: - PyCell

extension PyCell {

  /// Name of the type in Python.
  public static let pythonTypeName = "cell"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyCell` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let contentOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyCell>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self) // PyCell.content
        ]
      )

      assert(layout.offsets.count == 1)
      self.contentOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyCell.content`.
  internal var contentPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.contentOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyCell(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.contentPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyCell? {
    return py.cast.asCell(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `cell` type.
  public func newCell(type: PyType, content: PyObject?) -> PyCell {
    let typeLayout = PyCell.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyCell(ptr: ptr)
    result.initialize(self.py, type: type, content: content)

    return result
  }
}

// MARK: - PyClassMethod

extension PyClassMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "classmethod"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyClassMethod` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyClassMethod>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self) // PyClassMethod.callable
        ]
      )

      assert(layout.offsets.count == 1)
      self.callableOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyClassMethod.callable`.
  internal var callablePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.callableOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyClassMethod(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.callablePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyClassMethod? {
    return py.cast.asClassMethod(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `classmethod` type.
  public func newClassMethod(type: PyType, callable: PyObject?) -> PyClassMethod {
    let typeLayout = PyClassMethod.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyClassMethod(ptr: ptr)
    result.initialize(self.py, type: type, callable: callable)

    return result
  }
}

// MARK: - PyCode

extension PyCode {

  /// Name of the type in Python.
  public static let pythonTypeName = "code"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyCode` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let codeObjectOffset: Int
    internal let nameOffset: Int
    internal let qualifiedNameOffset: Int
    internal let filenameOffset: Int
    internal let instructionsOffset: Int
    internal let firstLineOffset: Int
    internal let instructionLinesOffset: Int
    internal let constantsOffset: Int
    internal let labelsOffset: Int
    internal let namesOffset: Int
    internal let variableNamesOffset: Int
    internal let cellVariableNamesOffset: Int
    internal let freeVariableNamesOffset: Int
    internal let argCountOffset: Int
    internal let posOnlyArgCountOffset: Int
    internal let kwOnlyArgCountOffset: Int
    internal let predictedObjectStackCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyCode>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyCode.CodeObject.self), // PyCode.codeObject
          GenericLayout.Field(PyString.self), // PyCode.name
          GenericLayout.Field(PyString.self), // PyCode.qualifiedName
          GenericLayout.Field(PyString.self), // PyCode.filename
          GenericLayout.Field([Instruction].self), // PyCode.instructions
          GenericLayout.Field(SourceLine.self), // PyCode.firstLine
          GenericLayout.Field([SourceLine].self), // PyCode.instructionLines
          GenericLayout.Field([PyObject].self), // PyCode.constants
          GenericLayout.Field([VioletBytecode.CodeObject.Label].self), // PyCode.labels
          GenericLayout.Field([PyString].self), // PyCode.names
          GenericLayout.Field([MangledName].self), // PyCode.variableNames
          GenericLayout.Field([MangledName].self), // PyCode.cellVariableNames
          GenericLayout.Field([MangledName].self), // PyCode.freeVariableNames
          GenericLayout.Field(Int.self), // PyCode.argCount
          GenericLayout.Field(Int.self), // PyCode.posOnlyArgCount
          GenericLayout.Field(Int.self), // PyCode.kwOnlyArgCount
          GenericLayout.Field(Int.self) // PyCode.predictedObjectStackCount
        ]
      )

      assert(layout.offsets.count == 17)
      self.codeObjectOffset = layout.offsets[0]
      self.nameOffset = layout.offsets[1]
      self.qualifiedNameOffset = layout.offsets[2]
      self.filenameOffset = layout.offsets[3]
      self.instructionsOffset = layout.offsets[4]
      self.firstLineOffset = layout.offsets[5]
      self.instructionLinesOffset = layout.offsets[6]
      self.constantsOffset = layout.offsets[7]
      self.labelsOffset = layout.offsets[8]
      self.namesOffset = layout.offsets[9]
      self.variableNamesOffset = layout.offsets[10]
      self.cellVariableNamesOffset = layout.offsets[11]
      self.freeVariableNamesOffset = layout.offsets[12]
      self.argCountOffset = layout.offsets[13]
      self.posOnlyArgCountOffset = layout.offsets[14]
      self.kwOnlyArgCountOffset = layout.offsets[15]
      self.predictedObjectStackCountOffset = layout.offsets[16]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyCode.codeObject`.
  internal var codeObjectPtr: Ptr<PyCode.CodeObject> { Ptr(self.ptr, offset: Self.layout.codeObjectOffset) }
  /// Property: `PyCode.name`.
  internal var namePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  /// Property: `PyCode.qualifiedName`.
  internal var qualifiedNamePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.qualifiedNameOffset) }
  /// Property: `PyCode.filename`.
  internal var filenamePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.filenameOffset) }
  /// Property: `PyCode.instructions`.
  internal var instructionsPtr: Ptr<[Instruction]> { Ptr(self.ptr, offset: Self.layout.instructionsOffset) }
  /// Property: `PyCode.firstLine`.
  internal var firstLinePtr: Ptr<SourceLine> { Ptr(self.ptr, offset: Self.layout.firstLineOffset) }
  /// Property: `PyCode.instructionLines`.
  internal var instructionLinesPtr: Ptr<[SourceLine]> { Ptr(self.ptr, offset: Self.layout.instructionLinesOffset) }
  /// Property: `PyCode.constants`.
  internal var constantsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.constantsOffset) }
  /// Property: `PyCode.labels`.
  internal var labelsPtr: Ptr<[VioletBytecode.CodeObject.Label]> { Ptr(self.ptr, offset: Self.layout.labelsOffset) }
  /// Property: `PyCode.names`.
  internal var namesPtr: Ptr<[PyString]> { Ptr(self.ptr, offset: Self.layout.namesOffset) }
  /// Property: `PyCode.variableNames`.
  internal var variableNamesPtr: Ptr<[MangledName]> { Ptr(self.ptr, offset: Self.layout.variableNamesOffset) }
  /// Property: `PyCode.cellVariableNames`.
  internal var cellVariableNamesPtr: Ptr<[MangledName]> { Ptr(self.ptr, offset: Self.layout.cellVariableNamesOffset) }
  /// Property: `PyCode.freeVariableNames`.
  internal var freeVariableNamesPtr: Ptr<[MangledName]> { Ptr(self.ptr, offset: Self.layout.freeVariableNamesOffset) }
  /// Property: `PyCode.argCount`.
  internal var argCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.argCountOffset) }
  /// Property: `PyCode.posOnlyArgCount`.
  internal var posOnlyArgCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.posOnlyArgCountOffset) }
  /// Property: `PyCode.kwOnlyArgCount`.
  internal var kwOnlyArgCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.kwOnlyArgCountOffset) }
  /// Property: `PyCode.predictedObjectStackCount`.
  internal var predictedObjectStackCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.predictedObjectStackCountOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyCode(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.codeObjectPtr.deinitialize()
    zelf.namePtr.deinitialize()
    zelf.qualifiedNamePtr.deinitialize()
    zelf.filenamePtr.deinitialize()
    zelf.instructionsPtr.deinitialize()
    zelf.firstLinePtr.deinitialize()
    zelf.instructionLinesPtr.deinitialize()
    zelf.constantsPtr.deinitialize()
    zelf.labelsPtr.deinitialize()
    zelf.namesPtr.deinitialize()
    zelf.variableNamesPtr.deinitialize()
    zelf.cellVariableNamesPtr.deinitialize()
    zelf.freeVariableNamesPtr.deinitialize()
    zelf.argCountPtr.deinitialize()
    zelf.posOnlyArgCountPtr.deinitialize()
    zelf.kwOnlyArgCountPtr.deinitialize()
    zelf.predictedObjectStackCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyCode? {
    return py.cast.asCode(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `code` type.
  public func newCode(type: PyType, code: VioletBytecode.CodeObject) -> PyCode {
    let typeLayout = PyCode.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyCode(ptr: ptr)
    result.initialize(self.py, type: type, code: code)

    return result
  }
}

// MARK: - PyComplex

extension PyComplex {

  /// Name of the type in Python.
  public static let pythonTypeName = "complex"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyComplex` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let realOffset: Int
    internal let imagOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyComplex>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(Double.self), // PyComplex.real
          GenericLayout.Field(Double.self) // PyComplex.imag
        ]
      )

      assert(layout.offsets.count == 2)
      self.realOffset = layout.offsets[0]
      self.imagOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyComplex.real`.
  internal var realPtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.realOffset) }
  /// Property: `PyComplex.imag`.
  internal var imagPtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.imagOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyComplex(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.realPtr.deinitialize()
    zelf.imagPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyComplex? {
    return py.cast.asComplex(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `complex` type.
  public func newComplex(type: PyType, real: Double, imag: Double) -> PyComplex {
    let typeLayout = PyComplex.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyComplex(ptr: ptr)
    result.initialize(self.py, type: type, real: real, imag: imag)

    return result
  }
}

// MARK: - PyDict

extension PyDict {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDict` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDict>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.OrderedDictionary.self) // PyDict.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDict.elements`.
  internal var elementsPtr: Ptr<PyDict.OrderedDictionary> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDict(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDict? {
    return py.cast.asDict(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict` type.
  public func newDict(type: PyType, elements: PyDict.OrderedDictionary) -> PyDict {
    let typeLayout = PyDict.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDict(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PyDictItemIterator

extension PyDictItemIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_itemiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictItemIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDictItemIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.self), // PyDictItemIterator.dict
          GenericLayout.Field(Int.self), // PyDictItemIterator.index
          GenericLayout.Field(Int.self) // PyDictItemIterator.initialCount
        ]
      )

      assert(layout.offsets.count == 3)
      self.dictOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.initialCountOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDictItemIterator.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  /// Property: `PyDictItemIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PyDictItemIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDictItemIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictItemIterator? {
    return py.cast.asDictItemIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_itemiterator` type.
  public func newDictItemIterator(type: PyType, dict: PyDict) -> PyDictItemIterator {
    let typeLayout = PyDictItemIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDictItemIterator(ptr: ptr)
    result.initialize(self.py, type: type, dict: dict)

    return result
  }
}

// MARK: - PyDictItems

extension PyDictItems {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_items"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictItems` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDictItems>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.self) // PyDictItems.dict
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDictItems.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDictItems(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.dictPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictItems? {
    return py.cast.asDictItems(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_items` type.
  public func newDictItems(type: PyType, dict: PyDict) -> PyDictItems {
    let typeLayout = PyDictItems.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDictItems(ptr: ptr)
    result.initialize(self.py, type: type, dict: dict)

    return result
  }
}

// MARK: - PyDictKeyIterator

extension PyDictKeyIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_keyiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictKeyIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDictKeyIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.self), // PyDictKeyIterator.dict
          GenericLayout.Field(Int.self), // PyDictKeyIterator.index
          GenericLayout.Field(Int.self) // PyDictKeyIterator.initialCount
        ]
      )

      assert(layout.offsets.count == 3)
      self.dictOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.initialCountOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDictKeyIterator.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  /// Property: `PyDictKeyIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PyDictKeyIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDictKeyIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictKeyIterator? {
    return py.cast.asDictKeyIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_keyiterator` type.
  public func newDictKeyIterator(type: PyType, dict: PyDict) -> PyDictKeyIterator {
    let typeLayout = PyDictKeyIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDictKeyIterator(ptr: ptr)
    result.initialize(self.py, type: type, dict: dict)

    return result
  }
}

// MARK: - PyDictKeys

extension PyDictKeys {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_keys"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictKeys` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDictKeys>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.self) // PyDictKeys.dict
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDictKeys.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDictKeys(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.dictPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictKeys? {
    return py.cast.asDictKeys(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_keys` type.
  public func newDictKeys(type: PyType, dict: PyDict) -> PyDictKeys {
    let typeLayout = PyDictKeys.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDictKeys(ptr: ptr)
    result.initialize(self.py, type: type, dict: dict)

    return result
  }
}

// MARK: - PyDictValueIterator

extension PyDictValueIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_valueiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictValueIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDictValueIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.self), // PyDictValueIterator.dict
          GenericLayout.Field(Int.self), // PyDictValueIterator.index
          GenericLayout.Field(Int.self) // PyDictValueIterator.initialCount
        ]
      )

      assert(layout.offsets.count == 3)
      self.dictOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.initialCountOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDictValueIterator.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  /// Property: `PyDictValueIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PyDictValueIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDictValueIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictValueIterator? {
    return py.cast.asDictValueIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_valueiterator` type.
  public func newDictValueIterator(type: PyType, dict: PyDict) -> PyDictValueIterator {
    let typeLayout = PyDictValueIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDictValueIterator(ptr: ptr)
    result.initialize(self.py, type: type, dict: dict)

    return result
  }
}

// MARK: - PyDictValues

extension PyDictValues {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_values"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictValues` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyDictValues>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyDict.self) // PyDictValues.dict
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyDictValues.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDictValues(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.dictPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictValues? {
    return py.cast.asDictValues(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_values` type.
  public func newDictValues(type: PyType, dict: PyDict) -> PyDictValues {
    let typeLayout = PyDictValues.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDictValues(ptr: ptr)
    result.initialize(self.py, type: type, dict: dict)

    return result
  }
}

// MARK: - PyEllipsis

extension PyEllipsis {

  /// Name of the type in Python.
  public static let pythonTypeName = "ellipsis"

  /// Arrangement of fields in memory.
  ///
  /// `PyEllipsis` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyObject`.
  internal typealias Layout = PyObject.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyEllipsis(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyEllipsis? {
    return py.cast.asEllipsis(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ellipsis` type.
  public func newEllipsis(type: PyType) -> PyEllipsis {
    let typeLayout = PyEllipsis.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyEllipsis(ptr: ptr)
    result.initialize(self.py, type: type)

    return result
  }
}

// MARK: - PyEnumerate

extension PyEnumerate {

  /// Name of the type in Python.
  public static let pythonTypeName = "enumerate"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyEnumerate` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let iteratorOffset: Int
    internal let nextIndexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyEnumerate>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PyEnumerate.iterator
          GenericLayout.Field(BigInt.self) // PyEnumerate.nextIndex
        ]
      )

      assert(layout.offsets.count == 2)
      self.iteratorOffset = layout.offsets[0]
      self.nextIndexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyEnumerate.iterator`.
  internal var iteratorPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.iteratorOffset) }
  /// Property: `PyEnumerate.nextIndex`.
  internal var nextIndexPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.nextIndexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyEnumerate(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.iteratorPtr.deinitialize()
    zelf.nextIndexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyEnumerate? {
    return py.cast.asEnumerate(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `enumerate` type.
  public func newEnumerate(type: PyType, iterator: PyObject, initialIndex: BigInt) -> PyEnumerate {
    let typeLayout = PyEnumerate.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyEnumerate(ptr: ptr)
    result.initialize(self.py, type: type, iterator: iterator, initialIndex: initialIndex)

    return result
  }
}

// MARK: - PyFilter

extension PyFilter {

  /// Name of the type in Python.
  public static let pythonTypeName = "filter"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFilter` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let fnOffset: Int
    internal let iteratorOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyFilter>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PyFilter.fn
          GenericLayout.Field(PyObject.self) // PyFilter.iterator
        ]
      )

      assert(layout.offsets.count == 2)
      self.fnOffset = layout.offsets[0]
      self.iteratorOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyFilter.fn`.
  internal var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.fnOffset) }
  /// Property: `PyFilter.iterator`.
  internal var iteratorPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.iteratorOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFilter(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.fnPtr.deinitialize()
    zelf.iteratorPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFilter? {
    return py.cast.asFilter(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `filter` type.
  public func newFilter(type: PyType, fn: PyObject, iterator: PyObject) -> PyFilter {
    let typeLayout = PyFilter.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFilter(ptr: ptr)
    result.initialize(self.py, type: type, fn: fn, iterator: iterator)

    return result
  }
}

// MARK: - PyFloat

extension PyFloat {

  /// Name of the type in Python.
  public static let pythonTypeName = "float"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFloat` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyFloat>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(Double.self) // PyFloat.value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyFloat.value`.
  internal var valuePtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFloat(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFloat? {
    return py.cast.asFloat(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `float` type.
  public func newFloat(type: PyType, value: Double) -> PyFloat {
    let typeLayout = PyFloat.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFloat(ptr: ptr)
    result.initialize(self.py, type: type, value: value)

    return result
  }
}

// MARK: - PyFrame

extension PyFrame {

  /// Name of the type in Python.
  public static let pythonTypeName = "frame"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFrame` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let codeOffset: Int
    internal let parentOffset: Int
    internal let localsOffset: Int
    internal let globalsOffset: Int
    internal let builtinsOffset: Int
    internal let objectStackStorageOffset: Int
    internal let objectStackEndOffset: Int
    internal let fastLocalsCellFreeBlockStackStoragePtrOffset: Int
    internal let currentInstructionIndexOffset: Int
    internal let nextInstructionIndexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyFrame>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyCode.self), // PyFrame.code
          GenericLayout.Field(PyFrame?.self), // PyFrame.parent
          GenericLayout.Field(PyDict.self), // PyFrame.locals
          GenericLayout.Field(PyDict.self), // PyFrame.globals
          GenericLayout.Field(PyDict.self), // PyFrame.builtins
          GenericLayout.Field(BufferPtr<PyObject>.self), // PyFrame.objectStackStorage
          GenericLayout.Field(PyFrame.ObjectStackProxy.EndPtr.self), // PyFrame.objectStackEnd
          GenericLayout.Field(RawPtr.self), // PyFrame.fastLocalsCellFreeBlockStackStoragePtr
          GenericLayout.Field(Int?.self), // PyFrame.currentInstructionIndex
          GenericLayout.Field(Int.self) // PyFrame.nextInstructionIndex
        ]
      )

      assert(layout.offsets.count == 10)
      self.codeOffset = layout.offsets[0]
      self.parentOffset = layout.offsets[1]
      self.localsOffset = layout.offsets[2]
      self.globalsOffset = layout.offsets[3]
      self.builtinsOffset = layout.offsets[4]
      self.objectStackStorageOffset = layout.offsets[5]
      self.objectStackEndOffset = layout.offsets[6]
      self.fastLocalsCellFreeBlockStackStoragePtrOffset = layout.offsets[7]
      self.currentInstructionIndexOffset = layout.offsets[8]
      self.nextInstructionIndexOffset = layout.offsets[9]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyFrame.code`.
  internal var codePtr: Ptr<PyCode> { Ptr(self.ptr, offset: Self.layout.codeOffset) }
  /// Property: `PyFrame.parent`.
  internal var parentPtr: Ptr<PyFrame?> { Ptr(self.ptr, offset: Self.layout.parentOffset) }
  /// Property: `PyFrame.locals`.
  internal var localsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.localsOffset) }
  /// Property: `PyFrame.globals`.
  internal var globalsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.globalsOffset) }
  /// Property: `PyFrame.builtins`.
  internal var builtinsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.builtinsOffset) }
  /// Property: `PyFrame.objectStackStorage`.
  internal var objectStackStoragePtr: Ptr<BufferPtr<PyObject>> { Ptr(self.ptr, offset: Self.layout.objectStackStorageOffset) }
  /// Property: `PyFrame.objectStackEnd`.
  internal var objectStackEndPtr: Ptr<PyFrame.ObjectStackProxy.EndPtr> { Ptr(self.ptr, offset: Self.layout.objectStackEndOffset) }
  /// Property: `PyFrame.fastLocalsCellFreeBlockStackStoragePtr`.
  internal var fastLocalsCellFreeBlockStackStoragePtrPtr: Ptr<RawPtr> { Ptr(self.ptr, offset: Self.layout.fastLocalsCellFreeBlockStackStoragePtrOffset) }
  /// Property: `PyFrame.currentInstructionIndex`.
  internal var currentInstructionIndexPtr: Ptr<Int?> { Ptr(self.ptr, offset: Self.layout.currentInstructionIndexOffset) }
  /// Property: `PyFrame.nextInstructionIndex`.
  internal var nextInstructionIndexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.nextInstructionIndexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFrame(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.codePtr.deinitialize()
    zelf.parentPtr.deinitialize()
    zelf.localsPtr.deinitialize()
    zelf.globalsPtr.deinitialize()
    zelf.builtinsPtr.deinitialize()
    zelf.objectStackStoragePtr.deinitialize()
    zelf.objectStackEndPtr.deinitialize()
    zelf.fastLocalsCellFreeBlockStackStoragePtrPtr.deinitialize()
    zelf.currentInstructionIndexPtr.deinitialize()
    zelf.nextInstructionIndexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFrame? {
    return py.cast.asFrame(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `frame` type.
  public func newFrame(type: PyType,
                       code: PyCode,
                       locals: PyDict,
                       globals: PyDict,
                       parent: PyFrame?) -> PyFrame {
    let typeLayout = PyFrame.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFrame(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      code: code,
                      locals: locals,
                      globals: globals,
                      parent: parent)

    return result
  }
}

// MARK: - PyFrozenSet

extension PyFrozenSet {

  /// Name of the type in Python.
  public static let pythonTypeName = "frozenset"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFrozenSet` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyFrozenSet>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(OrderedSet.self) // PyFrozenSet.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyFrozenSet.elements`.
  internal var elementsPtr: Ptr<OrderedSet> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFrozenSet(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFrozenSet? {
    return py.cast.asFrozenSet(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `frozenset` type.
  public func newFrozenSet(type: PyType, elements: OrderedSet) -> PyFrozenSet {
    let typeLayout = PyFrozenSet.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFrozenSet(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PyFunction

extension PyFunction {

  /// Name of the type in Python.
  public static let pythonTypeName = "function"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFunction` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let nameOffset: Int
    internal let qualnameOffset: Int
    internal let docOffset: Int
    internal let moduleOffset: Int
    internal let codeOffset: Int
    internal let globalsOffset: Int
    internal let defaultsOffset: Int
    internal let kwDefaultsOffset: Int
    internal let closureOffset: Int
    internal let annotationsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyFunction>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyString.self), // PyFunction.name
          GenericLayout.Field(PyString.self), // PyFunction.qualname
          GenericLayout.Field(PyString?.self), // PyFunction.doc
          GenericLayout.Field(PyObject.self), // PyFunction.module
          GenericLayout.Field(PyCode.self), // PyFunction.code
          GenericLayout.Field(PyDict.self), // PyFunction.globals
          GenericLayout.Field(PyTuple?.self), // PyFunction.defaults
          GenericLayout.Field(PyDict?.self), // PyFunction.kwDefaults
          GenericLayout.Field(PyTuple?.self), // PyFunction.closure
          GenericLayout.Field(PyDict?.self) // PyFunction.annotations
        ]
      )

      assert(layout.offsets.count == 10)
      self.nameOffset = layout.offsets[0]
      self.qualnameOffset = layout.offsets[1]
      self.docOffset = layout.offsets[2]
      self.moduleOffset = layout.offsets[3]
      self.codeOffset = layout.offsets[4]
      self.globalsOffset = layout.offsets[5]
      self.defaultsOffset = layout.offsets[6]
      self.kwDefaultsOffset = layout.offsets[7]
      self.closureOffset = layout.offsets[8]
      self.annotationsOffset = layout.offsets[9]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyFunction.name`.
  internal var namePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  /// Property: `PyFunction.qualname`.
  internal var qualnamePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.qualnameOffset) }
  /// Property: `PyFunction.doc`.
  internal var docPtr: Ptr<PyString?> { Ptr(self.ptr, offset: Self.layout.docOffset) }
  /// Property: `PyFunction.module`.
  internal var modulePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  /// Property: `PyFunction.code`.
  internal var codePtr: Ptr<PyCode> { Ptr(self.ptr, offset: Self.layout.codeOffset) }
  /// Property: `PyFunction.globals`.
  internal var globalsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.globalsOffset) }
  /// Property: `PyFunction.defaults`.
  internal var defaultsPtr: Ptr<PyTuple?> { Ptr(self.ptr, offset: Self.layout.defaultsOffset) }
  /// Property: `PyFunction.kwDefaults`.
  internal var kwDefaultsPtr: Ptr<PyDict?> { Ptr(self.ptr, offset: Self.layout.kwDefaultsOffset) }
  /// Property: `PyFunction.closure`.
  internal var closurePtr: Ptr<PyTuple?> { Ptr(self.ptr, offset: Self.layout.closureOffset) }
  /// Property: `PyFunction.annotations`.
  internal var annotationsPtr: Ptr<PyDict?> { Ptr(self.ptr, offset: Self.layout.annotationsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFunction(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.namePtr.deinitialize()
    zelf.qualnamePtr.deinitialize()
    zelf.docPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.codePtr.deinitialize()
    zelf.globalsPtr.deinitialize()
    zelf.defaultsPtr.deinitialize()
    zelf.kwDefaultsPtr.deinitialize()
    zelf.closurePtr.deinitialize()
    zelf.annotationsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFunction? {
    return py.cast.asFunction(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `function` type.
  public func newFunction(type: PyType,
                          qualname: PyString?,
                          module: PyObject,
                          code: PyCode,
                          globals: PyDict) -> PyFunction {
    let typeLayout = PyFunction.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFunction(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      qualname: qualname,
                      module: module,
                      code: code,
                      globals: globals)

    return result
  }
}

// MARK: - PyInt

extension PyInt {

  /// Name of the type in Python.
  public static let pythonTypeName = "int"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyInt` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyInt>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(BigInt.self) // PyInt.value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyInt.value`.
  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyInt(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyInt? {
    return py.cast.asInt(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `int` type.
  public func newInt(type: PyType, value: BigInt) -> PyInt {
    let typeLayout = PyInt.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyInt(ptr: ptr)
    result.initialize(self.py, type: type, value: value)

    return result
  }
}

// MARK: - PyIterator

extension PyIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PyIterator.sequence
          GenericLayout.Field(Int.self) // PyIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.sequenceOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyIterator.sequence`.
  internal var sequencePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sequenceOffset) }
  /// Property: `PyIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIterator? {
    return py.cast.asIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `iterator` type.
  public func newIterator(type: PyType, sequence: PyObject) -> PyIterator {
    let typeLayout = PyIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyIterator(ptr: ptr)
    result.initialize(self.py, type: type, sequence: sequence)

    return result
  }
}

// MARK: - PyList

extension PyList {

  /// Name of the type in Python.
  public static let pythonTypeName = "list"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyList` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyList>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field([PyObject].self) // PyList.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyList.elements`.
  internal var elementsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyList(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyList? {
    return py.cast.asList(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `list` type.
  public func newList(type: PyType, elements: [PyObject]) -> PyList {
    let typeLayout = PyList.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyList(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PyListIterator

extension PyListIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "list_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyListIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyListIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyList.self), // PyListIterator.list
          GenericLayout.Field(Int.self) // PyListIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.listOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyListIterator.list`.
  internal var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Self.layout.listOffset) }
  /// Property: `PyListIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyListIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyListIterator? {
    return py.cast.asListIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `list_iterator` type.
  public func newListIterator(type: PyType, list: PyList) -> PyListIterator {
    let typeLayout = PyListIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyListIterator(ptr: ptr)
    result.initialize(self.py, type: type, list: list)

    return result
  }
}

// MARK: - PyListReverseIterator

extension PyListReverseIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "list_reverseiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyListReverseIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyListReverseIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyList.self), // PyListReverseIterator.list
          GenericLayout.Field(Int.self) // PyListReverseIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.listOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyListReverseIterator.list`.
  internal var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Self.layout.listOffset) }
  /// Property: `PyListReverseIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyListReverseIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyListReverseIterator? {
    return py.cast.asListReverseIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `list_reverseiterator` type.
  public func newListReverseIterator(type: PyType, list: PyList) -> PyListReverseIterator {
    let typeLayout = PyListReverseIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyListReverseIterator(ptr: ptr)
    result.initialize(self.py, type: type, list: list)

    return result
  }
}

// MARK: - PyMap

extension PyMap {

  /// Name of the type in Python.
  public static let pythonTypeName = "map"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyMap` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let fnOffset: Int
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyMap>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PyMap.fn
          GenericLayout.Field([PyObject].self) // PyMap.iterators
        ]
      )

      assert(layout.offsets.count == 2)
      self.fnOffset = layout.offsets[0]
      self.iteratorsOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyMap.fn`.
  internal var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.fnOffset) }
  /// Property: `PyMap.iterators`.
  internal var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.iteratorsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyMap(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.fnPtr.deinitialize()
    zelf.iteratorsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyMap? {
    return py.cast.asMap(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `map` type.
  public func newMap(type: PyType, fn: PyObject, iterators: [PyObject]) -> PyMap {
    let typeLayout = PyMap.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyMap(ptr: ptr)
    result.initialize(self.py, type: type, fn: fn, iterators: iterators)

    return result
  }
}

// MARK: - PyMethod

extension PyMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "method"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyMethod` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyMethod>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyFunction.self), // PyMethod.function
          GenericLayout.Field(PyObject.self) // PyMethod.object
        ]
      )

      assert(layout.offsets.count == 2)
      self.functionOffset = layout.offsets[0]
      self.objectOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyMethod.function`.
  internal var functionPtr: Ptr<PyFunction> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  /// Property: `PyMethod.object`.
  internal var objectPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.objectOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyMethod(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyMethod? {
    return py.cast.asMethod(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `method` type.
  public func newMethod(type: PyType, function: PyFunction, object: PyObject) -> PyMethod {
    let typeLayout = PyMethod.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyMethod(ptr: ptr)
    result.initialize(self.py, type: type, function: function, object: object)

    return result
  }
}

// MARK: - PyModule

extension PyModule {

  /// Name of the type in Python.
  public static let pythonTypeName = "module"

  /// Arrangement of fields in memory.
  ///
  /// `PyModule` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyObject`.
  internal typealias Layout = PyObject.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyModule(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyModule? {
    return py.cast.asModule(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `module` type.
  public func newModule(type: PyType,
                        name: PyObject?,
                        doc: PyObject?,
                        __dict__: PyDict? = nil) -> PyModule {
    let typeLayout = PyModule.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyModule(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      name: name,
                      doc: doc,
                      __dict__: __dict__)

    return result
  }
}

// MARK: - PyNamespace

extension PyNamespace {

  /// Name of the type in Python.
  public static let pythonTypeName = "SimpleNamespace"

  /// Arrangement of fields in memory.
  ///
  /// `PyNamespace` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyObject`.
  internal typealias Layout = PyObject.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyNamespace(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNamespace? {
    return py.cast.asNamespace(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SimpleNamespace` type.
  public func newNamespace(type: PyType, __dict__: PyDict?) -> PyNamespace {
    let typeLayout = PyNamespace.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyNamespace(ptr: ptr)
    result.initialize(self.py, type: type, __dict__: __dict__)

    return result
  }
}

// MARK: - PyNone

extension PyNone {

  /// Name of the type in Python.
  public static let pythonTypeName = "NoneType"

  /// Arrangement of fields in memory.
  ///
  /// `PyNone` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyObject`.
  internal typealias Layout = PyObject.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyNone(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNone? {
    return py.cast.asNone(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NoneType` type.
  public func newNone(type: PyType) -> PyNone {
    let typeLayout = PyNone.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyNone(ptr: ptr)
    result.initialize(self.py, type: type)

    return result
  }
}

// MARK: - PyNotImplemented

extension PyNotImplemented {

  /// Name of the type in Python.
  public static let pythonTypeName = "NotImplementedType"

  /// Arrangement of fields in memory.
  ///
  /// `PyNotImplemented` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyObject`.
  internal typealias Layout = PyObject.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyNotImplemented(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNotImplemented? {
    return py.cast.asNotImplemented(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NotImplementedType` type.
  public func newNotImplemented(type: PyType) -> PyNotImplemented {
    let typeLayout = PyNotImplemented.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyNotImplemented(ptr: ptr)
    result.initialize(self.py, type: type)

    return result
  }
}

// MARK: - PyObject

extension PyObject {

  /// Name of the type in Python.
  public static let pythonTypeName = "object"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyObject` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let typeOffset: Int
    internal let memoryInfoOffset: Int
    internal let __dict__Offset: Int
    internal let flagsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyObject>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: 0,
        initialAlignment: 0,
        fields: [
          GenericLayout.Field(PyType.self), // PyObject.type
          GenericLayout.Field(PyMemory.ObjectHeader.self), // PyObject.memoryInfo
          GenericLayout.Field(PyObject.Lazy__dict__.self), // PyObject.__dict__
          GenericLayout.Field(PyObject.Flags.self) // PyObject.flags
        ]
      )

      assert(layout.offsets.count == 4)
      self.typeOffset = layout.offsets[0]
      self.memoryInfoOffset = layout.offsets[1]
      self.__dict__Offset = layout.offsets[2]
      self.flagsOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: Self.layout.typeOffset) }
  /// Property: `PyObject.memoryInfo`.
  internal var memoryInfoPtr: Ptr<PyMemory.ObjectHeader> { Ptr(self.ptr, offset: Self.layout.memoryInfoOffset) }
  /// Property: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: Self.layout.__dict__Offset) }
  /// Property: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: Self.layout.flagsOffset) }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyObject(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.typePtr.deinitialize()
    zelf.memoryInfoPtr.deinitialize()
    zelf.__dict__Ptr.deinitialize()
    zelf.flagsPtr.deinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `object` type.
  public func newObject(type: PyType, __dict__: PyDict? = nil) -> PyObject {
    let typeLayout = PyObject.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyObject(ptr: ptr)
    result.initialize(self.py, type: type, __dict__: __dict__)

    return result
  }
}

// MARK: - PyProperty

extension PyProperty {

  /// Name of the type in Python.
  public static let pythonTypeName = "property"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyProperty` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let _getOffset: Int
    internal let _setOffset: Int
    internal let _delOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyProperty>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self), // PyProperty._get
          GenericLayout.Field(PyObject?.self), // PyProperty._set
          GenericLayout.Field(PyObject?.self), // PyProperty._del
          GenericLayout.Field(PyObject?.self) // PyProperty.doc
        ]
      )

      assert(layout.offsets.count == 4)
      self._getOffset = layout.offsets[0]
      self._setOffset = layout.offsets[1]
      self._delOffset = layout.offsets[2]
      self.docOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyProperty._get`.
  internal var _getPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._getOffset) }
  /// Property: `PyProperty._set`.
  internal var _setPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._setOffset) }
  /// Property: `PyProperty._del`.
  internal var _delPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._delOffset) }
  /// Property: `PyProperty.doc`.
  internal var docPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyProperty(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf._getPtr.deinitialize()
    zelf._setPtr.deinitialize()
    zelf._delPtr.deinitialize()
    zelf.docPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyProperty? {
    return py.cast.asProperty(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `property` type.
  public func newProperty(type: PyType,
                          get: PyObject?,
                          set: PyObject?,
                          del: PyObject?,
                          doc: PyObject?) -> PyProperty {
    let typeLayout = PyProperty.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyProperty(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      get: get,
                      set: set,
                      del: del,
                      doc: doc)

    return result
  }
}

// MARK: - PyRange

extension PyRange {

  /// Name of the type in Python.
  public static let pythonTypeName = "range"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRange` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyRange>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyInt.self), // PyRange.start
          GenericLayout.Field(PyInt.self), // PyRange.stop
          GenericLayout.Field(PyInt.self), // PyRange.step
          GenericLayout.Field(PyInt.self) // PyRange.length
        ]
      )

      assert(layout.offsets.count == 4)
      self.startOffset = layout.offsets[0]
      self.stopOffset = layout.offsets[1]
      self.stepOffset = layout.offsets[2]
      self.lengthOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyRange.start`.
  internal var startPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  /// Property: `PyRange.stop`.
  internal var stopPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.stopOffset) }
  /// Property: `PyRange.step`.
  internal var stepPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.stepOffset) }
  /// Property: `PyRange.length`.
  internal var lengthPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lengthOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyRange(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()
    zelf.lengthPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRange? {
    return py.cast.asRange(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `range` type.
  public func newRange(type: PyType,
                       start: PyInt,
                       stop: PyInt,
                       step: PyInt?) -> PyRange {
    let typeLayout = PyRange.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyRange(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      start: start,
                      stop: stop,
                      step: step)

    return result
  }
}

// MARK: - PyRangeIterator

extension PyRangeIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "range_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRangeIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyRangeIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(BigInt.self), // PyRangeIterator.start
          GenericLayout.Field(BigInt.self), // PyRangeIterator.step
          GenericLayout.Field(BigInt.self), // PyRangeIterator.length
          GenericLayout.Field(BigInt.self) // PyRangeIterator.index
        ]
      )

      assert(layout.offsets.count == 4)
      self.startOffset = layout.offsets[0]
      self.stepOffset = layout.offsets[1]
      self.lengthOffset = layout.offsets[2]
      self.indexOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyRangeIterator.start`.
  internal var startPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  /// Property: `PyRangeIterator.step`.
  internal var stepPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.stepOffset) }
  /// Property: `PyRangeIterator.length`.
  internal var lengthPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.lengthOffset) }
  /// Property: `PyRangeIterator.index`.
  internal var indexPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyRangeIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.startPtr.deinitialize()
    zelf.stepPtr.deinitialize()
    zelf.lengthPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRangeIterator? {
    return py.cast.asRangeIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `range_iterator` type.
  public func newRangeIterator(type: PyType,
                               start: BigInt,
                               step: BigInt,
                               length: BigInt) -> PyRangeIterator {
    let typeLayout = PyRangeIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyRangeIterator(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      start: start,
                      step: step,
                      length: length)

    return result
  }
}

// MARK: - PyReversed

extension PyReversed {

  /// Name of the type in Python.
  public static let pythonTypeName = "reversed"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyReversed` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyReversed>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PyReversed.sequence
          GenericLayout.Field(Int.self) // PyReversed.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.sequenceOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyReversed.sequence`.
  internal var sequencePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sequenceOffset) }
  /// Property: `PyReversed.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyReversed(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyReversed? {
    return py.cast.asReversed(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `reversed` type.
  public func newReversed(type: PyType, sequence: PyObject, count: Int) -> PyReversed {
    let typeLayout = PyReversed.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyReversed(ptr: ptr)
    result.initialize(self.py, type: type, sequence: sequence, count: count)

    return result
  }
}

// MARK: - PySet

extension PySet {

  /// Name of the type in Python.
  public static let pythonTypeName = "set"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySet` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PySet>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(OrderedSet.self) // PySet.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PySet.elements`.
  internal var elementsPtr: Ptr<OrderedSet> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySet(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySet? {
    return py.cast.asSet(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `set` type.
  public func newSet(type: PyType, elements: OrderedSet) -> PySet {
    let typeLayout = PySet.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySet(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PySetIterator

extension PySetIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "set_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySetIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let setOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PySetIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyAnySet.self), // PySetIterator.set
          GenericLayout.Field(Int.self), // PySetIterator.index
          GenericLayout.Field(Int.self) // PySetIterator.initialCount
        ]
      )

      assert(layout.offsets.count == 3)
      self.setOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.initialCountOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PySetIterator.set`.
  internal var setPtr: Ptr<PyAnySet> { Ptr(self.ptr, offset: Self.layout.setOffset) }
  /// Property: `PySetIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PySetIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySetIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.setPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySetIterator? {
    return py.cast.asSetIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `set_iterator` type.
  public func newSetIterator(type: PyType, set: PySet) -> PySetIterator {
    let typeLayout = PySetIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySetIterator(ptr: ptr)
    result.initialize(self.py, type: type, set: set)

    return result
  }

  /// Allocate a new instance of `set_iterator` type.
  public func newSetIterator(type: PyType, frozenSet: PyFrozenSet) -> PySetIterator {
    let typeLayout = PySetIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySetIterator(ptr: ptr)
    result.initialize(self.py, type: type, frozenSet: frozenSet)

    return result
  }
}

// MARK: - PySlice

extension PySlice {

  /// Name of the type in Python.
  public static let pythonTypeName = "slice"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySlice` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PySlice>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self), // PySlice.start
          GenericLayout.Field(PyObject.self), // PySlice.stop
          GenericLayout.Field(PyObject.self) // PySlice.step
        ]
      )

      assert(layout.offsets.count == 3)
      self.startOffset = layout.offsets[0]
      self.stopOffset = layout.offsets[1]
      self.stepOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PySlice.start`.
  internal var startPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  /// Property: `PySlice.stop`.
  internal var stopPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.stopOffset) }
  /// Property: `PySlice.step`.
  internal var stepPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.stepOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySlice(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySlice? {
    return py.cast.asSlice(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `slice` type.
  public func newSlice(type: PyType,
                       start: PyObject,
                       stop: PyObject,
                       step: PyObject) -> PySlice {
    let typeLayout = PySlice.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySlice(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      start: start,
                      stop: stop,
                      step: step)

    return result
  }
}

// MARK: - PyStaticMethod

extension PyStaticMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "staticmethod"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStaticMethod` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyStaticMethod>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self) // PyStaticMethod.callable
        ]
      )

      assert(layout.offsets.count == 1)
      self.callableOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyStaticMethod.callable`.
  internal var callablePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.callableOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyStaticMethod(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.callablePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStaticMethod? {
    return py.cast.asStaticMethod(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `staticmethod` type.
  public func newStaticMethod(type: PyType, callable: PyObject?) -> PyStaticMethod {
    let typeLayout = PyStaticMethod.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyStaticMethod(ptr: ptr)
    result.initialize(self.py, type: type, callable: callable)

    return result
  }
}

// MARK: - PyString

extension PyString {

  /// Name of the type in Python.
  public static let pythonTypeName = "str"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyString` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let cachedCountOffset: Int
    internal let cachedHashOffset: Int
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyString>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(Int.self), // PyString.cachedCount
          GenericLayout.Field(PyHash.self), // PyString.cachedHash
          GenericLayout.Field(String.self) // PyString.value
        ]
      )

      assert(layout.offsets.count == 3)
      self.cachedCountOffset = layout.offsets[0]
      self.cachedHashOffset = layout.offsets[1]
      self.valueOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyString.cachedCount`.
  internal var cachedCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.cachedCountOffset) }
  /// Property: `PyString.cachedHash`.
  internal var cachedHashPtr: Ptr<PyHash> { Ptr(self.ptr, offset: Self.layout.cachedHashOffset) }
  /// Property: `PyString.value`.
  internal var valuePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyString(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.cachedCountPtr.deinitialize()
    zelf.cachedHashPtr.deinitialize()
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyString? {
    return py.cast.asString(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `str` type.
  public func newString(type: PyType, value: String) -> PyString {
    let typeLayout = PyString.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyString(ptr: ptr)
    result.initialize(self.py, type: type, value: value)

    return result
  }
}

// MARK: - PyStringIterator

extension PyStringIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "str_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStringIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let stringOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyStringIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyString.self), // PyStringIterator.string
          GenericLayout.Field(Int.self) // PyStringIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.stringOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyStringIterator.string`.
  internal var stringPtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.stringOffset) }
  /// Property: `PyStringIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyStringIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.stringPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStringIterator? {
    return py.cast.asStringIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `str_iterator` type.
  public func newStringIterator(type: PyType, string: PyString) -> PyStringIterator {
    let typeLayout = PyStringIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyStringIterator(ptr: ptr)
    result.initialize(self.py, type: type, string: string)

    return result
  }
}

// MARK: - PySuper

extension PySuper {

  /// Name of the type in Python.
  public static let pythonTypeName = "super"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySuper` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let thisClassOffset: Int
    internal let objectOffset: Int
    internal let objectTypeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PySuper>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyType?.self), // PySuper.thisClass
          GenericLayout.Field(PyObject?.self), // PySuper.object
          GenericLayout.Field(PyType?.self) // PySuper.objectType
        ]
      )

      assert(layout.offsets.count == 3)
      self.thisClassOffset = layout.offsets[0]
      self.objectOffset = layout.offsets[1]
      self.objectTypeOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PySuper.thisClass`.
  internal var thisClassPtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.thisClassOffset) }
  /// Property: `PySuper.object`.
  internal var objectPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.objectOffset) }
  /// Property: `PySuper.objectType`.
  internal var objectTypePtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.objectTypeOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySuper(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.thisClassPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.objectTypePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySuper? {
    return py.cast.asSuper(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `super` type.
  public func newSuper(type: PyType,
                       requestedType: PyType?,
                       object: PyObject?,
                       objectType: PyType?) -> PySuper {
    let typeLayout = PySuper.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySuper(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      requestedType: requestedType,
                      object: object,
                      objectType: objectType)

    return result
  }
}

// MARK: - PyTextFile

extension PyTextFile {

  /// Name of the type in Python.
  public static let pythonTypeName = "TextFile"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTextFile` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let nameOffset: Int
    internal let fdOffset: Int
    internal let modeOffset: Int
    internal let encodingOffset: Int
    internal let errorHandlingOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyTextFile>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(String?.self), // PyTextFile.name
          GenericLayout.Field(PyFileDescriptorType.self), // PyTextFile.fd
          GenericLayout.Field(FileMode.self), // PyTextFile.mode
          GenericLayout.Field(PyString.Encoding.self), // PyTextFile.encoding
          GenericLayout.Field(PyString.ErrorHandling.self) // PyTextFile.errorHandling
        ]
      )

      assert(layout.offsets.count == 5)
      self.nameOffset = layout.offsets[0]
      self.fdOffset = layout.offsets[1]
      self.modeOffset = layout.offsets[2]
      self.encodingOffset = layout.offsets[3]
      self.errorHandlingOffset = layout.offsets[4]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyTextFile.name`.
  internal var namePtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  /// Property: `PyTextFile.fd`.
  internal var fdPtr: Ptr<PyFileDescriptorType> { Ptr(self.ptr, offset: Self.layout.fdOffset) }
  /// Property: `PyTextFile.mode`.
  internal var modePtr: Ptr<FileMode> { Ptr(self.ptr, offset: Self.layout.modeOffset) }
  /// Property: `PyTextFile.encoding`.
  internal var encodingPtr: Ptr<PyString.Encoding> { Ptr(self.ptr, offset: Self.layout.encodingOffset) }
  /// Property: `PyTextFile.errorHandling`.
  internal var errorHandlingPtr: Ptr<PyString.ErrorHandling> { Ptr(self.ptr, offset: Self.layout.errorHandlingOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTextFile(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.namePtr.deinitialize()
    zelf.fdPtr.deinitialize()
    zelf.modePtr.deinitialize()
    zelf.encodingPtr.deinitialize()
    zelf.errorHandlingPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTextFile? {
    return py.cast.asTextFile(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TextFile` type.
  public func newTextFile(type: PyType,
                          name: String?,
                          fd: PyFileDescriptorType,
                          mode: FileMode,
                          encoding: PyString.Encoding,
                          errorHandling: PyString.ErrorHandling,
                          closeOnDealloc: Bool) -> PyTextFile {
    let typeLayout = PyTextFile.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTextFile(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      name: name,
                      fd: fd,
                      mode: mode,
                      encoding: encoding,
                      errorHandling: errorHandling,
                      closeOnDealloc: closeOnDealloc)

    return result
  }
}

// MARK: - PyTraceback

extension PyTraceback {

  /// Name of the type in Python.
  public static let pythonTypeName = "traceback"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTraceback` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let nextOffset: Int
    internal let frameOffset: Int
    internal let lastInstructionOffset: Int
    internal let lineNoOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyTraceback>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyTraceback?.self), // PyTraceback.next
          GenericLayout.Field(PyFrame.self), // PyTraceback.frame
          GenericLayout.Field(PyInt.self), // PyTraceback.lastInstruction
          GenericLayout.Field(PyInt.self) // PyTraceback.lineNo
        ]
      )

      assert(layout.offsets.count == 4)
      self.nextOffset = layout.offsets[0]
      self.frameOffset = layout.offsets[1]
      self.lastInstructionOffset = layout.offsets[2]
      self.lineNoOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyTraceback.next`.
  internal var nextPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: Self.layout.nextOffset) }
  /// Property: `PyTraceback.frame`.
  internal var framePtr: Ptr<PyFrame> { Ptr(self.ptr, offset: Self.layout.frameOffset) }
  /// Property: `PyTraceback.lastInstruction`.
  internal var lastInstructionPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lastInstructionOffset) }
  /// Property: `PyTraceback.lineNo`.
  internal var lineNoPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lineNoOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTraceback(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.nextPtr.deinitialize()
    zelf.framePtr.deinitialize()
    zelf.lastInstructionPtr.deinitialize()
    zelf.lineNoPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTraceback? {
    return py.cast.asTraceback(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `traceback` type.
  public func newTraceback(type: PyType,
                           next: PyTraceback?,
                           frame: PyFrame,
                           lastInstruction: PyInt,
                           lineNo: PyInt) -> PyTraceback {
    let typeLayout = PyTraceback.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTraceback(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      next: next,
                      frame: frame,
                      lastInstruction: lastInstruction,
                      lineNo: lineNo)

    return result
  }
}

// MARK: - PyTuple

extension PyTuple {

  /// Name of the type in Python.
  public static let pythonTypeName = "tuple"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTuple` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyTuple>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field([PyObject].self) // PyTuple.elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyTuple.elements`.
  internal var elementsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTuple(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTuple? {
    return py.cast.asTuple(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `tuple` type.
  public func newTuple(type: PyType, elements: [PyObject]) -> PyTuple {
    let typeLayout = PyTuple.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTuple(ptr: ptr)
    result.initialize(self.py, type: type, elements: elements)

    return result
  }
}

// MARK: - PyTupleIterator

extension PyTupleIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "tuple_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTupleIterator` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let tupleOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyTupleIterator>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyTuple.self), // PyTupleIterator.tuple
          GenericLayout.Field(Int.self) // PyTupleIterator.index
        ]
      )

      assert(layout.offsets.count == 2)
      self.tupleOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyTupleIterator.tuple`.
  internal var tuplePtr: Ptr<PyTuple> { Ptr(self.ptr, offset: Self.layout.tupleOffset) }
  /// Property: `PyTupleIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTupleIterator(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.tuplePtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTupleIterator? {
    return py.cast.asTupleIterator(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `tuple_iterator` type.
  public func newTupleIterator(type: PyType, tuple: PyTuple) -> PyTupleIterator {
    let typeLayout = PyTupleIterator.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTupleIterator(ptr: ptr)
    result.initialize(self.py, type: type, tuple: tuple)

    return result
  }
}

// MARK: - PyType

extension PyType {

  /// Name of the type in Python.
  public static let pythonTypeName = "type"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyType` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let nameOffset: Int
    internal let qualnameOffset: Int
    internal let docOffset: Int
    internal let baseOffset: Int
    internal let basesOffset: Int
    internal let mroOffset: Int
    internal let subclassesOffset: Int
    internal let instanceSizeWithoutTailOffset: Int
    internal let staticMethodsOffset: Int
    internal let debugFnOffset: Int
    internal let deinitializeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyType>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(String.self), // PyType.name
          GenericLayout.Field(String.self), // PyType.qualname
          GenericLayout.Field(PyObject?.self), // PyType.doc
          GenericLayout.Field(PyType?.self), // PyType.base
          GenericLayout.Field([PyType].self), // PyType.bases
          GenericLayout.Field([PyType].self), // PyType.mro
          GenericLayout.Field([PyType].self), // PyType.subclasses
          GenericLayout.Field(Int.self), // PyType.instanceSizeWithoutTail
          GenericLayout.Field(PyStaticCall.KnownNotOverriddenMethods.self), // PyType.staticMethods
          GenericLayout.Field(DebugFn.self), // PyType.debugFn
          GenericLayout.Field(DeinitializeFn.self) // PyType.deinitialize
        ]
      )

      assert(layout.offsets.count == 11)
      self.nameOffset = layout.offsets[0]
      self.qualnameOffset = layout.offsets[1]
      self.docOffset = layout.offsets[2]
      self.baseOffset = layout.offsets[3]
      self.basesOffset = layout.offsets[4]
      self.mroOffset = layout.offsets[5]
      self.subclassesOffset = layout.offsets[6]
      self.instanceSizeWithoutTailOffset = layout.offsets[7]
      self.staticMethodsOffset = layout.offsets[8]
      self.debugFnOffset = layout.offsets[9]
      self.deinitializeOffset = layout.offsets[10]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyType.name`.
  internal var namePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  /// Property: `PyType.qualname`.
  internal var qualnamePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.qualnameOffset) }
  /// Property: `PyType.doc`.
  internal var docPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.docOffset) }
  /// Property: `PyType.base`.
  internal var basePtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.baseOffset) }
  /// Property: `PyType.bases`.
  internal var basesPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.basesOffset) }
  /// Property: `PyType.mro`.
  internal var mroPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.mroOffset) }
  /// Property: `PyType.subclasses`.
  internal var subclassesPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.subclassesOffset) }
  /// Property: `PyType.instanceSizeWithoutTail`.
  internal var instanceSizeWithoutTailPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.instanceSizeWithoutTailOffset) }
  /// Property: `PyType.staticMethods`.
  internal var staticMethodsPtr: Ptr<PyStaticCall.KnownNotOverriddenMethods> { Ptr(self.ptr, offset: Self.layout.staticMethodsOffset) }
  /// Property: `PyType.debugFn`.
  internal var debugFnPtr: Ptr<DebugFn> { Ptr(self.ptr, offset: Self.layout.debugFnOffset) }
  /// Property: `PyType.deinitialize`.
  internal var deinitializePtr: Ptr<DeinitializeFn> { Ptr(self.ptr, offset: Self.layout.deinitializeOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyType(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.namePtr.deinitialize()
    zelf.qualnamePtr.deinitialize()
    zelf.docPtr.deinitialize()
    zelf.basePtr.deinitialize()
    zelf.basesPtr.deinitialize()
    zelf.mroPtr.deinitialize()
    zelf.subclassesPtr.deinitialize()
    zelf.instanceSizeWithoutTailPtr.deinitialize()
    zelf.staticMethodsPtr.deinitialize()
    zelf.debugFnPtr.deinitialize()
    zelf.deinitializePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyType? {
    return py.cast.asType(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `type` type.
  public func newType(type: PyType,
                      name: String,
                      qualname: String,
                      flags: PyType.Flags,
                      base: PyType?,
                      bases: [PyType],
                      mroWithoutSelf: [PyType],
                      subclasses: [PyType],
                      instanceSizeWithoutTail: Int,
                      staticMethods: PyStaticCall.KnownNotOverriddenMethods,
                      debugFn: @escaping PyType.DebugFn,
                      deinitialize: @escaping PyType.DeinitializeFn) -> PyType {
    let typeLayout = PyType.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyType(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      name: name,
                      qualname: qualname,
                      flags: flags,
                      base: base,
                      bases: bases,
                      mroWithoutSelf: mroWithoutSelf,
                      subclasses: subclasses,
                      instanceSizeWithoutTail: instanceSizeWithoutTail,
                      staticMethods: staticMethods,
                      debugFn: debugFn,
                      deinitialize: deinitialize)

    return result
  }
}

// MARK: - PyZip

extension PyZip {

  /// Name of the type in Python.
  public static let pythonTypeName = "zip"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyZip` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyZip>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field([PyObject].self) // PyZip.iterators
        ]
      )

      assert(layout.offsets.count == 1)
      self.iteratorsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyZip.iterators`.
  internal var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.iteratorsOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyZip(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.iteratorsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyZip? {
    return py.cast.asZip(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `zip` type.
  public func newZip(type: PyType, iterators: [PyObject]) -> PyZip {
    let typeLayout = PyZip.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyZip(ptr: ptr)
    result.initialize(self.py, type: type, iterators: iterators)

    return result
  }
}

// MARK: - PyArithmeticError

extension PyArithmeticError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ArithmeticError"

  /// Arrangement of fields in memory.
  ///
  /// `PyArithmeticError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyArithmeticError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyArithmeticError? {
    return py.cast.asArithmeticError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ArithmeticError` type.
  public func newArithmeticError(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyArithmeticError {
    let typeLayout = PyArithmeticError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyArithmeticError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyAssertionError

extension PyAssertionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "AssertionError"

  /// Arrangement of fields in memory.
  ///
  /// `PyAssertionError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyAssertionError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyAssertionError? {
    return py.cast.asAssertionError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `AssertionError` type.
  public func newAssertionError(type: PyType,
                                args: PyTuple,
                                traceback: PyTraceback? = nil,
                                cause: PyBaseException? = nil,
                                context: PyBaseException? = nil,
                                suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyAssertionError {
    let typeLayout = PyAssertionError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyAssertionError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyAttributeError

extension PyAttributeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "AttributeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyAttributeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyAttributeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyAttributeError? {
    return py.cast.asAttributeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `AttributeError` type.
  public func newAttributeError(type: PyType,
                                args: PyTuple,
                                traceback: PyTraceback? = nil,
                                cause: PyBaseException? = nil,
                                context: PyBaseException? = nil,
                                suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyAttributeError {
    let typeLayout = PyAttributeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyAttributeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyBaseException

extension PyBaseException {

  /// Name of the type in Python.
  public static let pythonTypeName = "BaseException"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBaseException` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let argsOffset: Int
    internal let tracebackOffset: Int
    internal let causeOffset: Int
    internal let contextOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyBaseException>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(PyTuple.self), // PyBaseException.args
          GenericLayout.Field(PyTraceback?.self), // PyBaseException.traceback
          GenericLayout.Field(PyBaseException?.self), // PyBaseException.cause
          GenericLayout.Field(PyBaseException?.self) // PyBaseException.context
        ]
      )

      assert(layout.offsets.count == 4)
      self.argsOffset = layout.offsets[0]
      self.tracebackOffset = layout.offsets[1]
      self.causeOffset = layout.offsets[2]
      self.contextOffset = layout.offsets[3]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: Self.layout.argsOffset) }
  /// Property: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: Self.layout.tracebackOffset) }
  /// Property: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: Self.layout.causeOffset) }
  /// Property: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: Self.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBaseException(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.argsPtr.deinitialize()
    zelf.tracebackPtr.deinitialize()
    zelf.causePtr.deinitialize()
    zelf.contextPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBaseException? {
    return py.cast.asBaseException(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BaseException` type.
  public func newBaseException(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBaseException {
    let typeLayout = PyBaseException.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBaseException(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyBlockingIOError

extension PyBlockingIOError {

  /// Name of the type in Python.
  public static let pythonTypeName = "BlockingIOError"

  /// Arrangement of fields in memory.
  ///
  /// `PyBlockingIOError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBlockingIOError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBlockingIOError? {
    return py.cast.asBlockingIOError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BlockingIOError` type.
  public func newBlockingIOError(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBlockingIOError {
    let typeLayout = PyBlockingIOError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBlockingIOError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyBrokenPipeError

extension PyBrokenPipeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "BrokenPipeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyBrokenPipeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyConnectionError`.
  internal typealias Layout = PyConnectionError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBrokenPipeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyConnectionError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBrokenPipeError? {
    return py.cast.asBrokenPipeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BrokenPipeError` type.
  public func newBrokenPipeError(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBrokenPipeError {
    let typeLayout = PyBrokenPipeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBrokenPipeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyBufferError

extension PyBufferError {

  /// Name of the type in Python.
  public static let pythonTypeName = "BufferError"

  /// Arrangement of fields in memory.
  ///
  /// `PyBufferError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBufferError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBufferError? {
    return py.cast.asBufferError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BufferError` type.
  public func newBufferError(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBufferError {
    let typeLayout = PyBufferError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBufferError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyBytesWarning

extension PyBytesWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "BytesWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyBytesWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyBytesWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBytesWarning? {
    return py.cast.asBytesWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BytesWarning` type.
  public func newBytesWarning(type: PyType,
                              args: PyTuple,
                              traceback: PyTraceback? = nil,
                              cause: PyBaseException? = nil,
                              context: PyBaseException? = nil,
                              suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBytesWarning {
    let typeLayout = PyBytesWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyBytesWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyChildProcessError

extension PyChildProcessError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ChildProcessError"

  /// Arrangement of fields in memory.
  ///
  /// `PyChildProcessError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyChildProcessError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyChildProcessError? {
    return py.cast.asChildProcessError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ChildProcessError` type.
  public func newChildProcessError(type: PyType,
                                   args: PyTuple,
                                   traceback: PyTraceback? = nil,
                                   cause: PyBaseException? = nil,
                                   context: PyBaseException? = nil,
                                   suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyChildProcessError {
    let typeLayout = PyChildProcessError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyChildProcessError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyConnectionAbortedError

extension PyConnectionAbortedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionAbortedError"

  /// Arrangement of fields in memory.
  ///
  /// `PyConnectionAbortedError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyConnectionError`.
  internal typealias Layout = PyConnectionError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyConnectionAbortedError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyConnectionError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionAbortedError? {
    return py.cast.asConnectionAbortedError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionAbortedError` type.
  public func newConnectionAbortedError(type: PyType,
                                        args: PyTuple,
                                        traceback: PyTraceback? = nil,
                                        cause: PyBaseException? = nil,
                                        context: PyBaseException? = nil,
                                        suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionAbortedError {
    let typeLayout = PyConnectionAbortedError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyConnectionAbortedError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyConnectionError

extension PyConnectionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionError"

  /// Arrangement of fields in memory.
  ///
  /// `PyConnectionError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyConnectionError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionError? {
    return py.cast.asConnectionError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionError` type.
  public func newConnectionError(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionError {
    let typeLayout = PyConnectionError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyConnectionError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyConnectionRefusedError

extension PyConnectionRefusedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionRefusedError"

  /// Arrangement of fields in memory.
  ///
  /// `PyConnectionRefusedError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyConnectionError`.
  internal typealias Layout = PyConnectionError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyConnectionRefusedError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyConnectionError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionRefusedError? {
    return py.cast.asConnectionRefusedError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionRefusedError` type.
  public func newConnectionRefusedError(type: PyType,
                                        args: PyTuple,
                                        traceback: PyTraceback? = nil,
                                        cause: PyBaseException? = nil,
                                        context: PyBaseException? = nil,
                                        suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionRefusedError {
    let typeLayout = PyConnectionRefusedError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyConnectionRefusedError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyConnectionResetError

extension PyConnectionResetError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionResetError"

  /// Arrangement of fields in memory.
  ///
  /// `PyConnectionResetError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyConnectionError`.
  internal typealias Layout = PyConnectionError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyConnectionResetError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyConnectionError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionResetError? {
    return py.cast.asConnectionResetError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionResetError` type.
  public func newConnectionResetError(type: PyType,
                                      args: PyTuple,
                                      traceback: PyTraceback? = nil,
                                      cause: PyBaseException? = nil,
                                      context: PyBaseException? = nil,
                                      suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionResetError {
    let typeLayout = PyConnectionResetError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyConnectionResetError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyDeprecationWarning

extension PyDeprecationWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "DeprecationWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyDeprecationWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyDeprecationWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDeprecationWarning? {
    return py.cast.asDeprecationWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `DeprecationWarning` type.
  public func newDeprecationWarning(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyDeprecationWarning {
    let typeLayout = PyDeprecationWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyDeprecationWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyEOFError

extension PyEOFError {

  /// Name of the type in Python.
  public static let pythonTypeName = "EOFError"

  /// Arrangement of fields in memory.
  ///
  /// `PyEOFError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyEOFError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyEOFError? {
    return py.cast.asEOFError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `EOFError` type.
  public func newEOFError(type: PyType,
                          args: PyTuple,
                          traceback: PyTraceback? = nil,
                          cause: PyBaseException? = nil,
                          context: PyBaseException? = nil,
                          suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyEOFError {
    let typeLayout = PyEOFError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyEOFError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyException

extension PyException {

  /// Name of the type in Python.
  public static let pythonTypeName = "Exception"

  /// Arrangement of fields in memory.
  ///
  /// `PyException` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyBaseException`.
  internal typealias Layout = PyBaseException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyException(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyBaseException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyException? {
    return py.cast.asException(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `Exception` type.
  public func newException(type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyException {
    let typeLayout = PyException.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyException(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyFileExistsError

extension PyFileExistsError {

  /// Name of the type in Python.
  public static let pythonTypeName = "FileExistsError"

  /// Arrangement of fields in memory.
  ///
  /// `PyFileExistsError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFileExistsError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFileExistsError? {
    return py.cast.asFileExistsError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FileExistsError` type.
  public func newFileExistsError(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFileExistsError {
    let typeLayout = PyFileExistsError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFileExistsError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyFileNotFoundError

extension PyFileNotFoundError {

  /// Name of the type in Python.
  public static let pythonTypeName = "FileNotFoundError"

  /// Arrangement of fields in memory.
  ///
  /// `PyFileNotFoundError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFileNotFoundError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFileNotFoundError? {
    return py.cast.asFileNotFoundError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FileNotFoundError` type.
  public func newFileNotFoundError(type: PyType,
                                   args: PyTuple,
                                   traceback: PyTraceback? = nil,
                                   cause: PyBaseException? = nil,
                                   context: PyBaseException? = nil,
                                   suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFileNotFoundError {
    let typeLayout = PyFileNotFoundError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFileNotFoundError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyFloatingPointError

extension PyFloatingPointError {

  /// Name of the type in Python.
  public static let pythonTypeName = "FloatingPointError"

  /// Arrangement of fields in memory.
  ///
  /// `PyFloatingPointError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyArithmeticError`.
  internal typealias Layout = PyArithmeticError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyArithmeticError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFloatingPointError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyArithmeticError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFloatingPointError? {
    return py.cast.asFloatingPointError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FloatingPointError` type.
  public func newFloatingPointError(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFloatingPointError {
    let typeLayout = PyFloatingPointError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFloatingPointError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyFutureWarning

extension PyFutureWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "FutureWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyFutureWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyFutureWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFutureWarning? {
    return py.cast.asFutureWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FutureWarning` type.
  public func newFutureWarning(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFutureWarning {
    let typeLayout = PyFutureWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyFutureWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyGeneratorExit

extension PyGeneratorExit {

  /// Name of the type in Python.
  public static let pythonTypeName = "GeneratorExit"

  /// Arrangement of fields in memory.
  ///
  /// `PyGeneratorExit` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyBaseException`.
  internal typealias Layout = PyBaseException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyGeneratorExit(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyBaseException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyGeneratorExit? {
    return py.cast.asGeneratorExit(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `GeneratorExit` type.
  public func newGeneratorExit(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyGeneratorExit {
    let typeLayout = PyGeneratorExit.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyGeneratorExit(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyImportError

extension PyImportError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ImportError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyImportError` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let msgOffset: Int
    internal let moduleNameOffset: Int
    internal let modulePathOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyImportError>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self), // PyImportError.msg
          GenericLayout.Field(PyObject?.self), // PyImportError.moduleName
          GenericLayout.Field(PyObject?.self) // PyImportError.modulePath
        ]
      )

      assert(layout.offsets.count == 3)
      self.msgOffset = layout.offsets[0]
      self.moduleNameOffset = layout.offsets[1]
      self.modulePathOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property: `PyImportError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.msgOffset) }
  /// Property: `PyImportError.moduleName`.
  internal var moduleNamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleNameOffset) }
  /// Property: `PyImportError.modulePath`.
  internal var modulePathPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.modulePathOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyImportError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.msgPtr.deinitialize()
    zelf.moduleNamePtr.deinitialize()
    zelf.modulePathPtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyImportError? {
    return py.cast.asImportError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ImportError` type.
  public func newImportError(type: PyType,
                             msg: PyObject?,
                             moduleName: PyObject?,
                             modulePath: PyObject?,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyImportError {
    let typeLayout = PyImportError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyImportError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      msg: msg,
                      moduleName: moduleName,
                      modulePath: modulePath,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `ImportError` type.
  public func newImportError(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyImportError {
    let typeLayout = PyImportError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyImportError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyImportWarning

extension PyImportWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "ImportWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyImportWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyImportWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyImportWarning? {
    return py.cast.asImportWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ImportWarning` type.
  public func newImportWarning(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyImportWarning {
    let typeLayout = PyImportWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyImportWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyIndentationError

extension PyIndentationError {

  /// Name of the type in Python.
  public static let pythonTypeName = "IndentationError"

  /// Arrangement of fields in memory.
  ///
  /// `PyIndentationError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PySyntaxError`.
  internal typealias Layout = PySyntaxError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property from base class: `PySyntaxError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.msgOffset) }
  /// Property from base class: `PySyntaxError.filename`.
  internal var filenamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.filenameOffset) }
  /// Property from base class: `PySyntaxError.lineno`.
  internal var linenoPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.linenoOffset) }
  /// Property from base class: `PySyntaxError.offset`.
  internal var offsetPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.offsetOffset) }
  /// Property from base class: `PySyntaxError.text`.
  internal var textPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.textOffset) }
  /// Property from base class: `PySyntaxError.printFileAndLine`.
  internal var printFileAndLinePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.printFileAndLineOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }
  /// Property from base class: `PySyntaxError.msg`.
  internal var msg: PyObject? { self.msgPtr.pointee }
  /// Property from base class: `PySyntaxError.filename`.
  internal var filename: PyObject? { self.filenamePtr.pointee }
  /// Property from base class: `PySyntaxError.lineno`.
  internal var lineno: PyObject? { self.linenoPtr.pointee }
  /// Property from base class: `PySyntaxError.offset`.
  internal var offset: PyObject? { self.offsetPtr.pointee }
  /// Property from base class: `PySyntaxError.text`.
  internal var text: PyObject? { self.textPtr.pointee }
  /// Property from base class: `PySyntaxError.printFileAndLine`.
  internal var printFileAndLine: PyObject? { self.printFileAndLinePtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               msg: PyObject?,
                               filename: PyObject?,
                               lineno: PyObject?,
                               offset: PyObject?,
                               text: PyObject?,
                               printFileAndLine: PyObject?,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PySyntaxError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    msg: msg,
                    filename: filename,
                    lineno: lineno,
                    offset: offset,
                    text: text,
                    printFileAndLine: printFileAndLine,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PySyntaxError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyIndentationError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PySyntaxError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIndentationError? {
    return py.cast.asIndentationError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `IndentationError` type.
  public func newIndentationError(type: PyType,
                                  msg: PyObject?,
                                  filename: PyObject?,
                                  lineno: PyObject?,
                                  offset: PyObject?,
                                  text: PyObject?,
                                  printFileAndLine: PyObject?,
                                  traceback: PyTraceback? = nil,
                                  cause: PyBaseException? = nil,
                                  context: PyBaseException? = nil,
                                  suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIndentationError {
    let typeLayout = PyIndentationError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyIndentationError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      msg: msg,
                      filename: filename,
                      lineno: lineno,
                      offset: offset,
                      text: text,
                      printFileAndLine: printFileAndLine,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `IndentationError` type.
  public func newIndentationError(type: PyType,
                                  args: PyTuple,
                                  traceback: PyTraceback? = nil,
                                  cause: PyBaseException? = nil,
                                  context: PyBaseException? = nil,
                                  suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIndentationError {
    let typeLayout = PyIndentationError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyIndentationError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyIndexError

extension PyIndexError {

  /// Name of the type in Python.
  public static let pythonTypeName = "IndexError"

  /// Arrangement of fields in memory.
  ///
  /// `PyIndexError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyLookupError`.
  internal typealias Layout = PyLookupError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyLookupError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyIndexError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyLookupError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIndexError? {
    return py.cast.asIndexError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `IndexError` type.
  public func newIndexError(type: PyType,
                            args: PyTuple,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIndexError {
    let typeLayout = PyIndexError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyIndexError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyInterruptedError

extension PyInterruptedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "InterruptedError"

  /// Arrangement of fields in memory.
  ///
  /// `PyInterruptedError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyInterruptedError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyInterruptedError? {
    return py.cast.asInterruptedError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `InterruptedError` type.
  public func newInterruptedError(type: PyType,
                                  args: PyTuple,
                                  traceback: PyTraceback? = nil,
                                  cause: PyBaseException? = nil,
                                  context: PyBaseException? = nil,
                                  suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyInterruptedError {
    let typeLayout = PyInterruptedError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyInterruptedError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyIsADirectoryError

extension PyIsADirectoryError {

  /// Name of the type in Python.
  public static let pythonTypeName = "IsADirectoryError"

  /// Arrangement of fields in memory.
  ///
  /// `PyIsADirectoryError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyIsADirectoryError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIsADirectoryError? {
    return py.cast.asIsADirectoryError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `IsADirectoryError` type.
  public func newIsADirectoryError(type: PyType,
                                   args: PyTuple,
                                   traceback: PyTraceback? = nil,
                                   cause: PyBaseException? = nil,
                                   context: PyBaseException? = nil,
                                   suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIsADirectoryError {
    let typeLayout = PyIsADirectoryError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyIsADirectoryError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyKeyError

extension PyKeyError {

  /// Name of the type in Python.
  public static let pythonTypeName = "KeyError"

  /// Arrangement of fields in memory.
  ///
  /// `PyKeyError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyLookupError`.
  internal typealias Layout = PyLookupError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyLookupError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyKeyError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyLookupError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyKeyError? {
    return py.cast.asKeyError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `KeyError` type.
  public func newKeyError(type: PyType,
                          args: PyTuple,
                          traceback: PyTraceback? = nil,
                          cause: PyBaseException? = nil,
                          context: PyBaseException? = nil,
                          suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyKeyError {
    let typeLayout = PyKeyError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyKeyError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyKeyboardInterrupt

extension PyKeyboardInterrupt {

  /// Name of the type in Python.
  public static let pythonTypeName = "KeyboardInterrupt"

  /// Arrangement of fields in memory.
  ///
  /// `PyKeyboardInterrupt` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyBaseException`.
  internal typealias Layout = PyBaseException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyKeyboardInterrupt(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyBaseException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyKeyboardInterrupt? {
    return py.cast.asKeyboardInterrupt(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `KeyboardInterrupt` type.
  public func newKeyboardInterrupt(type: PyType,
                                   args: PyTuple,
                                   traceback: PyTraceback? = nil,
                                   cause: PyBaseException? = nil,
                                   context: PyBaseException? = nil,
                                   suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyKeyboardInterrupt {
    let typeLayout = PyKeyboardInterrupt.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyKeyboardInterrupt(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyLookupError

extension PyLookupError {

  /// Name of the type in Python.
  public static let pythonTypeName = "LookupError"

  /// Arrangement of fields in memory.
  ///
  /// `PyLookupError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyLookupError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyLookupError? {
    return py.cast.asLookupError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `LookupError` type.
  public func newLookupError(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyLookupError {
    let typeLayout = PyLookupError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyLookupError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyMemoryError

extension PyMemoryError {

  /// Name of the type in Python.
  public static let pythonTypeName = "MemoryError"

  /// Arrangement of fields in memory.
  ///
  /// `PyMemoryError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyMemoryError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyMemoryError? {
    return py.cast.asMemoryError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `MemoryError` type.
  public func newMemoryError(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyMemoryError {
    let typeLayout = PyMemoryError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyMemoryError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyModuleNotFoundError

extension PyModuleNotFoundError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ModuleNotFoundError"

  /// Arrangement of fields in memory.
  ///
  /// `PyModuleNotFoundError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyImportError`.
  internal typealias Layout = PyImportError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property from base class: `PyImportError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PyImportError.layout.msgOffset) }
  /// Property from base class: `PyImportError.moduleName`.
  internal var moduleNamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PyImportError.layout.moduleNameOffset) }
  /// Property from base class: `PyImportError.modulePath`.
  internal var modulePathPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PyImportError.layout.modulePathOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }
  /// Property from base class: `PyImportError.msg`.
  internal var msg: PyObject? { self.msgPtr.pointee }
  /// Property from base class: `PyImportError.moduleName`.
  internal var moduleName: PyObject? { self.moduleNamePtr.pointee }
  /// Property from base class: `PyImportError.modulePath`.
  internal var modulePath: PyObject? { self.modulePathPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               msg: PyObject?,
                               moduleName: PyObject?,
                               modulePath: PyObject?,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyImportError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    msg: msg,
                    moduleName: moduleName,
                    modulePath: modulePath,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyImportError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyModuleNotFoundError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyImportError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyModuleNotFoundError? {
    return py.cast.asModuleNotFoundError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ModuleNotFoundError` type.
  public func newModuleNotFoundError(type: PyType,
                                     msg: PyObject?,
                                     moduleName: PyObject?,
                                     modulePath: PyObject?,
                                     traceback: PyTraceback? = nil,
                                     cause: PyBaseException? = nil,
                                     context: PyBaseException? = nil,
                                     suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyModuleNotFoundError {
    let typeLayout = PyModuleNotFoundError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyModuleNotFoundError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      msg: msg,
                      moduleName: moduleName,
                      modulePath: modulePath,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `ModuleNotFoundError` type.
  public func newModuleNotFoundError(type: PyType,
                                     args: PyTuple,
                                     traceback: PyTraceback? = nil,
                                     cause: PyBaseException? = nil,
                                     context: PyBaseException? = nil,
                                     suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyModuleNotFoundError {
    let typeLayout = PyModuleNotFoundError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyModuleNotFoundError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyNameError

extension PyNameError {

  /// Name of the type in Python.
  public static let pythonTypeName = "NameError"

  /// Arrangement of fields in memory.
  ///
  /// `PyNameError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyNameError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNameError? {
    return py.cast.asNameError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NameError` type.
  public func newNameError(type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyNameError {
    let typeLayout = PyNameError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyNameError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyNotADirectoryError

extension PyNotADirectoryError {

  /// Name of the type in Python.
  public static let pythonTypeName = "NotADirectoryError"

  /// Arrangement of fields in memory.
  ///
  /// `PyNotADirectoryError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyNotADirectoryError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNotADirectoryError? {
    return py.cast.asNotADirectoryError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NotADirectoryError` type.
  public func newNotADirectoryError(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyNotADirectoryError {
    let typeLayout = PyNotADirectoryError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyNotADirectoryError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyNotImplementedError

extension PyNotImplementedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "NotImplementedError"

  /// Arrangement of fields in memory.
  ///
  /// `PyNotImplementedError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyRuntimeError`.
  internal typealias Layout = PyRuntimeError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyRuntimeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyNotImplementedError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyRuntimeError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNotImplementedError? {
    return py.cast.asNotImplementedError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NotImplementedError` type.
  public func newNotImplementedError(type: PyType,
                                     args: PyTuple,
                                     traceback: PyTraceback? = nil,
                                     cause: PyBaseException? = nil,
                                     context: PyBaseException? = nil,
                                     suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyNotImplementedError {
    let typeLayout = PyNotImplementedError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyNotImplementedError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyOSError

extension PyOSError {

  /// Name of the type in Python.
  public static let pythonTypeName = "OSError"

  /// Arrangement of fields in memory.
  ///
  /// `PyOSError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyOSError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyOSError? {
    return py.cast.asOSError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `OSError` type.
  public func newOSError(type: PyType,
                         args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyOSError {
    let typeLayout = PyOSError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyOSError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyOverflowError

extension PyOverflowError {

  /// Name of the type in Python.
  public static let pythonTypeName = "OverflowError"

  /// Arrangement of fields in memory.
  ///
  /// `PyOverflowError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyArithmeticError`.
  internal typealias Layout = PyArithmeticError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyArithmeticError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyOverflowError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyArithmeticError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyOverflowError? {
    return py.cast.asOverflowError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `OverflowError` type.
  public func newOverflowError(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyOverflowError {
    let typeLayout = PyOverflowError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyOverflowError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyPendingDeprecationWarning

extension PyPendingDeprecationWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "PendingDeprecationWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyPendingDeprecationWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyPendingDeprecationWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyPendingDeprecationWarning? {
    return py.cast.asPendingDeprecationWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `PendingDeprecationWarning` type.
  public func newPendingDeprecationWarning(type: PyType,
                                           args: PyTuple,
                                           traceback: PyTraceback? = nil,
                                           cause: PyBaseException? = nil,
                                           context: PyBaseException? = nil,
                                           suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyPendingDeprecationWarning {
    let typeLayout = PyPendingDeprecationWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyPendingDeprecationWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyPermissionError

extension PyPermissionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "PermissionError"

  /// Arrangement of fields in memory.
  ///
  /// `PyPermissionError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyPermissionError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyPermissionError? {
    return py.cast.asPermissionError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `PermissionError` type.
  public func newPermissionError(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyPermissionError {
    let typeLayout = PyPermissionError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyPermissionError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyProcessLookupError

extension PyProcessLookupError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ProcessLookupError"

  /// Arrangement of fields in memory.
  ///
  /// `PyProcessLookupError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyProcessLookupError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyProcessLookupError? {
    return py.cast.asProcessLookupError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ProcessLookupError` type.
  public func newProcessLookupError(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyProcessLookupError {
    let typeLayout = PyProcessLookupError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyProcessLookupError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyRecursionError

extension PyRecursionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "RecursionError"

  /// Arrangement of fields in memory.
  ///
  /// `PyRecursionError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyRuntimeError`.
  internal typealias Layout = PyRuntimeError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyRuntimeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyRecursionError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyRuntimeError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRecursionError? {
    return py.cast.asRecursionError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `RecursionError` type.
  public func newRecursionError(type: PyType,
                                args: PyTuple,
                                traceback: PyTraceback? = nil,
                                cause: PyBaseException? = nil,
                                context: PyBaseException? = nil,
                                suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyRecursionError {
    let typeLayout = PyRecursionError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyRecursionError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyReferenceError

extension PyReferenceError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ReferenceError"

  /// Arrangement of fields in memory.
  ///
  /// `PyReferenceError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyReferenceError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyReferenceError? {
    return py.cast.asReferenceError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ReferenceError` type.
  public func newReferenceError(type: PyType,
                                args: PyTuple,
                                traceback: PyTraceback? = nil,
                                cause: PyBaseException? = nil,
                                context: PyBaseException? = nil,
                                suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyReferenceError {
    let typeLayout = PyReferenceError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyReferenceError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyResourceWarning

extension PyResourceWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "ResourceWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyResourceWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyResourceWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyResourceWarning? {
    return py.cast.asResourceWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ResourceWarning` type.
  public func newResourceWarning(type: PyType,
                                 args: PyTuple,
                                 traceback: PyTraceback? = nil,
                                 cause: PyBaseException? = nil,
                                 context: PyBaseException? = nil,
                                 suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyResourceWarning {
    let typeLayout = PyResourceWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyResourceWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyRuntimeError

extension PyRuntimeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "RuntimeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyRuntimeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyRuntimeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRuntimeError? {
    return py.cast.asRuntimeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `RuntimeError` type.
  public func newRuntimeError(type: PyType,
                              args: PyTuple,
                              traceback: PyTraceback? = nil,
                              cause: PyBaseException? = nil,
                              context: PyBaseException? = nil,
                              suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyRuntimeError {
    let typeLayout = PyRuntimeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyRuntimeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyRuntimeWarning

extension PyRuntimeWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "RuntimeWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyRuntimeWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyRuntimeWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRuntimeWarning? {
    return py.cast.asRuntimeWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `RuntimeWarning` type.
  public func newRuntimeWarning(type: PyType,
                                args: PyTuple,
                                traceback: PyTraceback? = nil,
                                cause: PyBaseException? = nil,
                                context: PyBaseException? = nil,
                                suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyRuntimeWarning {
    let typeLayout = PyRuntimeWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyRuntimeWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyStopAsyncIteration

extension PyStopAsyncIteration {

  /// Name of the type in Python.
  public static let pythonTypeName = "StopAsyncIteration"

  /// Arrangement of fields in memory.
  ///
  /// `PyStopAsyncIteration` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyStopAsyncIteration(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStopAsyncIteration? {
    return py.cast.asStopAsyncIteration(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `StopAsyncIteration` type.
  public func newStopAsyncIteration(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyStopAsyncIteration {
    let typeLayout = PyStopAsyncIteration.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyStopAsyncIteration(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyStopIteration

extension PyStopIteration {

  /// Name of the type in Python.
  public static let pythonTypeName = "StopIteration"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStopIteration` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyStopIteration>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject.self) // PyStopIteration.value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property: `PyStopIteration.value`.
  internal var valuePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyStopIteration(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStopIteration? {
    return py.cast.asStopIteration(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `StopIteration` type.
  public func newStopIteration(type: PyType,
                               value: PyObject,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyStopIteration {
    let typeLayout = PyStopIteration.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyStopIteration(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      value: value,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `StopIteration` type.
  public func newStopIteration(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyStopIteration {
    let typeLayout = PyStopIteration.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyStopIteration(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PySyntaxError

extension PySyntaxError {

  /// Name of the type in Python.
  public static let pythonTypeName = "SyntaxError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySyntaxError` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let msgOffset: Int
    internal let filenameOffset: Int
    internal let linenoOffset: Int
    internal let offsetOffset: Int
    internal let textOffset: Int
    internal let printFileAndLineOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PySyntaxError>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self), // PySyntaxError.msg
          GenericLayout.Field(PyObject?.self), // PySyntaxError.filename
          GenericLayout.Field(PyObject?.self), // PySyntaxError.lineno
          GenericLayout.Field(PyObject?.self), // PySyntaxError.offset
          GenericLayout.Field(PyObject?.self), // PySyntaxError.text
          GenericLayout.Field(PyObject?.self) // PySyntaxError.printFileAndLine
        ]
      )

      assert(layout.offsets.count == 6)
      self.msgOffset = layout.offsets[0]
      self.filenameOffset = layout.offsets[1]
      self.linenoOffset = layout.offsets[2]
      self.offsetOffset = layout.offsets[3]
      self.textOffset = layout.offsets[4]
      self.printFileAndLineOffset = layout.offsets[5]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property: `PySyntaxError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.msgOffset) }
  /// Property: `PySyntaxError.filename`.
  internal var filenamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.filenameOffset) }
  /// Property: `PySyntaxError.lineno`.
  internal var linenoPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.linenoOffset) }
  /// Property: `PySyntaxError.offset`.
  internal var offsetPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.offsetOffset) }
  /// Property: `PySyntaxError.text`.
  internal var textPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.textOffset) }
  /// Property: `PySyntaxError.printFileAndLine`.
  internal var printFileAndLinePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.printFileAndLineOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySyntaxError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.msgPtr.deinitialize()
    zelf.filenamePtr.deinitialize()
    zelf.linenoPtr.deinitialize()
    zelf.offsetPtr.deinitialize()
    zelf.textPtr.deinitialize()
    zelf.printFileAndLinePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySyntaxError? {
    return py.cast.asSyntaxError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SyntaxError` type.
  public func newSyntaxError(type: PyType,
                             msg: PyObject?,
                             filename: PyObject?,
                             lineno: PyObject?,
                             offset: PyObject?,
                             text: PyObject?,
                             printFileAndLine: PyObject?,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySyntaxError {
    let typeLayout = PySyntaxError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySyntaxError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      msg: msg,
                      filename: filename,
                      lineno: lineno,
                      offset: offset,
                      text: text,
                      printFileAndLine: printFileAndLine,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `SyntaxError` type.
  public func newSyntaxError(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySyntaxError {
    let typeLayout = PySyntaxError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySyntaxError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PySyntaxWarning

extension PySyntaxWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "SyntaxWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PySyntaxWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySyntaxWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySyntaxWarning? {
    return py.cast.asSyntaxWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SyntaxWarning` type.
  public func newSyntaxWarning(type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySyntaxWarning {
    let typeLayout = PySyntaxWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySyntaxWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PySystemError

extension PySystemError {

  /// Name of the type in Python.
  public static let pythonTypeName = "SystemError"

  /// Arrangement of fields in memory.
  ///
  /// `PySystemError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySystemError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySystemError? {
    return py.cast.asSystemError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SystemError` type.
  public func newSystemError(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySystemError {
    let typeLayout = PySystemError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySystemError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PySystemExit

extension PySystemExit {

  /// Name of the type in Python.
  public static let pythonTypeName = "SystemExit"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySystemExit` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let codeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PySystemExit>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: PyBaseException.layout.size,
        initialAlignment: PyBaseException.layout.alignment,
        fields: [
          GenericLayout.Field(PyObject?.self) // PySystemExit.code
        ]
      )

      assert(layout.offsets.count == 1)
      self.codeOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property: `PySystemExit.code`.
  internal var codePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.codeOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PySystemExit(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.codePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyBaseException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySystemExit? {
    return py.cast.asSystemExit(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SystemExit` type.
  public func newSystemExit(type: PyType,
                            code: PyObject?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySystemExit {
    let typeLayout = PySystemExit.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySystemExit(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      code: code,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `SystemExit` type.
  public func newSystemExit(type: PyType,
                            args: PyTuple,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySystemExit {
    let typeLayout = PySystemExit.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PySystemExit(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyTabError

extension PyTabError {

  /// Name of the type in Python.
  public static let pythonTypeName = "TabError"

  /// Arrangement of fields in memory.
  ///
  /// `PyTabError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyIndentationError`.
  internal typealias Layout = PyIndentationError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }
  /// Property from base class: `PySyntaxError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.msgOffset) }
  /// Property from base class: `PySyntaxError.filename`.
  internal var filenamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.filenameOffset) }
  /// Property from base class: `PySyntaxError.lineno`.
  internal var linenoPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.linenoOffset) }
  /// Property from base class: `PySyntaxError.offset`.
  internal var offsetPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.offsetOffset) }
  /// Property from base class: `PySyntaxError.text`.
  internal var textPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.textOffset) }
  /// Property from base class: `PySyntaxError.printFileAndLine`.
  internal var printFileAndLinePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PySyntaxError.layout.printFileAndLineOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }
  /// Property from base class: `PySyntaxError.msg`.
  internal var msg: PyObject? { self.msgPtr.pointee }
  /// Property from base class: `PySyntaxError.filename`.
  internal var filename: PyObject? { self.filenamePtr.pointee }
  /// Property from base class: `PySyntaxError.lineno`.
  internal var lineno: PyObject? { self.linenoPtr.pointee }
  /// Property from base class: `PySyntaxError.offset`.
  internal var offset: PyObject? { self.offsetPtr.pointee }
  /// Property from base class: `PySyntaxError.text`.
  internal var text: PyObject? { self.textPtr.pointee }
  /// Property from base class: `PySyntaxError.printFileAndLine`.
  internal var printFileAndLine: PyObject? { self.printFileAndLinePtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               msg: PyObject?,
                               filename: PyObject?,
                               lineno: PyObject?,
                               offset: PyObject?,
                               text: PyObject?,
                               printFileAndLine: PyObject?,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyIndentationError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    msg: msg,
                    filename: filename,
                    lineno: lineno,
                    offset: offset,
                    text: text,
                    printFileAndLine: printFileAndLine,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyIndentationError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTabError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyIndentationError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTabError? {
    return py.cast.asTabError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TabError` type.
  public func newTabError(type: PyType,
                          msg: PyObject?,
                          filename: PyObject?,
                          lineno: PyObject?,
                          offset: PyObject?,
                          text: PyObject?,
                          printFileAndLine: PyObject?,
                          traceback: PyTraceback? = nil,
                          cause: PyBaseException? = nil,
                          context: PyBaseException? = nil,
                          suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTabError {
    let typeLayout = PyTabError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTabError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      msg: msg,
                      filename: filename,
                      lineno: lineno,
                      offset: offset,
                      text: text,
                      printFileAndLine: printFileAndLine,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }

  /// Allocate a new instance of `TabError` type.
  public func newTabError(type: PyType,
                          args: PyTuple,
                          traceback: PyTraceback? = nil,
                          cause: PyBaseException? = nil,
                          context: PyBaseException? = nil,
                          suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTabError {
    let typeLayout = PyTabError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTabError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyTimeoutError

extension PyTimeoutError {

  /// Name of the type in Python.
  public static let pythonTypeName = "TimeoutError"

  /// Arrangement of fields in memory.
  ///
  /// `PyTimeoutError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyOSError`.
  internal typealias Layout = PyOSError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTimeoutError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyOSError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTimeoutError? {
    return py.cast.asTimeoutError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TimeoutError` type.
  public func newTimeoutError(type: PyType,
                              args: PyTuple,
                              traceback: PyTraceback? = nil,
                              cause: PyBaseException? = nil,
                              context: PyBaseException? = nil,
                              suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTimeoutError {
    let typeLayout = PyTimeoutError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTimeoutError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyTypeError

extension PyTypeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "TypeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyTypeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyTypeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTypeError? {
    return py.cast.asTypeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TypeError` type.
  public func newTypeError(type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTypeError {
    let typeLayout = PyTypeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyTypeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUnboundLocalError

extension PyUnboundLocalError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnboundLocalError"

  /// Arrangement of fields in memory.
  ///
  /// `PyUnboundLocalError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyNameError`.
  internal typealias Layout = PyNameError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyNameError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUnboundLocalError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyNameError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnboundLocalError? {
    return py.cast.asUnboundLocalError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnboundLocalError` type.
  public func newUnboundLocalError(type: PyType,
                                   args: PyTuple,
                                   traceback: PyTraceback? = nil,
                                   cause: PyBaseException? = nil,
                                   context: PyBaseException? = nil,
                                   suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnboundLocalError {
    let typeLayout = PyUnboundLocalError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUnboundLocalError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUnicodeDecodeError

extension PyUnicodeDecodeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeDecodeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyUnicodeDecodeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyUnicodeError`.
  internal typealias Layout = PyUnicodeError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyUnicodeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUnicodeDecodeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyUnicodeError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeDecodeError? {
    return py.cast.asUnicodeDecodeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeDecodeError` type.
  public func newUnicodeDecodeError(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeDecodeError {
    let typeLayout = PyUnicodeDecodeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUnicodeDecodeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUnicodeEncodeError

extension PyUnicodeEncodeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeEncodeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyUnicodeEncodeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyUnicodeError`.
  internal typealias Layout = PyUnicodeError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyUnicodeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUnicodeEncodeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyUnicodeError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeEncodeError? {
    return py.cast.asUnicodeEncodeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeEncodeError` type.
  public func newUnicodeEncodeError(type: PyType,
                                    args: PyTuple,
                                    traceback: PyTraceback? = nil,
                                    cause: PyBaseException? = nil,
                                    context: PyBaseException? = nil,
                                    suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeEncodeError {
    let typeLayout = PyUnicodeEncodeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUnicodeEncodeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUnicodeError

extension PyUnicodeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeError"

  /// Arrangement of fields in memory.
  ///
  /// `PyUnicodeError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyValueError`.
  internal typealias Layout = PyValueError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyValueError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUnicodeError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyValueError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeError? {
    return py.cast.asUnicodeError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeError` type.
  public func newUnicodeError(type: PyType,
                              args: PyTuple,
                              traceback: PyTraceback? = nil,
                              cause: PyBaseException? = nil,
                              context: PyBaseException? = nil,
                              suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeError {
    let typeLayout = PyUnicodeError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUnicodeError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUnicodeTranslateError

extension PyUnicodeTranslateError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeTranslateError"

  /// Arrangement of fields in memory.
  ///
  /// `PyUnicodeTranslateError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyUnicodeError`.
  internal typealias Layout = PyUnicodeError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyUnicodeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUnicodeTranslateError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyUnicodeError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeTranslateError? {
    return py.cast.asUnicodeTranslateError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeTranslateError` type.
  public func newUnicodeTranslateError(type: PyType,
                                       args: PyTuple,
                                       traceback: PyTraceback? = nil,
                                       cause: PyBaseException? = nil,
                                       context: PyBaseException? = nil,
                                       suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeTranslateError {
    let typeLayout = PyUnicodeTranslateError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUnicodeTranslateError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUnicodeWarning

extension PyUnicodeWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyUnicodeWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUnicodeWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeWarning? {
    return py.cast.asUnicodeWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeWarning` type.
  public func newUnicodeWarning(type: PyType,
                                args: PyTuple,
                                traceback: PyTraceback? = nil,
                                cause: PyBaseException? = nil,
                                context: PyBaseException? = nil,
                                suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeWarning {
    let typeLayout = PyUnicodeWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUnicodeWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyUserWarning

extension PyUserWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "UserWarning"

  /// Arrangement of fields in memory.
  ///
  /// `PyUserWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyWarning`.
  internal typealias Layout = PyWarning.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyUserWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyWarning.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUserWarning? {
    return py.cast.asUserWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UserWarning` type.
  public func newUserWarning(type: PyType,
                             args: PyTuple,
                             traceback: PyTraceback? = nil,
                             cause: PyBaseException? = nil,
                             context: PyBaseException? = nil,
                             suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUserWarning {
    let typeLayout = PyUserWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyUserWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyValueError

extension PyValueError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ValueError"

  /// Arrangement of fields in memory.
  ///
  /// `PyValueError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyValueError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyValueError? {
    return py.cast.asValueError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ValueError` type.
  public func newValueError(type: PyType,
                            args: PyTuple,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyValueError {
    let typeLayout = PyValueError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyValueError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyWarning

extension PyWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "Warning"

  /// Arrangement of fields in memory.
  ///
  /// `PyWarning` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyException`.
  internal typealias Layout = PyException.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyWarning(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyException.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyWarning? {
    return py.cast.asWarning(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `Warning` type.
  public func newWarning(type: PyType,
                         args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyWarning {
    let typeLayout = PyWarning.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyWarning(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}

// MARK: - PyZeroDivisionError

extension PyZeroDivisionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ZeroDivisionError"

  /// Arrangement of fields in memory.
  ///
  /// `PyZeroDivisionError` does not have any properties with `sourcery: storedProperty` annotation,
  /// so we will use the same layout as `PyArithmeticError`.
  internal typealias Layout = PyArithmeticError.Layout

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property from base class: `PyBaseException.args`.
  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: PyBaseException.layout.argsOffset) }
  /// Property from base class: `PyBaseException.traceback`.
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: PyBaseException.layout.tracebackOffset) }
  /// Property from base class: `PyBaseException.cause`.
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.causeOffset) }
  /// Property from base class: `PyBaseException.context`.
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: PyBaseException.layout.contextOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }
  /// Property from base class: `PyBaseException.args`.
  internal var args: PyTuple { self.argsPtr.pointee }
  /// Property from base class: `PyBaseException.traceback`.
  internal var traceback: PyTraceback? { self.tracebackPtr.pointee }
  /// Property from base class: `PyBaseException.cause`.
  internal var cause: PyBaseException? { self.causePtr.pointee }
  /// Property from base class: `PyBaseException.context`.
  internal var context: PyBaseException? { self.contextPtr.pointee }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyBaseException.defaultSuppressContext) {
    let base = PyArithmeticError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyZeroDivisionError(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyArithmeticError.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyZeroDivisionError? {
    return py.cast.asZeroDivisionError(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ZeroDivisionError` type.
  public func newZeroDivisionError(type: PyType,
                                   args: PyTuple,
                                   traceback: PyTraceback? = nil,
                                   cause: PyBaseException? = nil,
                                   context: PyBaseException? = nil,
                                   suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyZeroDivisionError {
    let typeLayout = PyZeroDivisionError.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyZeroDivisionError(ptr: ptr)
    result.initialize(self.py,
                      type: type,
                      args: args,
                      traceback: traceback,
                      cause: cause,
                      context: context,
                      suppressContext: suppressContext)

    return result
  }
}
