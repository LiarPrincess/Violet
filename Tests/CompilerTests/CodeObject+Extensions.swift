import XCTest
import BigInt
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// MARK: - CodeObject + any

extension CodeObject {

  static let anyName = "__ANY_CODE_OBJECT_NAME__"

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
                                    kwOnlyArgCount: 0,
                                    firstLine: 0)

    return builder.finalize()
  }()

  // Is this any code object without specific property requirements?
  var isAny: Bool {
    return self.name == CodeObject.anyName
  }
}

// MARK: - CodeObject + getAllFilledInstructions

extension CodeObject {

  func getAllFilledInstructions(file: StaticString,
                                line: UInt) -> [Instruction.Filled] {
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

  static func loadConst(_ value: String) -> Instruction.Filled {
    return .loadConst(.string(value))
  }

  static func loadConst(_ value: Data) -> Instruction.Filled {
    return .loadConst(.bytes(value))
  }

  static func loadConst(_ value: Int) -> Instruction.Filled {
    return .loadConst(.integer(BigInt(value)))
  }

  static func loadConst(_ value: BigInt) -> Instruction.Filled {
    return .loadConst(.integer(value))
  }

  static func loadConst(_ value: Double) -> Instruction.Filled {
    return .loadConst(.float(value))
  }

  static func loadConst(real: Double, imag: Double) -> Instruction.Filled {
    return .loadConst(.complex(real: real, imag: imag))
  }

  static func loadConst(codeObject: CodeObject) -> Instruction.Filled {
    return .loadConst(.code(codeObject))
  }

  static func loadConst(tuple elements: [String]) -> Instruction.Filled {
    let elements = elements.map { CodeObject.Constant.string($0) }
    return .loadConst(.tuple(elements))
  }

  static func loadFast(variable: String) -> Instruction.Filled {
    return .loadFast(variable: MangledName(withoutClass: variable))
  }
}
