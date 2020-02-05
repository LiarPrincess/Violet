import Objects
import Bytecode

private let isEnabled = true

extension Frame {

  internal func instructionDebug(instruction: Instruction,
                                 extendedArg: Int) {
    guard isEnabled else { return }
    print(self.code.dumpInstruction(instruction, extendedArg: extendedArg))
  }

  internal func callFunctionDebug(fn: PyObject,
                                  args: [PyObject],
                                  kwargs: PyDictData?,
                                  result: CallResult) {
    guard isEnabled else { return }
    print("  fn:", fn)
    print("  args:", args)
    print("  result:", result)
  }

  internal func loadMethodDebug(method: PyObject) {
    guard isEnabled else { return }
    print("  method:", method)
  }

  internal func callMethodDebug(method: PyObject,
                                args: [PyObject],
                                result: CallResult) {
    guard isEnabled else { return }
    print("  method:", method)
    print("  args:", args)
    print("  result:", result)
  }
}
