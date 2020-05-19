import VioletBytecode
import VioletObjects

// swiftlint:disable file_length

extension Eval {

  // MARK: - Make function

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
  internal func makeFunction(flags: Instruction.FunctionFlags) -> InstructionResult {
    let qualname = self.pop()
    let code = self.pop()
    let globals = self.globals

    let fn: PyFunction
    switch Py.newFunction(qualname: qualname, code: code, globals: globals) {
    case let .value(f): fn = f
    case let .error(e): return .exception(e)
    }

    if flags.contains(.hasFreeVariables) {
      let value = self.pop()
      switch fn.setClosure(value) {
      case .value: break
      case .error(let e): return .exception(e)
      }
    }

    if flags.contains(.hasAnnotations) {
      let value = self.pop()
      switch fn.setAnnotations(value) {
      case .value: break
      case .error(let e): return .exception(e)
      }
    }

    if flags.contains(.hasKwOnlyArgDefaults) {
      let value = self.pop()
      switch fn.setKeywordDefaults(value) {
      case .value: break
      case .error(let e): return .exception(e)
      }
    }

    if flags.contains(.hasPositionalArgDefaults) {
      let value = self.pop()
      switch fn.setDefaults(value) {
      case .value: break
      case .error(let e): return .exception(e)
      }
    }

    self.push(fn)
    return .ok
  }

  // MARK: - Return

  /// Returns with TOS to the caller of the function.
  internal func doReturn() -> InstructionResult {
    let value = self.pop()
    return .return(value)
  }

  // MARK: - Call function

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
    let level = self.stackLevel
    let result = self.callFunction(argAndKwargCount: argumentCount, kwNames: nil)

    let fnObject = 1
    let expectedLevel = level - argumentCount - fnObject
    assert(self.stackLevel == expectedLevel)

    switch result {
    case let .value(o):
      self.push(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
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
    let kwNamesObject = self.pop()

    guard let kwNames = kwNamesObject as? PyTuple else {
      let t = kwNamesObject.typeName
      let msg = "Keyword argument names should to be a tuple, not \(t)."
      return .exception(Py.newSystemError(msg: msg))
    }

    let level = self.stackLevel
    let result = self.callFunction(argAndKwargCount: argumentCount,
                                   kwNames: kwNames)

    let fnObject = 1
    let expectedLevel = level - argumentCount - fnObject
    assert(self.stackLevel == expectedLevel)

    switch result {
    case let .value(o):
      self.push(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
  }

  /// call_function(PyObject ***pp_stack, Py_ssize_t argCount, PyObject *kwnames)
  private func callFunction(argAndKwargCount: Int,
                            kwNames: PyTuple?) -> PyInstance.CallResult {
    guard let kwNames = kwNames else {
      let args = self.popElementsInPushOrder(count: argAndKwargCount)
      let fn = self.pop()
      let result = Py.call(callable: fn, args: args)
      Debug.callFunction(fn: fn, args: args, kwargs: nil, result: result)
      return result
    }

    let nKwargs = kwNames.elements.count
    let kwValues = self.popElementsInPushOrder(count: nKwargs)
    assert(kwValues.count == nKwargs)

    let kwargs: PyDict
    switch self.createKwargs(names: kwNames.elements, values: kwValues) {
    case let .value(d): kwargs = d
    case let .error(e): return .error(e)
    }

    let nArgs = argAndKwargCount - nKwargs
    let args = self.popElementsInPushOrder(count: nArgs)
    assert(args.count == nArgs)

    let fn = self.pop()
    return Py.call(callable: fn, args: args, kwargs: kwargs)
  }

  private func createKwargs(names: [PyObject],
                            values: [PyObject]) -> PyResult<PyDict> {
    assert(names.count == values.count)

    let result = Py.newDict()
    if names.isEmpty {
      return .value(result)
    }

    for (name, value) in zip(names, values) {
      switch result.set(key: name, to: value) {
      case .ok:
        break
      case .error(let e):
        return .error(e)
      }
    }

    assert(result.data.count == names.count)
    return .value(result)
  }

  // MARK: - Call function ex

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
    var kwargs: PyDict?
    if hasKeywordArguments {
      let kwargsObject = self.pop()
      switch self.extractKwargs(from: kwargsObject) {
      case let .value(d): kwargs = d
      case let .error(e): return .exception(e)
      }
    }

    let argsObject = self.pop()
    let fn = self.stack.top

    let args: [PyObject]
    switch self.extractArgs(fn: fn, args: argsObject) {
    case let .value(a): args = a
    case let .error(e): return .exception(e)
    }

    let level = self.stackLevel
    let result = Py.call(callable: fn, args: args, kwargs: kwargs)

    switch result {
    case let .value(o):
      assert(self.stackLevel == level)
      self.setTop(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
  }

  private func extractKwargs(from object: PyObject) -> PyResult<PyDict> {
    if let dict = object as? PyDict {
      return .value(dict)
    }

    let result = Py.newDict()
    switch result.update(from: object) {
    case .value:
      return .value(result)
    case .error(let e):
      return .error(e)
    }
  }

  private func extractArgs(fn: PyObject, args: PyObject) -> PyResult<[PyObject]> {
    if let tuple = args as? PyTuple {
      return .value(tuple.elements)
    }

    guard Py.hasIter(object: args) else {
      let t = args.typeName
      let fnName = self.getFunctionName(object: fn) ?? "function"
      let msg = "\(fnName) argument after * must be an iterable, not \(t)"
      return .typeError(msg)
    }

    return Py.toArray(iterable: args)
  }

  // MARK: - Load method

  /// Loads a method named `name` from TOS object.
  ///
  /// TOS is popped and method and TOS are pushed when interpreter
  /// can call unbound method directly.
  /// TOS will be used as the first argument (self) by `CallMethod`.
  /// Otherwise, NULL and method is pushed (method is bound method
  /// or something else).
  internal func loadMethod(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.top

    switch Py.loadMethod(object: object, selector: name) {
    case let .value(o):
      self.setTop(o)
      return .ok
    case let .error(e),
         let .notFound(e):
      return .exception(e)
    }
  }

  // MARK: - Call method

  /// Calls a method.
  /// `argc` is number of positional arguments.
  /// Keyword arguments are not supported.
  ///
  /// This opcode is designed to be used with `LoadMethod`.
  /// Positional arguments are on top of the stack.
  /// Below them, two items described in `LoadMethod` on the stack.
  /// All of them are popped and return value is pushed.
  internal func callMethod(argumentCount: Int) -> InstructionResult {
    let args = self.popElementsInPushOrder(count: argumentCount)
    assert(args.count == argumentCount)

    let level = self.stackLevel
    let method = self.stack.top

    let result = Py.call(callable: method, args: args, kwargs: nil)
    Debug.callMethod(method: method, args: args, result: result)
    assert(self.stackLevel == level)

    switch result {
    case let .value(o):
      self.setTop(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
  }
}
