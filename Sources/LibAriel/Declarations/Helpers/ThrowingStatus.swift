import SwiftSyntax

public enum ThrowingStatus {

  case `throws`
  case `rethrows`

  internal init(_ node: TokenSyntax) {
    let text = node.text.trimmed

    switch text {
    case "throws":
      self = .throws
    case "rethrows":
      self = .rethrows
    default:
      trap("Unknown throwing status: '\(text)'")
    }
  }
}
