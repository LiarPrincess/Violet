import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Unpack tuple/list

  /// Pops count iterables from the stack, joins them in a single tuple,
  /// and pushes the result.
  /// Implements iterable unpacking in tuple displays `(*x, *y, *z)`.
  internal func buildTupleUnpack(elementCount: Int) -> InstructionResult {
    switch self.unpackToArray(elementCount: elementCount) {
    case let .value(elements):
      let collection = self.py.newTuple(elements: elements)
      self.stack.push(collection.asObject)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a list instead of tuple.
  /// Implements iterable unpacking in list displays `[*x, *y, *z]`.
  internal func buildListUnpack(elementCount: Int) -> InstructionResult {
    switch self.unpackToArray(elementCount: elementCount) {
    case let .value(elements):
      let collection = self.py.newList(elements: elements)
      self.stack.push(collection.asObject)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func unpackToArray(elementCount: Int) -> PyResultGen<[PyObject]> {
    var result = [PyObject]()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for iterable in iterables {
      switch self.py.toArray(iterable: iterable) {
      case let .value(elements):
        result.append(contentsOf: elements)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(result)
  }

  /// This is similar to `BuildTupleUnpack`, but is used for `f(*x, *y, *z)` call syntax.
  /// The stack item at position count + 1 should be the corresponding callable `f`.
  internal func buildTupleUnpackWithCall(elementCount: Int) -> InstructionResult {
    var result = [PyObject]()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for iterable in iterables {
      switch self.py.toArray(iterable: iterable) {
      case let .value(elements):
        result.append(contentsOf: elements)
      case let .error(e):
        // Try to be a bit more precise in the error message.
        let e2 = self.tupleUnpackWithCallError(iterable: iterable, error: e) ?? e
        return .exception(e2)
      }
    }

    let collection = self.py.newTuple(elements: result)
    self.stack.push(collection.asObject)
    return .ok
  }

  private func tupleUnpackWithCallError(
    iterable: PyObject,
    error: PyBaseException
  ) -> PyBaseException? {
    let isTypeError = self.py.cast.isTypeError(error.asObject)
    let hasIter = self.py.hasIter(object: iterable)

    guard isTypeError && !hasIter else {
      return nil
    }

    let fn = self.stack.top
    let fnName = self.getName(function: fn) ?? "function"
    let message = "\(fnName) argument after * must be an iterable, not \(iterable.typeName)"
    return self.newTypeError(message: message)
  }

  // MARK: - Unpack set

  /// This is similar to `BuildTupleUnpack`, but pushes a set instead of tuple.
  /// Implements iterable unpacking in set displays `{*x, *y, *z}`.
  internal func buildSetUnpack(elementCount: Int) -> InstructionResult {
    let set = self.py.newSet()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for object in iterables {
      if let e = self.py.update(set: set, fromIterable: object) {
        return .exception(e)
      }
    }

    self.stack.push(set.asObject)
    return .ok
  }

  // MARK: - Unpack map

  /// Pops count mappings from the stack, merges them into a single dictionary,
  /// and pushes the result.
  /// Implements dictionary unpacking in dictionary displays `{**x, **y, **z}`.
  internal func buildMapUnpack(elementCount: Int) -> InstructionResult {
    let dict = self.py.newDict()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for object in iterables {
      if let e = dict.update(self.py, from: object, onKeyDuplicate: .continue) {
        if self.py.cast.isAttributeError(e.asObject) {
          let message = "'\(object.typeName)' object is not a mapping"
          let error = self.newTypeError(message: message)
          return .exception(error)
        }

        return .exception(e)
      }
    }

    self.stack.push(dict.asObject)
    return .ok
  }

  /// This is similar to `BuildMapUnpack`, but is used for `f(**x, **y, **z)` call syntax.
  /// The stack item at position count + 2 should be the corresponding callable `f`.
  internal func buildMapUnpackWithCall(elementCount: Int) -> InstructionResult {
    let dict = self.py.newDict()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for object in iterables {
      if let e = dict.update(self.py, from: object, onKeyDuplicate: .error) {
        if self.py.cast.isKeyError(e.asObject) {
          let e2 = self.mapUnpackWithCallDuplicateError(keyError: e)
          return .exception(e2)
        }

        // Try to be a bit more precise in the error message.
        let e2 = self.mapUnpackWithCallError(iterable: object, error: e) ?? e
        return .exception(e2)
      }
    }

    self.stack.push(dict.asObject)
    return .ok
  }

  private func mapUnpackWithCallDuplicateError(keyError: PyBaseException) -> PyBaseException {
    /// Template: function_name() got multiple values for keyword argument 'key_str'
    var message = ""

    if self.stack.count >= 2 {
      let fn = self.stack.second

      if let name = self.getName(function: fn) {
        message.append(name)
        message.append("() ")
      } else {
        message.append(fn.typeName)
        message.append("object ")
      }
    }

    message.append("got multiple values for keyword argument")

    let args = self.py.getArgs(exception: keyError)
    if let firstArg = self.getFirst(args: args) {
      switch self.py.strString(firstArg) {
      case .value(let string):
        message.append(" ")
        message.append(string.quoted)
      case .error: break
      }
    }

    let error = self.py.newTypeError(message: message)
    return error.asBaseException
  }

  private func mapUnpackWithCallError(iterable: PyObject,
                                      error: PyBaseException) -> PyBaseException? {

    let fn = self.stack.second
    let fnName = self.getName(function: fn) ?? "function"

    if self.py.cast.isAttributeError(error.asObject) {
      let message = "\(fnName) argument after ** must be a mapping, not \(iterable.typeName)"
      return self.newTypeError(message: message)
    }

    if let keyError = self.py.cast.asKeyError(error.asObject) {
      let args = self.py.getArgs(exception: keyError.asBaseException)
      guard let first = self.getFirst(args: args) else { return nil }

      if let keyPy = self.py.cast.asString(first) {
        let key = self.py.strString(keyPy)
        let message = "\(fnName) got multiple values for keyword argument '\(key)'"
        return self.newTypeError(message: message)
      }

      let message = "\(fnName) keywords must be strings"
      return self.newTypeError(message: message)
    }

    return nil
  }

  private func getFirst(args: PyTuple) -> PyObject? {
    switch py.getItem(object: args.asObject, index: 0) {
    case .value(let object):
      return object
    case .error:
      return nil
    }
  }

  // MARK: - Unpack sequence

  /// Unpacks TOS into count individual values,
  /// which are put onto the stack right-to-left.
  internal func unpackSequence(elementCount: Int) -> InstructionResult {
    let iterable = self.stack.pop()

    let elements: [PyObject]
    switch self.py.toArray(iterable: iterable) {
    case let .value(e):
      elements = e
    case let .error(e):
      // Try to be a bit more precise in the error message.
      let e2 = self.notIterableUnpackError(iterable: iterable) ?? e
      return .exception(e2)
    }

    if elements.count < elementCount {
      let got = elements.count
      let message = "not enough values to unpack (expected \(elementCount), got \(got))"
      let error = self.newValueError(message: message)
      return .exception(error)
    }

    if elements.count > elementCount {
      let message = "too many values to unpack (expected \(elementCount))"
      let error = self.newValueError(message: message)
      return .exception(error)
    }

    assert(elements.count == elementCount)

    // Reverse because we have to push them in 'right-to-left' order!
    self.stack.push(contentsOf: elements.reversed())
    return .ok
  }

  // MARK: - Unpack ex

  /// Implements assignment with a starred target.
  ///
  /// Unpacks an iterable in TOS into individual values, where the total number
  /// of values can be smaller than the number of items in the iterable:
  /// one of the new values will be a list of all leftover items.
  ///
  /// The low byte of counts is the number of values before the list value,
  /// the high byte of counts the number of values after it.
  /// The resulting values are put onto the stack right-to-left.
  internal func unpackEx(arg: Instruction.UnpackExArg) -> InstructionResult {
    let iterable = self.stack.pop()

    let elements: [PyObject]
    switch self.py.toArray(iterable: iterable) {
    case let .value(e):
      elements = e
    case let .error(e):
      // Try to be a bit more precise in the error message.
      let e2 = self.notIterableUnpackError(iterable: iterable) ?? e
      return .exception(e2)
    }

    let minCount = arg.countBefore + arg.countAfter
    if elements.count < minCount {
      let got = elements.count
      let message = "not enough values to unpack (expected at least \(minCount), got \(got))"
      let error = self.newValueError(message: message)
      return .exception(error)
    }

    let afterStartsAtIndex = elements.count - arg.countAfter
    let before = elements[..<arg.countBefore]
    let pack = Array(elements[arg.countBefore..<afterStartsAtIndex])
    let after = elements[afterStartsAtIndex...]

    assert(before.count == arg.countBefore)
    assert(pack.count == elements.count - arg.countBefore - arg.countAfter)
    assert(after.count == arg.countAfter)

    // Reverse because we have to push them in 'right-to-left' order!
    let list = self.py.newList(elements: pack)
    self.stack.push(contentsOf: after.reversed())
    self.stack.push(list.asObject)
    self.stack.push(contentsOf: before.reversed())

    return .ok
  }

  private func notIterableUnpackError(iterable: PyObject) -> PyBaseException? {
    let hasIter = self.py.hasIter(object: iterable)

    if !hasIter {
      let message = "cannot unpack non-iterable \(iterable.typeName) object"
      return self.newTypeError(message: message)
    }

    return nil
  }
}
