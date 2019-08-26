/// Wrapper around UInt
/// (so that we don't do anything stupid like addition: `label + label`).
public class Label: Equatable, Hashable {

  // That gives us 65_536 instructions in block before oveflow.
  private let value: UInt16

  public init(value: UInt16) {
    self.value = value
  }

  public static func == (lhs: Label, rhs: Label) -> Bool {
    return lhs.value == rhs.value
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.value)
  }
}
