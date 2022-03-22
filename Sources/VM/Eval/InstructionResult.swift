/* MARKER
import VioletObjects

/// Result of running of a single instruction.
internal enum InstructionResult {
  /// Instruction executed successfully.
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
  internal static func `continue`(loopStartLabelIndex: Int) -> InstructionResult {
    return .unwind(.continue(loopStartLabelIndex: loopStartLabelIndex))
  }

  /// `UnwindReason.exception`
  internal static func exception(
    _ value: PyBaseException,
    fillTracebackAndContext fill: Bool = true
  ) -> InstructionResult {
    return .unwind(.exception(value, fillTracebackAndContext: fill))
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

*/