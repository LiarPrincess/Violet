// =========================================================================
// Automatically generated from: ./Sources/Objects/Generated/Py+Generated.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =========================================================================

import Foundation
import BigInt
import VioletCore
import VioletBytecode

// swiftlint:disable function_body_length
// swiftlint:disable line_length

extension Py {

  // MARK: - Layout

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `Py` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let trueOffset: Int
    internal let falseOffset: Int
    internal let noneOffset: Int
    internal let notImplementedOffset: Int
    internal let ellipsisOffset: Int
    internal let emptyTupleOffset: Int
    internal let emptyStringOffset: Int
    internal let emptyBytesOffset: Int
    internal let emptyFrozenSetOffset: Int
    internal let idStringsOffset: Int
    internal let internedIntsOffset: Int
    internal let internedStringsOffset: Int
    internal let builtinsOffset: Int
    internal let sysOffset: Int
    internal let _impOffset: Int
    internal let _warningsOffset: Int
    internal let _osOffset: Int
    internal let builtinsModuleOffset: Int
    internal let sysModuleOffset: Int
    internal let _impModuleOffset: Int
    internal let _warningsModuleOffset: Int
    internal let _osModuleOffset: Int
    internal let typesOffset: Int
    internal let errorTypesOffset: Int
    internal let configOffset: Int
    internal let delegateOffset: Int
    internal let fileSystemOffset: Int
    internal let memoryOffset: Int
    internal let castOffset: Int
    internal let hasherOffset: Int

    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<Py>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")
      let layout = GenericLayout(
        initialOffset: 0,
        initialAlignment: 0,
        fields: [
          GenericLayout.Field(PyBool.self), // true
          GenericLayout.Field(PyBool.self), // false
          GenericLayout.Field(PyNone.self), // none
          GenericLayout.Field(PyNotImplemented.self), // notImplemented
          GenericLayout.Field(PyEllipsis.self), // ellipsis
          GenericLayout.Field(PyTuple.self), // emptyTuple
          GenericLayout.Field(PyString.self), // emptyString
          GenericLayout.Field(PyBytes.self), // emptyBytes
          GenericLayout.Field(PyFrozenSet.self), // emptyFrozenSet
          GenericLayout.Field(IdString.Collection.self), // idStrings
          GenericLayout.Field([PyInt].self), // internedInts
          GenericLayout.Field([UseScalarsToHashString: PyString].self), // internedStrings
          GenericLayout.Field(Builtins.self), // builtins
          GenericLayout.Field(Sys.self), // sys
          GenericLayout.Field(UnderscoreImp.self), // _imp
          GenericLayout.Field(UnderscoreWarnings.self), // _warnings
          GenericLayout.Field(UnderscoreOS.self), // _os
          GenericLayout.Field(PyModule.self), // builtinsModule
          GenericLayout.Field(PyModule.self), // sysModule
          GenericLayout.Field(PyModule.self), // _impModule
          GenericLayout.Field(PyModule.self), // _warningsModule
          GenericLayout.Field(PyModule.self), // _osModule
          GenericLayout.Field(Py.Types.self), // types
          GenericLayout.Field(Py.ErrorTypes.self), // errorTypes
          GenericLayout.Field(PyConfig.self), // config
          GenericLayout.Field(PyDelegateType.self), // delegate
          GenericLayout.Field(PyFileSystemType.self), // fileSystem
          GenericLayout.Field(PyMemory.self), // memory
          GenericLayout.Field(PyCast.self), // cast
          GenericLayout.Field(Hasher.self) // hasher
        ]
      )

      assert(layout.offsets.count == 30)
      self.trueOffset = layout.offsets[0]
      self.falseOffset = layout.offsets[1]
      self.noneOffset = layout.offsets[2]
      self.notImplementedOffset = layout.offsets[3]
      self.ellipsisOffset = layout.offsets[4]
      self.emptyTupleOffset = layout.offsets[5]
      self.emptyStringOffset = layout.offsets[6]
      self.emptyBytesOffset = layout.offsets[7]
      self.emptyFrozenSetOffset = layout.offsets[8]
      self.idStringsOffset = layout.offsets[9]
      self.internedIntsOffset = layout.offsets[10]
      self.internedStringsOffset = layout.offsets[11]
      self.builtinsOffset = layout.offsets[12]
      self.sysOffset = layout.offsets[13]
      self._impOffset = layout.offsets[14]
      self._warningsOffset = layout.offsets[15]
      self._osOffset = layout.offsets[16]
      self.builtinsModuleOffset = layout.offsets[17]
      self.sysModuleOffset = layout.offsets[18]
      self._impModuleOffset = layout.offsets[19]
      self._warningsModuleOffset = layout.offsets[20]
      self._osModuleOffset = layout.offsets[21]
      self.typesOffset = layout.offsets[22]
      self.errorTypesOffset = layout.offsets[23]
      self.configOffset = layout.offsets[24]
      self.delegateOffset = layout.offsets[25]
      self.fileSystemOffset = layout.offsets[26]
      self.memoryOffset = layout.offsets[27]
      self.castOffset = layout.offsets[28]
      self.hasherOffset = layout.offsets[29]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property: `Py.true`.
  internal var truePtr: Ptr<PyBool> { Ptr(self.ptr, offset: Self.layout.trueOffset) }
  /// Property: `Py.false`.
  internal var falsePtr: Ptr<PyBool> { Ptr(self.ptr, offset: Self.layout.falseOffset) }
  /// Property: `Py.none`.
  internal var nonePtr: Ptr<PyNone> { Ptr(self.ptr, offset: Self.layout.noneOffset) }
  /// Property: `Py.notImplemented`.
  internal var notImplementedPtr: Ptr<PyNotImplemented> { Ptr(self.ptr, offset: Self.layout.notImplementedOffset) }
  /// Property: `Py.ellipsis`.
  internal var ellipsisPtr: Ptr<PyEllipsis> { Ptr(self.ptr, offset: Self.layout.ellipsisOffset) }
  /// Property: `Py.emptyTuple`.
  internal var emptyTuplePtr: Ptr<PyTuple> { Ptr(self.ptr, offset: Self.layout.emptyTupleOffset) }
  /// Property: `Py.emptyString`.
  internal var emptyStringPtr: Ptr<PyString> { Ptr(self.ptr, offset: Self.layout.emptyStringOffset) }
  /// Property: `Py.emptyBytes`.
  internal var emptyBytesPtr: Ptr<PyBytes> { Ptr(self.ptr, offset: Self.layout.emptyBytesOffset) }
  /// Property: `Py.emptyFrozenSet`.
  internal var emptyFrozenSetPtr: Ptr<PyFrozenSet> { Ptr(self.ptr, offset: Self.layout.emptyFrozenSetOffset) }
  /// Property: `Py.idStrings`.
  internal var idStringsPtr: Ptr<IdString.Collection> { Ptr(self.ptr, offset: Self.layout.idStringsOffset) }
  /// Property: `Py.internedInts`.
  internal var internedIntsPtr: Ptr<[PyInt]> { Ptr(self.ptr, offset: Self.layout.internedIntsOffset) }
  /// Property: `Py.internedStrings`.
  internal var internedStringsPtr: Ptr<[UseScalarsToHashString: PyString]> { Ptr(self.ptr, offset: Self.layout.internedStringsOffset) }
  /// Property: `Py.builtins`.
  internal var builtinsPtr: Ptr<Builtins> { Ptr(self.ptr, offset: Self.layout.builtinsOffset) }
  /// Property: `Py.sys`.
  internal var sysPtr: Ptr<Sys> { Ptr(self.ptr, offset: Self.layout.sysOffset) }
  /// Property: `Py._imp`.
  internal var _impPtr: Ptr<UnderscoreImp> { Ptr(self.ptr, offset: Self.layout._impOffset) }
  /// Property: `Py._warnings`.
  internal var _warningsPtr: Ptr<UnderscoreWarnings> { Ptr(self.ptr, offset: Self.layout._warningsOffset) }
  /// Property: `Py._os`.
  internal var _osPtr: Ptr<UnderscoreOS> { Ptr(self.ptr, offset: Self.layout._osOffset) }
  /// Property: `Py.builtinsModule`.
  internal var builtinsModulePtr: Ptr<PyModule> { Ptr(self.ptr, offset: Self.layout.builtinsModuleOffset) }
  /// Property: `Py.sysModule`.
  internal var sysModulePtr: Ptr<PyModule> { Ptr(self.ptr, offset: Self.layout.sysModuleOffset) }
  /// Property: `Py._impModule`.
  internal var _impModulePtr: Ptr<PyModule> { Ptr(self.ptr, offset: Self.layout._impModuleOffset) }
  /// Property: `Py._warningsModule`.
  internal var _warningsModulePtr: Ptr<PyModule> { Ptr(self.ptr, offset: Self.layout._warningsModuleOffset) }
  /// Property: `Py._osModule`.
  internal var _osModulePtr: Ptr<PyModule> { Ptr(self.ptr, offset: Self.layout._osModuleOffset) }
  /// Property: `Py.types`.
  internal var typesPtr: Ptr<Py.Types> { Ptr(self.ptr, offset: Self.layout.typesOffset) }
  /// Property: `Py.errorTypes`.
  internal var errorTypesPtr: Ptr<Py.ErrorTypes> { Ptr(self.ptr, offset: Self.layout.errorTypesOffset) }
  /// Property: `Py.config`.
  internal var configPtr: Ptr<PyConfig> { Ptr(self.ptr, offset: Self.layout.configOffset) }
  /// Property: `Py.delegate`.
  internal var delegatePtr: Ptr<PyDelegateType> { Ptr(self.ptr, offset: Self.layout.delegateOffset) }
  /// Property: `Py.fileSystem`.
  internal var fileSystemPtr: Ptr<PyFileSystemType> { Ptr(self.ptr, offset: Self.layout.fileSystemOffset) }
  /// Property: `Py.memory`.
  internal var memoryPtr: Ptr<PyMemory> { Ptr(self.ptr, offset: Self.layout.memoryOffset) }
  /// Property: `Py.cast`.
  internal var castPtr: Ptr<PyCast> { Ptr(self.ptr, offset: Self.layout.castOffset) }
  /// Property: `Py.hasher`.
  internal var hasherPtr: Ptr<Hasher> { Ptr(self.ptr, offset: Self.layout.hasherOffset) }

  internal func deinitialize() {
    self.truePtr.deinitialize()
    self.falsePtr.deinitialize()
    self.nonePtr.deinitialize()
    self.notImplementedPtr.deinitialize()
    self.ellipsisPtr.deinitialize()
    self.emptyTuplePtr.deinitialize()
    self.emptyStringPtr.deinitialize()
    self.emptyBytesPtr.deinitialize()
    self.emptyFrozenSetPtr.deinitialize()
    self.idStringsPtr.deinitialize()
    self.internedIntsPtr.deinitialize()
    self.internedStringsPtr.deinitialize()
    self.builtinsPtr.deinitialize()
    self.sysPtr.deinitialize()
    self._impPtr.deinitialize()
    self._warningsPtr.deinitialize()
    self._osPtr.deinitialize()
    self.builtinsModulePtr.deinitialize()
    self.sysModulePtr.deinitialize()
    self._impModulePtr.deinitialize()
    self._warningsModulePtr.deinitialize()
    self._osModulePtr.deinitialize()
    self.typesPtr.deinitialize()
    self.errorTypesPtr.deinitialize()
    self.configPtr.deinitialize()
    self.delegatePtr.deinitialize()
    self.fileSystemPtr.deinitialize()
    self.memoryPtr.deinitialize()
    self.castPtr.deinitialize()
    self.hasherPtr.deinitialize()
  }
}
