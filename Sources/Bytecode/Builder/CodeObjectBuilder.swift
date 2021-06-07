import VioletCore

/// Helper for adding new instructions to `CodeObject`.
/// It will store reference to `codeObject`,
/// it is acceptable to have multiple builders to a single `CodeObject`.
public final class CodeObjectBuilder {

  public let name: String
  public let qualifiedName: String
  public let filename: String
  public let kind: CodeObject.Kind
  public let flags: CodeObject.Flags
  public let variableNames: [MangledName]
  public let freeVariableNames: [MangledName]
  public let cellVariableNames: [MangledName]
  public let argCount: Int
  public let kwOnlyArgCount: Int
  public let firstLine: SourceLine

  public internal(set) var instructions = [Instruction]()
  public internal(set) var instructionLines = [SourceLine]()
  public internal(set) var constants = [CodeObject.Constant]()
  public internal(set) var names = [String]()
  public internal(set) var labels = [CodeObject.Label]()

  /// Location on which next `append` occurs.
  private var appendLocation = SourceLocation.start

  /// Indices of already added constants (so that we don't store duplicates).
  internal var cache: CodeObjectBuilderCache

  public init(name: String,
              qualifiedName: String,
              filename: String,
              kind: CodeObject.Kind,
              flags: CodeObject.Flags,
              variableNames: [MangledName],
              freeVariableNames: [MangledName],
              cellVariableNames: [MangledName],
              argCount: Int,
              kwOnlyArgCount: Int,
              firstLine: SourceLine) {
    self.name = name
    self.qualifiedName = qualifiedName
    self.filename = filename
    self.kind = kind
    self.flags = flags
    self.variableNames = variableNames
    self.freeVariableNames = freeVariableNames
    self.cellVariableNames = cellVariableNames
    self.argCount = argCount
    self.kwOnlyArgCount = kwOnlyArgCount
    self.firstLine = firstLine

    self.cache = CodeObjectBuilderCache(variableNames: variableNames,
                                        freeVariableNames: freeVariableNames,
                                        cellVariableNames: cellVariableNames)
  }

  // MARK: - Finalize

  /// Create `CodeObject`.
  ///
  /// Read as `finalize` if you like tea.
  public func finalize() -> CodeObject {
    self.assertAllLabelsAssigned()

    return CodeObject(name: self.name,
                      qualifiedName: self.qualifiedName,
                      filename: self.filename,
                      kind: self.kind,
                      flags: self.flags,
                      firstLine: self.firstLine,
                      instructions: self.instructions,
                      instructionLines: self.instructionLines,
                      constants: self.constants,
                      names: self.names,
                      labels: self.labels,
                      variableNames: self.variableNames,
                      freeVariableNames: self.freeVariableNames,
                      cellVariableNames: self.cellVariableNames,
                      argCount: self.argCount,
                      kwOnlyArgCount: self.kwOnlyArgCount)
  }

  private func assertAllLabelsAssigned() {
    let allAssigned = self.labels.allSatisfy { $0.isAssigned }
    precondition(allAssigned, "One of the code object labels is not assigned!")
  }

  // MARK: - Append

  internal func append(_ instruction: Instruction) {
    let line = self.appendLocation.line
    self.instructions.append(instruction)
    self.instructionLines.append(line)
    assert(self.instructions.count == self.instructionLines.count)
  }

  /// Set location on which next `append` occurs.
  public func setAppendLocation(_ location: SourceLocation) {
    self.appendLocation = location
  }

  // MARK: - Label

  public struct NotAssignedLabel {
    /// Index of the label that we will set later.
    fileprivate let labelIndex: Int
  }

  /// Creates new label (jump target) with invalid value.
  /// Use `self.setLabel()` to assign proper value.
  public func createLabel() -> NotAssignedLabel {
    let index = self.labels.endIndex
    self.labels.append(CodeObject.Label.notAssigned)
    return NotAssignedLabel(labelIndex: index)
  }

  /// Set label to the next emitted instruction.
  public func setLabel(_ notAssigned: NotAssignedLabel) {
    let labelIndex = notAssigned.labelIndex
    assert(labelIndex < self.labels.count)
    assert(self.labels[labelIndex] == CodeObject.Label.notAssigned)

    let jumpAddress = self.instructions.endIndex
    self.labels[labelIndex] = CodeObject.Label(jumpAddress: jumpAddress)
  }

  /// Use when using label (from `self.labels`) index as instruction arg.
  internal func appendExtendedArgsForLabelIndex(
    _ notAssigned: NotAssignedLabel
  ) -> UInt8 {
    return self.appendExtendedArgIfNeeded(notAssigned.labelIndex)
  }

  // MARK: - Name

  /// Use when using name index as instruction arg.
  /// If the name was not previously used then it will be added.
  internal func appendExtendedArgsForNameIndex(name: String) -> UInt8 {
    let index: Int = {
      let cacheKey = UseScalarsToHashString(name)

      if let cachedIndex = self.cache.names[cacheKey] {
        return cachedIndex
      }

      let index = self.names.endIndex
      self.names.append(name)
      self.cache.names[cacheKey] = index
      return index
    }()

    return self.appendExtendedArgIfNeeded(index)
  }

  // MARK: - Variable/Cell/Free names

  /// Use when using variable name (from `self.variableNames`) index
  /// as instruction arg.
  internal func appendExtendedArgsForVariableNameIndex(
    name: MangledName
  ) -> UInt8 {
    if let index = self.cache.variableNames[name] {
      return self.appendExtendedArgIfNeeded(index)
    }

    self.trapMissingVariableName(name: name, type: .variable)
  }

  /// Use when using cell name (from `self.cellVariableNames`) index
  /// as instruction arg.
  internal func appendExtendedArgsForCellVariableNameIndex(
    name: MangledName
  ) -> UInt8 {
    if let index = self.cache.cellVariableNames[name] {
      return self.appendExtendedArgIfNeeded(index)
    }

    self.trapMissingVariableName(name: name, type: .cell)
  }

  /// Use when using free name (from `self.freeVariableNames`) index
  /// as instruction arg.
  internal func appendExtendedArgsForFreeVariableNameIndex(
    name: MangledName
  ) -> UInt8 {
    if let index = self.cache.freeVariableNames[name] {
      let realIndex = self.offsetFreeVariable(index: index)
      return self.appendExtendedArgIfNeeded(realIndex)
    }

    self.trapMissingVariableName(name: name, type: .free)
  }

  // Int 'VM.Frame.cellsAndFreeVariables' we store cells first and then free.
  internal func offsetFreeVariable(index: Int) -> Int {
    let offset = self.cellVariableNames.count
    return offset + index
  }

  private enum VariableType: String {
    case variable = "variable"
    case cell = "cell variable"
    case free = "free variable"
  }

  private func trapMissingVariableName(name: MangledName,
                                       type: VariableType) -> Never {
    let allowedNames: [MangledName]
    switch type {
    case .variable: allowedNames = self.variableNames
    case .cell: allowedNames = self.cellVariableNames
    case .free: allowedNames = self.freeVariableNames
    }

    let codeName = self.qualifiedName
    let typeName = type.rawValue
    var msg = "Code object '\(codeName)' does not contain \(typeName) '\(name)'"

    if allowedNames.any {
      let names = allowedNames.map { $0.value }.joined(separator: ", ")
      msg += ". Only one of the following names is allowed: \(names)."
    } else {
      msg += " (in fact it contains no such variables)."
    }

    trap(msg)
  }

  // MARK: - Extended arg

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
  internal func appendExtendedArgIfNeeded(_ arg: Int) -> UInt8 {
    assert(arg >= 0)
    if arg > Instruction.maxExtendedArgument3 {
      trap(
        "Cannot create instruction with argument greater than " +
        "'\(Instruction.maxExtendedArgument3)' (at \(self.appendLocation))."
      )
    }

    let ffMask = 0xff

    var shift = 24
    var mask = ffMask << shift
    var value = UInt8((arg & mask) >> shift)

    let emit1 = value > 0
    if emit1 {
      self.appendExtendedArg(value: value)
    }

    shift = 16
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit2 = emit1 || value > 0
    if emit2 {
      self.appendExtendedArg(value: value)
    }

    shift = 8
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit3 = emit2 || value > 0
    if emit3 {
      self.appendExtendedArg(value: value)
    }

    return UInt8(arg & ffMask)
  }
}
