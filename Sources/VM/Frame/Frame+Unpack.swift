import Bytecode
import Objects

extension Frame {

  /// Pops count iterables from the stack, joins them in a single tuple,
  /// and pushes the result.
  /// Implements iterable unpacking in tuple displays `(*x, *y, *z)`.
  internal func buildTupleUnpack(elementCount: Int) -> InstructionResult {
    return .unimplemented
  }

  /// This is similar to `BuildTupleUnpack`, but is used for `f(*x, *y, *z)` call syntax.
  /// The stack item at position count + 1 should be the corresponding callable `f`.
  internal func buildTupleUnpackWithCall(elementCount: Int) -> InstructionResult {
    return .unimplemented
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a list instead of tuple.
  /// Implements iterable unpacking in list displays `[*x, *y, *z]`.
  internal func buildListUnpack(elementCount: Int) -> InstructionResult {
    return .unimplemented
  }

  /// This is similar to `BuildTupleUnpack`, but pushes a set instead of tuple.
  /// Implements iterable unpacking in set displays `{*x, *y, *z}`.
  internal func buildSetUnpack(elementCount: Int) -> InstructionResult {
    return .unimplemented
  }

  /// Pops count mappings from the stack, merges them into a single dictionary,
  /// and pushes the result.
  /// Implements dictionary unpacking in dictionary displays `{**x, **y, **z}`.
  internal func buildMapUnpack(elementCount: Int) -> InstructionResult {
    return .unimplemented
  }

  /// This is similar to `BuildMapUnpack`, but is used for `f(**x, **y, **z)` call syntax.
  /// The stack item at position count + 2 should be the corresponding callable `f`.
  internal func buildMapUnpackWithCall(elementCount: Int) -> InstructionResult {
    return .unimplemented
  }

  /// Unpacks TOS into count individual values,
  /// which are put onto the stack right-to-left.
  internal func unpackSequence(elementCount: Int) -> InstructionResult {
    return .unimplemented
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
    return .unimplemented
  }
}
