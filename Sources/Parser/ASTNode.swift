import Core

public typealias ASTNodeId = UInt

// Hashable will automatically imply Equatable.
public protocol ASTNode: Hashable {
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
