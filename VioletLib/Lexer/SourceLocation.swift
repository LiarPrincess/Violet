// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct SourceLocation: Equatable {

  public static var start: SourceLocation {
    return SourceLocation(line: 1, column: 0)
  }

  public private(set) var line:   Int
  public private(set) var column: Int

  internal init(line: Int, column: Int) {
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
}

extension SourceLocation: CustomStringConvertible {
  public var description: String {
    return "\(line),\(column)"
  }
}
