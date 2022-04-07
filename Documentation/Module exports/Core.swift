================================
=== Double+PythonParse.swift ===
================================

extension Double {
  public init?(parseUsingPythonRules string: String)
  public init?(parseUsingPythonRules scalars: String.UnicodeScalarView)
  public init?(parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence)
}

=============================================
=== Extensions/CollectionExtensions.swift ===
=============================================

extension Array {
  public mutating func push(_ element: Element)
}

extension Collection {
  public var any: Bool { get }
}

extension OptionSet {
  public var any: Bool { get }
}

extension Collection {
  public func count(where predicate: (Element) -> Bool) -> Int
}

extension Collection {
  public func takeFirst(_ k: Int = 1) -> SubSequence
}

extension BidirectionalCollection {
  public func takeLast(_ k: Int = 1) -> SubSequence
}

extension BidirectionalCollection {
  public func ends<Suffix>(with suffix: Suffix) -> Bool where Suffix: BidirectionalCollection, Suffix.Element == Element, Element: Equatable
}

extension BidirectionalCollection {
  public func dropLast(while predicate: (Element) throws -> Bool) rethrows -> SubSequence
}

extension Collection where Self: MutableCollection, Self: RangeReplaceableCollection, Element: Hashable {
  public mutating func removeDuplicates()
}

extension Dictionary {
  public func contains(_ key: Key) -> Bool
}

extension Dictionary {
  public enum UniquingKeysWithStrategy {}
  public mutating func merge(_ other: [Key: Value], uniquingKeysWith: UniquingKeysWithStrategy)
}

extension OptionSet {
  public func contains(anyOf other: Self) -> Bool
}

=========================================
=== Extensions/StringExtensions.swift ===
=========================================

extension String {
  public init?(errno: Int32)
}

extension String {
  public init<Scalars: Collection>(_ scalars: Scalars) where Scalars.Element == UnicodeScalar
}

extension String {
  public var quoted: String { get }
}

extension String {
  public mutating func append(_ scalar: UnicodeScalar)
}

extension UnicodeScalar {
  public var asDigit: Int? { get }
  public var asDecimalDigit: Int? { get }
  public var asHexDigit: Int? { get }
}

extension UnicodeScalar {
  public var codePointNotation: String { get }
}

extension UnicodeScalar {
  public var isIdentifierStart: Bool { get }
  public var isIdentifierContinue: Bool { get }
}

public enum IsValidIdentifierResult {}
extension Collection where Element == UnicodeScalar {
  public var isValidIdentifier: IsValidIdentifierResult { get }
}

====================
=== Lyrics.swift ===
====================

public enum Lyrics {
  public static let letItGo = """
      The snow glows white on the mountain tonight
      Not a footprint to be seen
      A kingdom of <and so on…>"""
  public static let galavant = """
      Way back in days of old
      There was a legend told
      About a hero known as Galavant
      S <and so on…>"""
  public static let ga1ahadAndScientificWitchery = """
      (Witch)
      The magical potion of reanimation
      (Ga1ahad)
      Bittersweet cranberry flavor <and so on…>"""
}

===========================
=== NonEmptyArray.swift ===
===========================

public struct NonEmptyArray<Element>: RandomAccessCollection, CustomStringConvertible {
  public private(set) var elements = [Element]()
  public var first: Element { get }
  public var last: Element { get }
  public init(first: Element)
  public init<S: Sequence>(first: Element, rest: S) where S.Element == Element
  public mutating func append(_ newElement: Element)
  public mutating func append<S: Sequence>(contentsOf newElements: S) where S.Element == Element
  public typealias Index = Array<Element>.Index
  public var startIndex: Index { get }
  public var endIndex: Index { get }
  public subscript(index: Index) -> Element { get }
  public var description: String { get }
}

extension Array {
  public init(_ nonEmpty: NonEmptyArray<Element>)
}

=====================
=== SipHash.swift ===
=====================

public enum SipHash {
  public static func hash(key0: UInt64, key1: UInt64, bytes: UnsafeBufferPointer<UInt8>) -> UInt64
  public static func hash(key0: UInt64, key1: UInt64, bytes: UnsafeRawBufferPointer) -> UInt64
}

============================
=== SourceLocation.swift ===
============================

public typealias SourceLine = UInt32
public typealias SourceColumn = UInt32
public struct SourceLocation: Equatable, Comparable, CustomStringConvertible {
  public static var start: SourceLocation { get }
  public private(set) var line: SourceLine
  public private(set) var column: SourceColumn
  public var description: String { get }
  public init(line: SourceLine, column: SourceColumn)
  public mutating func advanceLine()
  public mutating func advanceColumn()
  public var nextColumn: SourceLocation { get }
  public static func <(lhs: SourceLocation, rhs: SourceLocation) -> Bool
}

==================
=== Trap.swift ===
==================

public func trap(_ msg: String, file: StaticString = #file, function: StaticString = #function, line: Int = #line) -> Never

=========================
=== Unreachable.swift ===
=========================

public func unreachable(file: StaticString = #file, function: StaticString = #function, line: Int = #line) -> Never
public func unreachable() -> Never

====================================
=== UseScalarsToHashString.swift ===
====================================

public struct UseScalarsToHashString: Equatable, Hashable, CustomStringConvertible {
  public var description: String { get }
  public init(_ value: String)
  public func hash(into hasher: inout Hasher)
  public static func hash(value: String, into hasher: inout Hasher)
  public static func ==(lhs: Self, rhs: Self) -> Bool
  public static func isEqual(lhs: String, rhs: String) -> Bool
}

