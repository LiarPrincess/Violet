import SwiftSyntax

/// Parameter for function or `init`.
struct Parameter: CustomStringConvertible {

  let firstName: String?
  let secondName: String?
  let type: Type?
  let isVariadic: Bool
  let defaultValue: VariableInitializer?

  var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  init(_ node: FunctionParameterSyntax) {
    self.firstName = node.firstName?.text.trimmed
    self.secondName = node.secondName?.text.trimmed
    self.type = node.type.map(Type.init)
    self.isVariadic = node.ellipsis != nil
    self.defaultValue = node.defaultArgument.map(VariableInitializer.init)
    assert(node.attributes == nil)
  }
}
