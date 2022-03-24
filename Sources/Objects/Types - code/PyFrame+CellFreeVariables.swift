import VioletCore

extension PyFrame {

  public typealias Cell = PyCell

  // MARK: - Initialize

  /// `self.fastLocals` have to be filled first!
  internal func initializeCellAndFreeVariables(_ py: Py, closure: PyTuple?) {
    let code = self.code

    let cellCount = code.cellVariableCount
    let freeCount = code.freeVariableCount
    let count = cellCount + freeCount

    let stride = MemoryLayout<Cell>.stride
    let alignment = MemoryLayout<Cell>.alignment

    let rawPtr = PyMemory.allocate(byteCount: count * stride, alignment: alignment)
    let ptr = rawPtr.bind(to: Cell.self, count: count)
    self.cellAndFreeVariablesStoragePtr.initialize(to: ptr)

    // Initialize cell variables
    let fastLocals = self.fastLocals
    for (index, name) in code.cellVariableNames.enumerated() {
      let cell: PyCell

      // Possibly account for the cell variable being an argument.
      if let arg = code.variableNames.firstIndex(of: name) {
        let local = fastLocals[arg]
        cell = py.newCell(content: local)
        self.fastLocals[arg] = nil
      } else {
        cell = py.newCell(content: nil)
      }

      // CPython stores everything in a single memory block
      // that's why they have to add 'co->co_nlocals'.
      ptr[index] = cell
    }

    // Initialize free variables
    let closure = closure?.elements ?? []
    assert(closure.count == code.freeVariableCount)

    let freeStartIndex = self.freeStartIndex
    for (index, object) in closure.enumerated() {
      guard let cell = py.cast.asCell(object) else {
        trap("Closure can only contain cells, not '\(object.typeName)'.")
      }

      // Free are always after cells
      let freeIndex = freeStartIndex + index
      ptr[freeIndex] = cell
    }
  }

  // MARK: - Deallocate

  internal func deallocateCellAndFreeVariables() {
    let ptr = self.cellAndFreeVariablesStorage.deinitialize()
    ptr.deallocate()
  }

  // MARK: - Cells

  private var cellStartIndex: Int { 0 }
  private var cellEndIndex: Int { self.code.cellVariableCount }

  public struct CellVariablesProxy {

    private let ptr: BufferPtr<Cell>

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let startIndex = 0
      let endIndex = frame.cellEndIndex
      self.ptr = frame.cellAndFreeVariablesStorage[startIndex..<endIndex]
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }

  // MARK: - Free

  private var freeStartIndex: Int { self.code.cellVariableCount }
  private var freeEndIndex: Int { self.cellAndFreeVariablesStorage.count }

  public struct FreeVariablesProxy {

    private let ptr: BufferPtr<Cell>

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let startIndex = frame.freeStartIndex
      let endIndex = frame.freeEndIndex
      self.ptr = frame.cellAndFreeVariablesStorage[startIndex..<endIndex]
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }
}
