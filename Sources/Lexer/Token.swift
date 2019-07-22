// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct Token: Equatable {

  public let kind:  TokenKind
  public let start: SourceLocation
  public let end:   SourceLocation

  public init(_ kind: TokenKind,
              start:  SourceLocation,
              end:    SourceLocation) {

    self.kind = kind
    self.start = start
    self.end = end
  }
}

extension Token: CustomStringConvertible {
  public var description: String {
    return "\(self.start)-\(self.end): \(self.kind)"
  }
}
