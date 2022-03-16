// ============================================================================
// Automatically generated from: ./Sources/Objects/Generated/Types+Generated.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ============================================================================

import Foundation
import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

// swiftlint:disable empty_count
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

// This file contains:
// - For 'PyObjectHeader':
//   - PyObjectHeader.Layout - mainly field offsets
//   - PyObjectHeader.xxxPtr - pointer properties to fields
// - For 'PyErrorHeader':
//   - PyErrorHeader.Layout - mainly field offsets
//   - PyErrorHeader.xxxPtr - pointer properties to fields
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - Then for each type:
//   - static let pythonTypeName - name of the type in Python
//   - static let layout - mainly field offsets
//   - static func deinitialize(ptr: RawPtr) - to deinitialize this object before deletion
//   - static func downcast(py: Py, object: PyObject) -> [TYPE_NAME]?
//   - static func invalidZelfArgument<T>(py: Py, object: PyObject, fnName: String) -> PyResult<T>
//   - PyMemory.new[TYPE_NAME] - to create new object of this type

// MARK: - PyObjectHeader

extension PyObjectHeader {

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyObjectHeader` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let typeOffset: Int
    internal let __dict__Offset: Int
    internal let flagsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: 0,
        initialAlignment: 0,
        fields: [
          PyMemory.FieldLayout(from: PyType.self), // type
          PyMemory.FieldLayout(from: PyObjectHeader.Lazy__dict__.self), // __dict__
          PyMemory.FieldLayout(from: Flags.self) // flags
        ]
      )

      assert(layout.offsets.count == 3)
      self.typeOffset = layout.offsets[0]
      self.__dict__Offset = layout.offsets[1]
      self.flagsOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: Self.layout.typeOffset) }
  internal var __dict__Ptr: Ptr<PyObjectHeader.Lazy__dict__> { Ptr(self.ptr, offset: Self.layout.__dict__Offset) }
  internal var flagsPtr: Ptr<Flags> { Ptr(self.ptr, offset: Self.layout.flagsOffset) }
}

// MARK: - PyErrorHeader

extension PyErrorHeader {

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyErrorHeader` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let argsOffset: Int
    internal let tracebackOffset: Int
    internal let causeOffset: Int
    internal let contextOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyTuple.self), // args
          PyMemory.FieldLayout(from: PyTraceback?.self), // traceback
          PyMemory.FieldLayout(from: PyBaseException?.self), // cause
          PyMemory.FieldLayout(from: PyBaseException?.self) // context
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

  internal var argsPtr: Ptr<PyTuple> { Ptr(self.ptr, offset: Self.layout.argsOffset) }
  internal var tracebackPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: Self.layout.tracebackOffset) }
  internal var causePtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: Self.layout.causeOffset) }
  internal var contextPtr: Ptr<PyBaseException?> { Ptr(self.ptr, offset: Self.layout.contextOffset) }
}

// MARK: - Type/object types init

extension PyMemory {

  /// Those types require a special treatment because:
  /// - `object` type has `type` type
  /// - `type` type has `type` type (self reference) and `object` type as base
  public func newTypeAndObjectTypes(_ py: Py) -> (objectType: PyType, typeType: PyType) {
    let layout = PyType.layout
    let objectTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)
    let typeTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)

    let objectType = PyType(ptr: objectTypePtr)
    let typeType = PyType(ptr: typeTypePtr)

    objectType.initialize(py,
                          type: typeType,
                          name: "object",
                          qualname: "object",
                          flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
                          base: nil,
                          bases: [],
                          mroWithoutSelf: [],
                          subclasses: [],
                          layout: Py.Types.objectMemoryLayout,
                          staticMethods: Py.Types.objectStaticMethods,
                          debugFn: PyObject.createDebugString(ptr:),
                          deinitialize: PyObject.deinitialize(ptr:))

    typeType.initialize(py,
                        type: typeType,
                        name: "type",
                        qualname: "type",
                        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag, .isTypeSubclassFlag],
                        base: objectType,
                        bases: [objectType],
                        mroWithoutSelf: [objectType],
                        subclasses: [],
                        layout: Py.Types.typeMemoryLayout,
                        staticMethods: Py.Types.typeStaticMethods,
                        debugFn: PyType.createDebugString(ptr:),
                        deinitialize: PyType.deinitialize(ptr:))

   return (objectType, typeType)
  }
}

// MARK: - PyBool

extension PyBool {

  /// Name of the type in Python.
  public static let pythonTypeName = "bool"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBool` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyInt.layout.size,
        initialAlignment: PyInt.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyInt.value`.
  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: PyInt.layout.valueOffset) }

  /// Property from base class: `PyInt.value`.
  internal var value: BigInt { self.valuePtr.pointee }

  internal func initializeBase(_ py: Py, type: PyType, value: BigInt) {
    let base = PyInt(ptr: self.ptr)
    base.initialize(py, type: type, value: value)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBool(ptr: ptr).beforeDeinitialize()
    PyInt(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyInt.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBool? {
    return py.cast.asBool(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bool` type.
  public func newBool(
    _ py: Py,
    type: PyType,
    value: Bool
  ) -> PyBool {
    let typeLayout = PyBool.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBool(ptr: ptr)

    result.initialize(
      py,
      type: type,
      value: value
    )

    return result
  }
}

// MARK: - PyBuiltinFunction

extension PyBuiltinFunction {

  /// Name of the type in Python.
  public static let pythonTypeName = "builtinFunction"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBuiltinFunction` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: FunctionWrapper.self), // PyBuiltinFunction.function
          PyMemory.FieldLayout(from: PyObject?.self), // PyBuiltinFunction.module
          PyMemory.FieldLayout(from: String?.self) // PyBuiltinFunction.doc
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

  /// Property: `PyBuiltinFunction.function`.
  internal var functionPtr: Ptr<FunctionWrapper> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  /// Property: `PyBuiltinFunction.module`.
  internal var modulePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  /// Property: `PyBuiltinFunction.doc`.
  internal var docPtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBuiltinFunction(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyBuiltinFunction(ptr: ptr)
    zelf.functionPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBuiltinFunction? {
    return py.cast.asBuiltinFunction(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `builtinFunction` type.
  public func newBuiltinFunction(
    _ py: Py,
    type: PyType,
    function: FunctionWrapper,
    module: PyObject?,
    doc: String?
  ) -> PyBuiltinFunction {
    let typeLayout = PyBuiltinFunction.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBuiltinFunction(ptr: ptr)

    result.initialize(
      py,
      type: type,
      function: function,
      module: module,
      doc: doc
    )

    return result
  }
}

// MARK: - PyBuiltinMethod

extension PyBuiltinMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "builtinMethod"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBuiltinMethod` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: FunctionWrapper.self), // PyBuiltinMethod.function
          PyMemory.FieldLayout(from: PyObject.self), // PyBuiltinMethod.object
          PyMemory.FieldLayout(from: PyObject?.self), // PyBuiltinMethod.module
          PyMemory.FieldLayout(from: String?.self) // PyBuiltinMethod.doc
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

  /// Property: `PyBuiltinMethod.function`.
  internal var functionPtr: Ptr<FunctionWrapper> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  /// Property: `PyBuiltinMethod.object`.
  internal var objectPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.objectOffset) }
  /// Property: `PyBuiltinMethod.module`.
  internal var modulePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  /// Property: `PyBuiltinMethod.doc`.
  internal var docPtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBuiltinMethod(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyBuiltinMethod(ptr: ptr)
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBuiltinMethod? {
    return py.cast.asBuiltinMethod(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `builtinMethod` type.
  public func newBuiltinMethod(
    _ py: Py,
    type: PyType,
    function: FunctionWrapper,
    object: PyObject,
    module: PyObject?,
    doc: String?
  ) -> PyBuiltinMethod {
    let typeLayout = PyBuiltinMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBuiltinMethod(ptr: ptr)

    result.initialize(
      py,
      type: type,
      function: function,
      object: object,
      module: module,
      doc: doc
    )

    return result
  }
}

// MARK: - PyByteArray

extension PyByteArray {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytearray"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyByteArray` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Data.self) // PyByteArray.elements
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

  /// Property: `PyByteArray.elements`.
  internal var elementsPtr: Ptr<Data> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyByteArray(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyByteArray(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyByteArray? {
    return py.cast.asByteArray(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytearray` type.
  public func newByteArray(
    _ py: Py,
    type: PyType,
    elements: Data
  ) -> PyByteArray {
    let typeLayout = PyByteArray.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyByteArray(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PyByteArrayIterator

extension PyByteArrayIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytearray_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyByteArrayIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyByteArray.self), // PyByteArrayIterator.bytes
          PyMemory.FieldLayout(from: Int.self) // PyByteArrayIterator.index
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

  /// Property: `PyByteArrayIterator.bytes`.
  internal var bytesPtr: Ptr<PyByteArray> { Ptr(self.ptr, offset: Self.layout.bytesOffset) }
  /// Property: `PyByteArrayIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyByteArrayIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyByteArrayIterator(ptr: ptr)
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyByteArrayIterator? {
    return py.cast.asByteArrayIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytearray_iterator` type.
  public func newByteArrayIterator(
    _ py: Py,
    type: PyType,
    bytes: PyByteArray
  ) -> PyByteArrayIterator {
    let typeLayout = PyByteArrayIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyByteArrayIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      bytes: bytes
    )

    return result
  }
}

// MARK: - PyBytes

extension PyBytes {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytes"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBytes` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Data.self) // PyBytes.elements
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

  /// Property: `PyBytes.elements`.
  internal var elementsPtr: Ptr<Data> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBytes(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyBytes(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBytes? {
    return py.cast.asBytes(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytes` type.
  public func newBytes(
    _ py: Py,
    type: PyType,
    elements: Data
  ) -> PyBytes {
    let typeLayout = PyBytes.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBytes(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PyBytesIterator

extension PyBytesIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "bytes_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBytesIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyBytes.self), // PyBytesIterator.bytes
          PyMemory.FieldLayout(from: Int.self) // PyBytesIterator.index
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

  /// Property: `PyBytesIterator.bytes`.
  internal var bytesPtr: Ptr<PyBytes> { Ptr(self.ptr, offset: Self.layout.bytesOffset) }
  /// Property: `PyBytesIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBytesIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyBytesIterator(ptr: ptr)
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBytesIterator? {
    return py.cast.asBytesIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `bytes_iterator` type.
  public func newBytesIterator(
    _ py: Py,
    type: PyType,
    bytes: PyBytes
  ) -> PyBytesIterator {
    let typeLayout = PyBytesIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBytesIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      bytes: bytes
    )

    return result
  }
}

// MARK: - PyCallableIterator

extension PyCallableIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "callable_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyCallableIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let sentinelOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PyCallableIterator.callable
          PyMemory.FieldLayout(from: PyObject.self) // PyCallableIterator.sentinel
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

  /// Property: `PyCallableIterator.callable`.
  internal var callablePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.callableOffset) }
  /// Property: `PyCallableIterator.sentinel`.
  internal var sentinelPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sentinelOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyCallableIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyCallableIterator(ptr: ptr)
    zelf.callablePtr.deinitialize()
    zelf.sentinelPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyCallableIterator? {
    return py.cast.asCallableIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `callable_iterator` type.
  public func newCallableIterator(
    _ py: Py,
    type: PyType,
    callable: PyObject,
    sentinel: PyObject
  ) -> PyCallableIterator {
    let typeLayout = PyCallableIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyCallableIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      callable: callable,
      sentinel: sentinel
    )

    return result
  }
}

// MARK: - PyCell

extension PyCell {

  /// Name of the type in Python.
  public static let pythonTypeName = "cell"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyCell` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let contentOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // PyCell.content
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

  /// Property: `PyCell.content`.
  internal var contentPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.contentOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyCell(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyCell(ptr: ptr)
    zelf.contentPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyCell? {
    return py.cast.asCell(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `cell` type.
  public func newCell(
    _ py: Py,
    type: PyType,
    content: PyObject?
  ) -> PyCell {
    let typeLayout = PyCell.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyCell(ptr: ptr)

    result.initialize(
      py,
      type: type,
      content: content
    )

    return result
  }
}

// MARK: - PyClassMethod

extension PyClassMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "classmethod"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyClassMethod` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // PyClassMethod.callable
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

  /// Property: `PyClassMethod.callable`.
  internal var callablePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.callableOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyClassMethod(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyClassMethod(ptr: ptr)
    zelf.callablePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyClassMethod? {
    return py.cast.asClassMethod(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `classmethod` type.
  public func newClassMethod(
    _ py: Py,
    type: PyType,
    callable: PyObject?
  ) -> PyClassMethod {
    let typeLayout = PyClassMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyClassMethod(ptr: ptr)

    result.initialize(
      py,
      type: type,
      callable: callable
    )

    return result
  }
}

// MARK: - PyCode

extension PyCode {

  /// Name of the type in Python.
  public static let pythonTypeName = "code"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyCode` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
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
    internal let kwOnlyArgCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyString.self), // PyCode.name
          PyMemory.FieldLayout(from: PyString.self), // PyCode.qualifiedName
          PyMemory.FieldLayout(from: PyString.self), // PyCode.filename
          PyMemory.FieldLayout(from: [Instruction].self), // PyCode.instructions
          PyMemory.FieldLayout(from: SourceLine.self), // PyCode.firstLine
          PyMemory.FieldLayout(from: [SourceLine].self), // PyCode.instructionLines
          PyMemory.FieldLayout(from: [PyObject].self), // PyCode.constants
          PyMemory.FieldLayout(from: [CodeObject.Label].self), // PyCode.labels
          PyMemory.FieldLayout(from: [PyString].self), // PyCode.names
          PyMemory.FieldLayout(from: [MangledName].self), // PyCode.variableNames
          PyMemory.FieldLayout(from: [MangledName].self), // PyCode.cellVariableNames
          PyMemory.FieldLayout(from: [MangledName].self), // PyCode.freeVariableNames
          PyMemory.FieldLayout(from: Int.self), // PyCode.argCount
          PyMemory.FieldLayout(from: Int.self) // PyCode.kwOnlyArgCount
        ]
      )

      assert(layout.offsets.count == 14)
      self.nameOffset = layout.offsets[0]
      self.qualifiedNameOffset = layout.offsets[1]
      self.filenameOffset = layout.offsets[2]
      self.instructionsOffset = layout.offsets[3]
      self.firstLineOffset = layout.offsets[4]
      self.instructionLinesOffset = layout.offsets[5]
      self.constantsOffset = layout.offsets[6]
      self.labelsOffset = layout.offsets[7]
      self.namesOffset = layout.offsets[8]
      self.variableNamesOffset = layout.offsets[9]
      self.cellVariableNamesOffset = layout.offsets[10]
      self.freeVariableNamesOffset = layout.offsets[11]
      self.argCountOffset = layout.offsets[12]
      self.kwOnlyArgCountOffset = layout.offsets[13]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

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
  internal var labelsPtr: Ptr<[CodeObject.Label]> { Ptr(self.ptr, offset: Self.layout.labelsOffset) }
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
  /// Property: `PyCode.kwOnlyArgCount`.
  internal var kwOnlyArgCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.kwOnlyArgCountOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyCode(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyCode(ptr: ptr)
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
    zelf.kwOnlyArgCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyCode? {
    return py.cast.asCode(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `code` type.
  public func newCode(
    _ py: Py,
    type: PyType,
    code: CodeObject
  ) -> PyCode {
    let typeLayout = PyCode.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyCode(ptr: ptr)

    result.initialize(
      py,
      type: type,
      code: code
    )

    return result
  }
}

// MARK: - PyComplex

extension PyComplex {

  /// Name of the type in Python.
  public static let pythonTypeName = "complex"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyComplex` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let realOffset: Int
    internal let imagOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Double.self), // PyComplex.real
          PyMemory.FieldLayout(from: Double.self) // PyComplex.imag
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

  /// Property: `PyComplex.real`.
  internal var realPtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.realOffset) }
  /// Property: `PyComplex.imag`.
  internal var imagPtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.imagOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyComplex(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyComplex(ptr: ptr)
    zelf.realPtr.deinitialize()
    zelf.imagPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyComplex? {
    return py.cast.asComplex(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `complex` type.
  public func newComplex(
    _ py: Py,
    type: PyType,
    real: Double,
    imag: Double
  ) -> PyComplex {
    let typeLayout = PyComplex.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyComplex(ptr: ptr)

    result.initialize(
      py,
      type: type,
      real: real,
      imag: imag
    )

    return result
  }
}

// MARK: - PyDict

extension PyDict {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDict` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.OrderedDictionary.self) // PyDict.elements
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

  /// Property: `PyDict.elements`.
  internal var elementsPtr: Ptr<PyDict.OrderedDictionary> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDict(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDict(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDict? {
    return py.cast.asDict(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict` type.
  public func newDict(
    _ py: Py,
    type: PyType,
    elements: PyDict.OrderedDictionary
  ) -> PyDict {
    let typeLayout = PyDict.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDict(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PyDictItemIterator

extension PyDictItemIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_itemiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictItemIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self), // PyDictItemIterator.dict
          PyMemory.FieldLayout(from: Int.self), // PyDictItemIterator.index
          PyMemory.FieldLayout(from: Int.self) // PyDictItemIterator.initialCount
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

  /// Property: `PyDictItemIterator.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  /// Property: `PyDictItemIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PyDictItemIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDictItemIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDictItemIterator(ptr: ptr)
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictItemIterator? {
    return py.cast.asDictItemIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_itemiterator` type.
  public func newDictItemIterator(
    _ py: Py,
    type: PyType,
    dict: PyDict
  ) -> PyDictItemIterator {
    let typeLayout = PyDictItemIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictItemIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      dict: dict
    )

    return result
  }
}

// MARK: - PyDictItems

extension PyDictItems {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_items"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictItems` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self) // PyDictItems.dict
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

  /// Property: `PyDictItems.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDictItems(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDictItems(ptr: ptr)
    zelf.dictPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictItems? {
    return py.cast.asDictItems(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_items` type.
  public func newDictItems(
    _ py: Py,
    type: PyType,
    dict: PyDict
  ) -> PyDictItems {
    let typeLayout = PyDictItems.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictItems(ptr: ptr)

    result.initialize(
      py,
      type: type,
      dict: dict
    )

    return result
  }
}

// MARK: - PyDictKeyIterator

extension PyDictKeyIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_keyiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictKeyIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self), // PyDictKeyIterator.dict
          PyMemory.FieldLayout(from: Int.self), // PyDictKeyIterator.index
          PyMemory.FieldLayout(from: Int.self) // PyDictKeyIterator.initialCount
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

  /// Property: `PyDictKeyIterator.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  /// Property: `PyDictKeyIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PyDictKeyIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDictKeyIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDictKeyIterator(ptr: ptr)
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictKeyIterator? {
    return py.cast.asDictKeyIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_keyiterator` type.
  public func newDictKeyIterator(
    _ py: Py,
    type: PyType,
    dict: PyDict
  ) -> PyDictKeyIterator {
    let typeLayout = PyDictKeyIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictKeyIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      dict: dict
    )

    return result
  }
}

// MARK: - PyDictKeys

extension PyDictKeys {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_keys"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictKeys` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self) // PyDictKeys.dict
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

  /// Property: `PyDictKeys.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDictKeys(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDictKeys(ptr: ptr)
    zelf.dictPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictKeys? {
    return py.cast.asDictKeys(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_keys` type.
  public func newDictKeys(
    _ py: Py,
    type: PyType,
    dict: PyDict
  ) -> PyDictKeys {
    let typeLayout = PyDictKeys.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictKeys(ptr: ptr)

    result.initialize(
      py,
      type: type,
      dict: dict
    )

    return result
  }
}

// MARK: - PyDictValueIterator

extension PyDictValueIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_valueiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictValueIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self), // PyDictValueIterator.dict
          PyMemory.FieldLayout(from: Int.self), // PyDictValueIterator.index
          PyMemory.FieldLayout(from: Int.self) // PyDictValueIterator.initialCount
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

  /// Property: `PyDictValueIterator.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  /// Property: `PyDictValueIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PyDictValueIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDictValueIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDictValueIterator(ptr: ptr)
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictValueIterator? {
    return py.cast.asDictValueIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_valueiterator` type.
  public func newDictValueIterator(
    _ py: Py,
    type: PyType,
    dict: PyDict
  ) -> PyDictValueIterator {
    let typeLayout = PyDictValueIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictValueIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      dict: dict
    )

    return result
  }
}

// MARK: - PyDictValues

extension PyDictValues {

  /// Name of the type in Python.
  public static let pythonTypeName = "dict_values"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDictValues` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self) // PyDictValues.dict
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

  /// Property: `PyDictValues.dict`.
  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDictValues(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyDictValues(ptr: ptr)
    zelf.dictPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDictValues? {
    return py.cast.asDictValues(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `dict_values` type.
  public func newDictValues(
    _ py: Py,
    type: PyType,
    dict: PyDict
  ) -> PyDictValues {
    let typeLayout = PyDictValues.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictValues(ptr: ptr)

    result.initialize(
      py,
      type: type,
      dict: dict
    )

    return result
  }
}

// MARK: - PyEllipsis

extension PyEllipsis {

  /// Name of the type in Python.
  public static let pythonTypeName = "ellipsis"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyEllipsis` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyEllipsis(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyEllipsis? {
    return py.cast.asEllipsis(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ellipsis` type.
  public func newEllipsis(
    _ py: Py,
    type: PyType
  ) -> PyEllipsis {
    let typeLayout = PyEllipsis.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyEllipsis(ptr: ptr)

    result.initialize(
      py,
      type: type
    )

    return result
  }
}

// MARK: - PyEnumerate

extension PyEnumerate {

  /// Name of the type in Python.
  public static let pythonTypeName = "enumerate"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyEnumerate` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let iteratorOffset: Int
    internal let nextIndexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PyEnumerate.iterator
          PyMemory.FieldLayout(from: BigInt.self) // PyEnumerate.nextIndex
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

  /// Property: `PyEnumerate.iterator`.
  internal var iteratorPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.iteratorOffset) }
  /// Property: `PyEnumerate.nextIndex`.
  internal var nextIndexPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.nextIndexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyEnumerate(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyEnumerate(ptr: ptr)
    zelf.iteratorPtr.deinitialize()
    zelf.nextIndexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyEnumerate? {
    return py.cast.asEnumerate(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `enumerate` type.
  public func newEnumerate(
    _ py: Py,
    type: PyType,
    iterator: PyObject,
    initialIndex: BigInt
  ) -> PyEnumerate {
    let typeLayout = PyEnumerate.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyEnumerate(ptr: ptr)

    result.initialize(
      py,
      type: type,
      iterator: iterator,
      initialIndex: initialIndex
    )

    return result
  }
}

// MARK: - PyFilter

extension PyFilter {

  /// Name of the type in Python.
  public static let pythonTypeName = "filter"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFilter` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let fnOffset: Int
    internal let iteratorOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PyFilter.fn
          PyMemory.FieldLayout(from: PyObject.self) // PyFilter.iterator
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

  /// Property: `PyFilter.fn`.
  internal var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.fnOffset) }
  /// Property: `PyFilter.iterator`.
  internal var iteratorPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.iteratorOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFilter(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyFilter(ptr: ptr)
    zelf.fnPtr.deinitialize()
    zelf.iteratorPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFilter? {
    return py.cast.asFilter(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `filter` type.
  public func newFilter(
    _ py: Py,
    type: PyType,
    fn: PyObject,
    iterator: PyObject
  ) -> PyFilter {
    let typeLayout = PyFilter.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFilter(ptr: ptr)

    result.initialize(
      py,
      type: type,
      fn: fn,
      iterator: iterator
    )

    return result
  }
}

// MARK: - PyFloat

extension PyFloat {

  /// Name of the type in Python.
  public static let pythonTypeName = "float"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFloat` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Double.self) // PyFloat.value
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

  /// Property: `PyFloat.value`.
  internal var valuePtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFloat(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyFloat(ptr: ptr)
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFloat? {
    return py.cast.asFloat(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `float` type.
  public func newFloat(
    _ py: Py,
    type: PyType,
    value: Double
  ) -> PyFloat {
    let typeLayout = PyFloat.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFloat(ptr: ptr)

    result.initialize(
      py,
      type: type,
      value: value
    )

    return result
  }
}

// MARK: - PyFrame

extension PyFrame {

  /// Name of the type in Python.
  public static let pythonTypeName = "frame"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFrame` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let codeOffset: Int
    internal let parentOffset: Int
    internal let stackOffset: Int
    internal let blocksOffset: Int
    internal let localsOffset: Int
    internal let globalsOffset: Int
    internal let builtinsOffset: Int
    internal let fastLocalsOffset: Int
    internal let cellVariablesOffset: Int
    internal let freeVariablesOffset: Int
    internal let currentInstructionIndexOffset: Int
    internal let nextInstructionIndexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyCode.self), // PyFrame.code
          PyMemory.FieldLayout(from: PyFrame?.self), // PyFrame.parent
          PyMemory.FieldLayout(from: ObjectStack.self), // PyFrame.stack
          PyMemory.FieldLayout(from: BlockStack.self), // PyFrame.blocks
          PyMemory.FieldLayout(from: PyDict.self), // PyFrame.locals
          PyMemory.FieldLayout(from: PyDict.self), // PyFrame.globals
          PyMemory.FieldLayout(from: PyDict.self), // PyFrame.builtins
          PyMemory.FieldLayout(from: [PyObject?].self), // PyFrame.fastLocals
          PyMemory.FieldLayout(from: [PyCell].self), // PyFrame.cellVariables
          PyMemory.FieldLayout(from: [PyCell].self), // PyFrame.freeVariables
          PyMemory.FieldLayout(from: Int?.self), // PyFrame.currentInstructionIndex
          PyMemory.FieldLayout(from: Int.self) // PyFrame.nextInstructionIndex
        ]
      )

      assert(layout.offsets.count == 12)
      self.codeOffset = layout.offsets[0]
      self.parentOffset = layout.offsets[1]
      self.stackOffset = layout.offsets[2]
      self.blocksOffset = layout.offsets[3]
      self.localsOffset = layout.offsets[4]
      self.globalsOffset = layout.offsets[5]
      self.builtinsOffset = layout.offsets[6]
      self.fastLocalsOffset = layout.offsets[7]
      self.cellVariablesOffset = layout.offsets[8]
      self.freeVariablesOffset = layout.offsets[9]
      self.currentInstructionIndexOffset = layout.offsets[10]
      self.nextInstructionIndexOffset = layout.offsets[11]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property: `PyFrame.code`.
  internal var codePtr: Ptr<PyCode> { Ptr(self.ptr, offset: Self.layout.codeOffset) }
  /// Property: `PyFrame.parent`.
  internal var parentPtr: Ptr<PyFrame?> { Ptr(self.ptr, offset: Self.layout.parentOffset) }
  /// Property: `PyFrame.stack`.
  internal var stackPtr: Ptr<ObjectStack> { Ptr(self.ptr, offset: Self.layout.stackOffset) }
  /// Property: `PyFrame.blocks`.
  internal var blocksPtr: Ptr<BlockStack> { Ptr(self.ptr, offset: Self.layout.blocksOffset) }
  /// Property: `PyFrame.locals`.
  internal var localsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.localsOffset) }
  /// Property: `PyFrame.globals`.
  internal var globalsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.globalsOffset) }
  /// Property: `PyFrame.builtins`.
  internal var builtinsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.builtinsOffset) }
  /// Property: `PyFrame.fastLocals`.
  internal var fastLocalsPtr: Ptr<[PyObject?]> { Ptr(self.ptr, offset: Self.layout.fastLocalsOffset) }
  /// Property: `PyFrame.cellVariables`.
  internal var cellVariablesPtr: Ptr<[PyCell]> { Ptr(self.ptr, offset: Self.layout.cellVariablesOffset) }
  /// Property: `PyFrame.freeVariables`.
  internal var freeVariablesPtr: Ptr<[PyCell]> { Ptr(self.ptr, offset: Self.layout.freeVariablesOffset) }
  /// Property: `PyFrame.currentInstructionIndex`.
  internal var currentInstructionIndexPtr: Ptr<Int?> { Ptr(self.ptr, offset: Self.layout.currentInstructionIndexOffset) }
  /// Property: `PyFrame.nextInstructionIndex`.
  internal var nextInstructionIndexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.nextInstructionIndexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFrame(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyFrame(ptr: ptr)
    zelf.codePtr.deinitialize()
    zelf.parentPtr.deinitialize()
    zelf.stackPtr.deinitialize()
    zelf.blocksPtr.deinitialize()
    zelf.localsPtr.deinitialize()
    zelf.globalsPtr.deinitialize()
    zelf.builtinsPtr.deinitialize()
    zelf.fastLocalsPtr.deinitialize()
    zelf.cellVariablesPtr.deinitialize()
    zelf.freeVariablesPtr.deinitialize()
    zelf.currentInstructionIndexPtr.deinitialize()
    zelf.nextInstructionIndexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFrame? {
    return py.cast.asFrame(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `frame` type.
  public func newFrame(
    _ py: Py,
    type: PyType,
    code: PyCode,
    locals: PyDict,
    globals: PyDict,
    parent: PyFrame?
  ) -> PyFrame {
    let typeLayout = PyFrame.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFrame(ptr: ptr)

    result.initialize(
      py,
      type: type,
      code: code,
      locals: locals,
      globals: globals,
      parent: parent
    )

    return result
  }
}

// MARK: - PyFrozenSet

extension PyFrozenSet {

  /// Name of the type in Python.
  public static let pythonTypeName = "frozenset"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFrozenSet` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: OrderedSet.self) // PyFrozenSet.elements
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

  /// Property: `PyFrozenSet.elements`.
  internal var elementsPtr: Ptr<OrderedSet> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFrozenSet(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyFrozenSet(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFrozenSet? {
    return py.cast.asFrozenSet(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `frozenset` type.
  public func newFrozenSet(
    _ py: Py,
    type: PyType,
    elements: OrderedSet
  ) -> PyFrozenSet {
    let typeLayout = PyFrozenSet.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFrozenSet(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PyFunction

extension PyFunction {

  /// Name of the type in Python.
  public static let pythonTypeName = "function"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFunction` fields
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
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyString.self), // PyFunction.name
          PyMemory.FieldLayout(from: PyString.self), // PyFunction.qualname
          PyMemory.FieldLayout(from: PyString?.self), // PyFunction.doc
          PyMemory.FieldLayout(from: PyObject.self), // PyFunction.module
          PyMemory.FieldLayout(from: PyCode.self), // PyFunction.code
          PyMemory.FieldLayout(from: PyDict.self), // PyFunction.globals
          PyMemory.FieldLayout(from: PyTuple?.self), // PyFunction.defaults
          PyMemory.FieldLayout(from: PyDict?.self), // PyFunction.kwDefaults
          PyMemory.FieldLayout(from: PyTuple?.self), // PyFunction.closure
          PyMemory.FieldLayout(from: PyDict?.self) // PyFunction.annotations
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

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFunction(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyFunction(ptr: ptr)
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
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFunction? {
    return py.cast.asFunction(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `function` type.
  public func newFunction(
    _ py: Py,
    type: PyType,
    qualname: PyString?,
    module: PyObject,
    code: PyCode,
    globals: PyDict
  ) -> PyFunction {
    let typeLayout = PyFunction.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFunction(ptr: ptr)

    result.initialize(
      py,
      type: type,
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )

    return result
  }
}

// MARK: - PyInt

extension PyInt {

  /// Name of the type in Python.
  public static let pythonTypeName = "int"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyInt` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: BigInt.self) // PyInt.value
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

  /// Property: `PyInt.value`.
  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyInt(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyInt(ptr: ptr)
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyInt? {
    return py.cast.asInt(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `int` type.
  public func newInt(
    _ py: Py,
    type: PyType,
    value: BigInt
  ) -> PyInt {
    let typeLayout = PyInt.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyInt(ptr: ptr)

    result.initialize(
      py,
      type: type,
      value: value
    )

    return result
  }
}

// MARK: - PyIterator

extension PyIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PyIterator.sequence
          PyMemory.FieldLayout(from: Int.self) // PyIterator.index
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

  /// Property: `PyIterator.sequence`.
  internal var sequencePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sequenceOffset) }
  /// Property: `PyIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyIterator(ptr: ptr)
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIterator? {
    return py.cast.asIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `iterator` type.
  public func newIterator(
    _ py: Py,
    type: PyType,
    sequence: PyObject
  ) -> PyIterator {
    let typeLayout = PyIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      sequence: sequence
    )

    return result
  }
}

// MARK: - PyList

extension PyList {

  /// Name of the type in Python.
  public static let pythonTypeName = "list"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyList` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: [PyObject].self) // PyList.elements
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

  /// Property: `PyList.elements`.
  internal var elementsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyList(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyList(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyList? {
    return py.cast.asList(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `list` type.
  public func newList(
    _ py: Py,
    type: PyType,
    elements: [PyObject]
  ) -> PyList {
    let typeLayout = PyList.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyList(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PyListIterator

extension PyListIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "list_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyListIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyList.self), // PyListIterator.list
          PyMemory.FieldLayout(from: Int.self) // PyListIterator.index
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

  /// Property: `PyListIterator.list`.
  internal var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Self.layout.listOffset) }
  /// Property: `PyListIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyListIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyListIterator(ptr: ptr)
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyListIterator? {
    return py.cast.asListIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `list_iterator` type.
  public func newListIterator(
    _ py: Py,
    type: PyType,
    list: PyList
  ) -> PyListIterator {
    let typeLayout = PyListIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyListIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      list: list
    )

    return result
  }
}

// MARK: - PyListReverseIterator

extension PyListReverseIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "list_reverseiterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyListReverseIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyList.self), // PyListReverseIterator.list
          PyMemory.FieldLayout(from: Int.self) // PyListReverseIterator.index
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

  /// Property: `PyListReverseIterator.list`.
  internal var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Self.layout.listOffset) }
  /// Property: `PyListReverseIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyListReverseIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyListReverseIterator(ptr: ptr)
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyListReverseIterator? {
    return py.cast.asListReverseIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `list_reverseiterator` type.
  public func newListReverseIterator(
    _ py: Py,
    type: PyType,
    list: PyList
  ) -> PyListReverseIterator {
    let typeLayout = PyListReverseIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyListReverseIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      list: list
    )

    return result
  }
}

// MARK: - PyMap

extension PyMap {

  /// Name of the type in Python.
  public static let pythonTypeName = "map"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyMap` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let fnOffset: Int
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PyMap.fn
          PyMemory.FieldLayout(from: [PyObject].self) // PyMap.iterators
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

  /// Property: `PyMap.fn`.
  internal var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.fnOffset) }
  /// Property: `PyMap.iterators`.
  internal var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.iteratorsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyMap(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyMap(ptr: ptr)
    zelf.fnPtr.deinitialize()
    zelf.iteratorsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyMap? {
    return py.cast.asMap(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `map` type.
  public func newMap(
    _ py: Py,
    type: PyType,
    fn: PyObject,
    iterators: [PyObject]
  ) -> PyMap {
    let typeLayout = PyMap.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyMap(ptr: ptr)

    result.initialize(
      py,
      type: type,
      fn: fn,
      iterators: iterators
    )

    return result
  }
}

// MARK: - PyMethod

extension PyMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "method"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyMethod` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyFunction.self), // PyMethod.function
          PyMemory.FieldLayout(from: PyObject.self) // PyMethod.object
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

  /// Property: `PyMethod.function`.
  internal var functionPtr: Ptr<PyFunction> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  /// Property: `PyMethod.object`.
  internal var objectPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.objectOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyMethod(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyMethod(ptr: ptr)
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyMethod? {
    return py.cast.asMethod(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `method` type.
  public func newMethod(
    _ py: Py,
    type: PyType,
    function: PyFunction,
    object: PyObject
  ) -> PyMethod {
    let typeLayout = PyMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyMethod(ptr: ptr)

    result.initialize(
      py,
      type: type,
      function: function,
      object: object
    )

    return result
  }
}

// MARK: - PyModule

extension PyModule {

  /// Name of the type in Python.
  public static let pythonTypeName = "module"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyModule` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyModule(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyModule? {
    return py.cast.asModule(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `module` type.
  public func newModule(
    _ py: Py,
    type: PyType,
    name: PyObject?,
    doc: PyObject?,
    __dict__: PyDict? = nil
  ) -> PyModule {
    let typeLayout = PyModule.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyModule(ptr: ptr)

    result.initialize(
      py,
      type: type,
      name: name,
      doc: doc,
      __dict__: __dict__
    )

    return result
  }
}

// MARK: - PyNamespace

extension PyNamespace {

  /// Name of the type in Python.
  public static let pythonTypeName = "SimpleNamespace"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyNamespace` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyNamespace(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNamespace? {
    return py.cast.asNamespace(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SimpleNamespace` type.
  public func newNamespace(
    _ py: Py,
    type: PyType,
    __dict__: PyDict?
  ) -> PyNamespace {
    let typeLayout = PyNamespace.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNamespace(ptr: ptr)

    result.initialize(
      py,
      type: type,
      __dict__: __dict__
    )

    return result
  }
}

// MARK: - PyNone

extension PyNone {

  /// Name of the type in Python.
  public static let pythonTypeName = "NoneType"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyNone` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyNone(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNone? {
    return py.cast.asNone(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NoneType` type.
  public func newNone(
    _ py: Py,
    type: PyType
  ) -> PyNone {
    let typeLayout = PyNone.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNone(ptr: ptr)

    result.initialize(
      py,
      type: type
    )

    return result
  }
}

// MARK: - PyNotImplemented

extension PyNotImplemented {

  /// Name of the type in Python.
  public static let pythonTypeName = "NotImplementedType"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyNotImplemented` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyNotImplemented(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNotImplemented? {
    return py.cast.asNotImplemented(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NotImplementedType` type.
  public func newNotImplemented(
    _ py: Py,
    type: PyType
  ) -> PyNotImplemented {
    let typeLayout = PyNotImplemented.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNotImplemented(ptr: ptr)

    result.initialize(
      py,
      type: type
    )

    return result
  }
}

// MARK: - PyObject

extension PyObject {

  /// Name of the type in Python.
  public static let pythonTypeName = "object"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyObject` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: 0,
        initialAlignment: 0,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyObject(ptr: ptr).beforeDeinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `object` type.
  public func newObject(
    _ py: Py,
    type: PyType,
    __dict__: PyDict? = nil
  ) -> PyObject {
    let typeLayout = PyObject.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyObject(ptr: ptr)

    result.initialize(
      py,
      type: type,
      __dict__: __dict__
    )

    return result
  }
}

// MARK: - PyProperty

extension PyProperty {

  /// Name of the type in Python.
  public static let pythonTypeName = "property"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyProperty` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let _getOffset: Int
    internal let _setOffset: Int
    internal let _delOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self), // PyProperty._get
          PyMemory.FieldLayout(from: PyObject?.self), // PyProperty._set
          PyMemory.FieldLayout(from: PyObject?.self), // PyProperty._del
          PyMemory.FieldLayout(from: PyObject?.self) // PyProperty.doc
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

  /// Property: `PyProperty._get`.
  internal var _getPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._getOffset) }
  /// Property: `PyProperty._set`.
  internal var _setPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._setOffset) }
  /// Property: `PyProperty._del`.
  internal var _delPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._delOffset) }
  /// Property: `PyProperty.doc`.
  internal var docPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyProperty(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyProperty(ptr: ptr)
    zelf._getPtr.deinitialize()
    zelf._setPtr.deinitialize()
    zelf._delPtr.deinitialize()
    zelf.docPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyProperty? {
    return py.cast.asProperty(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `property` type.
  public func newProperty(
    _ py: Py,
    type: PyType,
    get: PyObject?,
    set: PyObject?,
    del: PyObject?,
    doc: PyObject?
  ) -> PyProperty {
    let typeLayout = PyProperty.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyProperty(ptr: ptr)

    result.initialize(
      py,
      type: type,
      get: get,
      set: set,
      del: del,
      doc: doc
    )

    return result
  }
}

// MARK: - PyRange

extension PyRange {

  /// Name of the type in Python.
  public static let pythonTypeName = "range"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRange` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyInt.self), // PyRange.start
          PyMemory.FieldLayout(from: PyInt.self), // PyRange.stop
          PyMemory.FieldLayout(from: PyInt.self), // PyRange.step
          PyMemory.FieldLayout(from: PyInt.self) // PyRange.length
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

  /// Property: `PyRange.start`.
  internal var startPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  /// Property: `PyRange.stop`.
  internal var stopPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.stopOffset) }
  /// Property: `PyRange.step`.
  internal var stepPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.stepOffset) }
  /// Property: `PyRange.length`.
  internal var lengthPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lengthOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyRange(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyRange(ptr: ptr)
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()
    zelf.lengthPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRange? {
    return py.cast.asRange(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `range` type.
  public func newRange(
    _ py: Py,
    type: PyType,
    start: PyInt,
    stop: PyInt,
    step: PyInt?
  ) -> PyRange {
    let typeLayout = PyRange.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRange(ptr: ptr)

    result.initialize(
      py,
      type: type,
      start: start,
      stop: stop,
      step: step
    )

    return result
  }
}

// MARK: - PyRangeIterator

extension PyRangeIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "range_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRangeIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: BigInt.self), // PyRangeIterator.start
          PyMemory.FieldLayout(from: BigInt.self), // PyRangeIterator.step
          PyMemory.FieldLayout(from: BigInt.self), // PyRangeIterator.length
          PyMemory.FieldLayout(from: BigInt.self) // PyRangeIterator.index
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

  /// Property: `PyRangeIterator.start`.
  internal var startPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  /// Property: `PyRangeIterator.step`.
  internal var stepPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.stepOffset) }
  /// Property: `PyRangeIterator.length`.
  internal var lengthPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.lengthOffset) }
  /// Property: `PyRangeIterator.index`.
  internal var indexPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyRangeIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyRangeIterator(ptr: ptr)
    zelf.startPtr.deinitialize()
    zelf.stepPtr.deinitialize()
    zelf.lengthPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRangeIterator? {
    return py.cast.asRangeIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `range_iterator` type.
  public func newRangeIterator(
    _ py: Py,
    type: PyType,
    start: BigInt,
    step: BigInt,
    length: BigInt
  ) -> PyRangeIterator {
    let typeLayout = PyRangeIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRangeIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      start: start,
      step: step,
      length: length
    )

    return result
  }
}

// MARK: - PyReversed

extension PyReversed {

  /// Name of the type in Python.
  public static let pythonTypeName = "reversed"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyReversed` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PyReversed.sequence
          PyMemory.FieldLayout(from: Int.self) // PyReversed.index
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

  /// Property: `PyReversed.sequence`.
  internal var sequencePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sequenceOffset) }
  /// Property: `PyReversed.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyReversed(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyReversed(ptr: ptr)
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyReversed? {
    return py.cast.asReversed(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `reversed` type.
  public func newReversed(
    _ py: Py,
    type: PyType,
    sequence: PyObject,
    count: Int
  ) -> PyReversed {
    let typeLayout = PyReversed.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyReversed(ptr: ptr)

    result.initialize(
      py,
      type: type,
      sequence: sequence,
      count: count
    )

    return result
  }
}

// MARK: - PySet

extension PySet {

  /// Name of the type in Python.
  public static let pythonTypeName = "set"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySet` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: OrderedSet.self) // PySet.elements
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

  /// Property: `PySet.elements`.
  internal var elementsPtr: Ptr<OrderedSet> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySet(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PySet(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySet? {
    return py.cast.asSet(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `set` type.
  public func newSet(
    _ py: Py,
    type: PyType,
    elements: OrderedSet
  ) -> PySet {
    let typeLayout = PySet.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySet(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PySetIterator

extension PySetIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "set_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySetIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let setOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyAnySet.self), // PySetIterator.set
          PyMemory.FieldLayout(from: Int.self), // PySetIterator.index
          PyMemory.FieldLayout(from: Int.self) // PySetIterator.initialCount
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

  /// Property: `PySetIterator.set`.
  internal var setPtr: Ptr<PyAnySet> { Ptr(self.ptr, offset: Self.layout.setOffset) }
  /// Property: `PySetIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  /// Property: `PySetIterator.initialCount`.
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySetIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PySetIterator(ptr: ptr)
    zelf.setPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySetIterator? {
    return py.cast.asSetIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `set_iterator` type.
  public func newSetIterator(
    _ py: Py,
    type: PyType,
    set: PySet
  ) -> PySetIterator {
    let typeLayout = PySetIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySetIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      set: set
    )

    return result
  }

  /// Allocate a new instance of `set_iterator` type.
  public func newSetIterator(
    _ py: Py,
    type: PyType,
    frozenSet: PyFrozenSet
  ) -> PySetIterator {
    let typeLayout = PySetIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySetIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      frozenSet: frozenSet
    )

    return result
  }
}

// MARK: - PySlice

extension PySlice {

  /// Name of the type in Python.
  public static let pythonTypeName = "slice"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySlice` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // PySlice.start
          PyMemory.FieldLayout(from: PyObject.self), // PySlice.stop
          PyMemory.FieldLayout(from: PyObject.self) // PySlice.step
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

  /// Property: `PySlice.start`.
  internal var startPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  /// Property: `PySlice.stop`.
  internal var stopPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.stopOffset) }
  /// Property: `PySlice.step`.
  internal var stepPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.stepOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySlice(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PySlice(ptr: ptr)
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySlice? {
    return py.cast.asSlice(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `slice` type.
  public func newSlice(
    _ py: Py,
    type: PyType,
    start: PyObject,
    stop: PyObject,
    step: PyObject
  ) -> PySlice {
    let typeLayout = PySlice.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySlice(ptr: ptr)

    result.initialize(
      py,
      type: type,
      start: start,
      stop: stop,
      step: step
    )

    return result
  }
}

// MARK: - PyStaticMethod

extension PyStaticMethod {

  /// Name of the type in Python.
  public static let pythonTypeName = "staticmethod"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStaticMethod` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // PyStaticMethod.callable
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

  /// Property: `PyStaticMethod.callable`.
  internal var callablePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.callableOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyStaticMethod(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyStaticMethod(ptr: ptr)
    zelf.callablePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStaticMethod? {
    return py.cast.asStaticMethod(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `staticmethod` type.
  public func newStaticMethod(
    _ py: Py,
    type: PyType,
    callable: PyObject?
  ) -> PyStaticMethod {
    let typeLayout = PyStaticMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStaticMethod(ptr: ptr)

    result.initialize(
      py,
      type: type,
      callable: callable
    )

    return result
  }
}

// MARK: - PyString

extension PyString {

  /// Name of the type in Python.
  public static let pythonTypeName = "str"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyString` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let cachedCountOffset: Int
    internal let cachedHashOffset: Int
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Int.self), // PyString.cachedCount
          PyMemory.FieldLayout(from: PyHash.self), // PyString.cachedHash
          PyMemory.FieldLayout(from: String.self) // PyString.value
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

  /// Property: `PyString.cachedCount`.
  internal var cachedCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.cachedCountOffset) }
  /// Property: `PyString.cachedHash`.
  internal var cachedHashPtr: Ptr<PyHash> { Ptr(self.ptr, offset: Self.layout.cachedHashOffset) }
  /// Property: `PyString.value`.
  internal var valuePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyString(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyString(ptr: ptr)
    zelf.cachedCountPtr.deinitialize()
    zelf.cachedHashPtr.deinitialize()
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyString? {
    return py.cast.asString(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `str` type.
  public func newString(
    _ py: Py,
    type: PyType,
    value: String
  ) -> PyString {
    let typeLayout = PyString.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyString(ptr: ptr)

    result.initialize(
      py,
      type: type,
      value: value
    )

    return result
  }
}

// MARK: - PyStringIterator

extension PyStringIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "str_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStringIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let stringOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyString.self), // PyStringIterator.string
          PyMemory.FieldLayout(from: Int.self) // PyStringIterator.index
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

  /// Property: `PyStringIterator.string`.
  internal var stringPtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.stringOffset) }
  /// Property: `PyStringIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyStringIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyStringIterator(ptr: ptr)
    zelf.stringPtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStringIterator? {
    return py.cast.asStringIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `str_iterator` type.
  public func newStringIterator(
    _ py: Py,
    type: PyType,
    string: PyString
  ) -> PyStringIterator {
    let typeLayout = PyStringIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStringIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      string: string
    )

    return result
  }
}

// MARK: - PySuper

extension PySuper {

  /// Name of the type in Python.
  public static let pythonTypeName = "super"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySuper` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let thisClassOffset: Int
    internal let objectOffset: Int
    internal let objectTypeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyType?.self), // PySuper.thisClass
          PyMemory.FieldLayout(from: PyObject?.self), // PySuper.object
          PyMemory.FieldLayout(from: PyType?.self) // PySuper.objectType
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

  /// Property: `PySuper.thisClass`.
  internal var thisClassPtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.thisClassOffset) }
  /// Property: `PySuper.object`.
  internal var objectPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.objectOffset) }
  /// Property: `PySuper.objectType`.
  internal var objectTypePtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.objectTypeOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySuper(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PySuper(ptr: ptr)
    zelf.thisClassPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.objectTypePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySuper? {
    return py.cast.asSuper(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `super` type.
  public func newSuper(
    _ py: Py,
    type: PyType,
    requestedType: PyType?,
    object: PyObject?,
    objectType: PyType?
  ) -> PySuper {
    let typeLayout = PySuper.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySuper(ptr: ptr)

    result.initialize(
      py,
      type: type,
      requestedType: requestedType,
      object: object,
      objectType: objectType
    )

    return result
  }
}

// MARK: - PyTextFile

extension PyTextFile {

  /// Name of the type in Python.
  public static let pythonTypeName = "TextFile"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTextFile` fields
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
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: String?.self), // PyTextFile.name
          PyMemory.FieldLayout(from: FileDescriptorType.self), // PyTextFile.fd
          PyMemory.FieldLayout(from: FileMode.self), // PyTextFile.mode
          PyMemory.FieldLayout(from: PyString.Encoding.self), // PyTextFile.encoding
          PyMemory.FieldLayout(from: PyString.ErrorHandling.self) // PyTextFile.errorHandling
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

  /// Property: `PyTextFile.name`.
  internal var namePtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  /// Property: `PyTextFile.fd`.
  internal var fdPtr: Ptr<FileDescriptorType> { Ptr(self.ptr, offset: Self.layout.fdOffset) }
  /// Property: `PyTextFile.mode`.
  internal var modePtr: Ptr<FileMode> { Ptr(self.ptr, offset: Self.layout.modeOffset) }
  /// Property: `PyTextFile.encoding`.
  internal var encodingPtr: Ptr<PyString.Encoding> { Ptr(self.ptr, offset: Self.layout.encodingOffset) }
  /// Property: `PyTextFile.errorHandling`.
  internal var errorHandlingPtr: Ptr<PyString.ErrorHandling> { Ptr(self.ptr, offset: Self.layout.errorHandlingOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTextFile(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyTextFile(ptr: ptr)
    zelf.namePtr.deinitialize()
    zelf.fdPtr.deinitialize()
    zelf.modePtr.deinitialize()
    zelf.encodingPtr.deinitialize()
    zelf.errorHandlingPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTextFile? {
    return py.cast.asTextFile(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TextFile` type.
  public func newTextFile(
    _ py: Py,
    type: PyType,
    name: String?,
    fd: FileDescriptorType,
    mode: FileMode,
    encoding: PyString.Encoding,
    errorHandling: PyString.ErrorHandling,
    closeOnDealloc: Bool
  ) -> PyTextFile {
    let typeLayout = PyTextFile.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTextFile(ptr: ptr)

    result.initialize(
      py,
      type: type,
      name: name,
      fd: fd,
      mode: mode,
      encoding: encoding,
      errorHandling: errorHandling,
      closeOnDealloc: closeOnDealloc
    )

    return result
  }
}

// MARK: - PyTraceback

extension PyTraceback {

  /// Name of the type in Python.
  public static let pythonTypeName = "traceback"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTraceback` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let nextOffset: Int
    internal let frameOffset: Int
    internal let lastInstructionOffset: Int
    internal let lineNoOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyTraceback?.self), // PyTraceback.next
          PyMemory.FieldLayout(from: PyFrame.self), // PyTraceback.frame
          PyMemory.FieldLayout(from: PyInt.self), // PyTraceback.lastInstruction
          PyMemory.FieldLayout(from: PyInt.self) // PyTraceback.lineNo
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

  /// Property: `PyTraceback.next`.
  internal var nextPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: Self.layout.nextOffset) }
  /// Property: `PyTraceback.frame`.
  internal var framePtr: Ptr<PyFrame> { Ptr(self.ptr, offset: Self.layout.frameOffset) }
  /// Property: `PyTraceback.lastInstruction`.
  internal var lastInstructionPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lastInstructionOffset) }
  /// Property: `PyTraceback.lineNo`.
  internal var lineNoPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lineNoOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTraceback(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyTraceback(ptr: ptr)
    zelf.nextPtr.deinitialize()
    zelf.framePtr.deinitialize()
    zelf.lastInstructionPtr.deinitialize()
    zelf.lineNoPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTraceback? {
    return py.cast.asTraceback(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `traceback` type.
  public func newTraceback(
    _ py: Py,
    type: PyType,
    next: PyTraceback?,
    frame: PyFrame,
    lastInstruction: PyInt,
    lineNo: PyInt
  ) -> PyTraceback {
    let typeLayout = PyTraceback.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTraceback(ptr: ptr)

    result.initialize(
      py,
      type: type,
      next: next,
      frame: frame,
      lastInstruction: lastInstruction,
      lineNo: lineNo
    )

    return result
  }
}

// MARK: - PyTuple

extension PyTuple {

  /// Name of the type in Python.
  public static let pythonTypeName = "tuple"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTuple` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: [PyObject].self) // PyTuple.elements
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

  /// Property: `PyTuple.elements`.
  internal var elementsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTuple(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyTuple(ptr: ptr)
    zelf.elementsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTuple? {
    return py.cast.asTuple(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `tuple` type.
  public func newTuple(
    _ py: Py,
    type: PyType,
    elements: [PyObject]
  ) -> PyTuple {
    let typeLayout = PyTuple.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTuple(ptr: ptr)

    result.initialize(
      py,
      type: type,
      elements: elements
    )

    return result
  }
}

// MARK: - PyTupleIterator

extension PyTupleIterator {

  /// Name of the type in Python.
  public static let pythonTypeName = "tuple_iterator"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTupleIterator` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let tupleOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyTuple.self), // PyTupleIterator.tuple
          PyMemory.FieldLayout(from: Int.self) // PyTupleIterator.index
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

  /// Property: `PyTupleIterator.tuple`.
  internal var tuplePtr: Ptr<PyTuple> { Ptr(self.ptr, offset: Self.layout.tupleOffset) }
  /// Property: `PyTupleIterator.index`.
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTupleIterator(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyTupleIterator(ptr: ptr)
    zelf.tuplePtr.deinitialize()
    zelf.indexPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTupleIterator? {
    return py.cast.asTupleIterator(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `tuple_iterator` type.
  public func newTupleIterator(
    _ py: Py,
    type: PyType,
    tuple: PyTuple
  ) -> PyTupleIterator {
    let typeLayout = PyTupleIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTupleIterator(ptr: ptr)

    result.initialize(
      py,
      type: type,
      tuple: tuple
    )

    return result
  }
}

// MARK: - PyType

extension PyType {

  /// Name of the type in Python.
  public static let pythonTypeName = "type"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyType` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let nameOffset: Int
    internal let qualnameOffset: Int
    internal let baseOffset: Int
    internal let basesOffset: Int
    internal let mroOffset: Int
    internal let subclassesOffset: Int
    internal let layoutOffset: Int
    internal let staticMethodsOffset: Int
    internal let debugFnOffset: Int
    internal let deinitializeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: String.self), // PyType.name
          PyMemory.FieldLayout(from: String.self), // PyType.qualname
          PyMemory.FieldLayout(from: PyType?.self), // PyType.base
          PyMemory.FieldLayout(from: [PyType].self), // PyType.bases
          PyMemory.FieldLayout(from: [PyType].self), // PyType.mro
          PyMemory.FieldLayout(from: [PyType].self), // PyType.subclasses
          PyMemory.FieldLayout(from: MemoryLayout.self), // PyType.layout
          PyMemory.FieldLayout(from: PyStaticCall.KnownNotOverriddenMethods.self), // PyType.staticMethods
          PyMemory.FieldLayout(from: DebugFn.self), // PyType.debugFn
          PyMemory.FieldLayout(from: DeinitializeFn.self) // PyType.deinitialize
        ]
      )

      assert(layout.offsets.count == 10)
      self.nameOffset = layout.offsets[0]
      self.qualnameOffset = layout.offsets[1]
      self.baseOffset = layout.offsets[2]
      self.basesOffset = layout.offsets[3]
      self.mroOffset = layout.offsets[4]
      self.subclassesOffset = layout.offsets[5]
      self.layoutOffset = layout.offsets[6]
      self.staticMethodsOffset = layout.offsets[7]
      self.debugFnOffset = layout.offsets[8]
      self.deinitializeOffset = layout.offsets[9]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property: `PyType.name`.
  internal var namePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  /// Property: `PyType.qualname`.
  internal var qualnamePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.qualnameOffset) }
  /// Property: `PyType.base`.
  internal var basePtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.baseOffset) }
  /// Property: `PyType.bases`.
  internal var basesPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.basesOffset) }
  /// Property: `PyType.mro`.
  internal var mroPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.mroOffset) }
  /// Property: `PyType.subclasses`.
  internal var subclassesPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.subclassesOffset) }
  /// Property: `PyType.layout`.
  internal var layoutPtr: Ptr<MemoryLayout> { Ptr(self.ptr, offset: Self.layout.layoutOffset) }
  /// Property: `PyType.staticMethods`.
  internal var staticMethodsPtr: Ptr<PyStaticCall.KnownNotOverriddenMethods> { Ptr(self.ptr, offset: Self.layout.staticMethodsOffset) }
  /// Property: `PyType.debugFn`.
  internal var debugFnPtr: Ptr<DebugFn> { Ptr(self.ptr, offset: Self.layout.debugFnOffset) }
  /// Property: `PyType.deinitialize`.
  internal var deinitializePtr: Ptr<DeinitializeFn> { Ptr(self.ptr, offset: Self.layout.deinitializeOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyType(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyType(ptr: ptr)
    zelf.namePtr.deinitialize()
    zelf.qualnamePtr.deinitialize()
    zelf.basePtr.deinitialize()
    zelf.basesPtr.deinitialize()
    zelf.mroPtr.deinitialize()
    zelf.subclassesPtr.deinitialize()
    zelf.layoutPtr.deinitialize()
    zelf.staticMethodsPtr.deinitialize()
    zelf.debugFnPtr.deinitialize()
    zelf.deinitializePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyType? {
    return py.cast.asType(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `type` type.
  public func newType(
    _ py: Py,
    type: PyType,
    name: String,
    qualname: String,
    flags: PyType.TypeFlags,
    base: PyType?,
    bases: [PyType],
    mroWithoutSelf: [PyType],
    subclasses: [PyType],
    layout: PyType.MemoryLayout,
    staticMethods: PyStaticCall.KnownNotOverriddenMethods,
    debugFn: @escaping PyType.DebugFn,
    deinitialize: @escaping PyType.DeinitializeFn
  ) -> PyType {
    let typeLayout = PyType.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyType(ptr: ptr)

    result.initialize(
      py,
      type: type,
      name: name,
      qualname: qualname,
      flags: flags,
      base: base,
      bases: bases,
      mroWithoutSelf: mroWithoutSelf,
      subclasses: subclasses,
      layout: layout,
      staticMethods: staticMethods,
      debugFn: debugFn,
      deinitialize: deinitialize
    )

    return result
  }
}

// MARK: - PyZip

extension PyZip {

  /// Name of the type in Python.
  public static let pythonTypeName = "zip"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyZip` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: [PyObject].self) // PyZip.iterators
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

  /// Property: `PyZip.iterators`.
  internal var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.iteratorsOffset) }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyZip(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyZip(ptr: ptr)
    zelf.iteratorsPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyZip? {
    return py.cast.asZip(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `zip` type.
  public func newZip(
    _ py: Py,
    type: PyType,
    iterators: [PyObject]
  ) -> PyZip {
    let typeLayout = PyZip.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyZip(ptr: ptr)

    result.initialize(
      py,
      type: type,
      iterators: iterators
    )

    return result
  }
}

// MARK: - PyArithmeticError

extension PyArithmeticError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ArithmeticError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyArithmeticError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyArithmeticError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyArithmeticError? {
    return py.cast.asArithmeticError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ArithmeticError` type.
  public func newArithmeticError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyArithmeticError {
    let typeLayout = PyArithmeticError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyArithmeticError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyAssertionError

extension PyAssertionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "AssertionError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyAssertionError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyAssertionError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyAssertionError? {
    return py.cast.asAssertionError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `AssertionError` type.
  public func newAssertionError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyAssertionError {
    let typeLayout = PyAssertionError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyAssertionError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyAttributeError

extension PyAttributeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "AttributeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyAttributeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyAttributeError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyAttributeError? {
    return py.cast.asAttributeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `AttributeError` type.
  public func newAttributeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyAttributeError {
    let typeLayout = PyAttributeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyAttributeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyBaseException

extension PyBaseException {

  /// Name of the type in Python.
  public static let pythonTypeName = "BaseException"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBaseException` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyObject.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBaseException? {
    return py.cast.asBaseException(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BaseException` type.
  public func newBaseException(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyBaseException {
    let typeLayout = PyBaseException.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBaseException(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyBlockingIOError

extension PyBlockingIOError {

  /// Name of the type in Python.
  public static let pythonTypeName = "BlockingIOError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBlockingIOError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBlockingIOError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBlockingIOError? {
    return py.cast.asBlockingIOError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BlockingIOError` type.
  public func newBlockingIOError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyBlockingIOError {
    let typeLayout = PyBlockingIOError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBlockingIOError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyBrokenPipeError

extension PyBrokenPipeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "BrokenPipeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBrokenPipeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyConnectionError.layout.size,
        initialAlignment: PyConnectionError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBrokenPipeError(ptr: ptr).beforeDeinitialize()
    PyConnectionError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyConnectionError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBrokenPipeError? {
    return py.cast.asBrokenPipeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BrokenPipeError` type.
  public func newBrokenPipeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyBrokenPipeError {
    let typeLayout = PyBrokenPipeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBrokenPipeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyBufferError

extension PyBufferError {

  /// Name of the type in Python.
  public static let pythonTypeName = "BufferError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBufferError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBufferError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBufferError? {
    return py.cast.asBufferError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BufferError` type.
  public func newBufferError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyBufferError {
    let typeLayout = PyBufferError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBufferError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyBytesWarning

extension PyBytesWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "BytesWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyBytesWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyBytesWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyBytesWarning? {
    return py.cast.asBytesWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `BytesWarning` type.
  public func newBytesWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyBytesWarning {
    let typeLayout = PyBytesWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBytesWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyChildProcessError

extension PyChildProcessError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ChildProcessError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyChildProcessError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyChildProcessError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyChildProcessError? {
    return py.cast.asChildProcessError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ChildProcessError` type.
  public func newChildProcessError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyChildProcessError {
    let typeLayout = PyChildProcessError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyChildProcessError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyConnectionAbortedError

extension PyConnectionAbortedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionAbortedError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyConnectionAbortedError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyConnectionError.layout.size,
        initialAlignment: PyConnectionError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyConnectionAbortedError(ptr: ptr).beforeDeinitialize()
    PyConnectionError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyConnectionError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionAbortedError? {
    return py.cast.asConnectionAbortedError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionAbortedError` type.
  public func newConnectionAbortedError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyConnectionAbortedError {
    let typeLayout = PyConnectionAbortedError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyConnectionAbortedError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyConnectionError

extension PyConnectionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyConnectionError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyConnectionError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionError? {
    return py.cast.asConnectionError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionError` type.
  public func newConnectionError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyConnectionError {
    let typeLayout = PyConnectionError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyConnectionError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyConnectionRefusedError

extension PyConnectionRefusedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionRefusedError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyConnectionRefusedError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyConnectionError.layout.size,
        initialAlignment: PyConnectionError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyConnectionRefusedError(ptr: ptr).beforeDeinitialize()
    PyConnectionError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyConnectionError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionRefusedError? {
    return py.cast.asConnectionRefusedError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionRefusedError` type.
  public func newConnectionRefusedError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyConnectionRefusedError {
    let typeLayout = PyConnectionRefusedError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyConnectionRefusedError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyConnectionResetError

extension PyConnectionResetError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ConnectionResetError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyConnectionResetError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyConnectionError.layout.size,
        initialAlignment: PyConnectionError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyConnectionError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyConnectionResetError(ptr: ptr).beforeDeinitialize()
    PyConnectionError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyConnectionError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyConnectionResetError? {
    return py.cast.asConnectionResetError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ConnectionResetError` type.
  public func newConnectionResetError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyConnectionResetError {
    let typeLayout = PyConnectionResetError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyConnectionResetError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyDeprecationWarning

extension PyDeprecationWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "DeprecationWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyDeprecationWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyDeprecationWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyDeprecationWarning? {
    return py.cast.asDeprecationWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `DeprecationWarning` type.
  public func newDeprecationWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyDeprecationWarning {
    let typeLayout = PyDeprecationWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDeprecationWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyEOFError

extension PyEOFError {

  /// Name of the type in Python.
  public static let pythonTypeName = "EOFError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyEOFError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyEOFError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyEOFError? {
    return py.cast.asEOFError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `EOFError` type.
  public func newEOFError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyEOFError {
    let typeLayout = PyEOFError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyEOFError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyException

extension PyException {

  /// Name of the type in Python.
  public static let pythonTypeName = "Exception"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyException` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyBaseException.layout.size,
        initialAlignment: PyBaseException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyBaseException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyException? {
    return py.cast.asException(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `Exception` type.
  public func newException(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyException {
    let typeLayout = PyException.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyException(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyFileExistsError

extension PyFileExistsError {

  /// Name of the type in Python.
  public static let pythonTypeName = "FileExistsError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFileExistsError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFileExistsError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFileExistsError? {
    return py.cast.asFileExistsError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FileExistsError` type.
  public func newFileExistsError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyFileExistsError {
    let typeLayout = PyFileExistsError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFileExistsError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyFileNotFoundError

extension PyFileNotFoundError {

  /// Name of the type in Python.
  public static let pythonTypeName = "FileNotFoundError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFileNotFoundError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFileNotFoundError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFileNotFoundError? {
    return py.cast.asFileNotFoundError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FileNotFoundError` type.
  public func newFileNotFoundError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyFileNotFoundError {
    let typeLayout = PyFileNotFoundError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFileNotFoundError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyFloatingPointError

extension PyFloatingPointError {

  /// Name of the type in Python.
  public static let pythonTypeName = "FloatingPointError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFloatingPointError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyArithmeticError.layout.size,
        initialAlignment: PyArithmeticError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyArithmeticError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFloatingPointError(ptr: ptr).beforeDeinitialize()
    PyArithmeticError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyArithmeticError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFloatingPointError? {
    return py.cast.asFloatingPointError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FloatingPointError` type.
  public func newFloatingPointError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyFloatingPointError {
    let typeLayout = PyFloatingPointError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFloatingPointError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyFutureWarning

extension PyFutureWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "FutureWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyFutureWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyFutureWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyFutureWarning? {
    return py.cast.asFutureWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `FutureWarning` type.
  public func newFutureWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyFutureWarning {
    let typeLayout = PyFutureWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFutureWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyGeneratorExit

extension PyGeneratorExit {

  /// Name of the type in Python.
  public static let pythonTypeName = "GeneratorExit"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyGeneratorExit` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyBaseException.layout.size,
        initialAlignment: PyBaseException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyGeneratorExit(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyBaseException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyGeneratorExit? {
    return py.cast.asGeneratorExit(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `GeneratorExit` type.
  public func newGeneratorExit(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyGeneratorExit {
    let typeLayout = PyGeneratorExit.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyGeneratorExit(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyImportError

extension PyImportError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ImportError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyImportError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let msgOffset: Int
    internal let moduleNameOffset: Int
    internal let modulePathOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self), // PyImportError.msg
          PyMemory.FieldLayout(from: PyObject?.self), // PyImportError.moduleName
          PyMemory.FieldLayout(from: PyObject?.self) // PyImportError.modulePath
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

  /// Property: `PyImportError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.msgOffset) }
  /// Property: `PyImportError.moduleName`.
  internal var moduleNamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleNameOffset) }
  /// Property: `PyImportError.modulePath`.
  internal var modulePathPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.modulePathOffset) }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyImportError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyImportError(ptr: ptr)
    zelf.msgPtr.deinitialize()
    zelf.moduleNamePtr.deinitialize()
    zelf.modulePathPtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyImportError? {
    return py.cast.asImportError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ImportError` type.
  public func newImportError(
    _ py: Py,
    type: PyType,
    msg: PyObject?,
    moduleName: PyObject?,
    modulePath: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyImportError {
    let typeLayout = PyImportError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyImportError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      msg: msg,
      moduleName: moduleName,
      modulePath: modulePath,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `ImportError` type.
  public func newImportError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyImportError {
    let typeLayout = PyImportError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyImportError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyImportWarning

extension PyImportWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "ImportWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyImportWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyImportWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyImportWarning? {
    return py.cast.asImportWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ImportWarning` type.
  public func newImportWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyImportWarning {
    let typeLayout = PyImportWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyImportWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyIndentationError

extension PyIndentationError {

  /// Name of the type in Python.
  public static let pythonTypeName = "IndentationError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyIndentationError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PySyntaxError.layout.size,
        initialAlignment: PySyntaxError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

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
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
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
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PySyntaxError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyIndentationError(ptr: ptr).beforeDeinitialize()
    PySyntaxError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PySyntaxError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIndentationError? {
    return py.cast.asIndentationError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `IndentationError` type.
  public func newIndentationError(
    _ py: Py,
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
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyIndentationError {
    let typeLayout = PyIndentationError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyIndentationError(ptr: ptr)

    result.initialize(
      py,
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
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `IndentationError` type.
  public func newIndentationError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyIndentationError {
    let typeLayout = PyIndentationError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyIndentationError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyIndexError

extension PyIndexError {

  /// Name of the type in Python.
  public static let pythonTypeName = "IndexError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyIndexError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyLookupError.layout.size,
        initialAlignment: PyLookupError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyLookupError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyIndexError(ptr: ptr).beforeDeinitialize()
    PyLookupError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyLookupError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIndexError? {
    return py.cast.asIndexError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `IndexError` type.
  public func newIndexError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyIndexError {
    let typeLayout = PyIndexError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyIndexError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyInterruptedError

extension PyInterruptedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "InterruptedError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyInterruptedError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyInterruptedError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyInterruptedError? {
    return py.cast.asInterruptedError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `InterruptedError` type.
  public func newInterruptedError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyInterruptedError {
    let typeLayout = PyInterruptedError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyInterruptedError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyIsADirectoryError

extension PyIsADirectoryError {

  /// Name of the type in Python.
  public static let pythonTypeName = "IsADirectoryError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyIsADirectoryError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyIsADirectoryError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyIsADirectoryError? {
    return py.cast.asIsADirectoryError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `IsADirectoryError` type.
  public func newIsADirectoryError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyIsADirectoryError {
    let typeLayout = PyIsADirectoryError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyIsADirectoryError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyKeyError

extension PyKeyError {

  /// Name of the type in Python.
  public static let pythonTypeName = "KeyError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyKeyError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyLookupError.layout.size,
        initialAlignment: PyLookupError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyLookupError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyKeyError(ptr: ptr).beforeDeinitialize()
    PyLookupError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyLookupError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyKeyError? {
    return py.cast.asKeyError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `KeyError` type.
  public func newKeyError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyKeyError {
    let typeLayout = PyKeyError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyKeyError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyKeyboardInterrupt

extension PyKeyboardInterrupt {

  /// Name of the type in Python.
  public static let pythonTypeName = "KeyboardInterrupt"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyKeyboardInterrupt` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyBaseException.layout.size,
        initialAlignment: PyBaseException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyKeyboardInterrupt(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyBaseException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyKeyboardInterrupt? {
    return py.cast.asKeyboardInterrupt(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `KeyboardInterrupt` type.
  public func newKeyboardInterrupt(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyKeyboardInterrupt {
    let typeLayout = PyKeyboardInterrupt.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyKeyboardInterrupt(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyLookupError

extension PyLookupError {

  /// Name of the type in Python.
  public static let pythonTypeName = "LookupError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyLookupError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyLookupError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyLookupError? {
    return py.cast.asLookupError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `LookupError` type.
  public func newLookupError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyLookupError {
    let typeLayout = PyLookupError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyLookupError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyMemoryError

extension PyMemoryError {

  /// Name of the type in Python.
  public static let pythonTypeName = "MemoryError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyMemoryError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyMemoryError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyMemoryError? {
    return py.cast.asMemoryError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `MemoryError` type.
  public func newMemoryError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyMemoryError {
    let typeLayout = PyMemoryError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyMemoryError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyModuleNotFoundError

extension PyModuleNotFoundError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ModuleNotFoundError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyModuleNotFoundError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyImportError.layout.size,
        initialAlignment: PyImportError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyImportError.msg`.
  internal var msgPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PyImportError.layout.msgOffset) }
  /// Property from base class: `PyImportError.moduleName`.
  internal var moduleNamePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PyImportError.layout.moduleNameOffset) }
  /// Property from base class: `PyImportError.modulePath`.
  internal var modulePathPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: PyImportError.layout.modulePathOffset) }

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
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
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
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyImportError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyModuleNotFoundError(ptr: ptr).beforeDeinitialize()
    PyImportError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyImportError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyModuleNotFoundError? {
    return py.cast.asModuleNotFoundError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ModuleNotFoundError` type.
  public func newModuleNotFoundError(
    _ py: Py,
    type: PyType,
    msg: PyObject?,
    moduleName: PyObject?,
    modulePath: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyModuleNotFoundError {
    let typeLayout = PyModuleNotFoundError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyModuleNotFoundError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      msg: msg,
      moduleName: moduleName,
      modulePath: modulePath,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `ModuleNotFoundError` type.
  public func newModuleNotFoundError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyModuleNotFoundError {
    let typeLayout = PyModuleNotFoundError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyModuleNotFoundError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyNameError

extension PyNameError {

  /// Name of the type in Python.
  public static let pythonTypeName = "NameError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyNameError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyNameError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNameError? {
    return py.cast.asNameError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NameError` type.
  public func newNameError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyNameError {
    let typeLayout = PyNameError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNameError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyNotADirectoryError

extension PyNotADirectoryError {

  /// Name of the type in Python.
  public static let pythonTypeName = "NotADirectoryError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyNotADirectoryError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyNotADirectoryError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNotADirectoryError? {
    return py.cast.asNotADirectoryError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NotADirectoryError` type.
  public func newNotADirectoryError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyNotADirectoryError {
    let typeLayout = PyNotADirectoryError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNotADirectoryError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyNotImplementedError

extension PyNotImplementedError {

  /// Name of the type in Python.
  public static let pythonTypeName = "NotImplementedError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyNotImplementedError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyRuntimeError.layout.size,
        initialAlignment: PyRuntimeError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyRuntimeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyNotImplementedError(ptr: ptr).beforeDeinitialize()
    PyRuntimeError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyRuntimeError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyNotImplementedError? {
    return py.cast.asNotImplementedError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `NotImplementedError` type.
  public func newNotImplementedError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyNotImplementedError {
    let typeLayout = PyNotImplementedError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNotImplementedError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyOSError

extension PyOSError {

  /// Name of the type in Python.
  public static let pythonTypeName = "OSError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyOSError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyOSError? {
    return py.cast.asOSError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `OSError` type.
  public func newOSError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyOSError {
    let typeLayout = PyOSError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyOSError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyOverflowError

extension PyOverflowError {

  /// Name of the type in Python.
  public static let pythonTypeName = "OverflowError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyOverflowError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyArithmeticError.layout.size,
        initialAlignment: PyArithmeticError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyArithmeticError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyOverflowError(ptr: ptr).beforeDeinitialize()
    PyArithmeticError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyArithmeticError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyOverflowError? {
    return py.cast.asOverflowError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `OverflowError` type.
  public func newOverflowError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyOverflowError {
    let typeLayout = PyOverflowError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyOverflowError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyPendingDeprecationWarning

extension PyPendingDeprecationWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "PendingDeprecationWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyPendingDeprecationWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyPendingDeprecationWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyPendingDeprecationWarning? {
    return py.cast.asPendingDeprecationWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `PendingDeprecationWarning` type.
  public func newPendingDeprecationWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyPendingDeprecationWarning {
    let typeLayout = PyPendingDeprecationWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyPendingDeprecationWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyPermissionError

extension PyPermissionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "PermissionError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyPermissionError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyPermissionError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyPermissionError? {
    return py.cast.asPermissionError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `PermissionError` type.
  public func newPermissionError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyPermissionError {
    let typeLayout = PyPermissionError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyPermissionError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyProcessLookupError

extension PyProcessLookupError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ProcessLookupError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyProcessLookupError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyProcessLookupError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyProcessLookupError? {
    return py.cast.asProcessLookupError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ProcessLookupError` type.
  public func newProcessLookupError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyProcessLookupError {
    let typeLayout = PyProcessLookupError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyProcessLookupError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyRecursionError

extension PyRecursionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "RecursionError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRecursionError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyRuntimeError.layout.size,
        initialAlignment: PyRuntimeError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyRuntimeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyRecursionError(ptr: ptr).beforeDeinitialize()
    PyRuntimeError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyRuntimeError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRecursionError? {
    return py.cast.asRecursionError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `RecursionError` type.
  public func newRecursionError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyRecursionError {
    let typeLayout = PyRecursionError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRecursionError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyReferenceError

extension PyReferenceError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ReferenceError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyReferenceError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyReferenceError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyReferenceError? {
    return py.cast.asReferenceError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ReferenceError` type.
  public func newReferenceError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyReferenceError {
    let typeLayout = PyReferenceError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyReferenceError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyResourceWarning

extension PyResourceWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "ResourceWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyResourceWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyResourceWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyResourceWarning? {
    return py.cast.asResourceWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ResourceWarning` type.
  public func newResourceWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyResourceWarning {
    let typeLayout = PyResourceWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyResourceWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyRuntimeError

extension PyRuntimeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "RuntimeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRuntimeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyRuntimeError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRuntimeError? {
    return py.cast.asRuntimeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `RuntimeError` type.
  public func newRuntimeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyRuntimeError {
    let typeLayout = PyRuntimeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRuntimeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyRuntimeWarning

extension PyRuntimeWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "RuntimeWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyRuntimeWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyRuntimeWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyRuntimeWarning? {
    return py.cast.asRuntimeWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `RuntimeWarning` type.
  public func newRuntimeWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyRuntimeWarning {
    let typeLayout = PyRuntimeWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRuntimeWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyStopAsyncIteration

extension PyStopAsyncIteration {

  /// Name of the type in Python.
  public static let pythonTypeName = "StopAsyncIteration"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStopAsyncIteration` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyStopAsyncIteration(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStopAsyncIteration? {
    return py.cast.asStopAsyncIteration(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `StopAsyncIteration` type.
  public func newStopAsyncIteration(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyStopAsyncIteration {
    let typeLayout = PyStopAsyncIteration.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStopAsyncIteration(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyStopIteration

extension PyStopIteration {

  /// Name of the type in Python.
  public static let pythonTypeName = "StopIteration"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyStopIteration` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self) // PyStopIteration.value
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

  /// Property: `PyStopIteration.value`.
  internal var valuePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyStopIteration(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PyStopIteration(ptr: ptr)
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyStopIteration? {
    return py.cast.asStopIteration(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `StopIteration` type.
  public func newStopIteration(
    _ py: Py,
    type: PyType,
    value: PyObject,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyStopIteration {
    let typeLayout = PyStopIteration.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStopIteration(ptr: ptr)

    result.initialize(
      py,
      type: type,
      value: value,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `StopIteration` type.
  public func newStopIteration(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyStopIteration {
    let typeLayout = PyStopIteration.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStopIteration(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PySyntaxError

extension PySyntaxError {

  /// Name of the type in Python.
  public static let pythonTypeName = "SyntaxError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySyntaxError` fields
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
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self), // PySyntaxError.msg
          PyMemory.FieldLayout(from: PyObject?.self), // PySyntaxError.filename
          PyMemory.FieldLayout(from: PyObject?.self), // PySyntaxError.lineno
          PyMemory.FieldLayout(from: PyObject?.self), // PySyntaxError.offset
          PyMemory.FieldLayout(from: PyObject?.self), // PySyntaxError.text
          PyMemory.FieldLayout(from: PyObject?.self) // PySyntaxError.printFileAndLine
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

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySyntaxError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PySyntaxError(ptr: ptr)
    zelf.msgPtr.deinitialize()
    zelf.filenamePtr.deinitialize()
    zelf.linenoPtr.deinitialize()
    zelf.offsetPtr.deinitialize()
    zelf.textPtr.deinitialize()
    zelf.printFileAndLinePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySyntaxError? {
    return py.cast.asSyntaxError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SyntaxError` type.
  public func newSyntaxError(
    _ py: Py,
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
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PySyntaxError {
    let typeLayout = PySyntaxError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySyntaxError(ptr: ptr)

    result.initialize(
      py,
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
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `SyntaxError` type.
  public func newSyntaxError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PySyntaxError {
    let typeLayout = PySyntaxError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySyntaxError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PySyntaxWarning

extension PySyntaxWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "SyntaxWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySyntaxWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySyntaxWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySyntaxWarning? {
    return py.cast.asSyntaxWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SyntaxWarning` type.
  public func newSyntaxWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PySyntaxWarning {
    let typeLayout = PySyntaxWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySyntaxWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PySystemError

extension PySystemError {

  /// Name of the type in Python.
  public static let pythonTypeName = "SystemError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySystemError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySystemError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySystemError? {
    return py.cast.asSystemError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SystemError` type.
  public func newSystemError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PySystemError {
    let typeLayout = PySystemError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySystemError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PySystemExit

extension PySystemExit {

  /// Name of the type in Python.
  public static let pythonTypeName = "SystemExit"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PySystemExit` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let codeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyBaseException.layout.size,
        initialAlignment: PyBaseException.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // PySystemExit.code
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

  /// Property: `PySystemExit.code`.
  internal var codePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.codeOffset) }

  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyBaseException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PySystemExit(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' all of our own properties.
    let zelf = PySystemExit(ptr: ptr)
    zelf.codePtr.deinitialize()

    // Call 'deinitialize' on base type.
    PyBaseException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PySystemExit? {
    return py.cast.asSystemExit(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `SystemExit` type.
  public func newSystemExit(
    _ py: Py,
    type: PyType,
    code: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PySystemExit {
    let typeLayout = PySystemExit.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySystemExit(ptr: ptr)

    result.initialize(
      py,
      type: type,
      code: code,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `SystemExit` type.
  public func newSystemExit(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PySystemExit {
    let typeLayout = PySystemExit.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySystemExit(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyTabError

extension PyTabError {

  /// Name of the type in Python.
  public static let pythonTypeName = "TabError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTabError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyIndentationError.layout.size,
        initialAlignment: PyIndentationError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

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
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
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
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyIndentationError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTabError(ptr: ptr).beforeDeinitialize()
    PyIndentationError(ptr: ptr).beforeDeinitialize()
    PySyntaxError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyIndentationError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTabError? {
    return py.cast.asTabError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TabError` type.
  public func newTabError(
    _ py: Py,
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
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyTabError {
    let typeLayout = PyTabError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTabError(ptr: ptr)

    result.initialize(
      py,
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
      suppressContext: suppressContext
    )

    return result
  }

  /// Allocate a new instance of `TabError` type.
  public func newTabError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyTabError {
    let typeLayout = PyTabError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTabError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyTimeoutError

extension PyTimeoutError {

  /// Name of the type in Python.
  public static let pythonTypeName = "TimeoutError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTimeoutError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyOSError.layout.size,
        initialAlignment: PyOSError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyOSError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTimeoutError(ptr: ptr).beforeDeinitialize()
    PyOSError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyOSError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTimeoutError? {
    return py.cast.asTimeoutError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TimeoutError` type.
  public func newTimeoutError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyTimeoutError {
    let typeLayout = PyTimeoutError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTimeoutError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyTypeError

extension PyTypeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "TypeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyTypeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyTypeError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyTypeError? {
    return py.cast.asTypeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `TypeError` type.
  public func newTypeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyTypeError {
    let typeLayout = PyTypeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTypeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUnboundLocalError

extension PyUnboundLocalError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnboundLocalError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUnboundLocalError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyNameError.layout.size,
        initialAlignment: PyNameError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyNameError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUnboundLocalError(ptr: ptr).beforeDeinitialize()
    PyNameError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyNameError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnboundLocalError? {
    return py.cast.asUnboundLocalError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnboundLocalError` type.
  public func newUnboundLocalError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUnboundLocalError {
    let typeLayout = PyUnboundLocalError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUnboundLocalError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUnicodeDecodeError

extension PyUnicodeDecodeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeDecodeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUnicodeDecodeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyUnicodeError.layout.size,
        initialAlignment: PyUnicodeError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyUnicodeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUnicodeDecodeError(ptr: ptr).beforeDeinitialize()
    PyUnicodeError(ptr: ptr).beforeDeinitialize()
    PyValueError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyUnicodeError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeDecodeError? {
    return py.cast.asUnicodeDecodeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeDecodeError` type.
  public func newUnicodeDecodeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUnicodeDecodeError {
    let typeLayout = PyUnicodeDecodeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUnicodeDecodeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUnicodeEncodeError

extension PyUnicodeEncodeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeEncodeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUnicodeEncodeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyUnicodeError.layout.size,
        initialAlignment: PyUnicodeError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyUnicodeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUnicodeEncodeError(ptr: ptr).beforeDeinitialize()
    PyUnicodeError(ptr: ptr).beforeDeinitialize()
    PyValueError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyUnicodeError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeEncodeError? {
    return py.cast.asUnicodeEncodeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeEncodeError` type.
  public func newUnicodeEncodeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUnicodeEncodeError {
    let typeLayout = PyUnicodeEncodeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUnicodeEncodeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUnicodeError

extension PyUnicodeError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUnicodeError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyValueError.layout.size,
        initialAlignment: PyValueError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyValueError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUnicodeError(ptr: ptr).beforeDeinitialize()
    PyValueError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyValueError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeError? {
    return py.cast.asUnicodeError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeError` type.
  public func newUnicodeError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUnicodeError {
    let typeLayout = PyUnicodeError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUnicodeError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUnicodeTranslateError

extension PyUnicodeTranslateError {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeTranslateError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUnicodeTranslateError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyUnicodeError.layout.size,
        initialAlignment: PyUnicodeError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyUnicodeError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUnicodeTranslateError(ptr: ptr).beforeDeinitialize()
    PyUnicodeError(ptr: ptr).beforeDeinitialize()
    PyValueError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyUnicodeError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeTranslateError? {
    return py.cast.asUnicodeTranslateError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeTranslateError` type.
  public func newUnicodeTranslateError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUnicodeTranslateError {
    let typeLayout = PyUnicodeTranslateError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUnicodeTranslateError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUnicodeWarning

extension PyUnicodeWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "UnicodeWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUnicodeWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUnicodeWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUnicodeWarning? {
    return py.cast.asUnicodeWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UnicodeWarning` type.
  public func newUnicodeWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUnicodeWarning {
    let typeLayout = PyUnicodeWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUnicodeWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyUserWarning

extension PyUserWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "UserWarning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyUserWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyWarning.layout.size,
        initialAlignment: PyWarning.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyWarning(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyUserWarning(ptr: ptr).beforeDeinitialize()
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyWarning.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyUserWarning? {
    return py.cast.asUserWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `UserWarning` type.
  public func newUserWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyUserWarning {
    let typeLayout = PyUserWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyUserWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyValueError

extension PyValueError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ValueError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyValueError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyValueError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyValueError? {
    return py.cast.asValueError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ValueError` type.
  public func newValueError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyValueError {
    let typeLayout = PyValueError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyValueError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyWarning

extension PyWarning {

  /// Name of the type in Python.
  public static let pythonTypeName = "Warning"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyWarning` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyException.layout.size,
        initialAlignment: PyException.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyException(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyWarning(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyException.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyWarning? {
    return py.cast.asWarning(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `Warning` type.
  public func newWarning(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyWarning {
    let typeLayout = PyWarning.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyWarning(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

// MARK: - PyZeroDivisionError

extension PyZeroDivisionError {

  /// Name of the type in Python.
  public static let pythonTypeName = "ZeroDivisionError"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyZeroDivisionError` fields
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyArithmeticError.layout.size,
        initialAlignment: PyArithmeticError.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()


  internal func initializeBase(_ py: Py,
                               type: PyType,
                               args: PyTuple,
                               traceback: PyTraceback? = nil,
                               cause: PyBaseException? = nil,
                               context: PyBaseException? = nil,
                               suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    let base = PyArithmeticError(ptr: self.ptr)
    base.initialize(py,
                    type: type,
                    args: args,
                    traceback: traceback,
                    cause: cause,
                    context: context,
                    suppressContext: suppressContext)
  }

  internal static func deinitialize(ptr: RawPtr) {
    // Call 'beforeDeinitialize' starting from most-specific type.
    PyZeroDivisionError(ptr: ptr).beforeDeinitialize()
    PyArithmeticError(ptr: ptr).beforeDeinitialize()
    PyException(ptr: ptr).beforeDeinitialize()
    PyBaseException(ptr: ptr).beforeDeinitialize()
    PyObject(ptr: ptr).beforeDeinitialize()

    // Call 'deinitialize' on base type.
    PyArithmeticError.deinitialize(ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyZeroDivisionError? {
    return py.cast.asZeroDivisionError(object)
  }

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `ZeroDivisionError` type.
  public func newZeroDivisionError(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyErrorHeader.defaultSuppressContext
  ) -> PyZeroDivisionError {
    let typeLayout = PyZeroDivisionError.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyZeroDivisionError(ptr: ptr)

    result.initialize(
      py,
      type: type,
      args: args,
      traceback: traceback,
      cause: cause,
      context: context,
      suppressContext: suppressContext
    )

    return result
  }
}

