# Ariel

Ariel is a tiny module to print module interface (all of the `open`/`public` declarations).

## Usage

```
OVERVIEW: Tool to dump module interface (all of the 'public' and 'open'
declarations).

USAGE: arguments [--verbose] [--min-access-level <access-level>] [--output-path <path>] <input-path>

ARGUMENTS:
  <input-path>            Path to a single Swift file or to a directory that
                          contains such files (recursive).

OPTIONS:
  --verbose               Print additional messages.
  --min-access-level <access-level>
                          Minimum access level needed for the declaration to be
                          visible in the output. Note that the declaration may
                          be visible anyway, if one of the nested declarations
                          is visible. (default: public)
  --output-path <path>    Path at which the generated file will be written
                          (default: standard output). If the value represents a
                          path to a file then the output will be written to
                          this file. If the value represents a directory then
                          new file will be created in this directory (name of
                          the file depends on the input name).
  --version               Show the version.
  -h, --help              Show help information.
```

## Example output

This is the Ariel output for our `BigInt` module:

```Swift
=================================
=== BigInt+PythonString.swift ===
=================================

extension BigInt {
  public enum PythonParsingError: Error, Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public init(parseUsingPythonRules string: String, base: Int = 10) throws
  public init(parseUsingPythonRules scalars: String.UnicodeScalarView, base: Int = 10) throws
  public init(parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence, base _base: Int = 10) throws
}

===========================
=== BigInt+String.swift ===
===========================

extension String {
  public init(_ value: BigInt, radix: Int = 10, uppercase: Bool = false)
}

extension BigInt {
  public enum ParsingError: Error, Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public init(_ string: String, radix: Int = 10) throws
  public init(_ scalars: String.UnicodeScalarView, radix: Int = 10) throws
  public init(_ scalars: String.UnicodeScalarView.SubSequence, radix: Int = 10) throws
}

=================================
=== BigInt+WordsAndBits.swift ===
=================================

extension BigInt {
  public var bitWidth: Int { get }
}

extension BigInt {
  public struct Words: RandomAccessCollection {
    public var count: Int { get }
    public var startIndex: Int { get }
    public var endIndex: Int { get }
    public subscript(_ index: Int) -> UInt { get }
  }
  public var words: Words { get }
}

extension BigInt {
  public var minRequiredWidth: Int { get }
}

extension BigInt {
  public var trailingZeroBitCount: Int { get }
}

====================
=== BigInt.swift ===
====================

public struct BigInt: SignedInteger, Comparable, Hashable, Strideable, CustomStringConvertible, CustomDebugStringConvertible {
  public var isOdd: Bool { get }
  public var isEven: Bool { get }
  public var isZero: Bool { get }
  public var isOne: Bool { get }
  public var isPositiveOrZero: Bool { get }
  public var isNegative: Bool { get }
  public var magnitude: BigInt { get }
  public init()
  public init<T: BinaryInteger>(_ value: T)
  public init(integerLiteral value: Int)
  public init?<T: BinaryInteger>(exactly source: T)
  public init<T: BinaryInteger>(truncatingIfNeeded source: T)
  public init<T: BinaryInteger>(clamping source: T)
  public init<T: BinaryFloatingPoint>(_ source: T)
  public init?<T: BinaryFloatingPoint>(exactly source: T)
  public static func +(value: BigInt) -> BigInt
  public static func -(value: BigInt) -> BigInt
  public static func ~(value: BigInt) -> BigInt
  public static func +(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func +=(lhs: inout BigInt, rhs: BigInt)
  public static func -(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func -=(lhs: inout BigInt, rhs: BigInt)
  public static func *(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func *=(lhs: inout BigInt, rhs: BigInt)
  public static func /(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func /=(lhs: inout BigInt, rhs: BigInt)
  public static func %(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func %=(lhs: inout BigInt, rhs: BigInt)
  public typealias DivMod = (quotient: BigInt, remainder: BigInt)
  public func quotientAndRemainder(dividingBy other: BigInt) -> DivMod
  public func power(exponent: BigInt) -> BigInt
  public static func &(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func &=(lhs: inout BigInt, rhs: BigInt)
  public static func |(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func |=(lhs: inout BigInt, rhs: BigInt)
  public static func ^(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func ^=(lhs: inout BigInt, rhs: BigInt)
  public static func <<(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func <<=<T: BinaryInteger>(lhs: inout BigInt, rhs: T)
  public static func >>(lhs: BigInt, rhs: BigInt) -> BigInt
  public static func >>=<T: BinaryInteger>(lhs: inout BigInt, rhs: T)
  public var description: String { get }
  public var debugDescription: String { get }
  public static func ==(lhs: BigInt, rhs: BigInt) -> Bool
  public static func <(lhs: BigInt, rhs: BigInt) -> Bool
  public func hash(into hasher: inout Hasher)
}
```
