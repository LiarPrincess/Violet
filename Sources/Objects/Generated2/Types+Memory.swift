// ==========================================================================
// Automatically generated from: ./Sources/Objects/Generated2/Types+Memory.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ==========================================================================

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
//   - [TYPE_NAME].Layout - mainly field offsets
//   - [TYPE_NAME].deinitialize(ptr:) - to deinitialize this object before deletion
//   - PyMemory.new[TYPE_NAME] - to create new object of this type

// MARK: - PyObjectHeader

extension PyObjectHeader {

  /// This type was automatically generated based on `PyObjectHeader` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let typeOffset: Int
    internal let lazy__dict__Offset: Int
    internal let flagsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: 0,
        initialAlignment: 0,
        fields: [
          PyMemory.FieldLayout(from: PyType.self), // type
          PyMemory.FieldLayout(from: PyObjectHeader.LazyDict.self), // lazy__dict__
          PyMemory.FieldLayout(from: Flags.self) // flags
        ]
      )

      assert(layout.offsets.count == 3)
      self.typeOffset = layout.offsets[0]
      self.lazy__dict__Offset = layout.offsets[1]
      self.flagsOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: Self.layout.typeOffset) }
  internal var lazy__dict__Ptr: Ptr<PyObjectHeader.LazyDict> { Ptr(self.ptr, offset: Self.layout.lazy__dict__Offset) }
  internal var flagsPtr: Ptr<Flags> { Ptr(self.ptr, offset: Self.layout.flagsOffset) }
}

// MARK: - PyErrorHeader

extension PyErrorHeader {

  /// This type was automatically generated based on `PyErrorHeader` fields
  /// with `sourcery: includeInLayout` annotation.
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

  /// This type was automatically generated based on `PyBool` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: BigInt.self) // value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBool(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
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

  /// This type was automatically generated based on `PyBuiltinFunction` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: FunctionWrapper.self), // function
          PyMemory.FieldLayout(from: PyObject?.self), // module
          PyMemory.FieldLayout(from: String?.self) // doc
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

  internal static let layout = Layout()

  internal var functionPtr: Ptr<FunctionWrapper> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  internal var modulePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  internal var docPtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBuiltinFunction(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.functionPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()
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

  /// This type was automatically generated based on `PyBuiltinMethod` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: FunctionWrapper.self), // function
          PyMemory.FieldLayout(from: PyObject.self), // object
          PyMemory.FieldLayout(from: PyObject?.self), // module
          PyMemory.FieldLayout(from: String?.self) // doc
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

  internal static let layout = Layout()

  internal var functionPtr: Ptr<FunctionWrapper> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  internal var objectPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.objectOffset) }
  internal var modulePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  internal var docPtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBuiltinMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()
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

  /// This type was automatically generated based on `PyByteArray` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Data.self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<Data> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyByteArray(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
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

  /// This type was automatically generated based on `PyByteArrayIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyByteArray.self), // bytes
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.bytesOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var bytesPtr: Ptr<PyByteArray> { Ptr(self.ptr, offset: Self.layout.bytesOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyByteArrayIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyBytes` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Data.self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<Data> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBytes(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
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

  /// This type was automatically generated based on `PyBytesIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyBytes.self), // bytes
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.bytesOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var bytesPtr: Ptr<PyBytes> { Ptr(self.ptr, offset: Self.layout.bytesOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBytesIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyCallableIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let sentinelOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // callable
          PyMemory.FieldLayout(from: PyObject.self) // sentinel
        ]
      )

      assert(layout.offsets.count == 2)
      self.callableOffset = layout.offsets[0]
      self.sentinelOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var callablePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.callableOffset) }
  internal var sentinelPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sentinelOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyCallableIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
    zelf.sentinelPtr.deinitialize()
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

  /// This type was automatically generated based on `PyCell` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let contentOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // content
        ]
      )

      assert(layout.offsets.count == 1)
      self.contentOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var contentPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.contentOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyCell(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.contentPtr.deinitialize()
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

  /// This type was automatically generated based on `PyClassMethod` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // callable
        ]
      )

      assert(layout.offsets.count == 1)
      self.callableOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var callablePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.callableOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyClassMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
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

  /// This type was automatically generated based on `PyCode` fields
  /// with `sourcery: includeInLayout` annotation.
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
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyString.self), // name
          PyMemory.FieldLayout(from: PyString.self), // qualifiedName
          PyMemory.FieldLayout(from: PyString.self), // filename
          PyMemory.FieldLayout(from: [Instruction].self), // instructions
          PyMemory.FieldLayout(from: SourceLine.self), // firstLine
          PyMemory.FieldLayout(from: [SourceLine].self), // instructionLines
          PyMemory.FieldLayout(from: [PyObject].self), // constants
          PyMemory.FieldLayout(from: [CodeObject.Label].self), // labels
          PyMemory.FieldLayout(from: [PyString].self), // names
          PyMemory.FieldLayout(from: [MangledName].self), // variableNames
          PyMemory.FieldLayout(from: [MangledName].self), // cellVariableNames
          PyMemory.FieldLayout(from: [MangledName].self), // freeVariableNames
          PyMemory.FieldLayout(from: Int.self), // argCount
          PyMemory.FieldLayout(from: Int.self) // kwOnlyArgCount
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

  internal static let layout = Layout()

  internal var namePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  internal var qualifiedNamePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.qualifiedNameOffset) }
  internal var filenamePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.filenameOffset) }
  internal var instructionsPtr: Ptr<[Instruction]> { Ptr(self.ptr, offset: Self.layout.instructionsOffset) }
  internal var firstLinePtr: Ptr<SourceLine> { Ptr(self.ptr, offset: Self.layout.firstLineOffset) }
  internal var instructionLinesPtr: Ptr<[SourceLine]> { Ptr(self.ptr, offset: Self.layout.instructionLinesOffset) }
  internal var constantsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.constantsOffset) }
  internal var labelsPtr: Ptr<[CodeObject.Label]> { Ptr(self.ptr, offset: Self.layout.labelsOffset) }
  internal var namesPtr: Ptr<[PyString]> { Ptr(self.ptr, offset: Self.layout.namesOffset) }
  internal var variableNamesPtr: Ptr<[MangledName]> { Ptr(self.ptr, offset: Self.layout.variableNamesOffset) }
  internal var cellVariableNamesPtr: Ptr<[MangledName]> { Ptr(self.ptr, offset: Self.layout.cellVariableNamesOffset) }
  internal var freeVariableNamesPtr: Ptr<[MangledName]> { Ptr(self.ptr, offset: Self.layout.freeVariableNamesOffset) }
  internal var argCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.argCountOffset) }
  internal var kwOnlyArgCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.kwOnlyArgCountOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyCode(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyComplex` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let realOffset: Int
    internal let imagOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Double.self), // real
          PyMemory.FieldLayout(from: Double.self) // imag
        ]
      )

      assert(layout.offsets.count == 2)
      self.realOffset = layout.offsets[0]
      self.imagOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var realPtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.realOffset) }
  internal var imagPtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.imagOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyComplex(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.realPtr.deinitialize()
    zelf.imagPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDict` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: OrderedDictionary.self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<OrderedDictionary> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDict(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDictItemIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self), // dict
          PyMemory.FieldLayout(from: Int.self), // index
          PyMemory.FieldLayout(from: Int.self) // initialCount
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

  internal static let layout = Layout()

  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictItemIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDictItems` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self) // dict
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictItems(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDictKeyIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self), // dict
          PyMemory.FieldLayout(from: Int.self), // index
          PyMemory.FieldLayout(from: Int.self) // initialCount
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

  internal static let layout = Layout()

  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictKeyIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDictKeys` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self) // dict
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictKeys(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDictValueIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self), // dict
          PyMemory.FieldLayout(from: Int.self), // index
          PyMemory.FieldLayout(from: Int.self) // initialCount
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

  internal static let layout = Layout()

  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictValueIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
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

  /// This type was automatically generated based on `PyDictValues` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyDict.self) // dict
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var dictPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.dictOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictValues(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
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

  /// This type was automatically generated based on `PyEllipsis` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyEllipsis(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyEnumerate` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let iteratorOffset: Int
    internal let nextIndexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // iterator
          PyMemory.FieldLayout(from: BigInt.self) // nextIndex
        ]
      )

      assert(layout.offsets.count == 2)
      self.iteratorOffset = layout.offsets[0]
      self.nextIndexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var iteratorPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.iteratorOffset) }
  internal var nextIndexPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.nextIndexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyEnumerate(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.iteratorPtr.deinitialize()
    zelf.nextIndexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyFilter` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let fnOffset: Int
    internal let iteratorOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // fn
          PyMemory.FieldLayout(from: PyObject.self) // iterator
        ]
      )

      assert(layout.offsets.count == 2)
      self.fnOffset = layout.offsets[0]
      self.iteratorOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.fnOffset) }
  internal var iteratorPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.iteratorOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFilter(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.fnPtr.deinitialize()
    zelf.iteratorPtr.deinitialize()
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

  /// This type was automatically generated based on `PyFloat` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: Double.self) // value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var valuePtr: Ptr<Double> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFloat(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
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

  /// This type was automatically generated based on `PyFrame` fields
  /// with `sourcery: includeInLayout` annotation.
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
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyCode.self), // code
          PyMemory.FieldLayout(from: PyFrame?.self), // parent
          PyMemory.FieldLayout(from: ObjectStack.self), // stack
          PyMemory.FieldLayout(from: BlockStack.self), // blocks
          PyMemory.FieldLayout(from: PyDict.self), // locals
          PyMemory.FieldLayout(from: PyDict.self), // globals
          PyMemory.FieldLayout(from: PyDict.self), // builtins
          PyMemory.FieldLayout(from: [PyObject?].self), // fastLocals
          PyMemory.FieldLayout(from: [PyCell].self), // cellVariables
          PyMemory.FieldLayout(from: [PyCell].self), // freeVariables
          PyMemory.FieldLayout(from: Int?.self), // currentInstructionIndex
          PyMemory.FieldLayout(from: Int.self) // nextInstructionIndex
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

  internal static let layout = Layout()

  internal var codePtr: Ptr<PyCode> { Ptr(self.ptr, offset: Self.layout.codeOffset) }
  internal var parentPtr: Ptr<PyFrame?> { Ptr(self.ptr, offset: Self.layout.parentOffset) }
  internal var stackPtr: Ptr<ObjectStack> { Ptr(self.ptr, offset: Self.layout.stackOffset) }
  internal var blocksPtr: Ptr<BlockStack> { Ptr(self.ptr, offset: Self.layout.blocksOffset) }
  internal var localsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.localsOffset) }
  internal var globalsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.globalsOffset) }
  internal var builtinsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.builtinsOffset) }
  internal var fastLocalsPtr: Ptr<[PyObject?]> { Ptr(self.ptr, offset: Self.layout.fastLocalsOffset) }
  internal var cellVariablesPtr: Ptr<[PyCell]> { Ptr(self.ptr, offset: Self.layout.cellVariablesOffset) }
  internal var freeVariablesPtr: Ptr<[PyCell]> { Ptr(self.ptr, offset: Self.layout.freeVariablesOffset) }
  internal var currentInstructionIndexPtr: Ptr<Int?> { Ptr(self.ptr, offset: Self.layout.currentInstructionIndexOffset) }
  internal var nextInstructionIndexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.nextInstructionIndexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFrame(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyFrozenSet` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: OrderedSet.self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<OrderedSet> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFrozenSet(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `frozenset` type.
  public func newFrozenSet(
    _ py: Py,
    type: PyType,
    elements: PyFrozenSet.OrderedSet
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

  /// This type was automatically generated based on `PyFunction` fields
  /// with `sourcery: includeInLayout` annotation.
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
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyString.self), // name
          PyMemory.FieldLayout(from: PyString.self), // qualname
          PyMemory.FieldLayout(from: PyString?.self), // doc
          PyMemory.FieldLayout(from: PyObject.self), // module
          PyMemory.FieldLayout(from: PyCode.self), // code
          PyMemory.FieldLayout(from: PyDict.self), // globals
          PyMemory.FieldLayout(from: PyTuple?.self), // defaults
          PyMemory.FieldLayout(from: PyDict?.self), // kwDefaults
          PyMemory.FieldLayout(from: PyTuple?.self), // closure
          PyMemory.FieldLayout(from: PyDict?.self) // annotations
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

  internal static let layout = Layout()

  internal var namePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  internal var qualnamePtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.qualnameOffset) }
  internal var docPtr: Ptr<PyString?> { Ptr(self.ptr, offset: Self.layout.docOffset) }
  internal var modulePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.moduleOffset) }
  internal var codePtr: Ptr<PyCode> { Ptr(self.ptr, offset: Self.layout.codeOffset) }
  internal var globalsPtr: Ptr<PyDict> { Ptr(self.ptr, offset: Self.layout.globalsOffset) }
  internal var defaultsPtr: Ptr<PyTuple?> { Ptr(self.ptr, offset: Self.layout.defaultsOffset) }
  internal var kwDefaultsPtr: Ptr<PyDict?> { Ptr(self.ptr, offset: Self.layout.kwDefaultsOffset) }
  internal var closurePtr: Ptr<PyTuple?> { Ptr(self.ptr, offset: Self.layout.closureOffset) }
  internal var annotationsPtr: Ptr<PyDict?> { Ptr(self.ptr, offset: Self.layout.annotationsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFunction(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyInt` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: BigInt.self) // value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyInt(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
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

  /// This type was automatically generated based on `PyIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // sequence
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.sequenceOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var sequencePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sequenceOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyList` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: [PyObject].self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyList(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
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

  /// This type was automatically generated based on `PyListIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyList.self), // list
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.listOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Self.layout.listOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyListIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyListReverseIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyList.self), // list
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.listOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Self.layout.listOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyListReverseIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyMap` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let fnOffset: Int
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // fn
          PyMemory.FieldLayout(from: [PyObject].self) // iterators
        ]
      )

      assert(layout.offsets.count == 2)
      self.fnOffset = layout.offsets[0]
      self.iteratorsOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.fnOffset) }
  internal var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.iteratorsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyMap(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.fnPtr.deinitialize()
    zelf.iteratorsPtr.deinitialize()
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

  /// This type was automatically generated based on `PyMethod` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyFunction.self), // function
          PyMemory.FieldLayout(from: PyObject.self) // object
        ]
      )

      assert(layout.offsets.count == 2)
      self.functionOffset = layout.offsets[0]
      self.objectOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var functionPtr: Ptr<PyFunction> { Ptr(self.ptr, offset: Self.layout.functionOffset) }
  internal var objectPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.objectOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()
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

  /// This type was automatically generated based on `PyModule` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyModule(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyNamespace` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNamespace(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyNone` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNone(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyNotImplemented` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNotImplemented(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyObject` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyObject(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `object` type.
  public func newObject(
    _ py: Py,
    type: PyType
  ) -> PyObject {
    let typeLayout = PyObject.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyObject(ptr: ptr)

    result.initialize(
      py,
      type: type
    )

    return result
  }
}

// MARK: - PyProperty

extension PyProperty {

  /// This type was automatically generated based on `PyProperty` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let _getOffset: Int
    internal let _setOffset: Int
    internal let _delOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self), // _get
          PyMemory.FieldLayout(from: PyObject?.self), // _set
          PyMemory.FieldLayout(from: PyObject?.self), // _del
          PyMemory.FieldLayout(from: PyObject?.self) // doc
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

  internal static let layout = Layout()

  internal var _getPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._getOffset) }
  internal var _setPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._setOffset) }
  internal var _delPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout._delOffset) }
  internal var docPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.docOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyProperty(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf._getPtr.deinitialize()
    zelf._setPtr.deinitialize()
    zelf._delPtr.deinitialize()
    zelf.docPtr.deinitialize()
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

  /// This type was automatically generated based on `PyRange` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyInt.self), // start
          PyMemory.FieldLayout(from: PyInt.self), // stop
          PyMemory.FieldLayout(from: PyInt.self), // step
          PyMemory.FieldLayout(from: PyInt.self) // length
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

  internal static let layout = Layout()

  internal var startPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  internal var stopPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.stopOffset) }
  internal var stepPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.stepOffset) }
  internal var lengthPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lengthOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyRange(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()
    zelf.lengthPtr.deinitialize()
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

  /// This type was automatically generated based on `PyRangeIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: BigInt.self), // start
          PyMemory.FieldLayout(from: BigInt.self), // step
          PyMemory.FieldLayout(from: BigInt.self), // length
          PyMemory.FieldLayout(from: BigInt.self) // index
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

  internal static let layout = Layout()

  internal var startPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  internal var stepPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.stepOffset) }
  internal var lengthPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.lengthOffset) }
  internal var indexPtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyRangeIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.startPtr.deinitialize()
    zelf.stepPtr.deinitialize()
    zelf.lengthPtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyReversed` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // sequence
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.sequenceOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var sequencePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.sequenceOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyReversed(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PySet` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: OrderedSet.self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<OrderedSet> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySet(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `set` type.
  public func newSet(
    _ py: Py,
    type: PyType,
    elements: PySet.OrderedSet
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

  /// This type was automatically generated based on `PySetIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let setOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyAnySet.self), // set
          PyMemory.FieldLayout(from: Int.self), // index
          PyMemory.FieldLayout(from: Int.self) // initialCount
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

  internal static let layout = Layout()

  internal var setPtr: Ptr<PyAnySet> { Ptr(self.ptr, offset: Self.layout.setOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }
  internal var initialCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.initialCountOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySetIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.setPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
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

  /// This type was automatically generated based on `PySlice` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject.self), // start
          PyMemory.FieldLayout(from: PyObject.self), // stop
          PyMemory.FieldLayout(from: PyObject.self) // step
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

  internal static let layout = Layout()

  internal var startPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.startOffset) }
  internal var stopPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.stopOffset) }
  internal var stepPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Self.layout.stepOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySlice(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()
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

  /// This type was automatically generated based on `PyStaticMethod` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyObject?.self) // callable
        ]
      )

      assert(layout.offsets.count == 1)
      self.callableOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var callablePtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.callableOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyStaticMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
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

  /// This type was automatically generated based on `PyString` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let cachedCountOffset: Int
    internal let cachedHashOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: String.self), // value
          PyMemory.FieldLayout(from: Int.self), // cachedCount
          PyMemory.FieldLayout(from: PyHash.self) // cachedHash
        ]
      )

      assert(layout.offsets.count == 3)
      self.valueOffset = layout.offsets[0]
      self.cachedCountOffset = layout.offsets[1]
      self.cachedHashOffset = layout.offsets[2]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var valuePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.valueOffset) }
  internal var cachedCountPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.cachedCountOffset) }
  internal var cachedHashPtr: Ptr<PyHash> { Ptr(self.ptr, offset: Self.layout.cachedHashOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyString(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
    zelf.cachedCountPtr.deinitialize()
    zelf.cachedHashPtr.deinitialize()
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

  /// This type was automatically generated based on `PyStringIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let stringOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyString.self), // string
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.stringOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var stringPtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.stringOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyStringIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.stringPtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PySuper` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let thisClassOffset: Int
    internal let objectOffset: Int
    internal let objectTypeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyType?.self), // thisClass
          PyMemory.FieldLayout(from: PyObject?.self), // object
          PyMemory.FieldLayout(from: PyType?.self) // objectType
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

  internal static let layout = Layout()

  internal var thisClassPtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.thisClassOffset) }
  internal var objectPtr: Ptr<PyObject?> { Ptr(self.ptr, offset: Self.layout.objectOffset) }
  internal var objectTypePtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.objectTypeOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySuper(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.thisClassPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.objectTypePtr.deinitialize()
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

  /// This type was automatically generated based on `PyTextFile` fields
  /// with `sourcery: includeInLayout` annotation.
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
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: String?.self), // name
          PyMemory.FieldLayout(from: FileDescriptorType.self), // fd
          PyMemory.FieldLayout(from: FileMode.self), // mode
          PyMemory.FieldLayout(from: PyString.Encoding.self), // encoding
          PyMemory.FieldLayout(from: PyString.ErrorHandling.self) // errorHandling
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

  internal static let layout = Layout()

  internal var namePtr: Ptr<String?> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  internal var fdPtr: Ptr<FileDescriptorType> { Ptr(self.ptr, offset: Self.layout.fdOffset) }
  internal var modePtr: Ptr<FileMode> { Ptr(self.ptr, offset: Self.layout.modeOffset) }
  internal var encodingPtr: Ptr<PyString.Encoding> { Ptr(self.ptr, offset: Self.layout.encodingOffset) }
  internal var errorHandlingPtr: Ptr<PyString.ErrorHandling> { Ptr(self.ptr, offset: Self.layout.errorHandlingOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTextFile(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.namePtr.deinitialize()
    zelf.fdPtr.deinitialize()
    zelf.modePtr.deinitialize()
    zelf.encodingPtr.deinitialize()
    zelf.errorHandlingPtr.deinitialize()
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

  /// This type was automatically generated based on `PyTraceback` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let nextOffset: Int
    internal let frameOffset: Int
    internal let lastInstructionOffset: Int
    internal let lineNoOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyTraceback?.self), // next
          PyMemory.FieldLayout(from: PyFrame.self), // frame
          PyMemory.FieldLayout(from: PyInt.self), // lastInstruction
          PyMemory.FieldLayout(from: PyInt.self) // lineNo
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

  internal static let layout = Layout()

  internal var nextPtr: Ptr<PyTraceback?> { Ptr(self.ptr, offset: Self.layout.nextOffset) }
  internal var framePtr: Ptr<PyFrame> { Ptr(self.ptr, offset: Self.layout.frameOffset) }
  internal var lastInstructionPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lastInstructionOffset) }
  internal var lineNoPtr: Ptr<PyInt> { Ptr(self.ptr, offset: Self.layout.lineNoOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTraceback(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.nextPtr.deinitialize()
    zelf.framePtr.deinitialize()
    zelf.lastInstructionPtr.deinitialize()
    zelf.lineNoPtr.deinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `traceback` type.
  public func newTraceback(
    _ py: Py,
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

  /// This type was automatically generated based on `PyTuple` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: [PyObject].self) // elements
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var elementsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.elementsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTuple(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
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

  /// This type was automatically generated based on `PyTupleIterator` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let tupleOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: PyTuple.self), // tuple
          PyMemory.FieldLayout(from: Int.self) // index
        ]
      )

      assert(layout.offsets.count == 2)
      self.tupleOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var tuplePtr: Ptr<PyTuple> { Ptr(self.ptr, offset: Self.layout.tupleOffset) }
  internal var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Self.layout.indexOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTupleIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.tuplePtr.deinitialize()
    zelf.indexPtr.deinitialize()
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

  /// This type was automatically generated based on `PyType` fields
  /// with `sourcery: includeInLayout` annotation.
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
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: String.self), // name
          PyMemory.FieldLayout(from: String.self), // qualname
          PyMemory.FieldLayout(from: PyType?.self), // base
          PyMemory.FieldLayout(from: [PyType].self), // bases
          PyMemory.FieldLayout(from: [PyType].self), // mro
          PyMemory.FieldLayout(from: [PyType].self), // subclasses
          PyMemory.FieldLayout(from: MemoryLayout.self), // layout
          PyMemory.FieldLayout(from: PyStaticCall.KnownNotOverriddenMethods.self), // staticMethods
          PyMemory.FieldLayout(from: DebugFn.self), // debugFn
          PyMemory.FieldLayout(from: DeinitializeFn.self) // deinitialize
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

  internal static let layout = Layout()

  internal var namePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.nameOffset) }
  internal var qualnamePtr: Ptr<String> { Ptr(self.ptr, offset: Self.layout.qualnameOffset) }
  internal var basePtr: Ptr<PyType?> { Ptr(self.ptr, offset: Self.layout.baseOffset) }
  internal var basesPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.basesOffset) }
  internal var mroPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.mroOffset) }
  internal var subclassesPtr: Ptr<[PyType]> { Ptr(self.ptr, offset: Self.layout.subclassesOffset) }
  internal var layoutPtr: Ptr<MemoryLayout> { Ptr(self.ptr, offset: Self.layout.layoutOffset) }
  internal var staticMethodsPtr: Ptr<PyStaticCall.KnownNotOverriddenMethods> { Ptr(self.ptr, offset: Self.layout.staticMethodsOffset) }
  internal var debugFnPtr: Ptr<DebugFn> { Ptr(self.ptr, offset: Self.layout.debugFnOffset) }
  internal var deinitializePtr: Ptr<DeinitializeFn> { Ptr(self.ptr, offset: Self.layout.deinitializeOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyType(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
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

  /// This type was automatically generated based on `PyZip` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.layout.size,
        initialAlignment: PyObjectHeader.layout.alignment,
        fields: [
          PyMemory.FieldLayout(from: [PyObject].self) // iterators
        ]
      )

      assert(layout.offsets.count == 1)
      self.iteratorsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()

  internal var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Self.layout.iteratorsOffset) }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyZip(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.iteratorsPtr.deinitialize()
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

// MARK: - PyBaseException

extension PyBaseException {

  /// This type was automatically generated based on `PyBaseException` fields
  /// with `sourcery: includeInLayout` annotation.
  internal struct Layout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyErrorHeader.layout.size,
        initialAlignment: PyErrorHeader.layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  internal static let layout = Layout()


  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBaseException(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

extension PyMemory {

  /// Allocate a new instance of `BaseException` type.
  public func newBaseException(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback?,
    cause: PyBaseException?,
    context: PyBaseException?,
    suppressContext: Bool
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

