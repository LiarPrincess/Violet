// ============================================================================
// Automatically generated from: ./Sources/Objects/Generated2/PyMemory+Types.py
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
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - then for each type:
//   - PyMemory.[TYPE_NAME]Layout - mainly field offsets
//   - PyMemory.new[TYPE_NAME] - to create new object of this type
//   - [TYPE_NAME].deinitialize(ptr:) - to deinitialize this object before deletion

// MARK: - Type/object types init

extension PyMemory {

  /// Those types require a special treatment because:
  /// - `object` type has `type` type
  /// - `type` type has `type` type (self reference) and `object` type as base
  public func newTypeAndObjectTypes() -> (typeType: PyType, objectType: PyType) {
    let layout = PyType.layout
    let typeTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)
    let objectTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)

    let typeType = PyType(ptr: typeTypePtr)
    let objectType = PyType(ptr: objectTypePtr)

    objectType.initialize(type: typeType,
                          name: "object",
                          qualname: "object",
                          flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
                          base: nil,
                          bases: [],
                          mroWithoutSelf: [],
                          subclasses: [],
                          layout: PyContext.Types.objectMemoryLayout,
                          staticMethods: PyContext.Types.objectStaticMethods,
                          debugFn: PyObject.createDebugString(ptr:),
                          deinitialize: PyObject.deinitialize(ptr:))

    typeType.initialize(type: typeType,
                        name: "type",
                        qualname: "type",
                        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag, .isTypeSubclassFlag],
                        base: objectType,
                        bases: [objectType],
                        mroWithoutSelf: [objectType],
                        subclasses: [],
                        layout: PyContext.Types.typeMemoryLayout,
                        staticMethods: PyContext.Types.typeStaticMethods,
                        debugFn: PyType.createDebugString(ptr:),
                        deinitialize: PyType.deinitialize(ptr:))

   return (typeType, objectType)
  }
}

// MARK: - PyBool

extension PyMemory {

  /// This type was automatically generated based on `PyBool` fields.
  internal struct PyBoolLayout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: BigInt.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `bool` type.
  public func newBool(
    type: PyType,
    value: Bool
  ) -> PyBool {
    let typeLayout = PyBool.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBool(ptr: ptr)

    result.initialize(
      type: type,
      value: value
    )

    return result
  }
}

extension PyBool {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBool(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
  }
}

// MARK: - PyBuiltinFunction

extension PyMemory {

  /// This type was automatically generated based on `PyBuiltinFunction` fields.
  internal struct PyBuiltinFunctionLayout {
    internal let functionOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: FunctionWrapper.self),
          FieldLayout(from: PyObject?.self),
          FieldLayout(from: String?.self)
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

  /// Allocate a new instance of `builtinFunction` type.
  public func newBuiltinFunction(
    type: PyType,
    function: FunctionWrapper,
    module: PyObject?,
    doc: String?
  ) -> PyBuiltinFunction {
    let typeLayout = PyBuiltinFunction.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBuiltinFunction(ptr: ptr)

    result.initialize(
      type: type,
      function: function,
      module: module,
      doc: doc
    )

    return result
  }
}

extension PyBuiltinFunction {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBuiltinFunction(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.functionPtr.deinitialize()
    zelf.modulePtr.deinitialize()
    zelf.docPtr.deinitialize()
  }
}

// MARK: - PyBuiltinMethod

extension PyMemory {

  /// This type was automatically generated based on `PyBuiltinMethod` fields.
  internal struct PyBuiltinMethodLayout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let moduleOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: FunctionWrapper.self),
          FieldLayout(from: PyObject.self),
          FieldLayout(from: PyObject?.self),
          FieldLayout(from: String?.self)
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

  /// Allocate a new instance of `builtinMethod` type.
  public func newBuiltinMethod(
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
      type: type,
      function: function,
      object: object,
      module: module,
      doc: doc
    )

    return result
  }
}

extension PyBuiltinMethod {
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

// MARK: - PyByteArray

extension PyMemory {

  /// This type was automatically generated based on `PyByteArray` fields.
  internal struct PyByteArrayLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: Data.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `bytearray` type.
  public func newByteArray(
    type: PyType,
    elements: Data
  ) -> PyByteArray {
    let typeLayout = PyByteArray.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyByteArray(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PyByteArray {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyByteArray(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PyByteArrayIterator

extension PyMemory {

  /// This type was automatically generated based on `PyByteArrayIterator` fields.
  internal struct PyByteArrayIteratorLayout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyByteArray.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.bytesOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `bytearray_iterator` type.
  public func newByteArrayIterator(
    type: PyType,
    bytes: PyByteArray
  ) -> PyByteArrayIterator {
    let typeLayout = PyByteArrayIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyByteArrayIterator(ptr: ptr)

    result.initialize(
      type: type,
      bytes: bytes
    )

    return result
  }
}

extension PyByteArrayIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyByteArrayIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PyBytes

extension PyMemory {

  /// This type was automatically generated based on `PyBytes` fields.
  internal struct PyBytesLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: Data.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `bytes` type.
  public func newBytes(
    type: PyType,
    elements: Data
  ) -> PyBytes {
    let typeLayout = PyBytes.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBytes(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PyBytes {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBytes(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PyBytesIterator

extension PyMemory {

  /// This type was automatically generated based on `PyBytesIterator` fields.
  internal struct PyBytesIteratorLayout {
    internal let bytesOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyBytes.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.bytesOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `bytes_iterator` type.
  public func newBytesIterator(
    type: PyType,
    bytes: PyBytes
  ) -> PyBytesIterator {
    let typeLayout = PyBytesIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyBytesIterator(ptr: ptr)

    result.initialize(
      type: type,
      bytes: bytes
    )

    return result
  }
}

extension PyBytesIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyBytesIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PyCallableIterator

extension PyMemory {

  /// This type was automatically generated based on `PyCallableIterator` fields.
  internal struct PyCallableIteratorLayout {
    internal let callableOffset: Int
    internal let sentinelOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: PyObject.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.callableOffset = layout.offsets[0]
      self.sentinelOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `callable_iterator` type.
  public func newCallableIterator(
    type: PyType,
    callable: PyObject,
    sentinel: PyObject
  ) -> PyCallableIterator {
    let typeLayout = PyCallableIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyCallableIterator(ptr: ptr)

    result.initialize(
      type: type,
      callable: callable,
      sentinel: sentinel
    )

    return result
  }
}

extension PyCallableIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyCallableIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
    zelf.sentinelPtr.deinitialize()
  }
}

// MARK: - PyCell

extension PyMemory {

  /// This type was automatically generated based on `PyCell` fields.
  internal struct PyCellLayout {
    internal let contentOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject?.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.contentOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `cell` type.
  public func newCell(
    type: PyType,
    content: PyObject?
  ) -> PyCell {
    let typeLayout = PyCell.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyCell(ptr: ptr)

    result.initialize(
      type: type,
      content: content
    )

    return result
  }
}

extension PyCell {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyCell(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.contentPtr.deinitialize()
  }
}

// MARK: - PyClassMethod

extension PyMemory {

  /// This type was automatically generated based on `PyClassMethod` fields.
  internal struct PyClassMethodLayout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject?.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.callableOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `classmethod` type.
  public func newClassMethod(
    type: PyType,
    callable: PyObject?
  ) -> PyClassMethod {
    let typeLayout = PyClassMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyClassMethod(ptr: ptr)

    result.initialize(
      type: type,
      callable: callable
    )

    return result
  }
}

extension PyClassMethod {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyClassMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
  }
}

// MARK: - PyCode

extension PyMemory {

  /// This type was automatically generated based on `PyCode` fields.
  internal struct PyCodeLayout {
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
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyString.self),
          FieldLayout(from: PyString.self),
          FieldLayout(from: PyString.self),
          FieldLayout(from: [Instruction].self),
          FieldLayout(from: SourceLine.self),
          FieldLayout(from: [SourceLine].self),
          FieldLayout(from: [PyObject].self),
          FieldLayout(from: [CodeObject.Label].self),
          FieldLayout(from: [PyString].self),
          FieldLayout(from: [MangledName].self),
          FieldLayout(from: [MangledName].self),
          FieldLayout(from: [MangledName].self),
          FieldLayout(from: Int.self),
          FieldLayout(from: Int.self)
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

  /// Allocate a new instance of `code` type.
  public func newCode(
    type: PyType,
    code: CodeObject
  ) -> PyCode {
    let typeLayout = PyCode.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyCode(ptr: ptr)

    result.initialize(
      type: type,
      code: code
    )

    return result
  }
}

extension PyCode {
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

// MARK: - PyComplex

extension PyMemory {

  /// This type was automatically generated based on `PyComplex` fields.
  internal struct PyComplexLayout {
    internal let realOffset: Int
    internal let imagOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: Double.self),
          FieldLayout(from: Double.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.realOffset = layout.offsets[0]
      self.imagOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `complex` type.
  public func newComplex(
    type: PyType,
    real: Double,
    imag: Double
  ) -> PyComplex {
    let typeLayout = PyComplex.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyComplex(ptr: ptr)

    result.initialize(
      type: type,
      real: real,
      imag: imag
    )

    return result
  }
}

extension PyComplex {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyComplex(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.realPtr.deinitialize()
    zelf.imagPtr.deinitialize()
  }
}

// MARK: - PyDict

extension PyMemory {

  /// This type was automatically generated based on `PyDict` fields.
  internal struct PyDictLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.OrderedDictionary.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `dict` type.
  public func newDict(
    type: PyType,
    elements: PyDict.OrderedDictionary
  ) -> PyDict {
    let typeLayout = PyDict.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDict(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PyDict {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDict(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PyDictItemIterator

extension PyMemory {

  /// This type was automatically generated based on `PyDictItemIterator` fields.
  internal struct PyDictItemIteratorLayout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.self),
          FieldLayout(from: Int.self),
          FieldLayout(from: Int.self)
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

  /// Allocate a new instance of `dict_itemiterator` type.
  public func newDictItemIterator(
    type: PyType,
    dict: PyDict
  ) -> PyDictItemIterator {
    let typeLayout = PyDictItemIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictItemIterator(ptr: ptr)

    result.initialize(
      type: type,
      dict: dict
    )

    return result
  }
}

extension PyDictItemIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictItemIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
  }
}

// MARK: - PyDictItems

extension PyMemory {

  /// This type was automatically generated based on `PyDictItems` fields.
  internal struct PyDictItemsLayout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `dict_items` type.
  public func newDictItems(
    type: PyType,
    dict: PyDict
  ) -> PyDictItems {
    let typeLayout = PyDictItems.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictItems(ptr: ptr)

    result.initialize(
      type: type,
      dict: dict
    )

    return result
  }
}

extension PyDictItems {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictItems(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
  }
}

// MARK: - PyDictKeyIterator

extension PyMemory {

  /// This type was automatically generated based on `PyDictKeyIterator` fields.
  internal struct PyDictKeyIteratorLayout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.self),
          FieldLayout(from: Int.self),
          FieldLayout(from: Int.self)
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

  /// Allocate a new instance of `dict_keyiterator` type.
  public func newDictKeyIterator(
    type: PyType,
    dict: PyDict
  ) -> PyDictKeyIterator {
    let typeLayout = PyDictKeyIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictKeyIterator(ptr: ptr)

    result.initialize(
      type: type,
      dict: dict
    )

    return result
  }
}

extension PyDictKeyIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictKeyIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
  }
}

// MARK: - PyDictKeys

extension PyMemory {

  /// This type was automatically generated based on `PyDictKeys` fields.
  internal struct PyDictKeysLayout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `dict_keys` type.
  public func newDictKeys(
    type: PyType,
    dict: PyDict
  ) -> PyDictKeys {
    let typeLayout = PyDictKeys.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictKeys(ptr: ptr)

    result.initialize(
      type: type,
      dict: dict
    )

    return result
  }
}

extension PyDictKeys {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictKeys(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
  }
}

// MARK: - PyDictValueIterator

extension PyMemory {

  /// This type was automatically generated based on `PyDictValueIterator` fields.
  internal struct PyDictValueIteratorLayout {
    internal let dictOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.self),
          FieldLayout(from: Int.self),
          FieldLayout(from: Int.self)
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

  /// Allocate a new instance of `dict_valueiterator` type.
  public func newDictValueIterator(
    type: PyType,
    dict: PyDict
  ) -> PyDictValueIterator {
    let typeLayout = PyDictValueIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictValueIterator(ptr: ptr)

    result.initialize(
      type: type,
      dict: dict
    )

    return result
  }
}

extension PyDictValueIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictValueIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
  }
}

// MARK: - PyDictValues

extension PyMemory {

  /// This type was automatically generated based on `PyDictValues` fields.
  internal struct PyDictValuesLayout {
    internal let dictOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyDict.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.dictOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `dict_values` type.
  public func newDictValues(
    type: PyType,
    dict: PyDict
  ) -> PyDictValues {
    let typeLayout = PyDictValues.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyDictValues(ptr: ptr)

    result.initialize(
      type: type,
      dict: dict
    )

    return result
  }
}

extension PyDictValues {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyDictValues(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.dictPtr.deinitialize()
  }
}

// MARK: - PyEllipsis

extension PyMemory {

  /// This type was automatically generated based on `PyEllipsis` fields.
  internal struct PyEllipsisLayout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `ellipsis` type.
  public func newEllipsis(
    type: PyType
  ) -> PyEllipsis {
    let typeLayout = PyEllipsis.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyEllipsis(ptr: ptr)

    result.initialize(
      type: type
    )

    return result
  }
}

extension PyEllipsis {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyEllipsis(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

// MARK: - PyEnumerate

extension PyMemory {

  /// This type was automatically generated based on `PyEnumerate` fields.
  internal struct PyEnumerateLayout {
    internal let iteratorOffset: Int
    internal let nextIndexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: BigInt.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.iteratorOffset = layout.offsets[0]
      self.nextIndexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `enumerate` type.
  public func newEnumerate(
    type: PyType,
    iterator: PyObject,
    initialIndex: BigInt
  ) -> PyEnumerate {
    let typeLayout = PyEnumerate.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyEnumerate(ptr: ptr)

    result.initialize(
      type: type,
      iterator: iterator,
      initialIndex: initialIndex
    )

    return result
  }
}

extension PyEnumerate {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyEnumerate(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.iteratorPtr.deinitialize()
    zelf.nextIndexPtr.deinitialize()
  }
}

// MARK: - PyFilter

extension PyMemory {

  /// This type was automatically generated based on `PyFilter` fields.
  internal struct PyFilterLayout {
    internal let fnOffset: Int
    internal let iteratorOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: PyObject.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.fnOffset = layout.offsets[0]
      self.iteratorOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `filter` type.
  public func newFilter(
    type: PyType,
    fn: PyObject,
    iterator: PyObject
  ) -> PyFilter {
    let typeLayout = PyFilter.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFilter(ptr: ptr)

    result.initialize(
      type: type,
      fn: fn,
      iterator: iterator
    )

    return result
  }
}

extension PyFilter {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFilter(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.fnPtr.deinitialize()
    zelf.iteratorPtr.deinitialize()
  }
}

// MARK: - PyFloat

extension PyMemory {

  /// This type was automatically generated based on `PyFloat` fields.
  internal struct PyFloatLayout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: Double.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `float` type.
  public func newFloat(
    type: PyType,
    value: Double
  ) -> PyFloat {
    let typeLayout = PyFloat.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFloat(ptr: ptr)

    result.initialize(
      type: type,
      value: value
    )

    return result
  }
}

extension PyFloat {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFloat(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
  }
}

// MARK: - PyFrame

extension PyMemory {

  /// This type was automatically generated based on `PyFrame` fields.
  internal struct PyFrameLayout {
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
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyCode.self),
          FieldLayout(from: PyFrame?.self),
          FieldLayout(from: PyFrame.ObjectStack.self),
          FieldLayout(from: PyFrame.BlockStack.self),
          FieldLayout(from: PyDict.self),
          FieldLayout(from: PyDict.self),
          FieldLayout(from: PyDict.self),
          FieldLayout(from: [PyObject?].self),
          FieldLayout(from: [PyCell].self),
          FieldLayout(from: [PyCell].self),
          FieldLayout(from: Int?.self),
          FieldLayout(from: Int.self)
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

  /// Allocate a new instance of `frame` type.
  public func newFrame(
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
      type: type,
      code: code,
      locals: locals,
      globals: globals,
      parent: parent
    )

    return result
  }
}

extension PyFrame {
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

// MARK: - PyFrozenSet

extension PyMemory {

  /// This type was automatically generated based on `PyFrozenSet` fields.
  internal struct PyFrozenSetLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyFrozenSet.OrderedSet.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `frozenset` type.
  public func newFrozenSet(
    type: PyType,
    elements: PyFrozenSet.OrderedSet
  ) -> PyFrozenSet {
    let typeLayout = PyFrozenSet.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyFrozenSet(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PyFrozenSet {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFrozenSet(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PyFunction

extension PyMemory {

  /// This type was automatically generated based on `PyFunction` fields.
  internal struct PyFunctionLayout {
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
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyString.self),
          FieldLayout(from: PyString.self),
          FieldLayout(from: PyString?.self),
          FieldLayout(from: PyObject.self),
          FieldLayout(from: PyCode.self),
          FieldLayout(from: PyDict.self),
          FieldLayout(from: PyTuple?.self),
          FieldLayout(from: PyDict?.self),
          FieldLayout(from: PyTuple?.self),
          FieldLayout(from: PyDict?.self)
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

  /// Allocate a new instance of `function` type.
  public func newFunction(
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
      type: type,
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )

    return result
  }
}

extension PyFunction {
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

// MARK: - PyInt

extension PyMemory {

  /// This type was automatically generated based on `PyInt` fields.
  internal struct PyIntLayout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: BigInt.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `int` type.
  public func newInt(
    type: PyType,
    value: BigInt
  ) -> PyInt {
    let typeLayout = PyInt.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyInt(ptr: ptr)

    result.initialize(
      type: type,
      value: value
    )

    return result
  }
}

extension PyInt {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyInt(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
  }
}

// MARK: - PyIterator

extension PyMemory {

  /// This type was automatically generated based on `PyIterator` fields.
  internal struct PyIteratorLayout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.sequenceOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `iterator` type.
  public func newIterator(
    type: PyType,
    sequence: PyObject
  ) -> PyIterator {
    let typeLayout = PyIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyIterator(ptr: ptr)

    result.initialize(
      type: type,
      sequence: sequence
    )

    return result
  }
}

extension PyIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PyList

extension PyMemory {

  /// This type was automatically generated based on `PyList` fields.
  internal struct PyListLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: [PyObject].self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `list` type.
  public func newList(
    type: PyType,
    elements: [PyObject]
  ) -> PyList {
    let typeLayout = PyList.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyList(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PyList {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyList(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PyListIterator

extension PyMemory {

  /// This type was automatically generated based on `PyListIterator` fields.
  internal struct PyListIteratorLayout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyList.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.listOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `list_iterator` type.
  public func newListIterator(
    type: PyType,
    list: PyList
  ) -> PyListIterator {
    let typeLayout = PyListIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyListIterator(ptr: ptr)

    result.initialize(
      type: type,
      list: list
    )

    return result
  }
}

extension PyListIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyListIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PyListReverseIterator

extension PyMemory {

  /// This type was automatically generated based on `PyListReverseIterator` fields.
  internal struct PyListReverseIteratorLayout {
    internal let listOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyList.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.listOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `list_reverseiterator` type.
  public func newListReverseIterator(
    type: PyType,
    list: PyList
  ) -> PyListReverseIterator {
    let typeLayout = PyListReverseIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyListReverseIterator(ptr: ptr)

    result.initialize(
      type: type,
      list: list
    )

    return result
  }
}

extension PyListReverseIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyListReverseIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PyMap

extension PyMemory {

  /// This type was automatically generated based on `PyMap` fields.
  internal struct PyMapLayout {
    internal let fnOffset: Int
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: [PyObject].self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.fnOffset = layout.offsets[0]
      self.iteratorsOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `map` type.
  public func newMap(
    type: PyType,
    fn: PyObject,
    iterators: [PyObject]
  ) -> PyMap {
    let typeLayout = PyMap.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyMap(ptr: ptr)

    result.initialize(
      type: type,
      fn: fn,
      iterators: iterators
    )

    return result
  }
}

extension PyMap {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyMap(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.fnPtr.deinitialize()
    zelf.iteratorsPtr.deinitialize()
  }
}

// MARK: - PyMethod

extension PyMemory {

  /// This type was automatically generated based on `PyMethod` fields.
  internal struct PyMethodLayout {
    internal let functionOffset: Int
    internal let objectOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyFunction.self),
          FieldLayout(from: PyObject.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.functionOffset = layout.offsets[0]
      self.objectOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `method` type.
  public func newMethod(
    type: PyType,
    function: PyFunction,
    object: PyObject
  ) -> PyMethod {
    let typeLayout = PyMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyMethod(ptr: ptr)

    result.initialize(
      type: type,
      function: function,
      object: object
    )

    return result
  }
}

extension PyMethod {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.functionPtr.deinitialize()
    zelf.objectPtr.deinitialize()
  }
}

// MARK: - PyModule

extension PyMemory {

  /// This type was automatically generated based on `PyModule` fields.
  internal struct PyModuleLayout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `module` type.
  public func newModule(
    type: PyType,
    name: PyObject?,
    doc: PyObject?,
    __dict__: PyDict? = nil
  ) -> PyModule {
    let typeLayout = PyModule.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyModule(ptr: ptr)

    result.initialize(
      type: type,
      name: name,
      doc: doc,
      __dict__: __dict__
    )

    return result
  }
}

extension PyModule {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyModule(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

// MARK: - PyNamespace

extension PyMemory {

  /// This type was automatically generated based on `PyNamespace` fields.
  internal struct PyNamespaceLayout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `SimpleNamespace` type.
  public func newNamespace(
    type: PyType,
    __dict__: PyDict?
  ) -> PyNamespace {
    let typeLayout = PyNamespace.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNamespace(ptr: ptr)

    result.initialize(
      type: type,
      __dict__: __dict__
    )

    return result
  }
}

extension PyNamespace {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNamespace(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

// MARK: - PyNone

extension PyMemory {

  /// This type was automatically generated based on `PyNone` fields.
  internal struct PyNoneLayout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `NoneType` type.
  public func newNone(
    type: PyType
  ) -> PyNone {
    let typeLayout = PyNone.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNone(ptr: ptr)

    result.initialize(
      type: type
    )

    return result
  }
}

extension PyNone {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNone(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

// MARK: - PyNotImplemented

extension PyMemory {

  /// This type was automatically generated based on `PyNotImplemented` fields.
  internal struct PyNotImplementedLayout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `NotImplementedType` type.
  public func newNotImplemented(
    type: PyType
  ) -> PyNotImplemented {
    let typeLayout = PyNotImplemented.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyNotImplemented(ptr: ptr)

    result.initialize(
      type: type
    )

    return result
  }
}

extension PyNotImplemented {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNotImplemented(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

// MARK: - PyObject

extension PyMemory {

  /// This type was automatically generated based on `PyObject` fields.
  internal struct PyObjectLayout {
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: []
      )

      assert(layout.offsets.count == 0)
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `object` type.
  public func newObject(
    type: PyType
  ) -> PyObject {
    let typeLayout = PyObject.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyObject(ptr: ptr)

    result.initialize(
      type: type
    )

    return result
  }
}

extension PyObject {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyObject(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
  }
}

// MARK: - PyProperty

extension PyMemory {

  /// This type was automatically generated based on `PyProperty` fields.
  internal struct PyPropertyLayout {
    internal let _getOffset: Int
    internal let _setOffset: Int
    internal let _delOffset: Int
    internal let docOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject?.self),
          FieldLayout(from: PyObject?.self),
          FieldLayout(from: PyObject?.self),
          FieldLayout(from: PyObject?.self)
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

  /// Allocate a new instance of `property` type.
  public func newProperty(
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
      type: type,
      get: get,
      set: set,
      del: del,
      doc: doc
    )

    return result
  }
}

extension PyProperty {
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

// MARK: - PyRange

extension PyMemory {

  /// This type was automatically generated based on `PyRange` fields.
  internal struct PyRangeLayout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyInt.self),
          FieldLayout(from: PyInt.self),
          FieldLayout(from: PyInt.self),
          FieldLayout(from: PyInt.self)
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

  /// Allocate a new instance of `range` type.
  public func newRange(
    type: PyType,
    start: PyInt,
    stop: PyInt,
    step: PyInt?
  ) -> PyRange {
    let typeLayout = PyRange.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRange(ptr: ptr)

    result.initialize(
      type: type,
      start: start,
      stop: stop,
      step: step
    )

    return result
  }
}

extension PyRange {
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

// MARK: - PyRangeIterator

extension PyMemory {

  /// This type was automatically generated based on `PyRangeIterator` fields.
  internal struct PyRangeIteratorLayout {
    internal let startOffset: Int
    internal let stepOffset: Int
    internal let lengthOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: BigInt.self),
          FieldLayout(from: BigInt.self),
          FieldLayout(from: BigInt.self),
          FieldLayout(from: BigInt.self)
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

  /// Allocate a new instance of `range_iterator` type.
  public func newRangeIterator(
    type: PyType,
    start: BigInt,
    step: BigInt,
    length: BigInt
  ) -> PyRangeIterator {
    let typeLayout = PyRangeIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyRangeIterator(ptr: ptr)

    result.initialize(
      type: type,
      start: start,
      step: step,
      length: length
    )

    return result
  }
}

extension PyRangeIterator {
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

// MARK: - PyReversed

extension PyMemory {

  /// This type was automatically generated based on `PyReversed` fields.
  internal struct PyReversedLayout {
    internal let sequenceOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.sequenceOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `reversed` type.
  public func newReversed(
    type: PyType,
    sequence: PyObject,
    count: Int
  ) -> PyReversed {
    let typeLayout = PyReversed.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyReversed(ptr: ptr)

    result.initialize(
      type: type,
      sequence: sequence,
      count: count
    )

    return result
  }
}

extension PyReversed {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyReversed(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PySet

extension PyMemory {

  /// This type was automatically generated based on `PySet` fields.
  internal struct PySetLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PySet.OrderedSet.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `set` type.
  public func newSet(
    type: PyType,
    elements: PySet.OrderedSet
  ) -> PySet {
    let typeLayout = PySet.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySet(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PySet {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySet(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PySetIterator

extension PyMemory {

  /// This type was automatically generated based on `PySetIterator` fields.
  internal struct PySetIteratorLayout {
    internal let setOffset: Int
    internal let indexOffset: Int
    internal let initialCountOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyAnySet.self),
          FieldLayout(from: Int.self),
          FieldLayout(from: Int.self)
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

  /// Allocate a new instance of `set_iterator` type.
  public func newSetIterator(
    type: PyType,
    set: PySet
  ) -> PySetIterator {
    let typeLayout = PySetIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySetIterator(ptr: ptr)

    result.initialize(
      type: type,
      set: set
    )

    return result
  }

  /// Allocate a new instance of `set_iterator` type.
  public func newSetIterator(
    type: PyType,
    frozenSet: PyFrozenSet
  ) -> PySetIterator {
    let typeLayout = PySetIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySetIterator(ptr: ptr)

    result.initialize(
      type: type,
      frozenSet: frozenSet
    )

    return result
  }
}

extension PySetIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySetIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.setPtr.deinitialize()
    zelf.indexPtr.deinitialize()
    zelf.initialCountPtr.deinitialize()
  }
}

// MARK: - PySlice

extension PyMemory {

  /// This type was automatically generated based on `PySlice` fields.
  internal struct PySliceLayout {
    internal let startOffset: Int
    internal let stopOffset: Int
    internal let stepOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject.self),
          FieldLayout(from: PyObject.self),
          FieldLayout(from: PyObject.self)
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

  /// Allocate a new instance of `slice` type.
  public func newSlice(
    type: PyType,
    start: PyObject,
    stop: PyObject,
    step: PyObject
  ) -> PySlice {
    let typeLayout = PySlice.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySlice(ptr: ptr)

    result.initialize(
      type: type,
      start: start,
      stop: stop,
      step: step
    )

    return result
  }
}

extension PySlice {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySlice(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.startPtr.deinitialize()
    zelf.stopPtr.deinitialize()
    zelf.stepPtr.deinitialize()
  }
}

// MARK: - PyStaticMethod

extension PyMemory {

  /// This type was automatically generated based on `PyStaticMethod` fields.
  internal struct PyStaticMethodLayout {
    internal let callableOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyObject?.self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.callableOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `staticmethod` type.
  public func newStaticMethod(
    type: PyType,
    callable: PyObject?
  ) -> PyStaticMethod {
    let typeLayout = PyStaticMethod.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStaticMethod(ptr: ptr)

    result.initialize(
      type: type,
      callable: callable
    )

    return result
  }
}

extension PyStaticMethod {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyStaticMethod(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
  }
}

// MARK: - PyString

extension PyMemory {

  /// This type was automatically generated based on `PyString` fields.
  internal struct PyStringLayout {
    internal let valueOffset: Int
    internal let cachedCountOffset: Int
    internal let cachedHashOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: String.self),
          FieldLayout(from: Int.self),
          FieldLayout(from: PyHash.self)
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

  /// Allocate a new instance of `str` type.
  public func newString(
    type: PyType,
    value: String
  ) -> PyString {
    let typeLayout = PyString.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyString(ptr: ptr)

    result.initialize(
      type: type,
      value: value
    )

    return result
  }
}

extension PyString {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyString(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.valuePtr.deinitialize()
    zelf.cachedCountPtr.deinitialize()
    zelf.cachedHashPtr.deinitialize()
  }
}

// MARK: - PyStringIterator

extension PyMemory {

  /// This type was automatically generated based on `PyStringIterator` fields.
  internal struct PyStringIteratorLayout {
    internal let stringOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyString.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.stringOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `str_iterator` type.
  public func newStringIterator(
    type: PyType,
    string: PyString
  ) -> PyStringIterator {
    let typeLayout = PyStringIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyStringIterator(ptr: ptr)

    result.initialize(
      type: type,
      string: string
    )

    return result
  }
}

extension PyStringIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyStringIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.stringPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PySuper

extension PyMemory {

  /// This type was automatically generated based on `PySuper` fields.
  internal struct PySuperLayout {
    internal let thisClassOffset: Int
    internal let objectOffset: Int
    internal let objectTypeOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyType?.self),
          FieldLayout(from: PyObject?.self),
          FieldLayout(from: PyType?.self)
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

  /// Allocate a new instance of `super` type.
  public func newSuper(
    type: PyType,
    requestedType: PyType?,
    object: PyObject?,
    objectType: PyType?
  ) -> PySuper {
    let typeLayout = PySuper.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PySuper(ptr: ptr)

    result.initialize(
      type: type,
      requestedType: requestedType,
      object: object,
      objectType: objectType
    )

    return result
  }
}

extension PySuper {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PySuper(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.thisClassPtr.deinitialize()
    zelf.objectPtr.deinitialize()
    zelf.objectTypePtr.deinitialize()
  }
}

// MARK: - PyTextFile

extension PyMemory {

  /// This type was automatically generated based on `PyTextFile` fields.
  internal struct PyTextFileLayout {
    internal let nameOffset: Int
    internal let fdOffset: Int
    internal let modeOffset: Int
    internal let encodingOffset: Int
    internal let errorHandlingOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: String?.self),
          FieldLayout(from: FileDescriptorType.self),
          FieldLayout(from: FileMode.self),
          FieldLayout(from: PyString.Encoding.self),
          FieldLayout(from: PyString.ErrorHandling.self)
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

  /// Allocate a new instance of `TextFile` type.
  public func newTextFile(
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

extension PyTextFile {
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

// MARK: - PyTuple

extension PyMemory {

  /// This type was automatically generated based on `PyTuple` fields.
  internal struct PyTupleLayout {
    internal let elementsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: [PyObject].self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.elementsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `tuple` type.
  public func newTuple(
    type: PyType,
    elements: [PyObject]
  ) -> PyTuple {
    let typeLayout = PyTuple.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTuple(ptr: ptr)

    result.initialize(
      type: type,
      elements: elements
    )

    return result
  }
}

extension PyTuple {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTuple(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.elementsPtr.deinitialize()
  }
}

// MARK: - PyTupleIterator

extension PyMemory {

  /// This type was automatically generated based on `PyTupleIterator` fields.
  internal struct PyTupleIteratorLayout {
    internal let tupleOffset: Int
    internal let indexOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: PyTuple.self),
          FieldLayout(from: Int.self)
        ]
      )

      assert(layout.offsets.count == 2)
      self.tupleOffset = layout.offsets[0]
      self.indexOffset = layout.offsets[1]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `tuple_iterator` type.
  public func newTupleIterator(
    type: PyType,
    tuple: PyTuple
  ) -> PyTupleIterator {
    let typeLayout = PyTupleIterator.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyTupleIterator(ptr: ptr)

    result.initialize(
      type: type,
      tuple: tuple
    )

    return result
  }
}

extension PyTupleIterator {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTupleIterator(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.tuplePtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }
}

// MARK: - PyType

extension PyMemory {

  /// This type was automatically generated based on `PyType` fields.
  internal struct PyTypeLayout {
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
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: String.self),
          FieldLayout(from: String.self),
          FieldLayout(from: PyType?.self),
          FieldLayout(from: [PyType].self),
          FieldLayout(from: [PyType].self),
          FieldLayout(from: [PyType].self),
          FieldLayout(from: PyType.MemoryLayout.self),
          FieldLayout(from: PyType.StaticallyKnownNotOverriddenMethods.self),
          FieldLayout(from: PyType.DebugFn.self),
          FieldLayout(from: PyType.DeinitializeFn.self)
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

  /// Allocate a new instance of `type` type.
  public func newType(
    type: PyType,
    name: String,
    qualname: String,
    flags: PyType.TypeFlags,
    base: PyType?,
    bases: [PyType],
    mroWithoutSelf: [PyType],
    subclasses: [PyType],
    layout: PyType.MemoryLayout,
    staticMethods: PyType.StaticallyKnownNotOverriddenMethods,
    debugFn: @escaping PyType.DebugFn,
    deinitialize: @escaping PyType.DeinitializeFn
  ) -> PyType {
    let typeLayout = PyType.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyType(ptr: ptr)

    result.initialize(
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

extension PyType {
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

// MARK: - PyZip

extension PyMemory {

  /// This type was automatically generated based on `PyZip` fields.
  internal struct PyZipLayout {
    internal let iteratorsOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      let layout = PyMemory.GenericLayout(
        initialOffset: PyObjectHeader.Layout.size,
        initialAlignment: PyObjectHeader.Layout.alignment,
        fields: [
          FieldLayout(from: [PyObject].self)
        ]
      )

      assert(layout.offsets.count == 1)
      self.iteratorsOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Allocate a new instance of `zip` type.
  public func newZip(
    type: PyType,
    iterators: [PyObject]
  ) -> PyZip {
    let typeLayout = PyZip.layout
    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)
    let result = PyZip(ptr: ptr)

    result.initialize(
      type: type,
      iterators: iterators
    )

    return result
  }
}

extension PyZip {
  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyZip(ptr: ptr)
    zelf.beforeDeinitialize()

    zelf.header.deinitialize()
    zelf.iteratorsPtr.deinitialize()
  }
}

