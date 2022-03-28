extension PyFrame {

  private typealias GenericField = GenericLayout.Field
  private typealias BlockStackEnd = BlockStackProxy.EndPtr
  private typealias Metadata = FastLocalsCellFreeBlockStackStorage.Metadata

  // MARK: - Allocate

  internal func allocateFastLocalsCellFreeBlockStackStorage(code: PyCode) -> RawPtr {
    let fastLocalsCount = code.variableCount
    let cellVariableCount = code.cellVariableCount
    let freeVariableCount = code.freeVariableCount
    let blockStackCount = Self.maxBlockStackCount

    let layout = GenericLayout(initialOffset: 0, initialAlignment: 0, fields: [
      GenericField(FastLocalsCellFreeBlockStackStorage.Metadata.self), // 0: metadata
      GenericField(FastLocal.self, repeatCount: fastLocalsCount), // 1: fastLocals
      GenericField(Cell.self, repeatCount: cellVariableCount), // 2: cells
      GenericField(Cell.self, repeatCount: freeVariableCount), // 3: free
      GenericField(BlockStackEnd.self), // 4: blockStackEnd
      GenericField(Block.self, repeatCount: blockStackCount) // 5: blockStack
    ])

    assert(layout.offsets.count == 6)
    let ptr = PyMemory.allocate(byteCount: layout.size, alignment: layout.alignment)

    let metadata = Metadata(
      fastLocalsOffset: layout.offsets[1],
      fastLocalsCount: fastLocalsCount,
      cellVariablesOffset: layout.offsets[2],
      cellVariableCount: cellVariableCount,
      freeVariablesOffset: layout.offsets[3],
      freeVariableCount: freeVariableCount,
      blockStackEndOffset: layout.offsets[4],
      blockStackOffset: layout.offsets[5],
      blockStackCount: blockStackCount
    )

    let metadataPtr = Ptr<Metadata>(ptr, offset: 0)
    metadataPtr.initialize(to: metadata)

    return ptr
  }

  // MARK: - Deallocate

  internal func deallocateFastLocalsCellFreeBlockStackStorage() {
    // All of those things are trivial, but we will 'deinitialize' them anyway.
    let storage = self.fastLocalsCellFreeBlockStackStorage
    storage.fastLocals.deinitialize()
    storage.cellVariables.deinitialize()
    storage.freeVariables.deinitialize()
    storage.blockStackEnd.deinitialize()
    storage.blockStack.deinitialize()
    storage.metadataPtr.deinitialize()

    // Free memory.
    self.fastLocalsCellFreeBlockStackStoragePtr.deallocate()
  }

  // MARK: - Storage

  /// Fast locals, cell/free variables and block stack are stored in a single
  /// allocation.
  internal struct FastLocalsCellFreeBlockStackStorage {

    // swiftlint:disable:next nesting
    fileprivate struct Metadata {
      fileprivate let fastLocalsOffset: Int
      fileprivate let fastLocalsCount: Int
      fileprivate let cellVariablesOffset: Int
      fileprivate let cellVariableCount: Int
      fileprivate let freeVariablesOffset: Int
      fileprivate let freeVariableCount: Int
      fileprivate let blockStackEndOffset: Int
      fileprivate let blockStackOffset: Int
      fileprivate let blockStackCount: Int
    }

    fileprivate var metadataPtr: Ptr<Metadata> {
      return Ptr<Metadata>(self.ptr, offset: 0)
    }

    fileprivate var metadata: Metadata {
      return self.metadataPtr.pointee
    }

    internal var fastLocals: BufferPtr<FastLocal> {
      let rawPtr = self.ptr.advanced(by: self.metadata.fastLocalsOffset)
      return rawPtr.bind(to: FastLocal.self, count: self.metadata.fastLocalsCount)
    }

    internal var cellVariables: BufferPtr<Cell> {
      let rawPtr = self.ptr.advanced(by: self.metadata.cellVariablesOffset)
      return rawPtr.bind(to: Cell.self, count: self.metadata.cellVariableCount)
    }

    internal var freeVariables: BufferPtr<Cell> {
      let rawPtr = self.ptr.advanced(by: self.metadata.freeVariablesOffset)
      return rawPtr.bind(to: Cell.self, count: self.metadata.freeVariableCount)
    }

    internal var blockStackEnd: Ptr<BlockStackProxy.EndPtr> {
      let raw = self.ptr.advanced(by: self.metadata.blockStackEndOffset)
      return raw.bind(to: BlockStackProxy.EndPtr.self)
    }

    internal var blockStack: BufferPtr<Block> {
      let rawPtr = self.ptr.advanced(by: self.metadata.blockStackOffset)
      return rawPtr.bind(to: Block.self, count: self.metadata.blockStackCount)
    }

    private let ptr: RawPtr

    internal init(frame: PyFrame) {
      self.ptr = frame.fastLocalsCellFreeBlockStackStoragePtr
    }
  }
}
