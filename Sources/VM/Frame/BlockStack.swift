import Core

internal struct Block {
  /// The type of block.
  internal let type: BlockType
  /// Stack size when the block was entered.
  internal let level: Int
}

internal enum BlockType {
  case setupLoop(endLabelIndex: Int)
  case setupExcept(firstExceptLabelIndex: Int)
  case setupFinally(finallyStartLabelIndex: Int)
  case exceptHandler
}

internal class BlockStack {

  private var elements = [Block]()

  /// Top-most block.
  internal var current: Block? {
    return self.elements.last
  }

  /// void
  /// PyFrame_BlockSetup(PyFrameObject *f, int type, int handler, int level)
  internal func push(block: Block) {
    self.elements.push(block)
  }

  internal func pop() -> Block? {
    return self.elements.popLast()
  }
}
