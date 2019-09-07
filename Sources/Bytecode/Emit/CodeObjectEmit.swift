import Core

// Internal helpers for all of the 'emit' functions.
extension CodeObject {

  // MARK: - Emit

  // This function does not throw, but we will mark it as one for the future.
  // Also some of the 'emit' functions throw and it would be weird to use 'try'
  // only on some of the functions in api.
  internal func emit(_ instruction: Instruction,
                     location: SourceLocation) throws {
    self.instructions.append(instruction)

    let lastLine = self.instructionLines.last ?? SourceLocation.start.line
    self.instructionLines.append(max(lastLine, location.line))

    assert(self.instructions.count == self.instructionLines.count)
  }

  // MARK: - Label

  public func addLabel() -> Label {
    let index = self.labels.endIndex
    self.labels.append(Label.notAssigned)
    return Label(index: index)
  }

  public func setLabel(_ label: Label) {
    assert(label.index < self.labels.count)
    assert(self.labels[label.index] == Label.notAssigned)

    let jumpTarget = self.instructions.endIndex
    self.labels[label.index] = jumpTarget
  }

  // MARK: - Extended arg

  internal func addNameWithExtendedArgIfNeeded<S: ConstantString>(
    name: S,
    location: SourceLocation) throws -> UInt8 {

    let rawIndex = self.names.endIndex
    let index = try self.emitExtendedArgIfNeeded(rawIndex, location: location)
    self.names.append(name.constant)
    return index
  }

  internal func emitLabelWithExtendedArgIfNeeded(
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
      throw self.error(.instructionArgumentTooBig, location: location)
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
  internal func error(_ kind: CodeObjectErrorKind,
                      location: SourceLocation) -> CodeObjectError {
    return CodeObjectError(kind, location: location)
  }

  // MARK: - Unimplemented

  internal func unimplemented() -> Error {
    // TODO: remove this
    return NotImplemented.pep401
  }
}
