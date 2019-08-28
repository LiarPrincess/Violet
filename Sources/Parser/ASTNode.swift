import Core

// Hashable will automatically imply Equatable.
public protocol ASTNode: Hashable {
  /// Unique node identifier.
  var id: NodeId { get }
  /// Location of the first character in the source code.
  var start: SourceLocation { get }
  /// Location just after the last character in the source code.
  var end: SourceLocation { get }
}

// swiftlint:disable:next static_operator
public func == <T: ASTNode>(lhs: T, rhs: T) -> Bool {
  return lhs.id == rhs.id
}

extension ASTNode {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

/// Unique node identifier.
/// Use `NodeId.next` to obtain next available value.
public struct NodeId: Equatable, Hashable {

  private let value: UInt64

  /// Use `NodeId.next` for auto-generated value.
  public init(value: UInt64) {
    self.value = value
  }

  private static var nextValue: UInt64 = 0

  /// Next available value.
  public static var next: NodeId {
    if NodeId.nextValue == UInt64.max {
      fatalError("[BUG] NodeId: Reached maximim number of AST nodes: (\(UInt64.max)).")
    }

    let value = NodeId.nextValue
    NodeId.nextValue += 1
    return NodeId(value: value)
  }
}
