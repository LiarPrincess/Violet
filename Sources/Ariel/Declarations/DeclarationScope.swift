class DeclarationScope {

  private(set) var enumerations = [Enumeration]()
  private(set) var structures = [Structure]()
  private(set) var classes = [Class]()
  private(set) var protocols = [Protocol]()
  private(set) var typealiases = [Typealias]()
  private(set) var extensions = [Extension]()
  private(set) var variables = [Variable]()
  private(set) var initializers = [Initializer]()
  private(set) var functions = [Function]()
  private(set) var subscripts = [Subscript]()
  private(set) var operators = [Operator]()
  private(set) var associatedTypes = [AssociatedType]()

  var all: [Declaration] {
    // We can't use '+' operator because:
    // The compiler is unable to type-check this expression in reasonable time;
    // try breaking up the expression into distinct sub-expressions
    var result = [Declaration]()
    result.append(contentsOf: self.enumerations)
    result.append(contentsOf: self.structures)
    result.append(contentsOf: self.classes)
    result.append(contentsOf: self.protocols)
    result.append(contentsOf: self.typealiases)
    result.append(contentsOf: self.extensions)
    result.append(contentsOf: self.variables)
    result.append(contentsOf: self.initializers)
    result.append(contentsOf: self.functions)
    result.append(contentsOf: self.subscripts)
    result.append(contentsOf: self.operators)
    result.append(contentsOf: self.associatedTypes)
    return result
  }

  func append(_ node: Declaration) {
    class Appender: DeclarationVisitor {
      let scope: DeclarationScope

      init(scope: DeclarationScope) {
        self.scope = scope
      }

      func visit(_ node: Enumeration) { self.scope.append(node) }
      func visit(_ node: Structure) { self.scope.append(node) }
      func visit(_ node: Class) { self.scope.append(node) }
      func visit(_ node: Protocol) { self.scope.append(node) }
      func visit(_ node: Typealias) { self.scope.append(node) }
      func visit(_ node: Extension) { self.scope.append(node) }
      func visit(_ node: Variable) { self.scope.append(node) }
      func visit(_ node: Initializer) { self.scope.append(node) }
      func visit(_ node: Function) { self.scope.append(node) }
      func visit(_ node: Subscript) { self.scope.append(node) }
      func visit(_ node: Operator) { self.scope.append(node) }
      func visit(_ node: AssociatedType) { self.scope.append(node) }
    }

    let appender = Appender(scope: self)
    appender.visit(node)
  }

  func append(_ node: Enumeration) { self.enumerations.append(node) }
  func append(_ node: Structure) { self.structures.append(node) }
  func append(_ node: Class) { self.classes.append(node) }
  func append(_ node: Protocol) { self.protocols.append(node) }
  func append(_ node: Typealias) { self.typealiases.append(node) }
  func append(_ node: Extension) { self.extensions.append(node) }
  func append(_ node: Variable) { self.variables.append(node) }
  func append(_ node: Initializer) { self.initializers.append(node) }
  func append(_ node: Function) { self.functions.append(node) }
  func append(_ node: Subscript) { self.subscripts.append(node) }
  func append(_ node: Operator) { self.operators.append(node) }
  func append(_ node: AssociatedType) { self.associatedTypes.append(node) }
}
