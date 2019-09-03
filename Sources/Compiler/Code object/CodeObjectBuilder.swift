import Core
import Parser
import Bytecode

public struct CodeObjectBuilder {

  // MARK: - Code object

  private var _codeObject: CodeObject?

  /// Code object that we are currently filling.
  internal var codeObject: CodeObject {
    if let object = self._codeObject { return object }
    fatalError(
      "[BUG] CodeObjectBuilder: Using nil code object. " +
      "Use 'setInsertPoint' first."
    )
  }

  /// This specifies that created instructions should be appended to the
  /// end of the specified object.
  public mutating func setInsertPoint(_ codeObject: CodeObject) {
    self._codeObject = codeObject
  }

  // MARK: - Emit

  internal func emit(_ instruction: Instruction,
                     location: SourceLocation) throws {
    self.codeObject.instructions.append(instruction)
    self.codeObject.instructionLines.append(location.line)

    assert(self.codeObject.instructions.count
        == self.codeObject.instructionLines.count)
  }

  // MARK: - Label

  internal func addLabel() throws -> Label {
    let index = self.codeObject.labels.endIndex
    self.codeObject.labels.append(Label.notAssigned)
    return Label(index: index)
  }

  internal func setLabel(_ label: Label) {
    assert(label.index < self.codeObject.labels.count)
    assert(self.codeObject.labels[label.index] == Label.notAssigned)

    let jumpTarget = self.codeObject.instructions.endIndex
    self.codeObject.labels[label.index] = jumpTarget
  }

  // MARK: - Error

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind,
                      location: SourceLocation) -> CompilerError {
    return CompilerError(kind, location: location)
  }

  // MARK: - Unimplemented

  internal func unimplemented() -> Error {
    fatalError("CodeObjectBuilder.unimplemented")
  }
}
