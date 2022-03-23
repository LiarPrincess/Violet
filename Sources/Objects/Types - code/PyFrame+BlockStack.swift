import VioletCore

extension PyFrame {

  // MARK: - Block

  public struct Block: CustomStringConvertible {

    // swiftlint:disable:next nesting
    public enum Kind: CustomStringConvertible {
      case setupLoop(loopEndLabelIndex: Int)
      case setupExcept(firstExceptLabelIndex: Int)
      case setupFinally(finallyStartLabelIndex: Int)
      case exceptHandler

      public var description: String {
        switch self {
        case let .setupLoop(loopEndLabelIndex: index):
          return "setupLoop(loopEndLabelIndex: \(index))"
        case let .setupExcept(firstExceptLabelIndex: index):
          return "setupExcept(firstExceptLabelIndex: \(index))"
        case let .setupFinally(finallyStartLabelIndex: index):
          return "setupFinally(finallyStartLabelIndex: \(index))"
        case .exceptHandler:
          return "exceptHandler"
        }
      }
    }

    /// The type of block.
    public let kind: Kind
    /// Stack size when the block was entered.
    public let stackCount: Int

    public var isExceptHandler: Bool {
      switch self.kind {
      case .exceptHandler:
        return true
      default:
        return false
      }
    }

    public var description: String {
      return "Block(type: \(self.kind), level: \(self.stackCount))"
    }

    public init(kind: Kind, stackCount: Int) {
      self.kind = kind
      self.stackCount = stackCount
    }
  }

  // MARK: - Allocate

  internal func allocateBlockStack(_ py: Py, code: PyCode) -> BufferPtr<Block> {
    // 'Block' is trivial, so we don't have to initalize the memory.
    let count = Swift.max(code.predictedBlockStackCount, 32)
    return Self.allocateBuffer(count: count)
  }

  private static func allocateBuffer(count: Int) -> BufferPtr<Block> {
    let stride = MemoryLayout<Block>.stride
    let alignment = MemoryLayout<Block>.alignment
    let rawPtr = PyMemory.allocate(byteCount: count * stride, alignment: alignment)
    return rawPtr.bind(to: Block.self, count: count)
  }

  // MARK: - Deallocate

  internal func deallocateBlockStack() {
    Self.deallocateBuffer(ptr: self.blockStackStorage)
  }

  private static func deallocateBuffer(ptr: BufferPtr<Block>) {
    let rawPtr = ptr.deinitialize()
    rawPtr.deallocate()
  }

  // MARK: - Stack

  /// 'Exclusive' means that only 1 instance is allowed for a given `PyFrame`.
  public struct ExclusiveBlockStackProxy {

    /// Top-most block.
    public var current: Block? {
      if self.isEmpty {
        return nil
      }

      return self.endPointer.advanced(by: -1).pointee
    }

    public var isEmpty: Bool {
      return self.endPointer == self.buffer.baseAddress
    }

    public var count: Int {
      return self.buffer.baseAddress.distance(to: self.endPointer)
    }

    /// Predicted object count next time this `code` executes.
    /// Used to optimize allocation size.
    public var predictedNextRunCount: Int {
      return self.buffer.count
    }

    /// Pointer to the element AFTER the top of the stack.
    private var endPointer: UnsafeMutablePointer<Block>
    /// Shortcut to `self.frame.blockStackStorage`.
    private var buffer: BufferPtr<Block>
    /// When we need to reallocate `self.buffer` we also need to update `frame`.
    private let frame: PyFrame

    internal init(frame: PyFrame) {
      self.buffer = frame.blockStackStorage
      self.endPointer = frame.blockStackStorage.baseAddress
      self.frame = frame
    }

    // MARK: - Peek

    public func peek(_ n: Int) -> Block {
      assert(
        0 <= n && n < self.count,
        "Peek out of bounds (n: \(n), count: \(self.count))."
      )

      // '-1' because 'endPointer' is after last object.
      let ptr = self.endPointer.advanced(by: -n - 1)
      return ptr.pointee
    }

    // MARK: - Push

    /// void
    /// PyFrame_BlockSetup(PyFrameObject *f, int type, int handler, int level)
    public mutating func push(block: Block) {
      self.resizeIfNeeded()
      self.endPointer.pointee = block
      self.endPointer = self.endPointer.successor()
    }

    private mutating func resizeIfNeeded() {
      // Both 'self.count' and 'self.buffer.count' are stored inline inside this
      // 'struct', so this check is trivial.
      let count = self.count
      let bufferCount = self.buffer.count

      if bufferCount >= count + 1 {
        return
      }

      // We need a new buffer!
      let newCount = count + 16
      let newBuffer = PyFrame.allocateBuffer(count: newCount)
      newBuffer.initialize(from: self.buffer)
      // Elements after 'self.count' are uninitialized
      // (they are trivial, so whatever).

      PyFrame.deallocateBuffer(ptr: self.buffer)

      self.buffer = newBuffer
      self.frame.blockStackStoragePtr.pointee = newBuffer
      self.endPointer = newBuffer.baseAddress.advanced(by: count)
    }

    // MARK: - Pop

    public mutating func pop() -> Block? {
      assert(!self.isEmpty, "Pop from an empty stack.")
      self.endPointer = self.endPointer.predecessor()
      return self.endPointer.pointee
    }
  }
}
