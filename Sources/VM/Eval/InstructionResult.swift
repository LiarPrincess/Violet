import Objects

/// Result of running of a single instruction.
internal enum InstructionResult {
  /// Instruction executed succesfully.
  case ok
  /// Instruction requested stack unwind (`return`, `exception` etc.).
  case unwind(UnwindReason)

  /// `UnwindReason.return`
  internal static func `return`(_ value: PyObject) -> InstructionResult {
    return .unwind(.return(value))
  }
  /// `UnwindReason.break`
  internal static var `break`: InstructionResult {
    return .unwind(.break)
  }
  /// `UnwindReason.continue`
  internal static func `continue`(loopStartLabel: Int) -> InstructionResult {
    return .unwind(.continue(loopStartLabel: loopStartLabel))
  }
  /// `UnwindReason.exception`
  internal static func exception(_ value: PyBaseException) -> InstructionResult {
    return .unwind(.exception(value))
  }
  /// `UnwindReason.yield`
  internal static var yield: InstructionResult {
    return .unwind(.yield)
  }
  /// `UnwindReason.silenced`
  internal static var silenced: InstructionResult {
    return .unwind(.silenced)
  }
}
