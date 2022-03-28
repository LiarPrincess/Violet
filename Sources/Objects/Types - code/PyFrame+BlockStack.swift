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

  // MARK: - Stack

  public struct BlockStackProxy {

    // swiftlint:disable nesting
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
      let storage = frame.fastLocalsCellFreeBlockStackStorage
      self.buffer = storage.blockStack
      self.endPointerPtr = storage.blockStackEnd
    }

    internal func initialize() {
      // 'Block' is trivial, so we don't have to initialize the memory:
      // self.buffer.initialize <-- Not needed!

      // But we do have to initialize end ptr:
      self.endPointerPtr.initialize(to: self.buffer.baseAddress)
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
