// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Lexer

internal struct FakeLexer: LexerType {

  private var index = 0
  private let tokens: [Token]

  internal init(tokens: [Token]) {
    self.tokens = tokens
  }

  internal mutating func getToken() throws -> Token {
    if self.index == self.tokens.count {
      return self.tokens[tokens.count - 1]
    }

    let token = self.tokens[self.index]
    self.index += 1
    return token
  }
}
