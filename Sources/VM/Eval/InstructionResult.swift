/// Result of running of a single instruction.
internal enum InstructionResult {
  /// Instruction executed succesfully.
  case ok
  /// Instruction requested stack unwind (`return`, `exception` etc.).
  case unwind(UnwindReason)
}
