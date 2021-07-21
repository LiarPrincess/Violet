import VioletBytecode

internal enum BlockType {
  case loop(continueTarget: CodeObjectBuilder.NotAssignedLabel)
  case except
  case finallyTry
  case finallyEnd

  internal var isLoop: Bool {
    switch self {
    case .loop: return true
    case .except,
         .finallyTry,
         .finallyEnd: return false
    }
  }
}
