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
                        alreadyPushedArgs: 0,
                        location: location)
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
    try self.codeObject.appendLoadMethod(name: methodName, at: location)
    try self.visitExpressions(args)
    try self.codeObject.appendCallMethod(argumentCount: args.count, at: location)
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
                           alreadyPushedArgs: Int,
                           location: SourceLocation) throws {

    var nSeen = alreadyPushedArgs
    var nSubArgs = 0
    var nSubKwArgs = 0

    for arg in args {
      switch arg.kind {
      case let .starred(inner):
        // If we've seen positional arguments, then pack them into a tuple.
        if nSeen > 0 {
          try self.codeObject.appendBuildTuple(elementCount: nSeen, at: location)
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

    var hasDictionaryUnpack = false
    for keyword in keywords {
      // TODO: AST: Rename Keyword.name -> Keyword.arg
      // TODO: AST: `Keyword` should be a sum of unpack|name*value
      let isUnpack = keyword.name == nil
      if isUnpack {
        hasDictionaryUnpack = true
        break // break loop
      }
    }

    if nSubArgs > 0 || hasDictionaryUnpack {
      // Pack up any trailing positional arguments.
      if nSeen > 0 {
        try self.codeObject.appendBuildTuple(elementCount: nSeen, at: location)
        nSubArgs += 1
      }

      // If we ended up with more than one stararg,
      // we need to concatenate them into a single sequence.
      if nSubArgs > 1 {
        try self.codeObject.appendBuildTupleUnpackWithCall(elementCount: nSubArgs,
                                                           at: location)
      } else if nSubArgs == 0 {
        // We don't have normal args, fake one.
        try self.codeObject.appendBuildTuple(elementCount: 0, at: location)
      } // Else it is 1, so exactly as we need it

      nSeen = 0
      for (index, keyword) in keywords.enumerated() {
        if keyword.name == nil {
          // keyword argument unpacking
          if nSeen > 0 {
            let start = index - nSeen
            try self.visitSubkwargs(keywords: keywords[start..<index],
                                    location: location)
            nSubKwArgs += 1
            nSeen = 0
          }

          try self.visitExpression(keyword.value)
          nSubKwArgs += 1
        } else {
          nSeen += 1
        }
      }

      // Pack up any trailing keyword arguments.
      if nSeen > 0 {
        let start = keywords.count - nSeen
        try self.visitSubkwargs(keywords: keywords[start..<keywords.count],
                                location: location)
        nSubKwArgs += 1
      }

      if nSubKwArgs > 1 {
        try self.codeObject.appendBuildMapUnpackWithCall(elementCount: nSubKwArgs,
                                                         at: location)
      }

      try self.codeObject.appendCallFunctionEx(hasKeywordArguments: nSubKwArgs > 0,
                                               at: location)
    } else if keywords.any {
      // We can force unwrap, because: 'hasDictionaryUnpack' = false
      // swiftlint:disable:next force_unwrapping
      let names = keywords.map { Constant.string($0.name!) }
      let argCount = alreadyPushedArgs + args.count + keywords.count

      try self.visitKeywords(keywords: keywords)
      try self.codeObject.appendTuple(names, at: location)
      try self.codeObject.appendCallFunctionKw(argumentCount: argCount, at: location)
    } else {
      let argCount = alreadyPushedArgs + args.count
      try self.codeObject.appendCallFunction(argumentCount: argCount, at: location)
    }
  }

  /// compiler_visit_keyword(struct compiler *c, keyword_ty k)
  private func visitKeywords(keywords: [Keyword]) throws {
    for keyword in keywords {
      try self.visitExpression(keyword.value)
    }
  }

  /// compiler_subkwargs(struct compiler *c, asdl_seq *keywords,
  /// Py_ssize_t begin, Py_ssize_t end)
  private func visitSubkwargs(keywords: ArraySlice<Keyword>,
                              location: SourceLocation) throws {
    if keywords.count == 1 {
      guard let keyword = keywords.first else {
        fatalError("[BUG] Compiler: visitSubkwargs sould not be called for unpack.")
      }
      let name = keyword.name.map { Constant.string($0) } ?? Constant.none

      try self.codeObject.appendConstant(name, at: location)
      try self.visitExpression(keyword.value)
      try self.codeObject.appendBuildMap(elementCount: 1, at: location)
    } else {
      var names = [Constant]()
      for keyword in keywords {
        try self.visitExpression(keyword.value)

        let name = keyword.name.map { Constant.string($0) } ?? Constant.none
        names.append(name)
      }

      try self.codeObject.appendTuple(names, at: location)
      try self.codeObject.appendBuildConstKeyMap(elementCount: names.count,
                                                 at: location)
    }
  }
}
