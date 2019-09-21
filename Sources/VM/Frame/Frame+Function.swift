import Bytecode

extension Frame {

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
  internal func makeFunction(flags: FunctionFlags) throws {
    self.unimplemented()
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
  internal func callFunction(argumentCount: Int) throws {
    self.unimplemented()
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
  internal func callFunctionKw(argumentCount: Int) throws {
    self.unimplemented()
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
  internal func callFunctionEx(hasKeywordArguments: Bool) throws {
    self.unimplemented()
  }

  /// Returns with TOS to the caller of the function.
  internal func `return`() throws {
    self.unimplemented()
  }
}
