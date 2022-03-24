import VioletCore

extension PyFrame {

  // MARK: - Block

  // 'Equatable' for tests.
  public struct Block: Equatable, CustomStringConvertible {

    // swiftlint:disable:next nesting
    public enum Kind: Equatable, CustomStringConvertible {
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
    let count = Self.maxBlockStackCount
    let stride = MemoryLayout<Block>.stride
    let alignment = MemoryLayout<Block>.alignment
    let rawPtr = PyMemory.allocate(byteCount: count * stride, alignment: alignment)
    return rawPtr.bind(to: Block.self, count: count)
  }

  // MARK: - Deallocate

  internal func deallocateBlockStack() {
    let rawPtr = self.blockStackStorage.deinitialize()
    rawPtr.deallocate()
  }

  // MARK: - Stack

  public struct BlockStackProxy {

    internal typealias EndPtr = UnsafeMutablePointer<Block>

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

    /// Pointer to the element AFTER the top of the stack.
    private var endPointer: EndPtr {
      get { self.endPointerPtr.pointee }
      nonmutating set { self.endPointerPtr.pointee = newValue }
    }

    /// Shortcut to `self.frame.blockStackStorage`.
    private let buffer: BufferPtr<Block>
    /// `self.endPointer` is not stored here! It is actually stored in `frame`.
    /// So when we want to update `self.endPointer` we actually have to update
    /// `frame.blockStackEnd`. This property is a proxy to `frame.blockStackEnd`.
    ///
    /// Don't think about it, just use `self.endPointer`.
    private let endPointerPtr: Ptr<EndPtr>

    internal init(frame: PyFrame) {
      self.buffer = frame.blockStackStorage
      self.endPointerPtr = frame.blockStackEndPtr
    }

    // MARK: - Peek

    public func peek(_ n: Int) -> Block {
      assert(
        0 <= n && n < self.count,
        "Block peek out of bounds (n: \(n), count: \(self.count))."
      )

      // '-1' because 'endPointer' is after last object.
      let ptr = self.endPointer.advanced(by: -n - 1)
      return ptr.pointee
    }

    // MARK: - Push

    /// void
    /// PyFrame_BlockSetup(PyFrameObject *f, int type, int handler, int level)
    public func push(_ block: Block) {
      let count = self.count
      let bufferCount = self.buffer.count

      guard count + 1 <= bufferCount else {
        trap("Block stack overflow")
      }

      self.endPointer.pointee = block
      self.endPointer = self.endPointer.successor()
    }

    // MARK: - Pop

    public func pop() -> Block? {
      assert(!self.isEmpty, "Block stack underflow.")
      self.endPointer = self.endPointer.predecessor()
      return self.endPointer.pointee
    }
  }
}
