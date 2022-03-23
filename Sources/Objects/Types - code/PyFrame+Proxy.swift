extension PyCode {
  fileprivate var fastLocalsCount: Int {
    return self.variableCount
  }
}

extension PyFrame {

  // MARK: - Object stack

  internal func allocateObjectStack(_ py: Py, code: PyCode) -> BufferPtr<PyObject> {
    // We will allocate a bit more space, because the exact allocation could
    // be too tight.
    let predictedObjectStackCount = code.predictedObjectStackCount + 16
    let count = Swift.max(predictedObjectStackCount, 128)
    // 'PyObject' is trivial, so we don't have to initalize the memory.
    return Self.allocateObjectStackStorage(count: count)
  }

  private static func allocateObjectStackStorage(count: Int) -> BufferPtr<PyObject> {
    let stride = MemoryLayout<PyObject>.stride
    let alignment = MemoryLayout<PyObject>.alignment
    let rawPtr = PyMemory.allocate(byteCount: count * stride, alignment: alignment)
    return rawPtr.bind(to: PyObject.self, count: count)
  }

  internal func deallocateObjectStack() {
    Self.deallocateObjectStackStorage(ptr: self.objectStackStorage)
  }

  private static func deallocateObjectStackStorage(ptr: BufferPtr<PyObject>) {
    let rawPtr = ptr.deinitialize()
    rawPtr.deallocate()
  }

  /// 'Exclusive' means that only 1 instance is allowed for a given `PyFrame`.
  public struct ExclusiveObjectStackProxy {

    public var top: PyObject {
      get { return self.endPointer.advanced(by: -1).pointee }
      set { self.endPointer.advanced(by: -1).pointee = newValue }
    }

    public var second: PyObject {
      get { return self.endPointer.advanced(by: -2).pointee }
      set { self.endPointer.advanced(by: -2).pointee = newValue }
    }

    public var third: PyObject {
      get { return self.endPointer.advanced(by: -3).pointee }
      set { self.endPointer.advanced(by: -3).pointee = newValue }
    }

    public var fourth: PyObject {
      get { return self.endPointer.advanced(by: -4).pointee }
      set { self.endPointer.advanced(by: -4).pointee = newValue }
    }

    public var isEmpty: Bool {
      return self.endPointer == self.buffer.baseAddress
    }

    /// CPython `stacklevel`.
    public var count: Int {
      return self.buffer.baseAddress.distance(to: self.endPointer)
    }

    /// Pointer to the element AFTER the top of the stack.
    private var endPointer: UnsafeMutablePointer<PyObject>
    /// Shortcut to `self.frame.objectStackStorage`.
    private var buffer: BufferPtr<PyObject>
    /// When we need to reallocate `self.buffer` we also need to update `frame`.
    private let frame: PyFrame

    internal init(frame: PyFrame) {
      self.buffer = frame.objectStackStorage
      self.endPointer = frame.objectStackStorage.baseAddress
      self.frame = frame
    }

    public func peek(_ n: Int) -> PyObject {
      assert(
        0 <= n && n < self.count,
        "Peek out of bounds (n: \(n), count: \(self.count))."
      )

      // '-1' because 'endPointer' is after last object.
      let ptr = self.endPointer.advanced(by: -n - 1)
      return ptr.pointee
    }

    public func set(_ n: Int, object: PyObject) {
      assert(
        0 <= n && n < self.count,
        "Set out of bounds (n: \(n), count: \(self.count))."
      )

      // '-1' because 'endPointer' is after last object.
      let ptr = self.endPointer.advanced(by: -n - 1)
      ptr.pointee = object
    }

    public mutating func push(_ object: PyObject) {
      self.resizeIfNeeded(pushCount: 1)
      self.endPointer.pointee = object
      self.endPointer = self.endPointer.successor()
    }

    public mutating func push<C: Collection>(
      contentsOf objects: C
    ) where C.Element == PyObject {
      self.resizeIfNeeded(pushCount: objects.count)

      for object in objects {
        self.endPointer.pointee = object
        self.endPointer = self.endPointer.successor()
      }
    }

    private mutating func resizeIfNeeded(pushCount: Int) {
      // Both 'self.count' and 'self.buffer.count' are stored inline inside this
      // 'struct', so this check is trivial.
      let count = self.count
      let bufferCount = self.buffer.count

      if bufferCount >= count + pushCount {
        return
      }

      // We need a new buffer!
      let newCount = pushCount + Swift.min(count, 256)
      let newBuffer = PyFrame.allocateObjectStackStorage(count: newCount)
      newBuffer.initialize(from: self.buffer)
      // Elements after 'self.count' are uninitialized (they are trivial, so whatever).

      PyFrame.deallocateObjectStackStorage(ptr: self.buffer)

      self.buffer = newBuffer
      self.frame.objectStackStoragePtr.pointee = newBuffer
      self.endPointer = newBuffer.baseAddress.advanced(by: count)
    }

    public mutating func pop() -> PyObject {
      assert(!self.isEmpty, "Pop from an empty stack.")
      self.endPointer = self.endPointer.predecessor()
      return self.endPointer.pointee
    }

    /// Pop `count` elements and then reverse,
    /// so that first pushed element is at `0` index.
    ///
    /// So, basically it will slice stack `count` elements from the end
    /// and return this slice.
    public mutating func popElementsInPushOrder(count: Int) -> [PyObject] {
      assert(
        self.count >= count,
        "Pop elements out of bounds (pop: \(count), count: \(self.count))."
      )

      // Fast check to avoid allocation.
      if count == 0 {
        return []
      }

      let resultStart = self.count - count
      let resultBuffer = self.buffer[resultStart..<self.count]
      let result = Array(resultBuffer)


      self.endPointer = self.endPointer.advanced(by: -count)
      return result
    }

    /// Pop elements until we reach `untilCount`.
    public mutating func pop(untilCount: Int) {
      assert(
        untilCount <= self.count,
        "Pop until count out of bounds (pop: \(untilCount), count: \(self.count))."
      )

      self.endPointer = self.buffer.baseAddress.advanced(by: untilCount)
    }
  }

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
    let ptr = self.cellAndFreeVariableStorage.deinitialize()
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
      self.ptr = frame.cellAndFreeVariableStorage[startIndex..<endIndex]
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
      let endIndex = frame.cellAndFreeVariableStorage.count
      self.ptr = frame.cellAndFreeVariableStorage[startIndex..<endIndex]
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }
}
