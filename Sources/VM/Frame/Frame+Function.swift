import Bytecode
import Objects

extension Frame {

  // MARK: - Return

  /// Returns with TOS to the caller of the function.
  internal func doReturn() -> InstructionResult {
    let value = self.stack.pop()
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
    let result = self.callFunction(argAndKwargCount: argumentCount,
                                   kwNames: nil)

    let fnObject = 1
    let expectedLevel = level - argumentCount - fnObject
    assert(self.stackLevel == expectedLevel)

    switch result {
    case let .value(o):
      self.stack.push(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .error(e)
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
    let kwNamesObject = self.stack.pop()

    guard let kwNames = kwNamesObject as? PyTuple else {
      let t = kwNamesObject.typeName
      let msg = "Keyword argument names should to be a tuple, not \(t)."
      return .error(Py.newSystemError(msg: msg))
    }

    let level = self.stackLevel
    let result = self.callFunction(argAndKwargCount: argumentCount,
                                   kwNames: kwNames)

    let fnObject = 1
    let expectedLevel = level - argumentCount - fnObject
    assert(self.stackLevel == expectedLevel)

    switch result {
    case let .value(o):
      self.stack.push(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .error(e)
    }
  }

  /// call_function(PyObject ***pp_stack, Py_ssize_t argCount, PyObject *kwnames)
  private func callFunction(argAndKwargCount: Int,
                            kwNames: PyTuple?) -> CallResult {
    guard let kwNames = kwNames else {
      let args = stack.popElementsInPushOrder(count: argAndKwargCount)
      let fn = self.stack.pop()
      return Py.call(callable: fn, args: args)
    }

    let nKwargs = kwNames.elements.count
    let kwValues = self.stack.popElementsInPushOrder(count: nKwargs)
    assert(kwValues.count == nKwargs)

    let kwargs: PyDictData
    switch self.createKwargs(names: kwNames.elements, values: kwValues) {
    case let .value(d): kwargs = d
    case let .error(e): return .error(e)
    }

    let nArgs = argAndKwargCount - nKwargs
    let args = stack.popElementsInPushOrder(count: nArgs)
    assert(args.count == nArgs)

    let fn = self.stack.pop()
    return Py.call(callable: fn, args: args, kwargs: kwargs)
  }

  private func createKwargs(names: [PyObject],
                            values: [PyObject]) -> PyResult<PyDictData> {
    assert(names.count == values.count)

    var result = PyDictData(size: names.count)
    if names.isEmpty {
      return .value(result)
    }

    for (name, value) in zip(names, values) {
      switch Py.hash(name) {
      case let .value(nameHash):
        let key = PyDictKey(hash: nameHash, object: name)
        switch result.insert(key: key, value: value) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    assert(result.count == names.count)
    return .value(result)
  }

  // MARK: - Load method

  /// Loads a method named `name` from TOS object.
  ///
  /// TOS is popped and method and TOS are pushed when interpreter
  /// can call unbound method directly.
  /// TOS will be used as the first argument (self) by `CallMethod`.
  /// Otherwise, NULL and method is pushed (method is bound method or something else).
  internal func loadMethod(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.top

    switch Py.getMethod(object: object, selector: name) {
    case let .value(boundMethod):
      // 'bound' means that method already captured 'self' reference
      self.stack.top = boundMethod
      return .ok
    case let .error(e):
      return .error(e)
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
    let args = stack.popElementsInPushOrder(count: argumentCount)
    assert(args.count == argumentCount)

    // 'bound' means that method already captured 'self' reference
    let boundMethod = self.stack.top

    let level = self.stackLevel
    let result = Py.call(callable: boundMethod, args: args, kwargs: nil)
    assert(self.stackLevel == level)

    switch result {
    case let .value(o):
      self.stack.top = o
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .error(e)
    }
  }
}
