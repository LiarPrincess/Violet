import Core

/// Node unique identifier.
///
/// Used for `Equatable` and `Hashable` default implementation.
/// Technically, not needed because we can use `ObjectIdentifier` for this.
///
/// Mostly remainder from our old AST implementation where we used structs
/// as nodes (with `kind` enum, for example `Expression struct` +
/// `ExpressionKind enum`). We moved from this to our current class based version
/// to save some memory (we has huge payloads in those enums and since each
/// enum case has to have the same size we wasted a lot of memory in cases with
/// smaller payloads).
///
/// Anyway, we were not able to use `ObjectIdentifier` for structs, so we had to
/// implement our own thing.
public typealias ASTNodeId = UInt

/// Thingie that can be placed in AST.
///
/// ```
/// What are ASTs made of?
/// What are ASTs made of?
///   Nodes and nodes
///   With nody-nodes
/// That's what ASTs are made of
/// ```
///
/// See this
/// [nursery rhyme](https://en.wikipedia.org/wiki/What_Are_Little_Boys_Made_Of%3F).
public protocol ASTNode: Hashable {
  // Hashable will automatically imply Equatable.

  /// Node unique identifier.
  var id: ASTNodeId { get }
  /// Location of the first character in the source code.
  var start: SourceLocation { get }
  /// Location just after the last character in the source code.
  var end: SourceLocation { get }
}

extension ASTNode {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
