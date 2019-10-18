import Foundation
import Objects
import Bytecode

extension Frame {

  /// Removes the top-of-stack (TOS) item.
  internal func popTop() throws {
    _ = self.stack.pop()
  }

  /// Swaps the two top-most stack items.
  internal func rotTwo() throws {
    let top = self.stack.top
    let second = self.stack.second
    self.stack.top = second
    self.stack.second = top
  }

  /// Lifts second and third stack item one position up,
  /// moves top down to position three.
  internal func rotThree() throws {
    let top = self.stack.top
    let second = self.stack.second
    let third = self.stack.third
    self.stack.top = second
    self.stack.second = third
    self.stack.third = top
  }

  /// Duplicates the reference on top of the stack.
  internal func dupTop() throws {
    let top = self.stack.top
    self.stack.push(top)
  }

  /// Duplicates the two references on top of the stack,
  /// leaving them in the same order.
  internal func dupTopTwo() throws {
    let top = self.stack.top
    let second = self.stack.second
    self.stack.push(second)
    self.stack.push(top)
  }

  /// Implements the expression statement for the interactive mode.
  /// TOS is removed from the stack and printed.
  /// In non-interactive mode, an expression statement is terminated with PopTop.
  internal func printExpr() throws {
    let value = self.stack.pop()
    try self.context.print(value: value, file: self.standardOutput, raw: true)
  }

  /// Checks whether Annotations is defined in locals(),
  /// if not it is set up to an empty dict.
  /// This opcode is only emitted if a class or module body contains variable
  /// annotations statically.
  internal func setupAnnotations() throws {
    self.unimplemented()
  }

  /// Removes one block from the block stack.
  /// Per frame, there is a stack of blocks, denoting nested loops, try statements, and such.
  internal func popBlock() throws {
    self.unimplemented()
  }

  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  internal func loadClosure(cellOrFreeIndex: Int) throws {
    self.unimplemented()
  }

  /// Pushes a slice object on the stack.
  internal func buildSlice(arg: SliceArg) throws {
    let step = self.getSliceStep(arg: arg)
    let stop = self.stack.pop()
    let start = self.stack.top

    let slice = self.context.pySlice_New(start: start, stop: stop, step: step)
    self.stack.top = slice
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
