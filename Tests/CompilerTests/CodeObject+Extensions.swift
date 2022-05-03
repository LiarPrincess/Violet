import XCTest
import BigInt
import VioletCore
import VioletLexer
import VioletParser
@testable import VioletBytecode
@testable import VioletCompiler

// MARK: - CodeObject + any

extension CodeObject {

  private static let anyName = "__ANY_CODE_OBJECT_NAME__"

  /// Use this code object when you need *any* code object without specific
  /// property values.
  static let any: CodeObject = {
    let builder = CodeObjectBuilder(name: CodeObject.anyName,
                                    qualifiedName: CodeObject.anyName,
                                    filename: "",
                                    kind: .module,
                                    flags: CodeObject.Flags(),
                                    variableNames: [],
                                    freeVariableNames: [],
                                    cellVariableNames: [],
                                    argCount: 0,
                                    posOnlyArgCount: 0,
                                    kwOnlyArgCount: 0,
                                    firstLine: 0)

    return builder.finalize()
  }()

  // Is this *any* code object without any specific property requirements?
  var isAny: Bool {
    return self.name == CodeObject.anyName
  }
}

// MARK: - CodeObject + getAllFilledInstructions

extension CodeObject {

  func getAllFilledInstructions(file: StaticString = #file,
                                line: UInt = #line) -> [Instruction.Filled] {
    if self.instructions.isEmpty {
      return []
    }

    var result = [Instruction.Filled]()

    var instructionIndex: Int? = 0
    while let index = instructionIndex {
      let filled = self.getFilledInstruction(index: index)
      result.append(filled.instruction)
      instructionIndex = filled.nextInstructionIndex

      let maxInstructionCount = 100
      if result.count > maxInstructionCount {
        XCTFail("More than \(maxInstructionCount) instructions (probably error)",
                file: file,
                line: line)
        return []
      }
    }

    return result
  }
}

// MARK: - CodeObject + getChildCodeObject

extension CodeObject {

  func getChildCodeObject(atIndex index: Int,
                          file: StaticString = #file,
                          line: UInt = #line) -> CodeObject? {
    var currentIndex = 0

    for constant in self.constants {
      switch constant {
      case .code(let c):
        if currentIndex == index {
          return c
        }

        currentIndex += 1
      default:
        break
      }
    }

    let msg = currentIndex == 0 ?
      "No child code objects" :
      "Only \(currentIndex) available"

    XCTFail(msg, file: file, line: line)
    return nil
  }
}

// MARK: - Instruction.Filled + factory

extension Instruction.Filled {

  // MARK: Const

  static func loadConst(string value: String) -> Instruction.Filled {
    return .loadConst(.string(value))
  }

  static func loadConst(bytes value: Data) -> Instruction.Filled {
    return .loadConst(.bytes(value))
  }

  static func loadConst(integer value: Int) -> Instruction.Filled {
    return .loadConst(.integer(BigInt(value)))
  }

  static func loadConst(integer value: BigInt) -> Instruction.Filled {
    return .loadConst(.integer(value))
  }

  static func loadConst(float value: Double) -> Instruction.Filled {
    return .loadConst(.float(value))
  }

  static func loadConst(real: Double, imag: Double) -> Instruction.Filled {
    return .loadConst(.complex(real: real, imag: imag))
  }

  static func loadConst(codeObject: CodeObject) -> Instruction.Filled {
    return .loadConst(.code(codeObject))
  }

  static func loadConst(tuple elements: CodeObject.Constant...) -> Instruction.Filled {
    return .loadConst(.tuple(elements))
  }

  static func loadConst(tuple elements: [String]) -> Instruction.Filled {
    let elements = elements.map { CodeObject.Constant.string($0) }
    return .loadConst(.tuple(elements))
  }

  // MARK: Fast

  static func loadFast(variable: String) -> Instruction.Filled {
    return .loadFast(variable: MangledName(withoutClass: variable))
  }

  // MARK: Loops

  static func setupLoop(loopEndTarget: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: loopEndTarget)
    return .setupLoop(loopEndLabel: label)
  }

  static func forIter(ifEmptyTarget: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: ifEmptyTarget)
    return .forIter(ifEmptyLabel: label)
  }

  static func `continue`(loopStartTarget: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: loopStartTarget)
    return .continue(loopStartLabel: label)
  }

  // MARK: Try

  static func setupExcept(firstExceptTarget: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: firstExceptTarget)
    return .setupExcept(firstExceptLabel: label)
  }

  static func setupFinally(finallyStartTarget: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: finallyStartTarget)
    return .setupFinally(finallyStartLabel: label)
  }

  // MARK: With

  static func setupWith(afterBodyTarget: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: afterBodyTarget)
    return .setupWith(afterBodyLabel: label)
  }

  // MARK: Jumps

  static func jumpAbsolute(target: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: target)
    return .jumpAbsolute(label: label)
  }

  static func jumpIfTrueOrPop(target: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: target)
    return .jumpIfTrueOrPop(label: label)
  }

  static func jumpIfFalseOrPop(target: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: target)
    return .jumpIfFalseOrPop(label: label)
  }

  static func popJumpIfTrue(target: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: target)
    return .popJumpIfTrue(label: label)
  }

  static func popJumpIfFalse(target: Int) -> Instruction.Filled {
    let label = Self.toLabel(bytecodeIndex: target)
    return .popJumpIfFalse(label: label)
  }

  private static func toLabel(bytecodeIndex: Int) -> CodeObject.Label {
    let instructionIndex = bytecodeIndex / Instruction.byteSize
    return CodeObject.Label(instructionIndex: instructionIndex)
  }
}
