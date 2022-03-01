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
// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

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
  public static func deinitialize(ptr: RawPtr) {
    let zelf = PyObject(ptr: ptr)
    zelf.beforeDeinitialize()
    zelf.header.deinitialize()
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
    base: PyType?,
    bases: [PyType],
    mro: [PyType],
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
      base: base,
      bases: bases,
      mro: mro,
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
  public static func deinitialize(ptr: RawPtr) {
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

