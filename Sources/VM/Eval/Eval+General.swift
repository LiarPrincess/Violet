import Foundation
import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Pop

  /// Removes the top-of-stack (TOS) item.
  internal func popTop() -> InstructionResult {
    _ = self.stack.pop()
    return .ok
  }

  /// Removes one block from the block stack.
  /// Per frame, there is a stack of blocks, denoting nested loops,
  /// try statements, and such.
  ///
  /// - Note:
  /// This is an instruction implementation!
  /// If you want to just `popBlock` then use `self.blockStack.pop()`!
  internal func popBlockInstruction() -> InstructionResult {
    if let block = self.blockStack.pop() {
      self.unwindBlock(block: block)
      return .ok
    }

    let e = Py.newSystemError(msg: "XXX block stack underflow")
    return .exception(e)
  }

  // MARK: - Rot

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

  // MARK: - Dup

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

  // MARK: - Print

  /// Implements the expression statement for the interactive mode.
  /// TOS is removed from the stack and printed.
  /// In non-interactive mode, an expression statement is terminated with PopTop.
  internal func printExpr() -> InstructionResult {
    let value = self.stack.pop()

    switch Py.sys.callDisplayhook(value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  // MARK: - Annotations

  /// Checks whether Annotations is defined in locals(),
  /// if not it is set up to an empty dict.
  /// This opcode is only emitted if a class or module body contains variable
  /// annotations statically.
  internal func setupAnnotations() -> InstructionResult {
    let locals = self.locals

    if let object = locals.get(id: .__annotations__) {
      guard object is PyDict else {
        let t = object.typeName
        let msg = "You thought __annotations__ would be dict, but it was me Dio (\(t))!"
        return .exception(Py.newTypeError(msg: msg))
      }

      return .ok
    }

    let result = Py.newDict()
    locals.set(id: .__annotations__, to: result)
    return .ok
  }
}
