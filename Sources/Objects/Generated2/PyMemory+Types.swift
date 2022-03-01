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

