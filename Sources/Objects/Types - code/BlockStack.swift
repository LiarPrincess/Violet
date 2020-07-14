import VioletCore

public struct Block: CustomStringConvertible {
  /// The type of block.
  public let type: BlockType
  /// Stack size when the block was entered.
  public let stackCount: Int

  public var isExceptHandler: Bool {
    switch self.type {
    case .exceptHandler:
      return true
    default:
      return false
    }
  }

  public var description: String {
    return "Block(type: \(self.type), level: \(self.stackCount))"
  }

  public init(type: BlockType, stackCount: Int) {
    self.type = type
    self.stackCount = stackCount
  }
}

public enum BlockType: CustomStringConvertible {
  case setupLoop(endLabel: Int)
  case setupExcept(firstExceptLabel: Int)
  case setupFinally(finallyStartLabel: Int)
  case exceptHandler

  public var description: String {
    switch self {
    case let .setupLoop(endLabel: value):
      return "setupLoop(endLabel: \(value))"
    case let .setupExcept(firstExceptLabel: value):
      return "setupExcept(firstExceptLabel: \(value))"
    case let .setupFinally(finallyStartLabel: value):
      return "setupFinally(finallyStartLabel: \(value))"
    case .exceptHandler:
      return "exceptHandler"
    }
  }
}

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
