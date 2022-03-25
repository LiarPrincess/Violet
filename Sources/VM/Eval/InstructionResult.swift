import VioletObjects

/// Result of running of a single instruction.
internal enum InstructionResult {
  /// Instruction executed successfully.
  case ok
  /// Instruction requested stack unwind (`return`, `exception` etc.).
  case unwind(UnwindReason)

  /// `UnwindReason.return`
  internal static func `return`(_ object: PyObject) -> InstructionResult {
    let reason = UnwindReason.return(object)
    return .unwind(reason)
  }

  /// `UnwindReason.break`
  internal static var `break`: InstructionResult {
    return .unwind(.break)
  }

  /// `UnwindReason.continue`
  internal static func `continue`(loopStartLabelIndex: Int) -> InstructionResult {
    let reason = UnwindReason.continue(loopStartLabelIndex: loopStartLabelIndex)
    return .unwind(reason)
  }

  /// `UnwindReason.exception`
  internal static func exception(
    _ value: PyBaseException,
    fillTracebackAndContext fill: Bool = true
  ) -> InstructionResult {
    let reason = UnwindReason.exception(value, fillTracebackAndContext: fill)
    return .unwind(reason)
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
