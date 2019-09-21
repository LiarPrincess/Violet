import Bytecode

extension Frame {

  // MARK: - Collections

  /// Creates a tuple consuming `count` items from the stack,
  /// and pushes the resulting tuple onto the stack.
  internal func buildTuple(elementCount: Int) throws {
    self.unimplemented()
  }

  /// Creates a list consuming `count` items from the stack,
  /// and pushes the resulting list onto the stack.
  internal func buildList(elementCount: Int) throws {
    self.unimplemented()
  }

  /// Creates a set consuming `count` items from the stack,
  /// and pushes the resulting set onto the stack.
  internal func buildSet(elementCount: Int) throws {
    self.unimplemented()
  }

  /// Pushes a new dictionary object onto the stack.
  /// Pops 2 * count items so that the dictionary holds count entries:
  /// {..., TOS3: TOS2, TOS1: TOS}.
  internal func buildMap(elementCount: Int) throws {
    self.unimplemented()
  }

  /// The version of `BuildMap` specialized for constant keys.
  /// `elementCount` values are consumed from the stack.
  /// The top element on the stack contains a tuple of keys.
  internal func buildConstKeyMap(elementCount: Int) throws {
    self.unimplemented()
  }

  /// Calls `set.add(TOS1[-i], TOS)`. Container object remains on the stack.
  /// Used to implement set comprehensions.
  internal func setAdd(value: Int) throws {
    self.unimplemented()
  }

  /// Calls `list.append(TOS[-i], TOS)`. Container object remains on the stack.
  /// Used to implement list comprehensions.
  internal func listAppend(value: Int) throws {
    self.unimplemented()
  }

  /// Calls `dict.setitem(TOS1[-i], TOS, TOS1)`. Container object remains on the stack.
  /// Used to implement dict comprehensions.
  internal func mapAdd(value: Int) throws {
    self.unimplemented()
  }

  // MARK: - Unpack

  /// Pops count iterables from the stack, joins them in a single tuple,
  /// and pushes the result.
  /// Implements iterable unpacking in tuple displays `(*x, *y, *z)`.
  internal func buildTupleUnpack(elementCount: Int) throws {
    self.unimplemented()
  }

  /// This is similar to `BuildTupleUnpack`, but is used for `f(*x, *y, *z)` call syntax.
  /// The stack item at position count + 1 should be the corresponding callable `f`.
  internal func buildTupleUnpackWithCall(elementCount: Int) throws {
    self.unimplemented()
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a list instead of tuple.
  /// Implements iterable unpacking in list displays `[*x, *y, *z]`.
  internal func buildListUnpack(elementCount: Int) throws {
    self.unimplemented()
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a set instead of tuple.
  /// Implements iterable unpacking in set displays `{*x, *y, *z}`.
  internal func buildSetUnpack(elementCount: Int) throws {
    self.unimplemented()
  }

  /// Pops count mappings from the stack, merges them into a single dictionary,
  /// and pushes the result.
  /// Implements dictionary unpacking in dictionary displays `{**x, **y, **z}`.
  internal func buildMapUnpack(elementCount: Int) throws {
    self.unimplemented()
  }

  /// This is similar to `BuildMapUnpack`, but is used for `f(**x, **y, **z)` call syntax.
  /// The stack item at position count + 2 should be the corresponding callable `f`.
  internal func buildMapUnpackWithCall(elementCount: Int) throws {
    self.unimplemented()
  }

  /// Unpacks TOS into count individual values,
  /// which are put onto the stack right-to-left.
  internal func unpackSequence(elementCount: Int) throws {
    self.unimplemented()
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
  internal func unpackEx(elementCountBefore: Int) throws {
    self.unimplemented()
  }
}
