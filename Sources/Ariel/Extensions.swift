import SwiftSyntax

extension String {

  /// Python calls this 'strip' they are wrong
  var trimmed: String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

extension Collection {

  /// Does the collection has any element?
  var hasAny: Bool {
    !self.isEmpty
  }
}

extension Syntax {

  func isToken(withText expectedText: String) -> Bool {
    guard let token = TokenSyntax(self) else {
      return false
    }

    let text = token.text.trimmed
    return text == expectedText
  }
}
