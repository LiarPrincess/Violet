// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct SourceLocation {

  public private(set) var line:   UInt
  public private(set) var column: UInt

  public init(line: UInt, column: UInt) {
    self.line = line
    self.column = column
  }

  internal mutating func reset() {
    self.line = 1
    self.column = 1
  }

  internal mutating func advance() {
    self.column += 1
  }

  internal mutating func newLine() {
    self.line += 1
    self.column = 1
  }

  public static var start: SourceLocation {
    return SourceLocation(line: 1, column: 1)
  }
}

extension SourceLocation: CustomStringConvertible {
  public var description: String {
    return "\(line):\(column)"
  }
}
