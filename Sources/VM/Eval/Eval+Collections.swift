/* MARKER
import VioletBytecode
import VioletObjects

private typealias DictionaryElement = PyInstance.DictionaryElement

extension Eval {

  // MARK: - Tuple

  /// Creates a tuple consuming `count` items from the stack,
  /// and pushes the resulting tuple onto the stack.
  internal func buildTuple(elementCount: Int) -> InstructionResult {
    let elements = self.stack.popElementsInPushOrder(count: elementCount)
    let collection = Py.newTuple(elements: elements)
    self.stack.push(collection)
    return .ok
  }

  // MARK: - List

  /// Creates a list consuming `count` items from the stack,
  /// and pushes the resulting list onto the stack.
  internal func buildList(elementCount: Int) -> InstructionResult {
    let elements = self.stack.popElementsInPushOrder(count: elementCount)
    let collection = Py.newList(elements: elements)
    self.stack.push(collection)
    return .ok
  }

  /// Calls `list.append(TOS[-i], TOS)`.
  /// Container object remains on the stack.
  /// Used to implement list comprehensions.
  internal func listAdd(stackIndex: Int) -> InstructionResult {
    let element = self.stack.pop()
    let list = self.stack.peek(stackIndex)

    switch Py.add(list: list, element: element) {
    case .value:
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Set

  /// Creates a set consuming `count` items from the stack,
  /// and pushes the resulting set onto the stack.
  internal func buildSet(elementCount: Int) -> InstructionResult {
    let elements = self.stack.popElementsInPushOrder(count: elementCount)
    switch Py.newSet(elements: elements) {
    case let .value(collection):
      self.stack.push(collection)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Calls `set.add(TOS1[-i], TOS)`.
  /// Container object remains on the stack.
  /// Used to implement set comprehensions.
  internal func setAdd(stackIndex: Int) -> InstructionResult {
    let element = self.stack.pop()
    let set = self.stack.peek(stackIndex)

    switch Py.add(set: set, element: element) {
    case .value:
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Map

  /// Pushes a new dictionary object onto the stack.
  /// Pops 2 * count items so that the dictionary holds count entries:
  /// {..., TOS3: TOS2, TOS1: TOS}.
  internal func buildMap(elementCount: Int) -> InstructionResult {
    let elements = self.popDictionaryElements(count: elementCount)
    switch Py.newDict(elements: elements) {
    case let .value(collection):
      self.stack.push(collection)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// The version of `BuildMap` specialized for constant keys.
  /// `elementCount` values are consumed from the stack.
  /// The top element on the stack contains a tuple of keys.
  internal func buildConstKeyMap(elementCount: Int) -> InstructionResult {
    let keys = self.stack.pop()

    guard let keysTuple = self.py.cast.asTuple(keys) else {
      let msg = "bad BUILD_CONST_KEY_MAP keys argument"
      return .exception(Py.newSystemError(msg: msg))
    }

    let count = Py.lenInt(tuple: keysTuple)
    let elements = self.stack.popElementsInPushOrder(count: count)

    switch Py.newDict(keys: keysTuple, elements: elements) {
    case let .value(collection):
      self.stack.push(collection)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func popDictionaryElements(count: Int) -> [DictionaryElement] {
    var elements = [DictionaryElement]()
    for _ in 0..<count {
      let value = self.stack.pop()
      let key = self.stack.pop()
      elements.push(DictionaryElement(key: key, value: value))
    }

    // Elements on stack are in reverse order
    return elements.reversed()
  }

  /// Calls `dict.setitem(TOS1[-i], TOS, TOS1)`.
  /// Container object remains on the stack.
  /// Used to implement dict comprehensions.
  internal func mapAdd(stackIndex: Int) -> InstructionResult {
    let key = self.stack.pop()
    let value = self.stack.pop()
    let map = self.stack.peek(stackIndex)

    switch Py.add(dict: map, key: key, value: value) {
    case .value:
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Slice

  /// Pushes a slice object on the stack.
  internal func buildSlice(arg: Instruction.SliceArg) -> InstructionResult {
    let step: PyObject? = {
      switch arg {
      case .lowerUpper:
        return nil
      case .lowerUpperStep:
        return self.stack.pop()
      }
    }()

    let stop = self.stack.pop()
    let start = self.stack.top

    let slice = Py.newSlice(start: start, stop: stop, step: step)
    self.stack.top = slice
    return .ok
  }
}

*/
