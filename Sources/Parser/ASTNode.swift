import VioletCore

// cSpell:ignore nody

/// Node unique identifier.
///
/// Used for `Equatable` and `Hashable` default implementation.
///
/// Normally we would use `ObjectIdentifier`, but since our AST contains
/// both classes and structs we need some other solution.
/// We use structs, so they can be inlined inside other nodes which decreases
/// number of indirections.
public typealias ASTNodeId = UInt

/// Thingie that can be placed in AST.
///
/// ```
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
