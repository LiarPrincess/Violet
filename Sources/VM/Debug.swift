import Parser
import Objects
import Bytecode

#if DEBUG
/// Change this if you feel like it.
/// You have a whole 2 options to choose from, so go wild
/// (and rememeber to wash your hands after, also floss).
private let isEnabled = true
#else
/// Do not change this.
/// It will be inlined to all of the functions making them nops,
/// which will optimize away the whole call (probably).
private let isEnabled = false
#endif

internal enum Debug {

  // MARK: - Parser, compiler

  internal static func ast(_ ast: AST) {
    guard isEnabled else { return }
//    print("=== AST ===")
//    print(ast)
//    print()
  }

  internal static func code(_ code: PyCode) {
    guard isEnabled else { return }

    let qualifiedName = code.qualifiedName.value
    let title = qualifiedName.isEmpty ? "(no name)" : qualifiedName

    print("=== \(title) ===")
    print(code.dump())

    for case Objects.Constant.code(let inner) in code.constants {
      Debug.code(inner)
    }
  }

  // MARK: - Frame

  internal static func instruction(code: PyCode,
                                   instructionIndex: Int,
                                   extendedArg: Int) {
    guard isEnabled else { return }
    let instruction = code.instructions[instructionIndex]

    let byte = instructionIndex * Instruction.byteSize
    let dump = code.dumpInstruction(instruction, extendedArg: extendedArg)
    print("\(byte): \(dump)")
  }

  internal static func frameStart(frame: PyFrame) {
    guard isEnabled else { return }
    print("--- Frame start: \(frame.code.name.value) ---")
  }

  internal static func frameEnd(frame: PyFrame) {
    guard isEnabled else { return }
    print("--- Frame end: \(frame.code.name.value) ---")
  }

  internal static func stack(stack: ObjectStack) {
    guard isEnabled else { return }

    if stack.isEmpty {
      print("  Stack: (empty)")
      return
    }

    print("  Stack:")
    for index in 0..<stack.count {
      let peekIndex = stack.count - index - 1
      let value = stack.peek(peekIndex)
      print("    \(value)")
    }
  }

  internal static func stack(stack: BlockStack) {
    guard isEnabled else { return }

    if stack.isEmpty {
      print("  Blocks: (empty)")
      return
    }

    print("  Blocks:")
    for index in 0..<stack.count {
      let peekIndex = stack.count - index - 1
      let value = stack.peek(peekIndex)
      print("    \(value)")
    }
  }

  // MARK: - Compare

  internal static func compare(a: PyObject,
                               b: PyObject,
                               op: ComparisonOpcode,
                               result: PyResult<PyObject>) {
    guard isEnabled else { return }
    print("  a:", a)
    print("  b:", b)
    print("  op:", op)
    print("  result:", result)
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

  internal static func loadMethod(method: GetMethodResult) {
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
