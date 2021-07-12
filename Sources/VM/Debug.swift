import VioletParser
import VioletBytecode
import VioletObjects

#if DEBUG
/// Change this if you feel like it.
/// You have a whole 2 options to choose from, so go wild
/// (and remember to wash your hands after, also floss).
private let isEnabled = false
#endif

/// Printing various things (to help with debugging)
internal enum Debug {

  // MARK: - Parser, compiler

  internal static func ast(_ ast: AST) {
    #if DEBUG
    guard isEnabled else { return }
    print("=== AST ===")
    print(ast)
    print()
    #endif
  }

  internal static func code(_ code: PyCode) {
    #if DEBUG
    guard isEnabled else { return }

    let qualifiedName = code.qualifiedName.value
    let title = qualifiedName.isEmpty ? "(no name)" : qualifiedName

    print("=== \(title) ===")
    print(code)

    for constant in code.constants {
      if let codeConstant = PyCast.asCode(constant) {
        Debug.code(codeConstant)
      }
    }
    #endif
  }

  // MARK: - Instruction

  internal static func instruction(code: PyCode,
                                   index: Int,
                                   extendedArg: Int) {
    #if DEBUG
    guard isEnabled else { return }
    let byte = index * Instruction.byteSize
    let dump = code.codeObject.getFilledInstruction(index: index)
    print("\(byte): \(dump)")
    #endif
  }

  // MARK: - Frame

  internal static func frameStart(frame: PyFrame) {
    #if DEBUG
    guard isEnabled else { return }
    print("--- Frame start: \(frame.code.name.value) ---")
    #endif
  }

  internal static func frameEnd(frame: PyFrame) {
    #if DEBUG
    guard isEnabled else { return }
    print("--- Frame end: \(frame.code.name.value) ---")
    #endif
  }

  // MARK: - Stack

  internal static func stack(stack: PyFrame.ObjectStack) {
    #if DEBUG
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
    #endif
  }

  // MARK: - Blocks

  internal static func stack(stack: PyFrame.BlockStack) {
    #if DEBUG
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
    #endif
  }

  internal static func push(block: PyFrame.Block) {
    #if DEBUG
    guard isEnabled else { return }
    print("  push block:", block)
    #endif
  }

  internal static func pop(block: PyFrame.Block?) {
    #if DEBUG
    guard isEnabled else { return }
    let s = block.map(String.init(describing:)) ?? "nil"
    print("  pop block:", s)
    #endif
  }

  // MARK: - Compare

  internal static func compare(type: Instruction.CompareType,
                               a: PyObject,
                               b: PyObject,
                               result: PyResult<PyObject>) {
    #if DEBUG
    guard isEnabled else { return }
    print("  type:", type)
    print("  a:", a)
    print("  b:", b)
    print("  result:", result)
    #endif
  }

  // MARK: - Function/method

  internal static func callFunction(fn: PyObject,
                                    args: [PyObject],
                                    kwargs: PyDict.OrderedDictionary?,
                                    result: PyInstance.CallResult) {
    #if DEBUG
    guard isEnabled else { return }
    print("  fn:", fn)
    print("  args:", args)
    if let kwargs = kwargs {
      print("  kwargs:", kwargs)
    }
    print("  result:", result)
    #endif
  }

  internal static func loadMethod(method: PyInstance.GetMethodResult) {
    #if DEBUG
    guard isEnabled else { return }
    print("  method:", method)
    #endif
  }

  internal static func callMethod(method: PyObject,
                                  args: [PyObject],
                                  result: PyInstance.CallResult) {
    #if DEBUG
    guard isEnabled else { return }
    print("  method:", method)
    print("  args:", args)
    print("  result:", result)
    #endif
  }
}
