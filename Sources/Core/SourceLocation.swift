// '4_294_967_296' seems like a reasonable assumption
public typealias SourceLine = UInt32
public typealias SourceColumn = UInt32

/// Location in the source file.
public struct SourceLocation: Equatable, Comparable, CustomStringConvertible {

  /// Initial location.
  public static var start: SourceLocation {
    return SourceLocation(line: 1, column: 0)
  }

  /// Line in file, starting from 1.
  public private(set) var line: SourceLine

  /// Column in line, starting from 0.
  public private(set) var column: SourceColumn

  public var description: String {
    return "\(self.line):\(self.column)"
  }

  public init(line: SourceLine, column: SourceColumn) {
    self.line = line
    self.column = column
  }

  public mutating func advanceLine() {
    self.line += 1
    self.column = 0
  }

  public mutating func advanceColumn() {
    self.column += 1
  }

  public var nextColumn: SourceLocation {
    let nextColumn = self.column + 1
    return SourceLocation(line: self.line, column: nextColumn)
  }

  public static func < (lhs: SourceLocation, rhs: SourceLocation) -> Bool {
    if lhs.line < rhs.line {
      return true
    }

    if lhs.line == rhs.line {
      return lhs.column < rhs.column
    }

    assert(lhs.line > rhs.line) // Well… math is hard and we are not good at it
    return false
  }
}
