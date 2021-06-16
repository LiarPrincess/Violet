import VioletCore

// MARK: - Block

public struct Block: CustomStringConvertible {

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

// MARK: - Stack

public struct BlockStack {

  private var elements = [Block]()

  /// Top-most block.
  public var current: Block? {
    return self.elements.last
  }

  public var count: Int {
    return self.elements.count
  }

  public var isEmpty: Bool {
    return self.elements.isEmpty
  }

  public var any: Bool {
    return self.elements.any
  }

  public init() {}

  public func peek(_ n: Int) -> Block {
    let count = self.elements.count
    assert(
      0 <= n && n < count,
      "Stack peek out of bounds (peek: \(n), count: \(count))."
    )
    return self.elements[count - n - 1]
  }

  /// void
  /// PyFrame_BlockSetup(PyFrameObject *f, int type, int handler, int level)
  public mutating func push(block: Block) {
    self.elements.push(block)
  }

  public mutating func pop() -> Block? {
    return self.elements.popLast()
  }
}
