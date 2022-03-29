========================
=== ASTVisitor.swift ===
========================

public class ASTVisitor: SyntaxVisitor {
  public private(set) var topLevelDeclarations = [Declaration]()
  public typealias Continue = SyntaxVisitorContinueKind
  public override func visit(_ node: EnumDeclSyntax) -> Continue
  public override func visit(_ node: StructDeclSyntax) -> Continue
  public override func visit(_ node: ClassDeclSyntax) -> Continue
  public override func visit(_ node: ProtocolDeclSyntax) -> Continue
  public override func visit(_ node: ExtensionDeclSyntax) -> Continue
  public override func visit(_ node: FunctionDeclSyntax) -> Continue
  public override func visit(_ node: InitializerDeclSyntax) -> Continue
  public override func visit(_ node: SubscriptDeclSyntax) -> Continue
  public override func visit(_ node: OperatorDeclSyntax) -> Continue
  public override func visit(_ node: TypealiasDeclSyntax) -> Continue
  public override func visit(_ node: AssociatedtypeDeclSyntax) -> Continue
  public override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind
  public override func visitPost(_ node: EnumDeclSyntax)
  public override func visitPost(_ node: StructDeclSyntax)
  public override func visitPost(_ node: ClassDeclSyntax)
  public override func visitPost(_ node: ProtocolDeclSyntax)
  public override func visitPost(_ node: ExtensionDeclSyntax)
  public override func visitPost(_ node: FunctionDeclSyntax)
  public override func visitPost(_ node: InitializerDeclSyntax)
  public override func visitPost(_ node: SubscriptDeclSyntax)
  public override func visitPost(_ node: OperatorDeclSyntax)
  public override func visitPost(_ node: TypealiasDeclSyntax)
  public override func visitPost(_ node: AssociatedtypeDeclSyntax)
  public override func visitPost(_ node: VariableDeclSyntax)
}

=======================
=== Arguments.swift ===
=======================

public struct Arguments: ParsableCommand {
  public static var configuration = CommandConfiguration(
      abstract: "Tool to dump module interface " +
        "(all of the 'public' a <and so on…>"
  @Flag
  public var verbose = false
  @Option
  public var minAccessLevel = AccessModifier.public
  @Option
  public var outputPath: String?
  @Argument
  public var inputPath: String
  public init()
}

=========================================
=== Declarations/AssociatedType.swift ===
=========================================

public class AssociatedType: Declaration {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let initializer: TypeInitializer?
  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], inheritance: [InheritedType], initializer: TypeInitializer?, attributes: [Attribute], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

================================
=== Declarations/Class.swift ===
================================

public class Class: DeclarationWithScope {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public var children = [Declaration]()
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], inheritance: [InheritedType], attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

======================================
=== Declarations/Declaration.swift ===
======================================

public typealias DeclarationId = AnyHashable
public protocol Declaration: AnyObject, CustomStringConvertible {}
extension Declaration {
  public var description: String { get }
}

public protocol DeclarationVisitor: AnyObject {}
extension DeclarationVisitor {
  public func visit(_ node: Declaration)
}

======================================
=== Declarations/Enumeration.swift ===
======================================

public class Enumeration: DeclarationWithScope {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public var children = [Declaration]()
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], inheritance: [InheritedType], attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

====================================
=== Declarations/Extension.swift ===
====================================

public class Extension: DeclarationWithScope {
  public let id: DeclarationId
  public let extendedType: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]
  public var children = [Declaration]()
  public init(id: DeclarationId, extendedType: String, accessModifier: AccessModifier?, modifiers: [Modifier], inheritance: [InheritedType], attributes: [Attribute], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

===================================
=== Declarations/Function.swift ===
===================================

public class Function: Declaration {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let parameters: [Parameter]
  public let output: Type?
  public let `throws`: ThrowingStatus?
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], parameters: [Parameter], output: Type?, throws: ThrowingStatus?, attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

===========================================
=== Declarations/Helpers/Accessor.swift ===
===========================================

public struct Accessor {
  public enum Kind: String {}
  public enum Modifier: String {}
  public let kind: Kind
  public let modifier: Modifier?
  public let attributes: [Attribute]
  public init(kind: Kind, modifier: Modifier?, attributes: [Attribute])
}

============================================
=== Declarations/Helpers/Attribute.swift ===
============================================

public struct Attribute {
  public let name: String
  public init(name: String)
}

==========================================
=== Declarations/Helpers/Generic.swift ===
==========================================

public struct GenericParameter {
  public let name: String
  public let inheritedType: Type?
  public init(name: String, inheritedType: Type?)
}

public struct GenericRequirement {
  public enum Kind {}
  public let kind: Kind
  public let leftType: Type
  public let rightType: Type
  public init(kind: GenericRequirement.Kind, leftType: Type, rightType: Type)
}

===============================================
=== Declarations/Helpers/Initializers.swift ===
===============================================

public struct TypeInitializer {
  public let value: String
  public init(value: String)
}

public struct VariableInitializer {
  public let value: String
  public init(value: String)
}

============================================
=== Declarations/Helpers/Modifiers.swift ===
============================================

public enum AccessModifier: String, RawRepresentable, ExpressibleByArgument {}
public struct GetSetAccessModifiers {
  public let get: AccessModifier?
  public let set: AccessModifier?
}

public enum Modifier: String {}

============================================
=== Declarations/Helpers/Parameter.swift ===
============================================

public struct Parameter: CustomStringConvertible {
  public let firstName: String?
  public let secondName: String?
  public let type: Type?
  public let isVariadic: Bool
  public let defaultValue: VariableInitializer?
  public var description: String { get }
  public init(firstName: String?, secondName: String?, type: Type?, isVariadic: Bool, defaultValue: VariableInitializer?)
}

=================================================
=== Declarations/Helpers/ThrowingStatus.swift ===
=================================================

public enum ThrowingStatus {}

========================================
=== Declarations/Helpers/Types.swift ===
========================================

public struct Type {
  public let name: String
  public init(name: String)
}

public struct InheritedType {
  public let typeName: String
  public init(typeName: String)
}

public struct TypeAnnotation {
  public let typeName: String
  public init(typeName: String)
}

======================================
=== Declarations/Initializer.swift ===
======================================

public class Initializer: Declaration {
  public let id: DeclarationId
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let isOptional: Bool
  public let parameters: [Parameter]
  public let `throws`: ThrowingStatus?
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public init(id: DeclarationId, accessModifier: AccessModifier?, modifiers: [Modifier], isOptional: Bool, parameters: [Parameter], throws: ThrowingStatus?, attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

===================================
=== Declarations/Operator.swift ===
===================================

public class Operator: Declaration {
  public enum Kind: String {}
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let kind: Kind
  public let operatorPrecedenceAndTypes: [String]
  public let attributes: [Attribute]
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], kind: Operator.Kind, operatorPrecedenceAndTypes: [String], attributes: [Attribute])
  public func accept(visitor: DeclarationVisitor)
}

===================================
=== Declarations/Protocol.swift ===
===================================

public class Protocol: DeclarationWithScope {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]
  public var children = [Declaration]()
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], inheritance: [InheritedType], attributes: [Attribute], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

====================================
=== Declarations/Structure.swift ===
====================================

public class Structure: DeclarationWithScope {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public var children = [Declaration]()
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], inheritance: [InheritedType], attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

====================================
=== Declarations/Subscript.swift ===
====================================

public class Subscript: Declaration {
  public let id: DeclarationId
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let indices: [Parameter]
  public let result: Type
  public let accessors: [Accessor]
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public init(id: DeclarationId, accessModifiers: GetSetAccessModifiers?, modifiers: [Modifier], indices: [Parameter], result: Type, accessors: [Accessor], attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

====================================
=== Declarations/Typealias.swift ===
====================================

public class Typealias: Declaration {
  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let initializer: TypeInitializer?
  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]
  public init(id: DeclarationId, name: String, accessModifier: AccessModifier?, modifiers: [Modifier], initializer: TypeInitializer?, attributes: [Attribute], genericParameters: [GenericParameter], genericRequirements: [GenericRequirement])
  public func accept(visitor: DeclarationVisitor)
}

===================================
=== Declarations/Variable.swift ===
===================================

public class Variable: Declaration {
  public let id: DeclarationId
  public let name: String
  public let keyword: String
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let typeAnnotation: TypeAnnotation?
  public let initializer: VariableInitializer?
  public let accessors: [Accessor]
  public let attributes: [Attribute]
  public init(id: DeclarationId, name: String, keyword: String, accessModifiers: GetSetAccessModifiers?, modifiers: [Modifier], typeAnnotation: TypeAnnotation?, initializer: VariableInitializer?, accessors: [Accessor], attributes: [Attribute])
  public func accept(visitor: DeclarationVisitor)
}

============================
=== Filters/Filter.swift ===
============================

public class Filter {
  public init(minAccessModifier: AccessModifier?)
  public func walk(nodes: [Declaration])
  public func isAccepted(_ node: Declaration) -> Bool
}

=====================
=== Globals.swift ===
=====================

public let fileSystem = FileSystem.default

==================================
=== Output/ConsoleOutput.swift ===
==================================

public struct ConsoleOutput: Output {
  public func write(_ string: String)
  public func close()
}

===============================
=== Output/FileOutput.swift ===
===============================

public class FileOutput: Output {
  public static let stdout = FileOutput(name: "<stdout>",
                                          fileHandle: .standardOutput,
     <and so on…>
  public init(name: String, fileHandle: FileHandle, encoding: String.Encoding, closeFileHandleAfter: Bool)
  public init(path: Path, encoding: String.Encoding)
  public func write(_ string: String)
  public func close()
}

==============================
=== Output/Formatter.swift ===
==============================

public struct Formatter {
  public static let forDescription = Formatter(
      newLineAfterAttribute: false,
      maxInitializerLength: 50
    )
  public init(newLineAfterAttribute: Bool, maxInitializerLength: Int?)
  public func format(_ node: Declaration) -> String
  public func format(_ node: Enumeration) -> String
  public func format(_ node: Structure) -> String
  public func format(_ node: Class) -> String
  public func format(_ node: Protocol) -> String
  public func format(_ node: AssociatedType) -> String
  public func format(_ node: Typealias) -> String
  public func format(_ node: Extension) -> String
  public func format(_ node: Variable) -> String
  public func format(_ node: Initializer) -> String
  public func format(_ node: Function) -> String
  public func format(_ node: Subscript) -> String
  public func format(_ node: Operator) -> String
}

===========================
=== Output/Output.swift ===
===========================

public protocol Output: TextOutputStream {}

===========================
=== Output/Writer.swift ===
===========================

public class Writer {
  public init(filter: Filter, formatter: Formatter, output: Output)
  public func write(printedPath: String, declarations: [Declaration])
}

===============================
=== PrintErrorAndExit.swift ===
===============================

public func printErrorAndExit(_ msg: String) -> Never

==================
=== Trap.swift ===
==================

public func trap(_ msg: String, file: StaticString = #file, function: StaticString = #function, line: Int = #line) -> Never

