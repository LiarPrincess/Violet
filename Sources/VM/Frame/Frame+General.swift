import Foundation
import Objects
import Bytecode

extension Frame {

  /// Removes the top-of-stack (TOS) item.
  internal func popTop() -> InstructionResult {
    _ = self.stack.pop()
    return .ok
  }

  /// Swaps the two top-most stack items.
  internal func rotTwo() -> InstructionResult {
    let top = self.stack.top
    let second = self.stack.second
    self.stack.top = second
    self.stack.second = top
    return .ok
  }

  /// Lifts second and third stack item one position up,
  /// moves top down to position three.
  internal func rotThree() -> InstructionResult {
    let top = self.stack.top
    let second = self.stack.second
    let third = self.stack.third
    self.stack.top = second
    self.stack.second = third
    self.stack.third = top
    return .ok
  }

  /// Duplicates the reference on top of the stack.
  internal func dupTop() -> InstructionResult {
    let top = self.stack.top
    self.stack.push(top)
    return .ok
  }

  /// Duplicates the two references on top of the stack,
  /// leaving them in the same order.
  internal func dupTopTwo() -> InstructionResult {
    let top = self.stack.top
    let second = self.stack.second
    self.stack.push(second)
    self.stack.push(top)
    return .ok
  }

  /// Implements the expression statement for the interactive mode.
  /// TOS is removed from the stack and printed.
  /// In non-interactive mode, an expression statement is terminated with PopTop.
  internal func printExpr() -> InstructionResult {
    let value = self.stack.pop()

    switch self.builtins.print(value: value, raw: true) {
    case .value:
      return .ok
    case .error(let e):
      return .builtinError(e)
    }
  }

  /// Checks whether Annotations is defined in locals(),
  /// if not it is set up to an empty dict.
  /// This opcode is only emitted if a class or module body contains variable
  /// annotations statically.
  internal func setupAnnotations() -> InstructionResult {
    return .unimplemented
  }

  /// Removes one block from the block stack.
  /// Per frame, there is a stack of blocks, denoting nested loops, try statements, and such.
  internal func popBlock() -> InstructionResult {
    return .unimplemented
  }

  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  internal func loadClosure(cellOrFreeIndex: Int) -> InstructionResult {
    return .unimplemented
  }

  /// Pushes a slice object on the stack.
  internal func buildSlice(arg: SliceArg) -> InstructionResult {
    let step = self.getSliceStep(arg: arg)
    let stop = self.stack.pop()
    let start = self.stack.top

    let slice = self.builtins.newSlice(start: start, stop: stop, step: step)
    self.stack.top = slice
    return .ok
  }

  private func getSliceStep(arg: SliceArg) -> PyObject? {
    switch arg {
    case .lowerUpper:
      return nil
    case .lowerUpperStep:
      return self.stack.pop()
    }
  }
}
