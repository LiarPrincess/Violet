import Bytecode
import Objects

extension Frame {

  // MARK: - Return

  /// Returns with TOS to the caller of the function.
  internal func doReturn() -> InstructionResult {
    let value = self.stack.pop()
    return .unwind(.return(value))
  }
}
