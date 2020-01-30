import Core

public typealias ASTNodeId = UInt

/// Thingie that can be placed in AST.
///
/// ```
/// What are AST made of?
/// What are AST made of?
///   Nodes and nodes
///   With nody-nodes
/// That's what AST are made of
/// ```
///
/// See this
/// [nursery rhyme](https://en.wikipedia.org/wiki/What_Are_Little_Boys_Made_Of%3F).
public protocol ASTNode: Hashable {
  // Hashable will automatically imply Equatable.

  /// Unique node identifier.
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
