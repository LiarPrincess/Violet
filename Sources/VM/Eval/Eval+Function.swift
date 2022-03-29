import VioletBytecode
import VioletObjects

// cSpell:ignore kwnames

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
    let qualname = self.stack.pop()
    let code = self.stack.pop()
    let globals = self.globals

    var closure: PyObject?
    if flags.contains(.hasFreeVariables) {
      closure = self.stack.pop()
    }

    var annotations: PyObject?
    if flags.contains(.hasAnnotations) {
      annotations = self.stack.pop()
    }

    var keywordDefaults: PyObject?
    if flags.contains(.hasKwOnlyArgDefaults) {
      keywordDefaults = self.stack.pop()
    }

    var defaults: PyObject?
    if flags.contains(.hasPositionalArgDefaults) {
      defaults = self.stack.pop()
    }

    let result = self.py.newFunction(qualname: qualname,
                                     code: code,
                                     globals: globals,
                                     defaults: defaults,
                                     keywordDefaults: keywordDefaults,
                                     closure: closure,
                                     annotations: annotations)

    switch result {
    case let .value(fn):
      self.stack.push(fn.asObject)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

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
    let level = self.stack.count
    let result = self.callFunction(argAndKwargCount: argumentCount, kwNames: nil)

    let fnObject = 1
    let expectedLevel = level - argumentCount - fnObject
    assert(self.stack.count == expectedLevel)

    switch result {
    case let .value(o):
      self.stack.push(o)
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
    let kwNamesObject = self.stack.pop()

    guard let kwNames = self.py.cast.asTuple(kwNamesObject) else {
      let msg = "Keyword argument names should to be a tuple, not \(kwNamesObject.typeName)."
      let error = self.newSystemError(message: msg)
      return .exception(error)
    }

    let level = self.stack.count
    let result = self.callFunction(argAndKwargCount: argumentCount, kwNames: kwNames)

    let fnObject = 1
    let expectedLevel = level - argumentCount - fnObject
    assert(self.stack.count == expectedLevel)

    switch result {
    case let .value(o):
      self.stack.push(o)
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
  }

  /// call_function(PyObject ***pp_stack, Py_ssize_t argCount, PyObject *kwnames)
  private func callFunction(argAndKwargCount: Int, kwNames: PyTuple?) -> Py.CallResult {
    guard let kwNames = kwNames else {
      let args = self.stack.popElementsInPushOrder(count: argAndKwargCount)
      let fn = self.stack.pop()
      let result = self.py.call(callable: fn, args: args)
      Debug.callFunction(fn: fn, args: args, kwargs: nil, result: result)
      return result
    }

    let nKwargs = self.py.lengthInt(tuple: kwNames)
    let kwValues = self.stack.popElementsInPushOrder(count: nKwargs)
    assert(kwValues.count == nKwargs)

    let kwargs: PyDict
    switch self.createKwargs(names: kwNames, values: kwValues) {
    case let .value(d): kwargs = d
    case let .error(e): return .error(e)
    }

    let nArgs = argAndKwargCount - nKwargs
    let args = self.stack.popElementsInPushOrder(count: nArgs)
    assert(args.count == nArgs)

    let fn = self.stack.pop()
    return self.py.call(callable: fn, args: args, kwargs: kwargs)
  }

  private func createKwargs(names: PyTuple, values: [PyObject]) -> PyResultGen<PyDict> {
    let result = self.py.newDict()

    if values.isEmpty {
      return .value(result)
    }

    let error = self.py.forEach(tuple: names) { index, name in
      let value = values[index]
      switch result.set(self.py, key: name, value: value) {
      case .ok:
        return .goToNextElement
      case .error(let e):
        return .error(e)
      }
    }

    if let e = error {
      return .error(e)
    }

    assert(self.py.lengthInt(dict: result) == values.count)
    return .value(result)
  }

  // MARK: - Call function ex

  /// Calls a callable object with variable set of positional and keyword arguments.
  ///
  /// Stack layout (1st item means TOS):
  /// - (if `hasKeywordArguments` is set) mapping object containing keyword arguments
  /// - iterable object containing positional arguments and a callable object to call
  ///
  /// `BuildMapUnpackWithCall` and `BuildTupleUnpackWithCall` can be used for
  /// merging multiple mapping objects and iterables containing arguments.
  ///
  /// It will:
  /// 1. pop all arguments and the callable object off the stack
  /// 2. mapping object and iterable object are each “unpacked” and their
  /// contents is passed in as keyword and positional arguments respectively
  /// 3. call the callable object with those arguments
  /// 4. push the return value returned by the callable object
  internal func callFunctionEx(hasKeywordArguments: Bool) -> InstructionResult {
    var kwargs: PyObject?
    if hasKeywordArguments {
      let kwargsObject = self.stack.pop()
      switch self.extractKwargs(from: kwargsObject) {
      case let .value(d): kwargs = d.asObject
      case let .error(e): return .exception(e)
      }
    }

    let argsObject = self.stack.pop()
    let fn = self.stack.top

    let args: PyObject
    switch self.extractArgs(fn: fn, args: argsObject) {
    case let .value(a): args = a.asObject
    case let .error(e): return .exception(e)
    }

    let level = self.stack.count
    let result = self.py.call(callable: fn, args: args, kwargs: kwargs)

    switch result {
    case let .value(o):
      assert(self.stack.count == level)
      self.stack.top = o
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
  }

  private func extractKwargs(from object: PyObject) -> PyResultGen<PyDict> {
    if let dict = self.py.cast.asDict(object) {
      return .value(dict)
    }

    let result = self.py.newDict()
    if let error = result.update(self.py, from: object, onKeyDuplicate: .continue) {
      return .error(error)
    }

    return .value(result)
  }

  private func extractArgs(fn: PyObject, args: PyObject) -> PyResultGen<PyTuple> {
    if let tuple = self.py.cast.asTuple(args) {
      return .value(tuple)
    }

    guard self.py.hasIter(object: args) else {
      let fnName = self.getName(function: fn) ?? "function"
      let message = "\(fnName) argument after * must be an iterable, not \(args.typeName)"
      return .typeError(self.py, message: message)
    }

    switch self.py.toArray(iterable: args) {
    case let .value(elements):
      let tuple = self.py.newTuple(elements: elements)
      return .value(tuple)
    case let .error(e):
      return .error(e)
    }
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
    let name = self.code.names[nameIndex]
    let object = self.stack.top

    // The 'allowsCallableFromDict' is crucial here!
    // Tbh. 'loadMethod' was the main reason why this parameter exists.
    switch self.py.getMethod(object: object,
                             selector: name,
                             allowsCallableFromDict: true) {
    case let .value(o):
      self.stack.top = o
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
    let args = self.stack.popElementsInPushOrder(count: argumentCount)
    assert(args.count == argumentCount)

    let level = self.stack.count
    let method = self.stack.top

    let result = self.py.call(callable: method, args: args, kwargs: nil)
    Debug.callMethod(method: method, args: args, result: result)
    assert(self.stack.count == level)

    switch result {
    case let .value(o):
      self.stack.top = o
      return .ok
    case let .error(e),
         let .notCallable(e):
      return .exception(e)
    }
  }
}
