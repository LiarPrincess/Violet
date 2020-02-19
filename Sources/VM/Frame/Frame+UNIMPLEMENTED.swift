import Bytecode
import Objects

extension Frame {

  // MARK: - Class

  /// Pushes `builtins.BuildClass()` onto the stack.
  /// It is later called by `CallFunction` to construct a class.
  internal func loadBuildClass() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - General

  /// Checks whether Annotations is defined in locals(),
  /// if not it is set up to an empty dict.
  /// This opcode is only emitted if a class or module body contains variable
  /// annotations statically.
  internal func setupAnnotations() -> InstructionResult {
    return self.unimplemented()
  }

  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  internal func loadClosure(cellOrFreeIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Coroutines

  /// Implements `TOS = GetAwaitable(TOS)`.
  ///
  /// `GetAwaitable(o)` returns:
  /// - `o` if `o` is a coroutine object
  /// - generator object with the `CoIterableCoroutine` flag
  /// - `o.Await`
  internal func getAwaitable() -> InstructionResult {
    return self.unimplemented()
  }

  /// Implements `TOS = TOS.AIter()`.
  internal func getAIter() -> InstructionResult {
    return self.unimplemented()
  }

  /// Implements `Push(GetAwaitable(TOS.ANext()))`.
  /// See `GetAwaitable` for details.
  internal func getANext() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Generators

  /// Pops TOS and yields it from a generator.
  internal func yieldValue() -> InstructionResult {
    return self.unimplemented()
  }

  /// Pops TOS and delegates to it as a subiterator from a generator.
  internal func yieldFrom() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Import

  /// Loads all symbols not starting with '_' directly from the module TOS
  /// to the local namespace.
  ///
  /// The module is popped after loading all names.
  /// This opcode implements `from module import *`.
  internal func importStar() -> InstructionResult {
    return self.unimplemented()
  }

  /// Imports the module `name`.
  ///
  /// TOS and TOS1 are popped and provide the `fromlist` and `level` arguments of `Import()`.
  /// The module object is pushed onto the stack.
  /// The current namespace is not affected: for a proper import statement,
  /// a subsequent StoreFast instruction modifies the namespace.
  internal func importName(nameIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Loads the attribute `name` from the module found in TOS.
  ///
  /// The resulting object is pushed onto the stack,
  /// to be subsequently stored by a `StoreFast` instruction.
  internal func importFrom(nameIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Loop

  /// If TOS is a generator iterator or coroutine object then it is left as is.
  /// Otherwise, implements `TOS = iter(TOS)`.
  internal func getYieldFromIter() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Frame+Store+Load+Delete

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadDeref(nameIndex: Int) -> InstructionResult {
//    let name = self.getName(index: nameIndex)
//    if let value = self.freeVariables[name] {
//      self.stack.push(value)
//      return .ok
//    }

    // format_exc_unbound(co, oparg);
    return self.unimplemented()
  }

  /// Stores TOS into the cell contained in slot i of the cell
  /// and free variable storage.
  internal func storeDeref(nameIndex: Int) -> InstructionResult {
//    let name = self.getName(index: nameIndex)
//    let value = self.stack.pop()
//    self.freeVariables[name] = value
    return self.unimplemented()
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteDeref(nameIndex: Int) -> InstructionResult {
//    let name = self.getName(index: nameIndex)
//    let value = self.freeVariables.removeValue(forKey: name)
//
//    if value == nil {
//      // format_exc_unbound(co, oparg);
//      fatalError()
//    }

    return self.unimplemented()
  }

  /// Much like `LoadDeref` but first checks the locals dictionary before
  /// consulting the cell.
  /// This is used for loading free variables in class bodies.
  internal func loadClassDeref(nameIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - With

  /// This opcode performs several operations before a `with` block starts.
  ///
  /// It does following operations:
  /// 1.loads `Exit()` from the context manager and pushes it onto the stack
  /// for later use by `WithCleanup`.
  /// 2. calls `Enter()`
  /// 3. block staring at to `afterBodyLabel` is pushed.
  /// 4. the result of calling the enter method is pushed onto the stack.
  ///
  /// The next opcode will either ignore it (`PopTop`),
  /// or store it in variable (StoreFast, StoreName, or UnpackSequence).
  internal func setupWith(afterBodyLabelIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Cleans up the stack when a `with` statement block exits.
  ///
  /// TOS is the context manager’s `__exit__()` bound method.
  /// Below TOS are 1–3 values indicating how/why the finally clause was entered:
  /// - `SECOND = None`
  /// - `(SECOND, THIRD) = (WHY_{RETURN,CONTINUE}), retval`
  /// - `SECOND = WHY_*; no retval below it`
  /// - `(SECOND, THIRD, FOURTH) = exc_info()`
  /// In the last case, `TOS(SECOND, THIRD, FOURTH)` is called,
  /// otherwise `TOS(None, None, None)`.
  /// Pushes `SECOND` and result of the call to the stack.
  internal func withCleanupStart() -> InstructionResult {
    return self.unimplemented()
  }

  /// Pops exception type and result of ‘exit’ function call from the stack.
  ///
  /// If the stack represents an exception, and the function call returns a ‘true’ value,
  /// this information is “zapped” and replaced with a single WhySilenced
  /// to prevent EndFinally from re-raising the exception.
  /// (But non-local gotos will still be resumed.)
  internal func withCleanupFinish() -> InstructionResult {
    return self.unimplemented()
  }

  /// Resolves `AEnter` and `AExit` from the object on top of the stack.
  /// Pushes `AExit` and result of `AEnter()` to the stack.
  internal func beforeAsyncWith() -> InstructionResult {
    return self.unimplemented()
  }

  /// Creates a new frame object.
  internal func setupAsyncWith() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: StaticString = #function) -> InstructionResult {
    fatalError("NOT IMPLEMENTED: '\(fn)'")
  }
}
