import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// cSpell:ignore ssize subkwargs

extension CompilerImpl {

  /// compiler_call(struct compiler *c, expr_ty e)
  internal func visit(_ node: CallExpr) throws {
    if try self.emitOptimizedMethodCall(function: node.function,
                                        args: node.args,
                                        keywords: node.keywords,
                                        context: node.context) {
      return
    }

    try self.visit(node.function)
    try self.callHelper(args: node.args,
                        keywords: node.keywords,
                        context: node.context,
                        alreadyPushedArgs: 0)
  }

  /// maybe_optimize_method_call(struct compiler *c, expr_ty e)
  private func emitOptimizedMethodCall(function: Expression,
                                       args: [Expression],
                                       keywords: [KeywordArgument],
                                       context: ExpressionContext) throws -> Bool {
    // Check if it is an method
    guard let method = function as? AttributeExpr, context == .load else {
      return false
    }

    // No keywords or varargs
    let hasVarargs = args.contains { $0 is StarredExpr }
    guard !hasVarargs && keywords.isEmpty else {
      return false
    }

    try self.visit(method.object)
    self.builder.appendLoadMethod(name: method.name)
    try self.visit(args)
    self.builder.appendCallMethod(argumentCount: args.count)
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
  internal func callHelper(args: [Expression],
                           keywords: [KeywordArgument],
                           context: ExpressionContext,
                           alreadyPushedArgs: Int) throws {
    /// CPython: `nSeen`
    /// Packed -> transformed to Tuple (to handle `*`/`**`, if needed)
    var nArgNotPacked = alreadyPushedArgs
    /// Cpython: `nSubArgs`
    var nPackedArgs = 0
    /// CPython: `nSubKwArgs`
    var nPackedKwargs = 0

    for arg in args {
      if let star = arg as? StarredExpr {
        // If we've seen positional arguments, then pack them into a tuple.
        if nArgNotPacked > 0 {
          self.builder.appendBuildTuple(elementCount: nArgNotPacked)
          nArgNotPacked = 0
          nPackedArgs += 1
        }

        try self.visit(star.expression)
        nPackedArgs += 1
      } else {
        try self.visit(arg)
        nArgNotPacked += 1
      }
    }

    let hasDictionaryUnpack = keywords.contains { kwarg in
      switch kwarg.kind {
      case .named: return false
      case .dictionaryUnpack: return true
      }
    }

    if nPackedArgs > 0 || hasDictionaryUnpack {
      // Pack up any trailing positional arguments.
      if nArgNotPacked > 0 {
        self.builder.appendBuildTuple(elementCount: nArgNotPacked)
        nArgNotPacked = 0
        nPackedArgs += 1
      }
      assert(nArgNotPacked == 0, "We finished args, now kwargs with clean state")

      // If we ended up with more than one star arg,
      // we need to concatenate them into a single sequence.
      if nPackedArgs == 0 {
        // We don't have normal 'args', fake empty.
        self.builder.appendBuildTuple(elementCount: 0)
      } else if nPackedArgs == 1 {
        // Exactly as we need it
      } else {
        // nPackedArgs > 1
        self.builder.appendBuildTupleUnpackWithCall(elementCount: nPackedArgs)
      }

      for (index, keyword) in keywords.enumerated() {
        switch keyword.kind {
        case .dictionaryUnpack:
          if nArgNotPacked > 0 {
            let start = index - nArgNotPacked
            try self.visitKwargs(keywords: keywords[start..<index])
            nPackedKwargs += 1
            nArgNotPacked = 0
          }

          try self.visit(keyword.value)
          nPackedKwargs += 1
        case .named:
          nArgNotPacked += 1
        }
      }

      // Pack up any trailing keyword arguments.
      if nArgNotPacked > 0 {
        let start = keywords.count - nArgNotPacked
        try self.visitKwargs(keywords: keywords[start..<keywords.count])
        nPackedKwargs += 1
      }

      if nPackedKwargs > 1 {
        self.builder.appendBuildMapUnpackWithCall(elementCount: nPackedKwargs)
      }

      self.builder.appendCallFunctionEx(hasKeywordArguments: nPackedKwargs > 0)
    } else if keywords.any {
      // All of the 'keywords' are 'named' (no 'dictionaryUnpack')
      let names = self.getNames(keywords: keywords)
      let argCount = alreadyPushedArgs + args.count + keywords.count

      try self.visitKeywords(keywords: keywords)
      self.builder.appendTuple(names)
      self.builder.appendCallFunctionKw(argumentCount: argCount)
    } else {
      // Only args, no kwargs
      let argCount = alreadyPushedArgs + args.count
      self.builder.appendCallFunction(argumentCount: argCount)
    }
  }

  /// Precondition: 'hasDictionaryUnpack' = false
  private func getNames(keywords: [KeywordArgument]) -> [CodeObject.Constant] {
    var result = [CodeObject.Constant]()
    for keyword in keywords {
      switch keyword.kind {
      case .dictionaryUnpack: unreachable()
      case .named(let name): result.append(.string(name))
      }
    }

    return result
  }

  /// compiler_visit_keyword(struct compiler *c, keyword_ty k)
  private func visitKeywords(keywords: [KeywordArgument]) throws {
    for keyword in keywords {
      try self.visit(keyword.value)
    }
  }

  /// compiler_subkwargs(struct compiler *c, asdl_seq *keywords,
  /// Py_ssize_t begin, Py_ssize_t end)
  private func visitKwargs(keywords: ArraySlice<KeywordArgument>) throws {
    assert(keywords.any)

    if keywords.count == 1 {
      // swiftlint:disable:next force_unwrapping
      let keyword = keywords.first!

      guard case let .named(name) = keyword.kind else {
        trap("[BUG] Compiler: visitKwargs should not be called for unpack.")
      }

      self.builder.appendString(name)
      try self.visit(keyword.value)
      self.builder.appendBuildMap(elementCount: 1)
    } else {
      var names = [CodeObject.Constant]()
      for keyword in keywords {
        guard case let .named(name) = keyword.kind else {
          trap("[BUG] Compiler: visitKwargs should not be called for unpack.")
        }

        try self.visit(keyword.value)
        names.append(.string(name))
      }

      self.builder.appendTuple(names)
      self.builder.appendBuildConstKeyMap(elementCount: names.count)
    }
  }
}
