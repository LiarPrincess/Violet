import Core
import Lexer

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
  internal mutating func importStmt(closingTokens: [TokenKind])
    throws -> Statement {

    assert(self.isImportStmt())

    switch self.peek.kind {
    case .import:
      return try self.parseImport()
    case .from:
      return try self.parseImportFrom(closingTokens: closingTokens)
    default:
      assert(false)
      throw self.failUnexpectedToken(expected: .import, .from)
    }
  }

  /// `import_name: 'import' dotted_as_names`
  private mutating func parseImport() throws -> Statement {
    assert(self.peek.kind == .import)

    let start = self.peek.start
    try self.advance() // import

    let names = try self.dottedAsNames()
    let kind = StatementKind.import(names: Array(names))
    return self.statement(kind, start: start, end: names.last.end)
  }

  /// ```c
  /// import_from: (
  ///   'from' (('.' | '...')* dotted_name | ('.' | '...')+)
  ///   'import' ('*' | '(' import_as_names ')' | import_as_names)
  /// )
  /// ```
  // swiftlint:disable:next function_body_length
  private mutating func parseImportFrom(closingTokens: [TokenKind])
    throws -> Statement {

    assert(self.peek.kind == .from)

    let start = self.peek.start
    var end = self.peek.end
    try self.advance() // from

    let dotCount = try self.consumeDots()
    var module: Alias?
    var aliases = [Alias]()

    // it is either 'from ..name import' or 'from .. import'
    let isDotsOnly = self.peek.kind == .import
    if isDotsOnly { // 'from .. import'
      guard dotCount > 0 else {
        throw self.failUnexpectedToken(expected: .dot, .identifier)
      }
    } else { // 'from ..name import'
      module = try self.dottedName()
    }

    try self.consumeOrThrow(.import)

    switch self.peek.kind {
    case .star:
      let star = self.peek
      end = star.end
      try self.advance() // *

      let alias = Alias(name: "*", asName: nil, start: star.start, end: star.end)
      aliases.append(alias)

    case .leftParen:
      try self.advance() // (

      var close = closingTokens
      close.append(.rightParen)

      let (a, _) = try self.importAsNames(closingTokens: close)
      aliases.append(contentsOf: Array(a))

      end = self.peek.end
      try self.consumeOrThrow(.rightParen)

    default:
      let (a, trailingComma) = try self.importAsNames(closingTokens: closingTokens)

      if trailingComma {
        throw self.error(.fromImportWithTrailingComma)
      }

      end = a.last.end
      aliases.append(contentsOf: Array(a))
    }

    let modName = module?.name
    let level = PyInt(dotCount)
    let kind = StatementKind.importFrom(moduleName: modName, names: aliases, level: level)
    return self.statement(kind, start: start, end: end)
  }

  private mutating func consumeDots() throws -> Int {
    var count = 0

    while self.peek.kind == .dot || self.peek.kind == .ellipsis {
      switch self.peek.kind {
      case .dot: count += 1
      case .ellipsis: count += 3
      default: assert(false)
      }

      try self.advance() // '.' or '...'
    }

    return count
  }

  // MARK: - Import as names

  // `import_as_names: import_as_name (',' import_as_name)* [',']`
  private mutating func importAsNames(closingTokens: [TokenKind])
    throws -> (aliases: NonEmptyArray<Alias>, hasTrailingComma: Bool) {

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
  private mutating func importAsName() throws -> Alias {
    let start = self.peek.start
    var end = self.peek.end
    let name = try self.consumeIdentifierOrThrow()

    var asName: String?
    if self.peek.kind == .as {
      try self.advance() // as

      end = self.peek.end
      let value = try self.consumeIdentifierOrThrow()
      try self.checkForbiddenName(value)

      asName = value
    } else {
      try self.checkForbiddenName(name)
    }

    return Alias(name: name, asName: asName, start: start, end: end)
  }

  // MARK: - Dotted names

  /// `dotted_as_name: dotted_name ['as' NAME]`
  private mutating func dottedAsName() throws -> Alias {
    let base = try self.dottedName()

    guard self.peek.kind == .as else {
      return base
    }

    try self.advance() // as

    let end = self.peek.end
    let alias = try self.consumeIdentifierOrThrow()
    try self.checkForbiddenName(alias)

    return Alias(name: base.name, asName: alias, start: base.start, end: end)
  }

  /// `dotted_as_names: dotted_as_name (',' dotted_as_name)*`
  private mutating func dottedAsNames() throws -> NonEmptyArray<Alias> {
    let first = try self.dottedAsName()

    var additionalElements = [Alias]()
    while self.peek.kind == .comma {
      try self.advance() // ,

      let element = try self.dottedAsName()
      additionalElements.append(element)
    }

    return NonEmptyArray(first: first, rest: additionalElements)
  }

  /// `dotted_name: NAME ('.' NAME)*`
  private mutating func dottedName() throws -> Alias {
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
      try self.checkForbiddenName(first)
    }

    let name = first + dottedNames
    return Alias(name: name, asName: nil, start: start, end: end)
  }
}
