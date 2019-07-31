// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Lexer

public struct ParserError: Error, Equatable {

  /// Type of the error.
  public let kind: ParserErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public init(_ kind:   ParserErrorKind,
              location: SourceLocation) {

    self.kind = kind
    self.location = location
  }
}

extension ParserError: CustomStringConvertible {
  public var description: String {
    return "\(self.location): SyntaxError: \(self.kind)"
  }
}
