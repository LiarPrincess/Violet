import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// cSpell:ignore elts starunpack

/// Helper for `emitLoadWithPossibleUnpack` method.
/// We could pass clojure with `self`, but this is more self-documenting.
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

extension CompilerImpl {

  // MARK: - Tuple

  private struct TupleLoadAdapter: CollectionLoadAdapter {

    fileprivate let builder: CodeObjectBuilder

    func emitPackElements(count: Int) throws {
      self.builder.appendBuildTuple(elementCount: count)
    }

    func emitBuildCollection(count: Int) throws {
      self.builder.appendBuildTuple(elementCount: count)
    }

    func emitBuildUnpackCollection(count: Int) throws {
      self.builder.appendBuildTupleUnpack(elementCount: count)
    }
  }

  /// compiler_tuple(struct compiler *c, expr_ty e)
  internal func visit(_ node: TupleExpr) throws {
    let elements = node.elements

    switch node.context {
    case .store:
      try self.emitStoreWithPossibleUnpack(elements: elements)
    case .load:
      let adapter = TupleLoadAdapter(builder: self.builder)
      try self.emitLoadWithPossibleUnpack(elements: elements, adapter: adapter)
    case .del:
      try self.visit(elements)
    }
  }

  // MARK: - List

  private struct ListLoadAdapter: CollectionLoadAdapter {

    fileprivate let builder: CodeObjectBuilder

    func emitPackElements(count: Int) throws {
      self.builder.appendBuildTuple(elementCount: count)
    }

    func emitBuildCollection(count: Int) throws {
      self.builder.appendBuildList(elementCount: count)
    }

    func emitBuildUnpackCollection(count: Int) throws {
      self.builder.appendBuildListUnpack(elementCount: count)
    }
  }

  /// compiler_list(struct compiler *c, expr_ty e)
  internal func visit(_ node: ListExpr) throws {
    let elements = node.elements

    switch node.context {
    case .store:
      try self.emitStoreWithPossibleUnpack(elements: elements)
    case .load:
      let adapter = ListLoadAdapter(builder: self.builder)
      try self.emitLoadWithPossibleUnpack(elements: elements, adapter: adapter)
    case .del:
      try self.visit(elements)
    }
  }

  // MARK: - Dictionary

  /// compiler_dict(struct compiler *c, expr_ty e)
  ///
  /// Our implementation is similar to `self.visitLoadWithPossibleUnpack(...)`.
  internal func visit(_ node: DictionaryExpr) throws {
    assert(node.context == .load)

    /// Elements that do not need unpacking
    var nSimpleElement = 0
    /// Elements that need unpacking
    var nPackedElement = 0

    for element in node.elements {
      switch element {
      case let .unpacking(expr):
        // change elements to container, so we can unpack it later
        if nSimpleElement > 0 {
          self.builder.appendBuildMap(elementCount: nSimpleElement)
          nSimpleElement = 0
          nPackedElement += 1
        }

        // add another container
        try self.visit(expr)
        nPackedElement += 1

      case let .keyValue(key: k, value: v):
        try self.visit(k)
        try self.visit(v)
        nSimpleElement += 1
      }
    }

    if nPackedElement > 0 {
      if nSimpleElement > 0 {
        self.builder.appendBuildMap(elementCount: nSimpleElement)
        nPackedElement += 1
      }

      self.builder.appendBuildMapUnpack(elementCount: nPackedElement)
    } else {
      self.builder.appendBuildMap(elementCount: nSimpleElement)
    }
  }

  // MARK: - Set

  private struct SetLoadAdapter: CollectionLoadAdapter {

    fileprivate let builder: CodeObjectBuilder

    func emitPackElements(count: Int) throws {
      self.builder.appendBuildSet(elementCount: count)
    }

    func emitBuildCollection(count: Int) throws {
      self.builder.appendBuildSet(elementCount: count)
    }

    func emitBuildUnpackCollection(count: Int) throws {
      self.builder.appendBuildSetUnpack(elementCount: count)
    }
  }

  /// compiler_set(struct compiler *c, expr_ty e)
  internal func visit(_ node: SetExpr) throws {
    assert(node.context == .load)

    let elements = node.elements
    let adapter = SetLoadAdapter(builder: self.builder)
    try self.emitLoadWithPossibleUnpack(elements: elements, adapter: adapter)
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

    // Find unpack
    for (index, element) in elements.enumerated() {
      guard let star = element as? StarredExpr else {
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
      if countBefore > 0xff || countAfter > 0xff_ffff {
        throw self.error(.tooManyExpressionsInStarUnpackingAssignment)
      }

      hasSeenStar = true
      elementsWithoutUnpack[index] = star.expression
      self.builder.appendUnpackEx(countBefore: countBefore, countAfter: countAfter)
    }

    if !hasSeenStar {
      self.builder.appendUnpackSequence(elementCount: elements.count)
    }

    try self.visit(elementsWithoutUnpack)
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
    adapter: A
  ) throws {

    /// Elements that do not need unpacking
    var nSimpleElement = 0
    /// Elements that need unpacking
    var nPackedElement = 0

    for element in elements {
      if let star = element as? StarredExpr {
        // change elements to container, so we can unpack it later
        if nSimpleElement > 0 {
          try adapter.emitPackElements(count: nSimpleElement)
          nSimpleElement = 0
          nPackedElement += 1
        }

        // add another container
        try self.visit(star.expression)
        nPackedElement += 1
      } else {
        try self.visit(element)
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
