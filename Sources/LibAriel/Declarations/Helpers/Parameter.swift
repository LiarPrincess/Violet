import SwiftSyntax

/// Parameter for function or `init`.
public struct Parameter: CustomStringConvertible {

  public let firstName: String?
  public let secondName: String?
  public let type: Type?
  public let isVariadic: Bool
  public let defaultValue: VariableInitializer?

  public var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  public init(firstName: String?,
              secondName: String?,
              type: Type?,
              isVariadic: Bool,
              defaultValue: VariableInitializer?
  ) {
    self.firstName = firstName
    self.secondName = secondName
    self.type = type
    self.isVariadic = isVariadic
    self.defaultValue = defaultValue
  }

  internal init(_ node: FunctionParameterSyntax) {
    self.firstName = node.firstName?.text.trimmed
    self.secondName = node.secondName?.text.trimmed
    self.type = node.type.map(Type.init)
    self.isVariadic = node.ellipsis != nil
    self.defaultValue = node.defaultArgument.map(VariableInitializer.init)
    assert(node.attributes == nil)
  }
}
