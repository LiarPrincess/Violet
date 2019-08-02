public struct SourceLocation: Equatable {

  /// Initial location.
  public static var start: SourceLocation {
    return SourceLocation(line: 1, column: 0)
  }

  /// Line in file starting from 1.
  public private(set) var line: Int

  /// Column in line starting from 0.
  public private(set) var column: Int

  public init(line: Int, column: Int) {
    self.line = line
    self.column = column
  }

  internal mutating func advanceLine() {
    self.line += 1
    self.column = 0
  }

  internal mutating func advanceColumn() {
    self.column += 1
  }

  internal var next: SourceLocation {
    let line = self.line
    let column = self.column + 1
    return SourceLocation(line: line, column: column)
  }
}

extension SourceLocation: CustomStringConvertible {
  public var description: String {
    return "\(line):\(column)"
  }
}
