import Core

internal struct Block: CustomStringConvertible {
  /// The type of block.
  internal let type: BlockType
  /// Stack size when the block was entered.
  internal let stackLevel: Int

  internal var description: String {
    return "Block(type: \(self.type), level: \(self.stackLevel))"
  }

  internal var isExceptHandler: Bool {
    switch self.type {
    case .exceptHandler:
      return true
    default:
      return false
    }
  }
}

internal enum BlockType: CustomStringConvertible {
  case setupLoop(endLabel: Int)
  case setupExcept(firstExceptLabel: Int)
  case setupFinally(finallyStartLabel: Int)
  case exceptHandler

  internal var description: String {
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

internal struct BlockStack {

  private var elements = [Block]()

  /// Top-most block.
  internal var current: Block? {
    return self.elements.last
  }

  internal var last: Block? {
    return self.elements.last
  }

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var any: Bool {
    return self.elements.any
  }

  /// void
  /// PyFrame_BlockSetup(PyFrameObject *f, int type, int handler, int level)
  internal mutating func push(block: Block) {
    Debug.push(block: block)
    self.elements.push(block)
  }

  internal mutating func pop() -> Block? {
    let block = self.elements.popLast()
    Debug.pop(block: block)
    return block
  }
}
