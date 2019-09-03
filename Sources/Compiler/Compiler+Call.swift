import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

extension Compiler {

  /// compiler_call(struct compiler *c, expr_ty e)
  internal func visitCall(function: Expression,
                          args:     [Expression],
                          keywords: [Keyword],
                          context:  ExpressionContext,
                          location: SourceLocation) throws {

    if try self.emitOptimizedMethodCall(function: function,
                                        args: args,
                                        keywords: keywords,
                                        context: context,
                                        location: location) {
      return
    }

    try self.visitExpression(function)
    try self.callHelper(args:     args,
                        keywords: keywords,
                        context:  context,
                        location: location,
                        alreadyPushedArgs: 0)
  }

  /// maybe_optimize_method_call(struct compiler *c, expr_ty e)
  private func emitOptimizedMethodCall(function: Expression,
                                       args:     [Expression],
                                       keywords: [Keyword],
                                       context:  ExpressionContext,
                                       location: SourceLocation) throws -> Bool {

    // Check if it is an method
    guard case let .attribute(object, name: methodName) = function.kind,
        context == .load else {
      return false
    }

    // No keywords or varargs
    guard keywords.isEmpty && !args.contains(where: { $0.kind.isStarred }) else {
      return false
    }

    try self.visitExpression(object)
    try self.emitLoadMethod(name: methodName, location: location)
    try self.visitExpressions(args)
    try self.emitCallMethod(argumentCount: args.count, location: location)
    return true
  }

  /// Shared code between `call` and `class`.
  ///
  /// ```c
  /// compiler_call_helper(struct compiler *c,
  ///                      int n, /* Args already pushed */
  ///                      asdl_seq *args,
  ///                      asdl_seq *keywords)
  /// ```
  internal func callHelper(args:     [Expression],
                           keywords: [Keyword],
                           context:  ExpressionContext,
                           location: SourceLocation,
                           alreadyPushedArgs: Int) throws {

    var hasDictionaryUnpack = false
    for kw in keywords {
      // TODO: `Keyword` should be a sum of unpack|name*value
      let isUnpack = kw.name == nil
      if isUnpack {
        hasDictionaryUnpack = true
        break // for loop
      }
    }

    var nSeen = alreadyPushedArgs
    var nSubArgs = 0
    var nSubKwArgs = 0

    for arg in args {
      switch arg.kind {
      case let .starred(inner):
        // A star-arg. If we've seen positional arguments,
        // pack the positional arguments into a tuple.

        if nSeen > 0 {
          try self.emitBuildTuple(elementCount: nSeen, location: location)
          nSeen = 0
          nSubArgs += 1
        }

        try self.visitExpression(inner)
        nSubArgs += 1

      default:
        try self.visitExpression(arg)
        nSeen += 1
      }
    }

    if nSubArgs > 0 || hasDictionaryUnpack {
      // Pack up any trailing positional arguments.
      if nSeen > 0 {
        try self.emitBuildTuple(elementCount: nSeen, location: location)
        nSubArgs += 1
      }

      // If we ended up with more than one stararg, we need
      // to concatenate them into a single sequence.
      if nSubArgs > 1 {
        try self.emitBuildTupleUnpackWithCall(elementCount: nSubArgs, location: location)
      } else if nSubArgs == 0 {
        try self.emitBuildTuple(elementCount: 0, location: location)
      }

      // the number of keyword arguments on the stack following
      nSeen = 0

      for kw in keywords {
        if kw.name == nil {
          // keyword argument unpacking
          if nSeen > 0 {
            try self.visitSubkwargs(keywords: keywords,
                                    start: keywords.count - nSeen,
                                    end: keywords.count,
                                    location: location)
            nSubKwArgs += 1
            nSeen = 0
          }

          try self.visitExpression(kw.value)
          nSubKwArgs += 1
        } else {
          nSeen += 1
        }
      }

      // Pack up any trailing keyword arguments.
      if nSeen > 0 {
        try self.visitSubkwargs(keywords: keywords,
                                start: keywords.count - nSeen,
                                end: keywords.count,
                                location: location)
        nSubKwArgs += 1
      }

      if nSubKwArgs > 1 {
        try self.emitBuildMapUnpackWithCall(elementCount: nSubKwArgs, location: location)
      }

      try self.emitCallFunctionEx(hasKeywordArguments: nSubKwArgs > 0)
    } else if keywords.any {
      let names = keywords.map { Constant.string($0.name!) }
      let argCount = alreadyPushedArgs + args.count + keywords.count

      try self.visitKeywords(keywords: keywords)
      try self.emitConstant(.tuple(names), location: location)
      try self.emitCallFunctionKw(argumentCount: argCount)
    } else {
      let argCount = alreadyPushedArgs + args.count
      try self.emitCallFunction(argumentCount: argCount)
    }
  }

  /// compiler_visit_keyword(struct compiler *c, keyword_ty k)
  private func visitKeywords(keywords: [Keyword]) throws {
    for kw in keywords {
      try self.visitExpression(kw.value)
    }
  }

  /// compiler_subkwargs(struct compiler *c, asdl_seq *keywords,
  /// Py_ssize_t begin, Py_ssize_t end)
  private func visitSubkwargs(keywords: [Keyword],
                              start: Int,
                              end:   Int,
                              location: SourceLocation) throws {
    // TODO: CPython uses BUILD_CONST_KEY_MAP
    assert(start < end)

    for kw in keywords[start..<end] {
      let c = kw.name.map { Constant.string($0) } ?? Constant.none
      try self.emitConstant(c, location: location)
      try self.visitExpression(kw.value)
    }
    try self.emitBuildMap(elementCount: keywords.count, location: location)
  }
}
