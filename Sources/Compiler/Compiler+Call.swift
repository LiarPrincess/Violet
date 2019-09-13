import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// TODO: ^ Remove this

extension Compiler {

  /// compiler_call(struct compiler *c, expr_ty e)
  internal func visitCall(function: Expression,
                          args:     [Expression],
                          keywords: [Keyword],
                          context:  ExpressionContext) throws {

    if try self.emitOptimizedMethodCall(function: function,
                                        args: args,
                                        keywords: keywords,
                                        context: context) {
      return
    }

    try self.visitExpression(function)
    try self.callHelper(args:     args,
                        keywords: keywords,
                        context:  context,
                        alreadyPushedArgs: 0)
  }

  /// maybe_optimize_method_call(struct compiler *c, expr_ty e)
  private func emitOptimizedMethodCall(function: Expression,
                                       args:     [Expression],
                                       keywords: [Keyword],
                                       context:  ExpressionContext) throws -> Bool {

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
    self.builder.appendLoadMethod(name: methodName)
    try self.visitExpressions(args)
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
                           keywords: [Keyword],
                           context:  ExpressionContext,
                           alreadyPushedArgs: Int) throws {

    var nSeen = alreadyPushedArgs
    var nSubArgs = 0
    var nSubKwArgs = 0

    for arg in args {
      switch arg.kind {
      case let .starred(inner):
        // If we've seen positional arguments, then pack them into a tuple.
        if nSeen > 0 {
          self.builder.appendBuildTuple(elementCount: nSeen)
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

    let hasDictionaryUnpack = keywords.contains { $0.kind == .dictionaryUnpack }
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

          try self.visitExpression(keyword.value)
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
  private func getNames(keywords: [Keyword]) -> [Constant] {
    var result = [Constant]()
    for keyword in keywords {
      switch keyword.kind {
      case .dictionaryUnpack: assert(false)
      case let .named(name): result.append(.string(name))
      }
    }
    return result
  }

  /// compiler_visit_keyword(struct compiler *c, keyword_ty k)
  private func visitKeywords(keywords: [Keyword]) throws {
    for keyword in keywords {
      try self.visitExpression(keyword.value)
    }
  }

  /// compiler_subkwargs(struct compiler *c, asdl_seq *keywords,
  /// Py_ssize_t begin, Py_ssize_t end)
  private func visitSubkwargs(keywords: ArraySlice<Keyword>) throws {
    assert(keywords.any)

    if keywords.count == 1 {
      // swiftlint:disable:next force_unwrapping
      let keyword = keywords.first!

      guard case let KeywordKind.named(name) = keyword.kind else {
        fatalError("[BUG] Compiler: VisitSubkwargs should not be called for unpack.")
      }

      self.builder.appendString(name)
      try self.visitExpression(keyword.value)
      self.builder.appendBuildMap(elementCount: 1)
    } else {
      var names = [Constant]()
      for keyword in keywords {
        guard case let KeywordKind.named(name) = keyword.kind else {
          fatalError("[BUG] Compiler: VisitSubkwargs should not be called for unpack.")
        }

        try self.visitExpression(keyword.value)
        names.append(.string(name))
      }

      self.builder.appendTuple(names)
      self.builder.appendBuildConstKeyMap(elementCount: names.count)
    }
  }
}
