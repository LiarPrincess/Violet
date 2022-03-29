======================
=== Compiler.swift ===
======================

public final class Compiler {
  public struct Options {
    public let optimizationLevel: OptimizationLevel
    public init(optimizationLevel: OptimizationLevel)
  }
  public enum OptimizationLevel: Equatable, Comparable {
    public static func <(lhs: OptimizationLevel, rhs: OptimizationLevel) -> Bool
  }
  public init(filename: String, ast: AST, options: Options, delegate: CompilerDelegate?)
  public func run() throws -> CodeObject
}

==============================
=== CompilerDelegate.swift ===
==============================

public protocol CompilerDelegate: AnyObject {}

===========================
=== CompilerError.swift ===
===========================

public struct CompilerError: Error, Equatable, CustomStringConvertible {
  public let kind: Kind
  public let location: SourceLocation
  public var description: String { get }
  public init(_ kind: Kind, location: SourceLocation)
  public enum Kind: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
}

=============================
=== CompilerWarning.swift ===
=============================

public struct CompilerWarning: CustomStringConvertible {
  public let kind: Kind
  public let location: SourceLocation
  public var description: String { get }
  public init(_ kind: Kind, location: SourceLocation)
  public enum Kind: CustomStringConvertible {
    public var description: String { get }
  }
}

============================
=== FutureFeatures.swift ===
============================

public struct FutureFeatures {
  public struct Flags: OptionSet {
    public let rawValue: UInt8
    public static let absoluteImport = Flags(rawValue: 1 << 0)
    public static let division = Flags(rawValue: 1 << 1)
    public static let withStatement = Flags(rawValue: 1 << 2)
    public static let printFunction = Flags(rawValue: 1 << 3)
    public static let unicodeLiterals = Flags(rawValue: 1 << 4)
    public static let barryAsBdfl = Flags(rawValue: 1 << 5)
    public static let generatorStop = Flags(rawValue: 1 << 6)
    public static let annotations = Flags(rawValue: 1 << 7)
    public init(rawValue: UInt8)
  }
  public private(set) var flags: Flags = []
  public private(set) var lastLine = SourceLocation.start.line
  public static func parse(ast: AST) throws -> FutureFeatures
}

=======================================================
=== Implementation/CompilerImpl+UNIMPLEMENTED.swift ===
=======================================================

public enum CompilerUnimplemented: CustomStringConvertible, Equatable {
  public var description: String { get }
}

=====================================
=== Symbol table/SymbolInfo.swift ===
=====================================

public struct SymbolInfo: Equatable, CustomStringConvertible {
  public struct Flags: OptionSet, Equatable, CustomStringConvertible {
    public let rawValue: UInt16
    public static let defLocal = Flags(rawValue: 1 << 0)
    public static let defGlobal = Flags(rawValue: 1 << 1)
    public static let defNonlocal = Flags(rawValue: 1 << 2)
    public static let defParam = Flags(rawValue: 1 << 3)
    public static let defImport = Flags(rawValue: 1 << 4)
    public static let defFree = Flags(rawValue: 1 << 5)
    public static let defFreeClass = Flags(rawValue: 1 << 6)
    public static let defBoundMask: Flags = [
          .defLocal, .defParam, .defImport
        ]
    public static let scopeMask: Flags = [
          .defLocal, .defGlobal, .defNonlocal, .defParam
        ]
    public static let srcLocal = Flags(rawValue: 1 << 7)
    public static let srcGlobalExplicit = Flags(rawValue: 1 << 8)
    public static let srcGlobalImplicit = Flags(rawValue: 1 << 9)
    public static let srcFree = Flags(rawValue: 1 << 10)
    public static let cell = Flags(rawValue: 1 << 11)
    public static let srcMask: Flags = [
          .srcLocal, .srcGlobalExplicit, .srcGlobalImplicit, .srcFree, .cell
        ]
    public static let use = Flags(rawValue: 1 << 12)
    public static let annotated = Flags(rawValue: 1 << 13)
    public var description: String { get }
    public init(rawValue: UInt16)
  }
  public let flags: Flags
  public let location: SourceLocation
  public var description: String { get }
}

======================================
=== Symbol table/SymbolScope.swift ===
======================================

public final class SymbolScope {
  public enum Kind: Equatable {}
  public struct SymbolByName: Sequence {
    public var count: Int { get }
    public var isEmpty: Bool { get }
    public internal(set) subscript(name: MangledName) -> SymbolInfo? { get; set }
    public typealias Element = (key: MangledName, info: SymbolInfo)
    public typealias Iterator = AnyIterator<Self.Element>
    public func makeIterator() -> Iterator
  }
  public let name: String
  public let kind: Kind
  public internal(set) var symbols = SymbolByName()
  public internal(set) var children = [SymbolScope]()
  public internal(set) var parameterNames = [MangledName]()
  public let isNested: Bool
  public internal(set) var isGenerator = false
  public internal(set) var isCoroutine = false
  public internal(set) var hasVarargs = false
  public internal(set) var hasVarKeywords = false
  public internal(set) var hasReturnValue = false
  public internal(set) var needsClassClosure = false
}

======================================
=== Symbol table/SymbolTable.swift ===
======================================

public final class SymbolTable {
  public struct ScopeByNode {
    public internal(set) subscript<N: ASTNode>(key: N) -> SymbolScope? { get; set }
  }
  public let top: SymbolScope
  public let scopeByNode: ScopeByNode
}

=============================================
=== Symbol table/SymbolTableBuilder.swift ===
=============================================

public final class SymbolTableBuilder {
  public init(delegate: CompilerDelegate?)
  public func visit(ast: AST) throws -> SymbolTable
}

