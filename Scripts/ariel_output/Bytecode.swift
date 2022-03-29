=============================================
=== Builder/CodeObjectBuilder+Class.swift ===
=============================================

extension CodeObjectBuilder {
  public func appendLoadBuildClass()
}

==========================================================
=== Builder/CodeObjectBuilder+Collections+Unpack.swift ===
==========================================================

extension CodeObjectBuilder {
  public func appendBuildTuple(elementCount: Int)
  public func appendBuildList(elementCount: Int)
  public func appendBuildSet(elementCount: Int)
  public func appendBuildMap(elementCount: Int)
  public func appendBuildConstKeyMap(elementCount: Int)
  public func appendListAppend(relativeStackIndex: Int)
  public func appendSetAdd(relativeStackIndex: Int)
  public func appendMapAdd(relativeStackIndex: Int)
  public func appendBuildTupleUnpack(elementCount: Int)
  public func appendBuildTupleUnpackWithCall(elementCount: Int)
  public func appendBuildListUnpack(elementCount: Int)
  public func appendBuildSetUnpack(elementCount: Int)
  public func appendBuildMapUnpack(elementCount: Int)
  public func appendBuildMapUnpackWithCall(elementCount: Int)
  public func appendUnpackSequence(elementCount: Int)
  public func appendUnpackEx(countBefore: Int, countAfter: Int)
}

=================================================
=== Builder/CodeObjectBuilder+Constants.swift ===
=================================================

extension CodeObjectBuilder {
  public func appendTrue()
  public func appendFalse()
  public func appendNone()
  public func appendEllipsis()
  public func appendInteger(_ value: BigInt)
  public func appendFloat(_ value: Double)
  public func appendComplex(real: Double, imag: Double)
  public func appendString(_ value: String)
  public func appendString(_ name: MangledName)
  public func appendBytes(_ value: Data)
  public func appendTuple(_ value: [CodeObject.Constant])
  public func appendCode(_ value: CodeObject)
  public func appendConstant(_ value: CodeObject.Constant)
  public func addNoneConstant()
  public func addConstant(string: String)
}

================================================
=== Builder/CodeObjectBuilder+Function.swift ===
================================================

extension CodeObjectBuilder {
  public func appendMakeFunction(flags: Instruction.FunctionFlags)
  public func appendCallFunction(argumentCount: Int)
  public func appendCallFunctionKw(argumentCount: Int)
  public func appendCallFunctionEx(hasKeywordArguments: Bool)
  public func appendLoadMethod(name: String)
  public func appendCallMethod(argumentCount: Int)
  public func appendReturn()
}

===============================================
=== Builder/CodeObjectBuilder+General.swift ===
===============================================

extension CodeObjectBuilder {
  public func appendNop()
  public func appendPopTop()
  public func appendRotTwo()
  public func appendRotThree()
  public func appendDupTop()
  public func appendDupTopTwo()
  public func appendPrintExpr()
  public func appendSetupAnnotations()
  public func appendPopBlock()
  public func appendBuildSlice(arg: Instruction.SliceArg)
  public func appendExtendedArg(value: UInt8)
}

=============================================================
=== Builder/CodeObjectBuilder+Generators+Coroutines.swift ===
=============================================================

extension CodeObjectBuilder {
  public func appendYieldValue()
  public func appendYieldFrom()
  public func appendGetAwaitable()
  public func appendGetAIter()
  public func appendGetANext()
}

==============================================
=== Builder/CodeObjectBuilder+Import.swift ===
==============================================

extension CodeObjectBuilder {
  public func appendImportName(name: String)
  public func appendImportStar()
  public func appendImportFrom(name: String)
}

============================================
=== Builder/CodeObjectBuilder+Jump.swift ===
============================================

extension CodeObjectBuilder {
  public func appendJumpAbsolute(to label: NotAssignedLabel)
  public func appendPopJumpIfTrue(to label: NotAssignedLabel)
  public func appendPopJumpIfFalse(to label: NotAssignedLabel)
  public func appendJumpIfTrueOrPop(to label: NotAssignedLabel)
  public func appendJumpIfFalseOrPop(to label: NotAssignedLabel)
}

============================================
=== Builder/CodeObjectBuilder+Loop.swift ===
============================================

extension CodeObjectBuilder {
  public func appendSetupLoop(loopEnd: NotAssignedLabel)
  public func appendGetIter()
  public func appendForIter(ifEmpty: NotAssignedLabel)
  public func appendGetYieldFromIter()
  public func appendBreak()
  public func appendContinue(loopStartLabel: NotAssignedLabel)
}

==================================================
=== Builder/CodeObjectBuilder+Operations.swift ===
==================================================

extension CodeObjectBuilder {
  public func appendUnaryPositive()
  public func appendUnaryNegative()
  public func appendUnaryNot()
  public func appendUnaryInvert()
  public func appendBinaryPower()
  public func appendBinaryMultiply()
  public func appendBinaryMatrixMultiply()
  public func appendBinaryFloorDivide()
  public func appendBinaryTrueDivide()
  public func appendBinaryModulo()
  public func appendBinaryAdd()
  public func appendBinarySubtract()
  public func appendBinaryLShift()
  public func appendBinaryRShift()
  public func appendBinaryAnd()
  public func appendBinaryXor()
  public func appendBinaryOr()
  public func appendInPlacePower()
  public func appendInPlaceMultiply()
  public func appendInPlaceMatrixMultiply()
  public func appendInPlaceFloorDivide()
  public func appendInPlaceTrueDivide()
  public func appendInPlaceModulo()
  public func appendInPlaceAdd()
  public func appendInPlaceSubtract()
  public func appendInPlaceLShift()
  public func appendInPlaceRShift()
  public func appendInPlaceAnd()
  public func appendInPlaceXor()
  public func appendInPlaceOr()
  public func appendCompareOp(type: Instruction.CompareType)
}

=========================================================
=== Builder/CodeObjectBuilder+Store+Load+Delete.swift ===
=========================================================

extension CodeObjectBuilder {
  public func appendStoreName(_ name: String)
  public func appendStoreName(_ name: MangledName)
  public func appendLoadName(_ name: String)
  public func appendLoadName(_ name: MangledName)
  public func appendDeleteName(_ name: String)
  public func appendDeleteName(_ name: MangledName)
  public func appendStoreAttribute(_ name: String)
  public func appendStoreAttribute(_ name: MangledName)
  public func appendLoadAttribute(_ name: String)
  public func appendLoadAttribute(_ name: MangledName)
  public func appendDeleteAttribute(_ name: String)
  public func appendDeleteAttribute(_ name: MangledName)
  public func appendBinarySubscript()
  public func appendStoreSubscript()
  public func appendDeleteSubscript()
  public func appendStoreGlobal(_ name: String)
  public func appendStoreGlobal(_ name: MangledName)
  public func appendLoadGlobal(_ name: String)
  public func appendLoadGlobal(_ name: MangledName)
  public func appendDeleteGlobal(_ name: String)
  public func appendDeleteGlobal(_ name: MangledName)
  public func appendLoadFast(_ name: MangledName)
  public func appendStoreFast(_ name: MangledName)
  public func appendDeleteFast(_ name: MangledName)
  public func appendLoadCell(_ name: MangledName)
  public func appendStoreCell(_ name: MangledName)
  public func appendDeleteCell(_ name: MangledName)
  public func appendLoadFree(_ name: MangledName)
  public func appendLoadClassFree(_ name: MangledName)
  public func appendStoreFree(_ name: MangledName)
  public func appendDeleteFree(_ name: MangledName)
  public func appendLoadClosureCell(name: MangledName)
  public func appendLoadClosureFree(name: MangledName)
}

==============================================
=== Builder/CodeObjectBuilder+String.swift ===
==============================================

extension CodeObjectBuilder {
  public func appendFormatValue(conversion: Instruction.StringConversion, hasFormat: Bool)
  public func appendBuildString(count: Int)
}

=================================================
=== Builder/CodeObjectBuilder+Try+Catch.swift ===
=================================================

extension CodeObjectBuilder {
  public func appendPopExcept()
  public func appendEndFinally()
  public func appendSetupExcept(firstExcept: NotAssignedLabel)
  public func appendSetupFinally(finallyStart: NotAssignedLabel)
  public func appendRaiseVarargs(arg: Instruction.RaiseArg)
}

============================================
=== Builder/CodeObjectBuilder+With.swift ===
============================================

extension CodeObjectBuilder {
  public func appendSetupWith(afterBody: NotAssignedLabel)
  public func appendWithCleanupStart()
  public func appendWithCleanupFinish()
  public func appendBeforeAsyncWith()
  public func appendSetupAsyncWith()
}

=======================================
=== Builder/CodeObjectBuilder.swift ===
=======================================

public final class CodeObjectBuilder {
  public let name: String
  public let qualifiedName: String
  public let filename: String
  public let kind: CodeObject.Kind
  public let flags: CodeObject.Flags
  public let variableNames: [MangledName]
  public let freeVariableNames: [MangledName]
  public let cellVariableNames: [MangledName]
  public let argCount: Int
  public let kwOnlyArgCount: Int
  public let firstLine: SourceLine
  public internal(set) var instructions = [Instruction]()
  public internal(set) var instructionLines = [SourceLine]()
  public internal(set) var constants = [CodeObject.Constant]()
  public internal(set) var names = [String]()
  public internal(set) var labels = [CodeObject.Label]()
  public init(name: String, qualifiedName: String, filename: String, kind: CodeObject.Kind, flags: CodeObject.Flags, variableNames: [MangledName], freeVariableNames: [MangledName], cellVariableNames: [MangledName], argCount: Int, kwOnlyArgCount: Int, firstLine: SourceLine)
  public func finalize() -> CodeObject
  public func setAppendLocation(_ location: SourceLocation)
  public struct NotAssignedLabel {}
  public func createLabel() -> NotAssignedLabel
  public func setLabel(_ notAssigned: NotAssignedLabel)
}

================================================
=== CodeObject+CustomStringConvertible.swift ===
================================================

extension CodeObject: CustomStringConvertible {
  public var description: String { get }
}

=============================================
=== CodeObject+GetFilledInstruction.swift ===
=============================================

extension CodeObject {
  public struct FilledInstruction: CustomStringConvertible {
    public let instruction: Instruction.Filled
    public let nextInstructionIndex: Int?
    public var description: String { get }
  }
  public func getFilledInstruction(index: Int) -> FilledInstruction
}

========================
=== CodeObject.swift ===
========================

public final class CodeObject: Equatable {
  public enum Kind: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public enum ComprehensionKind: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public struct Flags: OptionSet, CustomStringConvertible {
    public let rawValue: UInt16
    public static let optimized = Flags(rawValue: 0x0001)
    public static let newLocals = Flags(rawValue: 0x0002)
    public static let varArgs = Flags(rawValue: 0x0004)
    public static let varKeywords = Flags(rawValue: 0x0008)
    public static let nested = Flags(rawValue: 0x0010)
    public static let generator = Flags(rawValue: 0x0020)
    public static let coroutine = Flags(rawValue: 0x0080)
    public static let asyncGenerator = Flags(rawValue: 0x0200)
    public static let noFree = Flags(rawValue: 0x0040)
    public static let iterableCoroutine = Flags(rawValue: 0x0100)
    public var description: String { get }
    public init(rawValue: UInt16)
  }
  public enum Constant: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public struct Label: Equatable, CustomStringConvertible {
    public static let notAssigned = Label(instructionIndex: -1)
    public internal(set) var instructionIndex: Int
    public var byteOffset: Int { get }
    public var description: String { get }
  }
  public enum Names {
    public static let module = "<module>"
    public static let lambda = "<lambda>"
    public static let generatorExpression = "<genexpr>"
    public static let listComprehension = "<listcomp>"
    public static let setComprehension = "<setcomp>"
    public static let dictionaryComprehension = "<dictcomp>"
  }
  public let name: String
  public let qualifiedName: String
  public let filename: String
  public let kind: Kind
  public let flags: Flags
  public let firstLine: SourceLine
  public let instructions: [Instruction]
  public let instructionLines: [SourceLine]
  public let constants: [Constant]
  public let names: [String]
  public let labels: [Label]
  public let variableNames: [MangledName]
  public let freeVariableNames: [MangledName]
  public let cellVariableNames: [MangledName]
  public let argCount: Int
  public let kwOnlyArgCount: Int
  public static func ==(lhs: CodeObject, rhs: CodeObject) -> Bool
}

================================================
=== Generated/Instructions+Description.swift ===
================================================

extension Instruction.StringConversion: CustomStringConvertible {
  public var description: String { get }
}

extension Instruction.CompareType: CustomStringConvertible {
  public var description: String { get }
}

extension Instruction.SliceArg: CustomStringConvertible {
  public var description: String { get }
}

extension Instruction.RaiseArg: CustomStringConvertible {
  public var description: String { get }
}

extension Instruction: CustomStringConvertible {
  public var description: String { get }
}

=======================================================
=== Generated/Instructions+Filled+Description.swift ===
=======================================================

extension Instruction.Filled: CustomStringConvertible {
  public var description: String { get }
}

===========================================
=== Generated/Instructions+Filled.swift ===
===========================================

extension Instruction {
  public enum Filled: Equatable {}
}

====================================
=== Generated/Instructions.swift ===
====================================

extension Instruction {
  public enum StringConversion: Equatable {}
}

extension Instruction {
  public enum CompareType: Equatable {}
}

extension Instruction {
  public enum SliceArg: Equatable {}
}

extension Instruction {
  public enum RaiseArg: Equatable {}
}

public enum Instruction: Equatable {}

===============================
=== Instructions+Misc.swift ===
===============================

extension Instruction {
  public static let byteSize = 2
  public static let maxArgument = 0xff
  public static let maxExtendedArgument1 = 0xffff
  public static let maxExtendedArgument2 = 0xff_ffff
  public static let maxExtendedArgument3 = 0xffff_ffff
  public static func extend(base: Int, arg: UInt8) -> Int
  public struct FunctionFlags: OptionSet, Equatable, CustomStringConvertible {
    public let rawValue: UInt8
    public static let hasPositionalArgDefaults = FunctionFlags(rawValue: 0x01)
    public static let hasKwOnlyArgDefaults = FunctionFlags(rawValue: 0x02)
    public static let hasAnnotations = FunctionFlags(rawValue: 0x04)
    public static let hasFreeVariables = FunctionFlags(rawValue: 0x08)
    public var description: String { get }
    public init(rawValue: UInt8)
  }
  public struct UnpackExArg: Equatable, CustomStringConvertible {
    public let value: Int
    public var countBefore: Int { get }
    public var countAfter: Int { get }
    public var description: String { get }
    public init(value: Int)
    public init(countBefore: Int, countAfter: Int)
  }
}

=========================
=== MangledName.swift ===
=========================

public struct MangledName: Equatable, Hashable, CustomStringConvertible {
  public let beforeMangling: String
  public let value: String
  public var description: String { get }
  public init(withoutClass name: String)
  public init(className: String?, name: String)
  public func hash(into hasher: inout Hasher)
  public static func ==(lhs: MangledName, rhs: MangledName) -> Bool
}

