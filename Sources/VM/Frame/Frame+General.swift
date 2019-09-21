import Bytecode

extension Frame {

  /// Do nothing code.
  internal func nop() throws {
    self.unimplemented()
  }

  /// Removes the top-of-stack (TOS) item.
  internal func popTop() throws {
    self.unimplemented()
  }

  /// Swaps the two top-most stack items.
  internal func rotTwo() throws {
    self.unimplemented()
  }

  /// Lifts second and third stack item one position up,
  /// moves top down to position three.
  internal func rotThree() throws {
    self.unimplemented()
  }

  /// Duplicates the reference on top of the stack.
  internal func dupTop() throws {
    self.unimplemented()
  }

  /// Duplicates the two references on top of the stack,
  /// leaving them in the same order.
  internal func dupTopTwo() throws {
    self.unimplemented()
  }

  /// Implements the expression statement for the interactive mode.
  /// TOS is removed from the stack and printed.
  /// In non-interactive mode, an expression statement is terminated with PopTop.
  internal func printExpr() throws {
    self.unimplemented()
  }

  /// Prefixes any opcode which has an argument too big to fit into the default one byte.
  ///
  /// `ext` holds an additional byte which act as higher bits in the argument.
  /// For each opcode, at most three prefixal `ExtendedArg` are allowed,
  /// forming an argument from two-byte to four-byte.
  internal func extendedArg(value: Int) throws {
    self.unimplemented()
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
    self.unimplemented()
  }
}
