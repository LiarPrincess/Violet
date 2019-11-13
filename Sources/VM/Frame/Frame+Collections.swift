import Bytecode
import Objects

extension Frame {

  // MARK: - Build

  /// Creates a tuple consuming `count` items from the stack,
  /// and pushes the resulting tuple onto the stack.
  internal func buildTuple(elementCount: Int) -> InstructionResult {
    let elements = self.stack.popElementsInPushOrder(count: elementCount)
    let collection = self.builtins.newTuple(elements)
    self.stack.push(collection)
    return .ok
  }

  /// Creates a list consuming `count` items from the stack,
  /// and pushes the resulting list onto the stack.
  internal func buildList(elementCount: Int) -> InstructionResult {
    let elements = self.stack.popElementsInPushOrder(count: elementCount)
    let collection = self.builtins.newList(elements)
    self.stack.push(collection)
    return .ok
  }

  /// Creates a set consuming `count` items from the stack,
  /// and pushes the resulting set onto the stack.
  internal func buildSet(elementCount: Int) -> InstructionResult {
    let elements = self.stack.popElementsInPushOrder(count: elementCount)
    let collection = self.builtins.newSet(elements)
    self.stack.push(collection)
    return .ok
  }

  /// Pushes a new dictionary object onto the stack.
  /// Pops 2 * count items so that the dictionary holds count entries:
  /// {..., TOS3: TOS2, TOS1: TOS}.
  internal func buildMap(elementCount: Int) -> InstructionResult {
    let elements = self.popDictionaryElements(count: elementCount)
    let collection = self.builtins.newDict(elements)
    self.stack.push(collection)
    return .ok
  }

  /// The version of `BuildMap` specialized for constant keys.
  /// `elementCount` values are consumed from the stack.
  /// The top element on the stack contains a tuple of keys.
  internal func buildConstKeyMap(elementCount: Int) -> InstructionResult {
    let keys = self.stack.pop()
    let count = self.context.getSizeInt(value: keys)

    if count != elementCount {
      return .builtinError(.systemError("bad BUILD_CONST_KEY_MAP keys argument"))
    }

    let elements = self.stack.popElementsInPushOrder(count: count)
    let collection = self.builtins.newDict(keyTuple: keys, elements: elements)
    self.stack.push(collection)
    return .ok
  }

  private func popDictionaryElements(count: Int) -> [CreateDictionaryArg] {
    var elements = [CreateDictionaryArg]()
    for _ in 0..<count {
      let value = self.stack.pop()
      let key = self.stack.pop()
      elements.push(CreateDictionaryArg(key: key, value: value))
    }

    // Elements on stack are in reverse order
    return elements.reversed()
  }

  // MARK: - Add

  /// Calls `set.add(TOS1[-i], TOS)`.
  /// Container object remains on the stack.
  /// Used to implement set comprehensions.
  internal func setAdd(value: Int) -> InstructionResult {
    let element = self.stack.pop()
    let set = self.stack.top
    self.builtins.add(set: set, value: element)
    return .ok
  }

  /// Calls `list.append(TOS[-i], TOS)`.
  /// Container object remains on the stack.
  /// Used to implement list comprehensions.
  internal func listAppend(value: Int) -> InstructionResult {
    let element = self.stack.pop()
    let list = self.stack.top
    self.builtins.add(list: list, element: element)
    return .ok
  }

  /// Calls `dict.setitem(TOS1[-i], TOS, TOS1)`.
  /// Container object remains on the stack.
  /// Used to implement dict comprehensions.
  internal func mapAdd(value: Int) -> InstructionResult {
    let key = self.stack.pop()
    let value = self.stack.pop()
    let map = self.stack.top
    self.builtins.add(dict: map, key: key, value: value)
    return .ok
  }
}
