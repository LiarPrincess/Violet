import Objects
import Bytecode

private let isEnabled = true

internal enum Debug {

  internal static func instruction(code: CodeObject,
                                   instruction: Instruction,
                                   extendedArg: Int) {
    guard isEnabled else { return }
    print(code.dumpInstruction(instruction, extendedArg: extendedArg))
  }

  // MARK: - Function/method

  internal static func callFunction(fn: PyObject,
                                    args: [PyObject],
                                    kwargs: PyDictData?,
                                    result: CallResult) {
    guard isEnabled else { return }
    print("  fn:", fn)
    print("  args:", args)
    print("  result:", result)
  }

  internal static func loadMethod(method: PyObject) {
    guard isEnabled else { return }
    print("  method:", method)
  }

  internal static func callMethod(method: PyObject,
                                  args: [PyObject],
                                  result: CallResult) {
    guard isEnabled else { return }
    print("  method:", method)
    print("  args:", args)
    print("  result:", result)
  }

  // MARK: - Block

  internal static func push(block: Block) {
    guard isEnabled else { return }
    print("  push block:", block)
  }

  internal static func pop(block: Block?) {
    guard isEnabled else { return }
    let s = block.map(String.init(describing:)) ?? "nil"
    print("  pop block:", s)
  }
}
