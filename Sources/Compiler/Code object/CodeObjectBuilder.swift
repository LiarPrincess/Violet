import Core
import Parser
import Bytecode

// TODO: This should be an protocol (just as ASTBuilder)

/// Helper for creating new `CodeObjects`.
///
/// It is just a bunch of helper methods put thogether, which means
/// thet you can create multiple builders for a single `CodeObject`.
/// Builder will store a strong reference to `CodeObject` passed in `init`.
public struct CodeObjectBuilder {

  // MARK: - Code object

  /// Code object that we are currently filling.
  internal let codeObject: CodeObject

  public init(for codeObject: CodeObject) {
    self.codeObject = codeObject
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

  // MARK: - Extended arg

  internal func addNameWithExtendedArgIfNeeded(
    name: MangledName,
    location: SourceLocation) throws -> UInt8 {

    return try self.addNameWithExtendedArgIfNeeded(name: name.value,
                                                   location: location)
  }

  internal func addNameWithExtendedArgIfNeeded(
    name: String,
    location: SourceLocation) throws -> UInt8 {

    let rawIndex = self.codeObject.names.endIndex
    let index = try self.emitExtendedArgIfNeeded(rawIndex, location: location)
    self.codeObject.names.append(name)
    return index
  }

  internal func emitIndexWithExtendedArgIfNeeded(
    _ label: Label,
    location: SourceLocation) throws -> UInt8 {

    return try self.emitExtendedArgIfNeeded(label.index, location: location)
  }

  /// If the arg is `>255` then it can't be stored directly in instruction.
  /// In this case we have to emit `extendedArg` before it.
  ///
  /// Will use following masks:
  /// ```c
  /// 0xff000000 <- extended 1
  /// 0x00ff0000 <- extended 2
  /// 0x0000ff00 <- extended 3
  /// 0x000000ff <- instruction arg (return value)
  /// ```
  /// - Returns:
  /// Value that should be used in instruction.
  internal func emitExtendedArgIfNeeded(
    _ arg: Int,
    location: SourceLocation) throws -> UInt8 {

    // TODO: Test this

    assert(arg > 0)
    if arg > Instruction.maxArgument {
      fatalError()
    }

    let ffMask = 0xff

    var shift = 24
    var mask = ffMask << shift
    var value = UInt8((arg & mask) >> shift)

    let emit1 = value > 0
    if emit1 {
      try self.emit(.extendedArg(value), location: location)
    }

    shift = 16
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit2 = emit1 || value > 0
    if emit2 {
      try self.emit(.extendedArg(value), location: location)
    }

    shift = 8
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit3 = emit2 || value > 0
    if emit3 {
      try self.emit(.extendedArg(value), location: location)
    }

    return UInt8((arg & ffMask) >> shift)
  }

  // MARK: - Error

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind,
                      location: SourceLocation) -> CompilerError {
    return CompilerError(kind, location: location)
  }

  // MARK: - Unimplemented

//  @available(*, deprecated, message: "TODO")
  internal func unimplemented() -> Error {
    return NotImplemented.pep401
  }
}
