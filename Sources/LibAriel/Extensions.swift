import SwiftSyntax

extension String {

  /// Python calls this 'strip' they are wrong
  internal var trimmed: String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

extension Syntax {

  internal func isToken(withText expectedText: String) -> Bool {
    guard let token = TokenSyntax(self) else {
      return false
    }

    let text = token.text.trimmed
    return text == expectedText
  }
}
