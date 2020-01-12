import Bytecode
import Objects

// swiftlint:disable file_length

extension Frame {

  // MARK: - Numeric binary

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Numeric in-place

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Class

  /// Pushes `builtins.BuildClass()` onto the stack.
  /// It is later called by `CallFunction` to construct a class.
  internal func loadBuildClass() -> InstructionResult {
    return self.unimplemented()
  }

  /// Loads a method named `name` from TOS object.
  ///
  /// TOS is popped and method and TOS are pushed when interpreter can call unbound method directly.
  /// TOS will be used as the first argument (self) by `CallMethod`.
  /// Otherwise, NULL and method is pushed (method is bound method or something else).
  internal func loadMethod(nameIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Calls a method.
  /// `argc` is number of positional arguments.
  /// Keyword arguments are not supported.
  ///
  /// This opcode is designed to be used with `LoadMethod`.
  /// Positional arguments are on top of the stack.
  /// Below them, two items described in `LoadMethod` on the stack.
  /// All of them are popped and return value is pushed.
  internal func callMethod(argumentCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Function

  /// Pushes a new function object on the stack.
  ///
  /// From bottom to top, the consumed stack must consist of values
  /// if the argument carries a specified flag value
  /// - `0x01` - has tuple of default values for positional-only
  ///            and positional-or-keyword parameters in positional order
  /// - `0x02` - has dictionary of keyword-only parameters default values
  /// - `0x04` - has annotation dictionary
  /// - `0x08` - has tuple containing cells for free variables,
  ///            making a closure the code associated with the function (at TOS1)
  ///            the qualified name of the function (at TOS)
  internal func makeFunction(flags: FunctionFlags) -> InstructionResult {
    return self.unimplemented()
  }

  /// Calls a callable object with positional arguments.
  /// `argc` indicates the number of positional arguments.
  ///
  /// Stack layout (1st item means TOS):
  /// - positional arguments, with the right-most argument on top
  /// - callable object to call.
  ///
  /// It will:
  /// 1. pop all arguments and the callable object off the stack
  /// 2. call the callable object with those arguments
  /// 3. push the return value returned by the callable object
  /// - Note:
  /// This opcode is used only for calls with positional arguments!
  internal func callFunction(argumentCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Calls a callable object with positional (if any) and keyword arguments.
  /// `argc` indicates the total number of positional and keyword arguments.
  ///
  /// Stack layout (1st item means TOS):
  /// - tuple of keyword argument names
  /// - keyword arguments in the order corresponding to the tuple
  /// - positional arguments, with the right-most parameter on top
  /// - callable object to call.
  ///
  /// It will:
  /// 1. pop all arguments and the callable object off the stack
  /// 2. call the callable object with those arguments
  /// 3. push the return value returned by the callable object.
  internal func callFunctionKw(argumentCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Calls a callable object with variable set of positional and keyword arguments.
  ///
  /// Stack layout (1st item means TOS):
  /// - (if `hasKeywordArguments` is set) mapping object containing keyword arguments
  /// - iterable object containing positional arguments and a callable object to call
  ///
  /// `BuildmapUnpackWithCall` and `BuildTupleUnpackWithCall` can be used for
  /// merging multiple mapping objects and iterables containing arguments.
  ///
  /// It will:
  /// 1. pop all arguments and the callable object off the stack
  /// 2. mapping object and iterable object are each “unpacked” and their
  /// contents is passed in as keyword and positional arguments respectively
  /// 3. call the callable object with those arguments
  /// 4. push the return value returned by the callable object
  internal func callFunctionEx(hasKeywordArguments: Bool) -> InstructionResult {
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

  /// Removes one block from the block stack.
  /// Per frame, there is a stack of blocks, denoting nested loops, try statements, and such.
  internal func popBlock() -> InstructionResult {
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

  /// Pushes a block for a loop onto the block stack.
  /// The block spans from the current instruction up until `loopEndLabel`.
  internal func setupLoop(loopEndLabelIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// TOS is an iterator. Call its `Next()` method.
  /// If this `yields` a new value, push it on the stack (leaving the iterator below it).
  /// If not then TOS is popped, and the byte code counter is incremented by delta.
  internal func forIter(ifEmptyLabelIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Implements `TOS = iter(TOS)`.
  internal func getIter() -> InstructionResult {
    return self.unimplemented()
  }

  /// If TOS is a generator iterator or coroutine object then it is left as is.
  /// Otherwise, implements `TOS = iter(TOS)`.
  internal func getYieldFromIter() -> InstructionResult {
    return self.unimplemented()
  }

  /// Terminates a loop due to a break statement.
  internal func doBreak() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Try+Catch

  /// Removes one block from the block stack.
  /// The popped block must be an exception handler block,
  /// as implicitly created when entering an except handler.
  /// In addition to popping extraneous values from the frame stack,
  /// the last three popped values are used to restore the exception state.
  internal func popExcept() -> InstructionResult {
    return self.unimplemented()
  }

  /// Terminates a finally clause.
  /// The interpreter recalls whether the exception has to be re-raised,
  /// or whether the function returns, and continues with the outer-next block.
  internal func endFinally() -> InstructionResult {
    return self.unimplemented()
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the first except block.
  internal func setupExcept(firstExceptLabelIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the finally block.
  internal func setupFinally(finallyStartLabelIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Raises an exception using one of the 3 forms of the raise statement,
  /// depending on the value of argc:
  /// - 0: raise (re-raise previous exception)
  /// - 1: raise TOS (raise exception instance or type at TOS)
  /// - 2: raise TOS1 from TOS (raise exception instance or type at TOS1 with Cause set to TOS)
  internal func raiseVarargs(arg: RaiseArg) -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Frame+Store+Load+Delete

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadDeref(nameIndex: Int) -> InstructionResult {
//    let name = self.code.names[nameIndex]
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
//    let name = self.code.names[nameIndex]
//    let value = self.stack.pop()
//    self.freeVariables[name] = value
    return self.unimplemented()
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteDeref(nameIndex: Int) -> InstructionResult {
//    let name = self.code.names[nameIndex]
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

  // MARK: - Unpack

  /// Pops count iterables from the stack, joins them in a single tuple,
  /// and pushes the result.
  /// Implements iterable unpacking in tuple displays `(*x, *y, *z)`.
  internal func buildTupleUnpack(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// This is similar to `BuildTupleUnpack`, but is used for `f(*x, *y, *z)` call syntax.
  /// The stack item at position count + 1 should be the corresponding callable `f`.
  internal func buildTupleUnpackWithCall(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a list instead of tuple.
  /// Implements iterable unpacking in list displays `[*x, *y, *z]`.
  internal func buildListUnpack(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a set instead of tuple.
  /// Implements iterable unpacking in set displays `{*x, *y, *z}`.
  internal func buildSetUnpack(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Pops count mappings from the stack, merges them into a single dictionary,
  /// and pushes the result.
  /// Implements dictionary unpacking in dictionary displays `{**x, **y, **z}`.
  internal func buildMapUnpack(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// This is similar to `BuildMapUnpack`, but is used for `f(**x, **y, **z)` call syntax.
  /// The stack item at position count + 2 should be the corresponding callable `f`.
  internal func buildMapUnpackWithCall(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Unpacks TOS into count individual values,
  /// which are put onto the stack right-to-left.
  internal func unpackSequence(elementCount: Int) -> InstructionResult {
    return self.unimplemented()
  }

  /// Implements assignment with a starred target.
  ///
  /// Unpacks an iterable in TOS into individual values, where the total number
  /// of values can be smaller than the number of items in the iterable:
  /// one of the new values will be a list of all leftover items.
  ///
  /// The low byte of counts is the number of values before the list value,
  /// the high byte of counts the number of values after it.
  /// The resulting values are put onto the stack right-to-left.
  internal func unpackEx(elementCountBefore: Int) -> InstructionResult {
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
