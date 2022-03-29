============================
=== Lexer+GetToken.swift ===
============================

extension Lexer {
  public func getToken() throws -> Token
}

=================================
=== Lexer+UNIMPLEMENTED.swift ===
=================================

public enum LexerUnimplemented: CustomStringConvertible, Equatable {
  public var description: String { get }
}

===================
=== Lexer.swift ===
===================

public final class Lexer: LexerType {
  public init(for source: String, delegate: LexerDelegate?)
}

===========================
=== LexerDelegate.swift ===
===========================

public protocol LexerDelegate: AnyObject {}

========================
=== LexerError.swift ===
========================

public struct LexerError: Error, Equatable, CustomStringConvertible {
  public let kind: Kind
  public let location: SourceLocation
  public var description: String { get }
  public init(_ kind: Kind, location: SourceLocation)
  public enum Kind: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
}

=======================
=== LexerType.swift ===
=======================

public protocol LexerType: AnyObject {}

==========================
=== LexerWarning.swift ===
==========================

public struct LexerWarning: Equatable, CustomStringConvertible {
  public let kind: Kind
  public let location: SourceLocation
  public var description: String { get }
  public init(_ kind: Kind, location: SourceLocation)
  public enum Kind: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
}

========================
=== NumberType.swift ===
========================

public enum NumberType: CustomStringConvertible {
  public var description: String { get }
}

===================
=== Token.swift ===
===================

public struct Token: Equatable, CustomStringConvertible {
  public let kind: Kind
  public let start: SourceLocation
  public let end: SourceLocation
  public var description: String { get }
  public init(_ kind: Kind, start: SourceLocation, end: SourceLocation)
  public enum Kind: Equatable, Hashable, CustomStringConvertible {
    public var description: String { get }
  }
}

