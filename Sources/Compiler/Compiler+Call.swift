import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

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
    var nSeen = alreadyPushedArgs
    var nSubArgs = 0
    var nSubKwArgs = 0

    for arg in args {
      if let star = arg as? StarredExpr {
        // If we've seen positional arguments, then pack them into a tuple.
        if nSeen > 0 {
          self.builder.appendBuildTuple(elementCount: nSeen)
          nSeen = 0
          nSubArgs += 1
        }

        try self.visit(star.expression)
        nSubArgs += 1
      } else {
        try self.visit(arg)
        nSeen += 1
      }
    }

    let hasDictionaryUnpack = keywords.contains { kwarg in
      switch kwarg.kind {
      case .named: return false
      case .dictionaryUnpack: return true
      }
    }

    if nSubArgs > 0 || hasDictionaryUnpack {
      // Pack up any trailing positional arguments.
      if nSeen > 0 {
        self.builder.appendBuildTuple(elementCount: nSeen)
        nSubArgs += 1
      }

      // If we ended up with more than one stararg,
      // we need to concatenate them into a single sequence.
      if nSubArgs > 1 {
        self.builder.appendBuildTupleUnpackWithCall(elementCount: nSubArgs)
      } else if nSubArgs == 0 {
        // We don't have normal args, fake one.
        self.builder.appendBuildTuple(elementCount: 0)
      } // Else it is 1, so exactly as we need it

      nSeen = 0
      for (index, keyword) in keywords.enumerated() {
        switch keyword.kind {
        case .dictionaryUnpack:
          if nSeen > 0 {
            let start = index - nSeen
            try self.visitSubkwargs(keywords: keywords[start..<index])
            nSubKwArgs += 1
            nSeen = 0
          }

          try self.visit(keyword.value)
          nSubKwArgs += 1
        case .named:
          nSeen += 1
        }
      }

      // Pack up any trailing keyword arguments.
      if nSeen > 0 {
        let start = keywords.count - nSeen
        try self.visitSubkwargs(keywords: keywords[start..<keywords.count])
        nSubKwArgs += 1
      }

      if nSubKwArgs > 1 {
        self.builder.appendBuildMapUnpackWithCall(elementCount: nSubKwArgs)
      }

      self.builder.appendCallFunctionEx(hasKeywordArguments: nSubKwArgs > 0)
    } else if keywords.any {
      let names = self.getNames(keywords: keywords)
      let argCount = alreadyPushedArgs + args.count + keywords.count

      try self.visitKeywords(keywords: keywords)
      self.builder.appendTuple(names)
      self.builder.appendCallFunctionKw(argumentCount: argCount)
    } else {
      let argCount = alreadyPushedArgs + args.count
      self.builder.appendCallFunction(argumentCount: argCount)
    }
  }

  /// Precondition: 'hasDictionaryUnpack' = false
  private func getNames(keywords: [KeywordArgument]) -> [CodeObject.Constant] {
    var result = [CodeObject.Constant]()
    for keyword in keywords {
      switch keyword.kind {
      case .dictionaryUnpack: assert(false)
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
  private func visitSubkwargs(keywords: ArraySlice<KeywordArgument>) throws {
    assert(keywords.any)

    if keywords.count == 1 {
      // swiftlint:disable:next force_unwrapping
      let keyword = keywords.first!

      guard case let .named(name) = keyword.kind else {
        trap("[BUG] Compiler: VisitSubkwargs should not be called for unpack.")
      }

      self.builder.appendString(name)
      try self.visit(keyword.value)
      self.builder.appendBuildMap(elementCount: 1)
    } else {
      var names = [CodeObject.Constant]()
      for keyword in keywords {
        guard case let .named(name) = keyword.kind else {
          trap("[BUG] Compiler: VisitSubkwargs should not be called for unpack.")
        }

        try self.visit(keyword.value)
        names.append(.string(name))
      }

      self.builder.appendTuple(names)
      self.builder.appendBuildConstKeyMap(elementCount: names.count)
    }
  }
}
