/// String that can be used in CodeObject.
public protocol ConstantString {
  var constant: String { get }
}

extension String: ConstantString {
  public var constant: String { return self }
}
