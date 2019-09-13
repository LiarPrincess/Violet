import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length

/// Helper for `emitLoadWithPossibleUnpack` method.
/// We could pass clojures with `self`, but this is more self-documenting.
private protocol CollectionLoadAdapter {
  /// Create an *artificial container* for elements with given `count`.
  ///
  /// For example: `(a, b*, c) -> (*[a], *b) -> BuildTupleUnpack(count: 2)`,
  /// where [a] is an *artificial container*.
  func emitPackElements(count: Int) throws

  /// Create collection (tuple, list etc.) from elements with given `count`.
  ///
  /// For example: `(a, b, c) -> BuildTuple(count: 3)`
  func emitBuildCollection(count: Int) throws

  /// Create collection from iterable elements with given `count`.
  ///
  /// For example: `(*a, *b, *c) -> BuildTupleUnpack(count: 3)`
  func emitBuildUnpackCollection(count: Int) throws
}

extension Compiler {

  // MARK: - Tuple

  /// compiler_tuple(struct compiler *c, expr_ty e)
  internal func visitTuple(elements: [Expression],
                           context:  ExpressionContext) throws {
    switch context {
    case .store:
      try self.emitStoreWithPossibleUnpack(elements: elements)
    case .load:
      let adapter = TupleLoadAdapter(builder: self.builder)
      try self.emitLoadWithPossibleUnpack(elements: elements, adapter:  adapter)
    case .del:
      try self.visitExpressions(elements, context: .del)
    }
  }

  private struct TupleLoadAdapter: CollectionLoadAdapter {

    fileprivate let builder: CodeObjectBuilder

    func emitPackElements(count: Int) throws {
      try self.builder.appendBuildTuple(elementCount: count)
    }

    func emitBuildCollection(count: Int) throws {
      try self.builder.appendBuildTuple(elementCount: count)
    }

    func emitBuildUnpackCollection(count: Int) throws {
      try self.builder.appendBuildTupleUnpack(elementCount: count)
    }
  }

  // MARK: - List

  /// compiler_list(struct compiler *c, expr_ty e)
  internal func visitList(elements: [Expression], context:  ExpressionContext) throws {
    switch context {
    case .store:
      try self.emitStoreWithPossibleUnpack(elements: elements)
    case .load:
      let adapter = ListLoadAdapter(builder: self.builder)
      try self.emitLoadWithPossibleUnpack(elements: elements, adapter:  adapter)
    case .del:
      try self.visitExpressions(elements, context: .del)
    }
  }

  private struct ListLoadAdapter: CollectionLoadAdapter {

    fileprivate let builder: CodeObjectBuilder

    func emitPackElements(count: Int) throws {
      try self.builder.appendBuildTuple(elementCount: count)
    }

    func emitBuildCollection(count: Int) throws {
      try self.builder.appendBuildList(elementCount: count)
    }

    func emitBuildUnpackCollection(count: Int) throws {
      try self.builder.appendBuildListUnpack(elementCount: count)
    }
  }

  // MARK: - Dictionary

  /// compiler_dict(struct compiler *c, expr_ty e)
  ///
  /// Our implementation is similiar to `self.visitLoadWithPossibleUnpack(...)`.
  internal func visitDictionary(elements: [DictionaryElement],
                                context:  ExpressionContext) throws {
    assert(context == .load)

    /// Elements that do not need unpacking
    var nSimpleElement = 0
    /// Elements that need unpacking
    var nPackedElement = 0

    for element in elements {
      switch element {
      case let .unpacking(expr):
        // change elements to container, so we can unpack it later
        if nSimpleElement > 0 {
          try self.builder.appendBuildMap(elementCount: nSimpleElement)
          nSimpleElement = 0
          nPackedElement += 1
        }

        // add another container
        try self.visitExpression(expr)
        nPackedElement += 1

      case let .keyValue(key: k, value: v):
        try self.visitExpression(k)
        try self.visitExpression(v)
        nSimpleElement += 1
      }
    }

    if nPackedElement > 0 {
      if nSimpleElement > 0 {
        try self.builder.appendBuildMap(elementCount: nSimpleElement)
        nPackedElement += 1
      }

      try self.builder.appendBuildMapUnpack(elementCount: nPackedElement)
    } else {
      try self.builder.appendBuildMap(elementCount: nSimpleElement)
    }
  }

  // MARK: - Set

  /// compiler_set(struct compiler *c, expr_ty e)
  internal func visitSet(elements: [Expression], context:  ExpressionContext) throws {
    assert(context == .load)

    let adapter = SetLoadAdapter(builder: self.builder)
    try self.emitLoadWithPossibleUnpack(elements: elements, adapter:  adapter)
  }

  private struct SetLoadAdapter: CollectionLoadAdapter {

    fileprivate let builder: CodeObjectBuilder

    func emitPackElements(count: Int) throws {
      try self.builder.appendBuildSet(elementCount: count)
    }

    func emitBuildCollection(count: Int) throws {
      try self.builder.appendBuildSet(elementCount: count)
    }

    func emitBuildUnpackCollection(count: Int) throws {
      try self.builder.appendBuildSetUnpack(elementCount: count)
    }
  }

  // MARK: - Helpers

  /// assignment_helper(struct compiler *c, asdl_seq *elts)
  ///
  /// `dis.dis('a, *b, c = [1, 2, 3]')` gives us:
  /// ```c
  ///  0 LOAD_CONST               0 (1)
  ///  2 LOAD_CONST               1 (2)
  ///  4 LOAD_CONST               2 (3)
  ///  6 BUILD_LIST               3
  ///  8 EXTENDED_ARG             1
  /// 10 UNPACK_EX              257
  /// 12 STORE_NAME               0 (a)
  /// 14 STORE_NAME               1 (b)
  /// 16 STORE_NAME               2 (c)
  /// 18 LOAD_CONST               3 (None)
  /// 20 RETURN_VALUE
  /// ```
  private func emitStoreWithPossibleUnpack(elements: [Expression]) throws {

    var hasSeenStar = false
    var elementsWithoutUnpack = elements

    for (index, element) in elements.enumerated() {
      guard case let .starred(inner) = element.kind else {
        continue
      }

      guard !hasSeenStar else {
        throw self.error(.multipleStarredInAssignmentExpressions)
      }

      // 0x0000_00ff
      //          ^^ element count before *
      // 0xffff_ff00
      //   ^^^^^^^   element count after *

      let countBefore = index
      let countAfter = elements.count - index - 1
      if countBefore > 0xff || countAfter > 0xffff_ff {
        throw self.error(.tooManyExpressionsInStarUnpackingAssignment)
      }

      hasSeenStar = true
      elementsWithoutUnpack[index] = inner
      try self.builder.appendUnpackEx(countBefore: countBefore, countAfter: countAfter)
    }

    if !hasSeenStar {
      try self.builder.appendUnpackSequence(elementCount: elements.count)
    }

    try self.visitExpressions(elementsWithoutUnpack, context: .store)
  }

  /// starunpack_helper(struct compiler *c, asdl_seq *elts, int single_op,
  /// int inner_op, int outer_op)
  ///
  /// `dis.dis('(a, *b, c)')` gives us:
  /// ```c
  ///  0 LOAD_NAME                0 (a)
  ///  2 BUILD_TUPLE              1     <- create artificial container
  ///  4 LOAD_NAME                1 (b)
  ///  6 LOAD_NAME                2 (c)
  ///  8 BUILD_TUPLE              1     <- create artificial container
  /// 10 BUILD_TUPLE_UNPACK       3     <- unpack containers
  /// 12 RETURN_VALUE
  /// ```
  private func emitLoadWithPossibleUnpack<A: CollectionLoadAdapter>(
    elements: [Expression],
    adapter:  A) throws {

    /// Elements that do not need unpacking
    var nSimpleElement = 0
    /// Elements that need unpacking
    var nPackedElement = 0

    for element in elements {
      switch element.kind {
      case let .starred(inner):
        // change elements to container, so we can unpack it later
        if nSimpleElement > 0 {
          try adapter.emitPackElements(count: nSimpleElement)
          nSimpleElement = 0
          nPackedElement += 1
        }

        // add another container
        try self.visitExpression(inner)
        nPackedElement += 1

      default:
        try self.visitExpression(element)
        nSimpleElement += 1
      }
    }

    if nPackedElement > 0 {
      if nSimpleElement > 0 {
        try adapter.emitPackElements(count: nSimpleElement)
        nPackedElement += 1
      }

      try adapter.emitBuildUnpackCollection(count: nPackedElement)
    } else {
      try adapter.emitBuildCollection(count: nSimpleElement)
    }
  }
}
