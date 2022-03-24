extension PyCode {
  fileprivate var fastLocalsCount: Int {
    return self.variableCount
  }
}

extension PyFrame {

  // MARK: - Fast locals

  public typealias FastLocal = PyObject?

  internal func allocateFastLocals(_ py: Py, code: PyCode) -> BufferPtr<FastLocal> {
    let count = code.fastLocalsCount
    let stride = MemoryLayout<FastLocal>.stride
    let byteCount = count * stride

    let alignment = MemoryLayout<FastLocal>.alignment
    let rawPtr = PyMemory.allocate(byteCount: byteCount, alignment: alignment)
    let ptr = rawPtr.bind(to: FastLocal.self, count: count)

    ptr.initialize(repeating: nil)
    return ptr
  }

  internal func deallocateFastLocals() {
    let ptr = self.fastLocalsStorage.deinitialize()
    ptr.deallocate()
  }

  public struct FastLocalsProxy {

    private let ptr: BufferPtr<FastLocal>

    internal var first: FastLocal? {
      return self.ptr.first
    }

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      self.ptr = frame.fastLocalsStorage
    }

    public subscript(index: Int) -> FastLocal {
      get { return self.ptr[index] }
      nonmutating set { self.ptr[index] = newValue }
    }
  }

  // MARK: - Cell/free variables

  public typealias Cell = PyCell

  internal func allocateCellAndFreeVariables(_ py: Py, code: PyCode) -> BufferPtr<Cell> {
    let cellCount = code.cellVariableCount
    let freeCount = code.freeVariableCount
    let count = cellCount + freeCount

    let stride = MemoryLayout<Cell>.stride
    let byteCount = count * stride

    let alignment = MemoryLayout<Cell>.alignment
    let rawPtr = PyMemory.allocate(byteCount: byteCount, alignment: alignment)
    let ptr = rawPtr.bind(to: Cell.self, count: count)

    ptr.initialize { _ in py.newCell(content: nil) }
    return ptr
  }

  internal func deallocateCellAndFreeVariables() {
    let ptr = self.cellAndFreeVariablesStorage.deinitialize()
    ptr.deallocate()
  }

  public struct CellVariablesProxy {

    private let ptr: BufferPtr<Cell>

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let startIndex = 0
      let endIndex = frame.code.cellVariableCount
      self.ptr = frame.cellAndFreeVariablesStorage[startIndex..<endIndex]
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }

  public struct FreeVariablesProxy {

    private let ptr: BufferPtr<Cell>

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let startIndex = frame.code.cellVariableCount
      let endIndex = frame.cellAndFreeVariablesStorage.count
      self.ptr = frame.cellAndFreeVariablesStorage[startIndex..<endIndex]
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }
}
