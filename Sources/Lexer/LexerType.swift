// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public protocol LexerType {

  /// Get nex token to parse.
  /// If we reached EOF then it should return EOF token.
  mutating func getToken() throws -> Token
}
