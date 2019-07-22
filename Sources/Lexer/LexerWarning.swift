// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct LexerWarning: OptionSet {

  /// Changed in version 3.6:
  /// Unrecognized escape sequences produce a DeprecationWarning.
  /// In some future version of Python they will be a SyntaxError.
  public static let unrecognizedEscapeSequence = LexerWarning(rawValue: 1 << 0)

  public let rawValue: UInt32

  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
}
