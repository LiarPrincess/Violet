// =========================================================================
// Automatically generated from: ./Sources/Objects/Generated/Py+Generated.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =========================================================================

import Foundation
import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

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
      let layout = PyMemory.GenericLayout(
        initialOffset: 0,
        initialAlignment: 0,
        fields: [
          PyMemory.FieldLayout(from: PyBool.self), // true
          PyMemory.FieldLayout(from: PyBool.self), // false
          PyMemory.FieldLayout(from: PyNone.self), // none
          PyMemory.FieldLayout(from: PyNotImplemented.self), // notImplemented
          PyMemory.FieldLayout(from: PyEllipsis.self), // ellipsis
          PyMemory.FieldLayout(from: PyTuple.self), // emptyTuple
          PyMemory.FieldLayout(from: PyString.self), // emptyString
          PyMemory.FieldLayout(from: PyBytes.self), // emptyBytes
          PyMemory.FieldLayout(from: PyFrozenSet.self), // emptyFrozenSet
          PyMemory.FieldLayout(from: [PyInt].self), // internedInts
          PyMemory.FieldLayout(from: [UseScalarsToHashString: PyString].self), // internedStrings
          PyMemory.FieldLayout(from: Builtins.self), // builtins
          PyMemory.FieldLayout(from: Sys.self), // sys
          PyMemory.FieldLayout(from: UnderscoreImp.self), // _imp
          PyMemory.FieldLayout(from: UnderscoreWarnings.self), // _warnings
          PyMemory.FieldLayout(from: UnderscoreOS.self), // _os
          PyMemory.FieldLayout(from: PyModule.self), // builtinsModule
          PyMemory.FieldLayout(from: PyModule.self), // sysModule
          PyMemory.FieldLayout(from: PyModule.self), // _impModule
          PyMemory.FieldLayout(from: PyModule.self), // _warningsModule
          PyMemory.FieldLayout(from: PyModule.self), // _osModule
          PyMemory.FieldLayout(from: Py.Types.self), // types
          PyMemory.FieldLayout(from: Py.ErrorTypes.self), // errorTypes
          PyMemory.FieldLayout(from: PyConfig.self), // config
          PyMemory.FieldLayout(from: PyDelegate.self), // delegate
          PyMemory.FieldLayout(from: PyFileSystem.self), // fileSystem
          PyMemory.FieldLayout(from: PyMemory.self), // memory
          PyMemory.FieldLayout(from: PyCast.self), // cast
          PyMemory.FieldLayout(from: Hasher.self) // hasher
        ]
      )

      assert(layout.offsets.count == 29)
      self.trueOffset = layout.offsets[0]
      self.falseOffset = layout.offsets[1]
      self.noneOffset = layout.offsets[2]
      self.notImplementedOffset = layout.offsets[3]
      self.ellipsisOffset = layout.offsets[4]
      self.emptyTupleOffset = layout.offsets[5]
      self.emptyStringOffset = layout.offsets[6]
      self.emptyBytesOffset = layout.offsets[7]
      self.emptyFrozenSetOffset = layout.offsets[8]
      self.internedIntsOffset = layout.offsets[9]
      self.internedStringsOffset = layout.offsets[10]
      self.builtinsOffset = layout.offsets[11]
      self.sysOffset = layout.offsets[12]
      self._impOffset = layout.offsets[13]
      self._warningsOffset = layout.offsets[14]
      self._osOffset = layout.offsets[15]
      self.builtinsModuleOffset = layout.offsets[16]
      self.sysModuleOffset = layout.offsets[17]
      self._impModuleOffset = layout.offsets[18]
      self._warningsModuleOffset = layout.offsets[19]
      self._osModuleOffset = layout.offsets[20]
      self.typesOffset = layout.offsets[21]
      self.errorTypesOffset = layout.offsets[22]
      self.configOffset = layout.offsets[23]
      self.delegateOffset = layout.offsets[24]
      self.fileSystemOffset = layout.offsets[25]
      self.memoryOffset = layout.offsets[26]
      self.castOffset = layout.offsets[27]
      self.hasherOffset = layout.offsets[28]
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
  internal var delegatePtr: Ptr<PyDelegate> { Ptr(self.ptr, offset: Self.layout.delegateOffset) }
  /// Property: `Py.fileSystem`.
  internal var fileSystemPtr: Ptr<PyFileSystem> { Ptr(self.ptr, offset: Self.layout.fileSystemOffset) }
  /// Property: `Py.memory`.
  internal var memoryPtr: Ptr<PyMemory> { Ptr(self.ptr, offset: Self.layout.memoryOffset) }
  /// Property: `Py.cast`.
  internal var castPtr: Ptr<PyCast> { Ptr(self.ptr, offset: Self.layout.castOffset) }
  /// Property: `Py.hasher`.
  internal var hasherPtr: Ptr<Hasher> { Ptr(self.ptr, offset: Self.layout.hasherOffset) }
}

