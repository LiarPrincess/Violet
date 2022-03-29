======================
=== Rapunzel.swift ===
======================

public protocol RapunzelConvertible {}
extension RapunzelConvertible {
  public func dump() -> String
}

public indirect enum Doc: RapunzelConvertible {
  public var doc: Doc { get }
  public func layout() -> String
  public static func <>(lhs: Doc, rhs: Doc) -> Doc
  public static func <+>(lhs: Doc, rhs: Doc) -> Doc
  public static func <|>(lhs: Doc, rhs: Doc) -> Doc
  public static let empty = Doc.text("")
  public static let space = Doc.text(" ")
  public static let dot = Doc.text(".")
  public static let colon = Doc.text(":")
  public static let comma = Doc.text(",")
  public static let semicolon = Doc.text(";")
  public static let leftParen = Doc.text("(")
  public static let leftSqb = Doc.text("[")
  public static let leftBrace = Doc.text("{")
  public static let rightParen = Doc.text(")")
  public static let rightSqb = Doc.text("]")
  public static let rightBrace = Doc.text("}")
  public static func spread(_ docs: Doc...) -> Doc
  public static func spread<S: Sequence>(_ docs: S) -> Doc where S.Element == Doc
  public static func stack(_ docs: Doc...) -> Doc
  public static func stack<S: Sequence>(_ docs: S) -> Doc where S.Element == Doc
  public static func block(title: String, indent: Int, lines: [Doc]) -> Doc
  public static func block(title: Doc, indent: Int, lines: [Doc]) -> Doc
  public static func join<S: Sequence>(_ docs: S, with glue: Doc) -> Doc where S.Element == Doc
}

extension String: RapunzelConvertible {
  public var doc: Doc { get }
}

extension Sequence where Element: RapunzelConvertible {
  public func spread() -> Doc
  public func stack() -> Doc
}

