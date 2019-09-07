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
  func emitPackElements(count: Int, location: SourceLocation) throws

  /// Create collection (tuple, list etc.) from elements with given `count`.
  ///
  /// For example: `(a, b, c) -> BuildTuple(count: 3)`
  func emitBuildCollection(count: Int, location: SourceLocation) throws

  /// Create collection from iterable elements with given `count`.
  ///
  /// For example: `(*a, *b, *c) -> BuildTupleUnpack(count: 3)`
  func emitBuildUnpackCollection(count: Int, location: SourceLocation) throws
}

extension Compiler {

  // MARK: - Tuple

  /// compiler_tuple(struct compiler *c, expr_ty e)
  internal func visitTuple(elements: [Expression],
                           context:  ExpressionContext,
                           location: SourceLocation) throws {
    switch context {
    case .store:
      try self.emitStoreWithPossibleUnpack(elements: elements, location: location)
    case .load:
      let adapter = TupleLoadAdapter(codeObject: self.codeObject)
      try self.emitLoadWithPossibleUnpack(elements: elements,
                                          adapter:  adapter,
                                          location: location)
    case .del:
      try self.visitExpressions(elements, context: .del)
    }
  }

  private struct TupleLoadAdapter: CollectionLoadAdapter {

    fileprivate let codeObject: CodeObject

    func emitPackElements(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildTuple(elementCount: count, at: location)
    }

    func emitBuildCollection(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildTuple(elementCount: count, at: location)
    }

    func emitBuildUnpackCollection(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildTupleUnpack(elementCount: count, at: location)
    }
  }

  // MARK: - List

  /// compiler_list(struct compiler *c, expr_ty e)
  internal func visitList(elements: [Expression],
                          context:  ExpressionContext,
                          location: SourceLocation) throws {
    switch context {
    case .store:
      try self.emitStoreWithPossibleUnpack(elements: elements, location: location)
    case .load:
      let adapter = ListLoadAdapter(codeObject: self.codeObject)
      try self.emitLoadWithPossibleUnpack(elements: elements,
                                          adapter:  adapter,
                                          location: location)
    case .del:
      try self.visitExpressions(elements, context: .del)
    }
  }

  private struct ListLoadAdapter: CollectionLoadAdapter {

    fileprivate let codeObject: CodeObject

    func emitPackElements(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildList(elementCount: count, at: location)
    }

    func emitBuildCollection(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildTuple(elementCount: count, at: location)
    }

    func emitBuildUnpackCollection(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildListUnpack(elementCount: count, at: location)
    }
  }

  // MARK: - Dictionary

  /// compiler_dict(struct compiler *c, expr_ty e)
  ///
  /// Our implementation is similiar to `self.codeObject.appendLoadWithPossibleUnpack(...)`.
  internal func visitDictionary(elements: [DictionaryElement],
                                context:  ExpressionContext,
                                location: SourceLocation) throws {
    // TODO: CPython does this differently (const)
    assert(context == .load)

    /// Elements that do not need unpacking
    var nSimpleElement = 0
    /// Elements that need unpacking
    var nPackedElement = 0

    for el in elements {
      switch el {
      case let .unpacking(expr):
        // change elements to container, so we can unpack it later
        if nSimpleElement > 0 {
          try self.codeObject.appendBuildMap(elementCount: nSimpleElement, at: location)
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
        try self.codeObject.appendBuildMap(elementCount: nSimpleElement, at: location)
        nPackedElement += 1
      }

      try self.codeObject.appendBuildMapUnpack(elementCount: nPackedElement, at: location)
    } else {
      try self.codeObject.appendBuildMap(elementCount: nSimpleElement, at: location)
    }
  }

  // MARK: - Set

  /// compiler_set(struct compiler *c, expr_ty e)
  internal func visitSet(elements: [Expression],
                         context:  ExpressionContext,
                         location: SourceLocation) throws {
    assert(context == .load)

    let adapter = SetLoadAdapter(codeObject: self.codeObject)
    try self.emitLoadWithPossibleUnpack(elements: elements,
                                        adapter:  adapter,
                                        location: location)
  }

  private struct SetLoadAdapter: CollectionLoadAdapter {

    fileprivate let codeObject: CodeObject

    func emitPackElements(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildSet(elementCount: count, at: location)
    }

    func emitBuildCollection(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildSet(elementCount: count, at: location)
    }

    func emitBuildUnpackCollection(count: Int, location: SourceLocation) throws {
      try self.codeObject.appendBuildSetUnpack(elementCount: count, at: location)
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
  private func emitStoreWithPossibleUnpack(elements: [Expression],
                                           location: SourceLocation) throws {

    var hasSeenStar = false
    var elementsWithoutUnpack = elements

    for (index, el) in elements.enumerated() {
      guard case let .starred(inner) = el.kind else {
        continue
      }

      guard !hasSeenStar else {
        let kind = CompilerErrorKind.multipleStarredInAssignmentExpressions
        throw self.error(kind, location: location)
      }

      // 0x0000_00ff
      //          ^^ element count before *
      // 0xffff_ff00
      //   ^^^^^^^   element count after *

      let countBefore = index
      let countAfter = elements.count - index - 1
      if countBefore > 0xff || countAfter > 0xffff_ff {
        let kind = CompilerErrorKind.tooManyExpressionsInStarUnpackingAssignment
        throw self.error(kind, location: location)
      }

      hasSeenStar = true
      elementsWithoutUnpack[index] = inner
      try self.codeObject.appendUnpackEx(countBefore: countBefore,
                                         countAfter: countAfter,
                                         location: location)
    }

    if !hasSeenStar {
      try self.codeObject.appendUnpackSequence(elementCount: elements.count,
                                               at: location)
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
    adapter:  A,
    location: SourceLocation) throws {

    /// Elements that do not need unpacking
    var nSimpleElement = 0
    /// Elements that need unpacking
    var nPackedElement = 0

    for el in elements {
      switch el.kind {
      case let .starred(inner):
        // change elements to container, so we can unpack it later
        if nSimpleElement > 0 {
          try adapter.emitPackElements(count: nSimpleElement, location: location)
          nSimpleElement = 0
          nPackedElement += 1
        }

        // add another container
        try self.visitExpression(inner)
        nPackedElement += 1

      default:
        try self.visitExpression(el)
        nSimpleElement += 1
      }
    }

    if nPackedElement > 0 {
      if nSimpleElement > 0 {
        try adapter.emitPackElements(count: nSimpleElement, location: location)
        nPackedElement += 1
      }

      try adapter.emitBuildUnpackCollection(count: nPackedElement,
                                            location: location)
    } else {
      try adapter.emitBuildCollection(count: nSimpleElement, location: location)
    }
  }
}
