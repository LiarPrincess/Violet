/// String that can be used in CodeObject.
public protocol ConstantString {
  var asConstant: String { get }
}

extension String: ConstantString {
  public var asConstant: String { return self }
}
