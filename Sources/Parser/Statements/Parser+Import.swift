import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_import_stmt(struct compiling *c, const node *n)
//  alias_for_import_name(struct compiling *c, const node *n, int store)

extension Parser {

  /// ```c
  /// import_stmt: import_name | import_from
  /// import_name: 'import' dotted_as_names
  /// import_from: (
  ///   'from' (('.' | '...')* dotted_name | ('.' | '...')+)
  ///   'import' ('*' | '(' import_as_names ')' | import_as_names)
  /// )
  /// ```
  internal func isImportStmt() -> Bool {
    return self.peek.kind == .import || self.peek.kind == .from
  }

  /// ```c
  /// import_stmt: import_name | import_from
  /// import_name: 'import' dotted_as_names
  /// import_from: (
  ///   'from' (('.' | '...')* dotted_name | ('.' | '...')+)
  ///   'import' ('*' | '(' import_as_names ')' | import_as_names)
  /// )
  /// ```
  internal func importStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.isImportStmt())

    switch self.peek.kind {
    case .import:
      return try self.parseImport()
    case .from:
      return try self.parseImportFrom(closingTokens: closingTokens)
    default:
      throw self.unexpectedToken(expected: [.import, .from])
    }
  }

  // MARK: - Import

  /// `import_name: 'import' dotted_as_names`
  private func parseImport() throws -> Statement {
    assert(self.peek.kind == .import)

    let start = self.peek.start
    try self.advance() // import

    let names = try self.dottedAsNames()
    return self.builder.importStmt(names: names,
                                   start: start,
                                   end: names.last.end)
  }

  // MARK: - Dotted names

  /// `dotted_as_name: dotted_name ['as' NAME]`
  private func dottedAsName() throws -> Alias {
    let base = try self.dottedName()

    var asName: String?
    var end = base.end

    if self.peek.kind == .as {
      try self.advance() // as

      let token = self.peek
      let n = try self.consumeIdentifierOrThrow()
      try self.checkForbiddenName(n, location: token.start)

      asName = n
      end = token.end
    }

    return self.builder.alias(name: base.name,
                              asName: asName,
                              start: base.start,
                              end: end)
  }

  /// `dotted_as_names: dotted_as_name (',' dotted_as_name)*`
  private func dottedAsNames() throws -> NonEmptyArray<Alias> {
    let first = try self.dottedAsName()

    var additionalElements = [Alias]()
    while self.peek.kind == .comma {
      try self.advance() // ,

      let element = try self.dottedAsName()
      additionalElements.append(element)
    }

    return NonEmptyArray(first: first, rest: additionalElements)
  }

  private struct DottedName {
    let name: String
    let start: SourceLocation
    let end: SourceLocation
  }

  /// `dotted_name: NAME ('.' NAME)*`
  private func dottedName() throws -> DottedName {
    let start = self.peek.start
    var end = self.peek.end
    let first = try self.consumeIdentifierOrThrow()

    // Create a string of the form "a.b.c"
    var dottedNames = ""
    while self.peek.kind == .dot {
      try self.advance() // .

      end = self.peek.end
      let name = try self.consumeIdentifierOrThrow()
      dottedNames += "." + name
    }

    // CPython: `if (NCH(n) == 1)` branch
    let isWithoutDotes = dottedNames.isEmpty
    if isWithoutDotes {
      try self.checkForbiddenName(first, location: start)
    }

    let name = first + dottedNames
    return DottedName(name: name, start: start, end: end)
  }

  // MARK: - Import from

  private enum ImportedValues {
    case all
    case aliases(NonEmptyArray<Alias>)
  }

  private struct ImportFromIR {
    fileprivate var module: String?
    fileprivate var values = ImportedValues.all
    fileprivate var level: UInt8 = 0
    fileprivate var end: SourceLocation = .start
  }

  /// ```c
  /// import_from: (
  ///   'from' (('.' | '...')* dotted_name | ('.' | '...')+)
  ///   'import' ('*' | '(' import_as_names ')' | import_as_names)
  /// )
  /// ```
  private func parseImportFrom(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .from)

    let start = self.peek.start

    var ir = ImportFromIR()
    try self.parseImportFromModule(into: &ir)
    try self.parseImportFromNames(into: &ir, closingTokens: closingTokens)

    switch ir.values {
    case .all:
      return self.builder.importFromStarStmt(moduleName: ir.module,
                                             level: ir.level,
                                             start: start,
                                             end: ir.end)
    case let .aliases(aliases):
      return self.builder.importFromStmt(moduleName: ir.module,
                                         names: aliases,
                                         level: ir.level,
                                         start: start,
                                         end: ir.end)
    }
  }

  /// ```c
  /// import_from: (
  ///   'from' (('.' | '...')* dotted_name | ('.' | '...')+) <- THIS
  ///   'import' ('*' | '(' import_as_names ')' | import_as_names)
  /// )
  /// ```
  private func parseImportFromModule(into ir: inout ImportFromIR) throws {
    try self.consumeOrThrow(.from)

    ir.level = try self.consumeDots()

    // it is either 'from .. import' or 'from ..name import'
    let isDotsOnly = self.peek.kind == .import
    if isDotsOnly { // 'from .. import'
      guard ir.level > 0 else {
        throw self.unexpectedToken(expected: [.dot, .identifier])
      }
    } else { // 'from ..name import'
      let alias = try self.dottedName()
      ir.module = alias.name
    }
  }

  private func consumeDots() throws -> UInt8 {
    var count: UInt8 = 0

    while self.peek.kind == .dot || self.peek.kind == .ellipsis {
      switch self.peek.kind {
      case .dot: count += 1
      case .ellipsis: count += 3
      default: unreachable() // see 'while' condition
      }

      try self.advance() // '.' or '...'
    }

    return count
  }

  /// ```c
  /// import_from: (
  ///   'from' (('.' | '...')* dotted_name | ('.' | '...')+)
  ///   'import' ('*' | '(' import_as_names ')' | import_as_names) <- THIS
  /// )
  /// ```
  private func parseImportFromNames(into ir: inout ImportFromIR,
                                    closingTokens: [Token.Kind]) throws {

    try self.consumeOrThrow(.import)

    switch self.peek.kind {
    case .star:
      let star = self.peek
      try self.advance() // *

      ir.values = .all
      ir.end = star.end

    case .leftParen:
      try self.advance() // (

      var close = closingTokens
      close.append(.rightParen)

      let result = try self.importAsNames(closingTokens: close)
      ir.values = .aliases(result.aliases)
      ir.end = self.peek.end // end of ')'
      try self.consumeOrThrow(.rightParen)

    default:
      let result = try self.importAsNames(closingTokens: closingTokens)

      if result.hasTrailingComma {
        throw self.error(.fromImportWithTrailingComma)
      }

      ir.values = .aliases(result.aliases)
      ir.end = result.aliases.last.end
    }
  }

  // MARK: - Import as names

  // `import_as_names: import_as_name (',' import_as_name)* [',']`
  private func importAsNames(closingTokens: [Token.Kind]) throws ->
    (aliases: NonEmptyArray<Alias>, hasTrailingComma: Bool) {

    let first = try self.importAsName()

    var additionalElements = [Alias]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let element = try self.importAsName()
      additionalElements.append(element)
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      try self.advance() // ,
    }

    let aliases = NonEmptyArray(first: first, rest: additionalElements)
    return (aliases, hasTrailingComma)
  }

  // `import_as_name: NAME ['as' NAME]`
  private func importAsName() throws -> Alias {
    let start = self.peek.start
    var end = self.peek.end
    let name = try self.consumeIdentifierOrThrow()

    var asName: String?
    if try self.consumeIf(.as) {
      end = self.peek.end
      let value = try self.consumeIdentifierOrThrow()
      try self.checkForbiddenName(value, location: start)

      asName = value
    } else {
      try self.checkForbiddenName(name, location: start)
    }

    return self.builder.alias(name: name, asName: asName, start: start, end: end)
  }
}
