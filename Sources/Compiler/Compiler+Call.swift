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
    try self.builder.emitLoadMethod(name: methodName, location: location)
    try self.visitExpressions(args)
    try self.builder.emitCallMethod(argumentCount: args.count, location: location)
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
          try self.builder.emitBuildTuple(elementCount: nSeen, location: location)
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
        try self.builder.emitBuildTuple(elementCount: nSeen, location: location)
        nSubArgs += 1
      }

      // If we ended up with more than one stararg, we need
      // to concatenate them into a single sequence.
      if nSubArgs > 1 {
        try self.builder.emitBuildTupleUnpackWithCall(elementCount: nSubArgs,
                                                      location: location)
      } else if nSubArgs == 0 {
        try self.builder.emitBuildTuple(elementCount: 0, location: location)
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
        try self.builder.emitBuildMapUnpackWithCall(elementCount: nSubKwArgs,
                                                    location: location)
      }

      try self.builder.emitCallFunctionEx(hasKeywordArguments: nSubKwArgs > 0,
                                          location: location)
    } else if keywords.any {
      let names = keywords.map { Constant.string($0.name!) }
      let argCount = alreadyPushedArgs + args.count + keywords.count

      try self.visitKeywords(keywords: keywords)
      try self.builder.emitTuple(names, location: location)
      try self.builder.emitCallFunctionKw(argumentCount: argCount, location: location)
    } else {
      let argCount = alreadyPushedArgs + args.count
      try self.builder.emitCallFunction(argumentCount: argCount, location: location)
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
    let n = end - start
    assert(n > 0)

    if n > 1 {
      var names = [Constant]()
      for kw in keywords[start..<end] {
        try self.visitExpression(kw.value)

        let name = kw.name.map { Constant.string($0) } ?? Constant.none
        names.append(name)
      }

      try self.builder.emitTuple(names, location: location)
      try self.builder.emitBuildConstKeyMap(elementCount: names.count,
                                            location: location)
    } else {
      let kw = keywords[start]
      let name = kw.name.map { Constant.string($0) } ?? Constant.none
      try self.builder.emitConstant(name, location: location)
      try self.visitExpression(kw.value)
      try self.builder.emitBuildMap(elementCount: 1, location: location)
    }
  }
}
