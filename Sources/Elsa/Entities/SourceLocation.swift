struct SourceLocation: Equatable, CustomStringConvertible {

  static var start: SourceLocation {
    return SourceLocation(line: 1, column: 0)
  }

  var line: Int
  var column: Int

  mutating func advanceLine() {
    self.line += 1
    self.column = 0
  }

  mutating func advanceColumn() {
    self.column += 1
  }

  var description: String {
    let columnPrefix = self.column < 10 ? "0" : ""
    return "\(self.line):\(columnPrefix)\(self.column)"
  }
}
