import VioletBytecode
import VioletObjects

// swiftlint:disable file_length

extension Eval {

  // MARK: - Unpack tuple/list

  /// Pops count iterables from the stack, joins them in a single tuple,
  /// and pushes the result.
  /// Implements iterable unpacking in tuple displays `(*x, *y, *z)`.
  internal func buildTupleUnpack(elementCount: Int) -> InstructionResult {
    switch self.unpackToArray(elementCount: elementCount) {
    case let .value(elements):
      self.stack.push(Py.newTuple(elements: elements))
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
      self.stack.push(Py.newList(elements: elements))
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func unpackToArray(elementCount: Int) -> PyResult<[PyObject]> {
    var result = [PyObject]()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for iterable in iterables {
      switch Py.toArray(iterable: iterable) {
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
      switch Py.toArray(iterable: iterable) {
      case let .value(elements):
        result.append(contentsOf: elements)
      case let .error(e):
        // Try to be a bit more precise in the error message.
        let e2 = self.tupleUnpackWithCallError(iterable: iterable, error: e) ?? e
        return .exception(e2)
      }
    }

    self.stack.push(Py.newTuple(elements: result))
    return .ok
  }

  private func tupleUnpackWithCallError(
    iterable: PyObject,
    error: PyBaseException
  ) -> PyBaseException? {
    let isTypeErrorForIter = error.isTypeError && !Py.hasIter(object: iterable)
    guard isTypeErrorForIter else {
      return nil
    }

    let fn = self.stack.top
    let fnName = Py.getFunctionName(object: fn) ?? "function"

    let msg = "\(fnName) argument after * must be an iterable, not \(iterable.type)"
    return Py.newTypeError(msg: msg)
  }

  // MARK: - Unpack set

  /// This is similar to `BuildTupleUnpack`, but pushes a set instead of tuple.
  /// Implements iterable unpacking in set displays `{*x, *y, *z}`.
  internal func buildSetUnpack(elementCount: Int) -> InstructionResult {
    let set = Py.newSet()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for object in iterables {
      switch set.update(from: object) {
      case .value:
        break // just go to the next element
      case .error(let e):
        return .exception(e)
      }
    }

    self.stack.push(set)
    return .ok
  }

  // MARK: - Unpack map

  /// Pops count mappings from the stack, merges them into a single dictionary,
  /// and pushes the result.
  /// Implements dictionary unpacking in dictionary displays `{**x, **y, **z}`.
  internal func buildMapUnpack(elementCount: Int) -> InstructionResult {
    let dict = Py.newDict()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for object in iterables {
      switch dict.update(from: object, onKeyDuplicate: .continue) {
      case .value:
        break // just go to the next element
      case .error(let e):
        if e.isAttributeError {
          let msg = "'\(object.typeName)' object is not a mapping"
          return .exception(Py.newTypeError(msg: msg))
        }

        return .exception(e)
      }
    }

    self.stack.push(dict)
    return .ok
  }

  /// This is similar to `BuildMapUnpack`, but is used for `f(**x, **y, **z)` call syntax.
  /// The stack item at position count + 2 should be the corresponding callable `f`.
  internal func buildMapUnpackWithCall(elementCount: Int) -> InstructionResult {
    let dict = Py.newDict()
    let iterables = self.stack.popElementsInPushOrder(count: elementCount)

    for object in iterables {
      switch dict.update(from: object, onKeyDuplicate: .error) {
      case .value:
        break // just go to the next element
      case .error(let e):
        if e.isKeyError {
          let e2 = self.mapUnpackWithCallDuplicateError(keyError: e)
          return .exception(e2)
        }

        // Try to be a bit more precise in the error message.
        let e2 = self.mapUnpackWithCallError(iterable: object, error: e) ?? e
        return .exception(e2)
      }
    }

    self.stack.push(dict)
    return .ok
  }

  private func mapUnpackWithCallDuplicateError(
    keyError: PyBaseException
  ) -> PyBaseException {
    /// Template: function_name() got multiple values for keyword argument 'key_str'
    var msg = ""

    if self.stack.count >= 2 {
      let fnObject = self.stack.second

      if let name = Py.getFunctionName(object: fnObject) {
        msg.append(name + "() ")
      } else {
        msg.append(fnObject.typeName + "object ")
      }
    }

    msg.append("got multiple values for keyword argument")

    let args = keyError.getArgs()
    if let firstArg = args.elements.first {
      switch Py.strValue(object: firstArg) {
      case .value(let s):
        msg.append(" \(s.quoted)")
      case .error:
        break
      }
    }

    return Py.newTypeError(msg: msg)
  }

  private func mapUnpackWithCallError(
    iterable: PyObject,
    error: PyBaseException
  ) -> PyBaseException? {

    let fn = self.stack.second
    let fnName = Py.getFunctionName(object: fn) ?? "function"

    if error.isAttributeError {
      let t = iterable.typeName
      let msg = "\(fnName) argument after ** must be a mapping, not \(t)"
      return Py.newTypeError(msg: msg)
    }

    if let keyError = PyCast.asKeyError(error) {
      let args = keyError.getArgs()
      guard let first = args.elements.first else { return nil }

      if let key = PyCast.asString(first) {
        let msg = "\(fnName) got multiple values for keyword argument '\(key)'"
        return Py.newTypeError(msg: msg)
      }

      let msg = "\(fnName) keywords must be strings"
      return Py.newTypeError(msg: msg)
    }

    return nil
  }

  // MARK: - Unpack sequence

  /// Unpacks TOS into count individual values,
  /// which are put onto the stack right-to-left.
  internal func unpackSequence(elementCount: Int) -> InstructionResult {
    let iterable = self.stack.pop()

    let elements: [PyObject]
    switch Py.toArray(iterable: iterable) {
    case let .value(e):
      elements = e
    case let .error(e):
      // Try to be a bit more precise in the error message.
      let e2 = self.notIterableUnpackError(iterable: iterable) ?? e
      return .exception(e2)
    }

    if elements.count < elementCount {
      let got = elements.count
      let msg = "not enough values to unpack (expected \(elementCount), got \(got))"
      return .exception(Py.newValueError(msg: msg))
    }

    if elements.count > elementCount {
      let msg = "too many values to unpack (expected \(elementCount))"
      return .exception(Py.newValueError(msg: msg))
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
    switch Py.toArray(iterable: iterable) {
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
      let msg = "not enough values to unpack (expected at least \(minCount), got \(got))"
      return .exception(Py.newValueError(msg: msg))
    }

    let afterStartsAtIndex = elements.count - arg.countAfter
    let before = elements[..<arg.countBefore]
    let pack = Array(elements[arg.countBefore..<afterStartsAtIndex])
    let after = elements[afterStartsAtIndex...]

    assert(before.count == arg.countBefore)
    assert(pack.count == elements.count - arg.countBefore - arg.countAfter)
    assert(after.count == arg.countAfter)

    // Reverse because we have to push them in 'right-to-left' order!
    self.stack.push(contentsOf: after.reversed())
    self.stack.push(Py.newList(elements: pack))
    self.stack.push(contentsOf: before.reversed())

    return .ok
  }

  private func notIterableUnpackError(iterable: PyObject) -> PyBaseException? {
    let hasIter = Py.hasIter(object: iterable)

    if !hasIter {
      let msg = "cannot unpack non-iterable \(iterable.typeName) object"
      return Py.newTypeError(msg: msg)
    }

    return nil
  }
}
