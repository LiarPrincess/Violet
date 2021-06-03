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
  public internal(set) var labels = [Int]()

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

    self.cache = CodeObjectBuilderCache(constants: [],
                                        names: [],
                                        variableNames: variableNames,
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
    let hasAllAssigned = self.labels.allSatisfy {
      $0 != CodeObject.Label.notAssigned
    }

    precondition(hasAllAssigned, "One of the code object labels is not assigned!")
  }

  // MARK: - Append

  internal func append(_ instruction: Instruction) {
    self.instructions.append(instruction)

    var line = self.appendLocation.line
    if let lastLine = self.instructionLines.last, lastLine > line {
      // We have to check this, because there may be some other builder
      // working on the same CodeObject.
      line = lastLine
    }

    self.instructionLines.append(line)
    assert(self.instructions.count == self.instructionLines.count)
  }

  /// Set location on which next `append` occurs.
  public func setAppendLocation(_ location: SourceLocation) {
    self.appendLocation = location
  }

  // MARK: - Label

  /// Creates new label (jump target) with invalid value.
  /// Use `self.setLabel()` to assign proper value.
  public func createLabel() -> CodeObject.Label {
    let index = self.labels.endIndex
    self.labels.append(CodeObject.Label.notAssigned)
    return CodeObject.Label(index: index)
  }

  /// Set label to next emitted instruction.
  public func setLabel(_ label: CodeObject.Label) {
    assert(label.index < self.labels.count)
    assert(self.labels[label.index] == CodeObject.Label.notAssigned)

    let jumpTarget = self.instructions.endIndex
    self.labels[label.index] = jumpTarget
  }

  // MARK: - Add name

  internal func addNameWithExtendedArgIfNeeded(name: String) -> UInt8 {
    let index = self.getNameIndex(name)
    return self.appendExtendedArgIfNeeded(index)
  }

  private func getNameIndex(_ name: String) -> Int {
    let key = UseScalarsToHashString(name)

    if let cachedIndex = self.cache.names[key] {
      return cachedIndex
    }

    let index = self.names.endIndex
    self.names.append(name)
    self.cache.names[key] = index
    return index
  }

  // MARK: - Add variable name

  internal func addVariableNameWithExtendedArgIfNeeded(
    name: MangledName
  ) -> UInt8 {
    let index = self.getVariableNameIndex(name)
    return self.appendExtendedArgIfNeeded(index)
  }

  private func getVariableNameIndex(_ name: MangledName) -> Int {
    if let cachedIndex = self.cache.variableNames[name] {
      return cachedIndex
    }

    self.missingVariable(name: name,
                         allowedNames: self.variableNames,
                         type: .variable)
  }

  private enum VariableType: String {
    case variable = "variable"
    case cell = "cell variable"
    case free = "free variable"
  }

  private func missingVariable(name: MangledName,
                               allowedNames: [MangledName],
                               type: VariableType) -> Never {
    let codeName = self.qualifiedName
    var msg = "Code object '\(codeName)' does not contain \(type.rawValue) '\(name)'"

    if allowedNames.any {
      let names = allowedNames.map { $0.value }.joined(separator: ", ")
      msg += ". Only one of the following names is allowed: \(names)."
    } else {
      msg += " (in fact it contains no such variables)."
    }

    trap(msg)
  }

  // MARK: - Add free variable name

  internal func addFreeVariableNameWithExtendedArgIfNeeded(
    name: MangledName
  ) -> UInt8 {
    let index = self.getFreeVariableNameIndex(name)
    let realIndex = self.offsetFreeVariable(index: index)
    return self.appendExtendedArgIfNeeded(realIndex)
  }

  private func getFreeVariableNameIndex(_ name: MangledName) -> Int {
    if let cachedIndex = self.cache.freeVariableNames[name] {
      return cachedIndex
    }

    self.missingVariable(name: name,
                         allowedNames: self.freeVariableNames,
                         type: .free)
  }

  internal func offsetFreeVariable(index: Int) -> Int {
    // Int 'VM.Frame.cellsAndFreeVariables' we store cells first and then free.
    let offset = self.cellVariableNames.count
    return offset + index
  }

  // MARK: - Add cell variable name

  internal func addCellVariableNameWithExtendedArgIfNeeded(
    name: MangledName
  ) -> UInt8 {
    let index = self.getCellVariableNameIndex(name)
    return self.appendExtendedArgIfNeeded(index)
  }

  private func getCellVariableNameIndex(_ name: MangledName) -> Int {
    if let cachedIndex = self.cache.cellVariableNames[name] {
      return cachedIndex
    }

    self.missingVariable(name: name,
                         allowedNames: self.cellVariableNames,
                         type: .cell)
  }

  // MARK: - Add label

  internal func addLabelWithExtendedArgIfNeeded(_ label: CodeObject.Label) -> UInt8 {
    return self.appendExtendedArgIfNeeded(label.index)
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
