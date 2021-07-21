import VioletLexer

internal class FakeLexer: LexerType {

  private var index = 0
  private let tokens: [Token]

  internal init(tokens: [Token]) {
    self.tokens = tokens

    // Uncomment this for debug:
    // print("Starting with:")
    // for token in tokens {
    //   print("  ", token)
    // }
  }

  internal func getToken() throws -> Token {
    if self.index == self.tokens.count {
      let eofLocation = self.tokens.last?.end ?? loc0
      return Token(.eof, start: eofLocation, end: eofLocation)
    }

    let token = self.tokens[self.index]
    self.index += 1
    return token
  }
}
