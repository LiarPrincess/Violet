import VioletCore

// cSpell:ignore finalise

/// Helper for adding new instructions to `CodeObject`.
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
  public let posOnlyArgCount: Int
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
              posOnlyArgCount: Int,
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
    self.posOnlyArgCount = posOnlyArgCount
    self.kwOnlyArgCount = kwOnlyArgCount
    self.firstLine = firstLine

    self.cache = CodeObjectBuilderCache(variableNames: variableNames,
                                        freeVariableNames: freeVariableNames,
                                        cellVariableNames: cellVariableNames)
  }

  // MARK: - Finalize

  /// Create `CodeObject`.
  ///
  /// Read as `finalise` if you like tea.
  public func finalize() -> CodeObject {
    return self.finalize(usePeepholeOptimizer: true)
  }

  /// Create `CodeObject`.
  ///
  /// Read as `finalise` if you like tea.
  ///
  /// `usePeepholeOptimizer = false` is for tests (and only for those that do
  ///  require it, most of the time we do want optimizations).
  internal func finalize(usePeepholeOptimizer: Bool) -> CodeObject {
    // swiftlint:disable:previous function_body_length

    self.assertAllLabelsAssigned()

    var instructions = self.instructions
    var instructionLines = self.instructionLines
    var constants = self.constants
    var labels = self.labels

    if usePeepholeOptimizer {
      let optimizer = PeepholeOptimizer(instructions: self.instructions,
                                        instructionLines: self.instructionLines,
                                        constants: self.constants,
                                        labels: self.labels)

      let result = optimizer.run()
      instructions = result.instructions
      instructionLines = result.instructionLines
      constants = result.constants
      labels = result.labels
    }

    return CodeObject(name: self.name,
                      qualifiedName: self.qualifiedName,
                      filename: self.filename,
                      kind: self.kind,
                      flags: self.flags,
                      firstLine: self.firstLine,
                      instructions: instructions,
                      instructionLines: instructionLines,
                      constants: constants,
                      names: self.names,
                      labels: labels,
                      variableNames: self.variableNames,
                      freeVariableNames: self.freeVariableNames,
                      cellVariableNames: self.cellVariableNames,
                      argCount: self.argCount,
                      posOnlyArgCount: self.posOnlyArgCount,
                      kwOnlyArgCount: self.kwOnlyArgCount)
  }

  private func assertAllLabelsAssigned() {
    let allAssigned = self.labels.allSatisfy { $0.isAssigned }
    precondition(allAssigned, "One of the code object labels was not assigned!")
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

    let jumpTarget = self.instructions.endIndex
    self.labels[labelIndex] = CodeObject.Label(instructionIndex: jumpTarget)
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
      return self.appendExtendedArgIfNeeded(index)
    }

    self.trapMissingVariableName(name: name, type: .free)
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
    let split = Self.splitExtendedArg(arg)

    if let arg = split.extendedArg0 {
      self.appendExtendedArg(value: arg)
    }

    if let arg = split.extendedArg1 {
      self.appendExtendedArg(value: arg)
    }

    if let arg = split.extendedArg2 {
      self.appendExtendedArg(value: arg)
    }

    return split.instructionArg
  }

  internal struct ExtendedArgSplit {
    /// 1st extended arg to emit.
    internal let extendedArg0: UInt8?
    /// 2nd extended arg to emit.
    internal let extendedArg1: UInt8?
    /// 3rd extended arg to emit.
    internal let extendedArg2: UInt8?
    /// Arg to put inside of the instruction.
    internal let instructionArg: UInt8

    /// Number of instructions to emit.
    internal var count: Int {
      if self.extendedArg0 != nil { return 4 }
      if self.extendedArg1 != nil { return 3 }
      if self.extendedArg2 != nil { return 2 }
      return 1
    }
  }

  internal static func splitExtendedArg(_ arg: Int) -> ExtendedArgSplit {
    assert(arg >= 0)
    if arg > Instruction.maxExtendedArgument3 {
      trap(
        "Cannot create instruction with argument greater than " +
        "'\(Instruction.maxExtendedArgument3)'."
      )
    }

    // 1. extendedArg: 0xfa
    // 2. extendedArg: 0xfb
    // 3. extendedArg: 0xfc
    // 4. instruction: 0xf0
    //
    // Gives us:
    // |No.|Base    |Calculation         |Result    |
    // |1. |       0|       0 << 8 | 0xfa|      0xfa|
    // |2. |    0xfa|    0xfa << 8 | 0xfb|    0xfafb|
    // |3. |  0xfafb|  0xfa fb<< 8 | 0xfc|  0xfafbfc|
    // |4. |0xfafbfc|0xfafbfc << 8 | 0xf0|0xfafbfcf0|

    let ff = Int(UInt8.max)
    let argWidth = UInt8.bitWidth

    let arg0Int = (arg >> (3 * argWidth)) & ff
    let hasArg0 = arg0Int != 0
    let arg0 = hasArg0 ? UInt8(arg0Int) : nil

    let arg1Int = (arg >> (2 * argWidth)) & ff
    let hasArg1 = hasArg0 || arg1Int != 0
    let arg1 = hasArg1 ? UInt8(arg1Int) : nil

    let arg2Int = (arg >> (1 * argWidth)) & ff
    let hasArg2 = hasArg1 || arg2Int != 0
    let arg2 = hasArg2 ? UInt8(arg2Int) : nil

    let instructionArg = UInt8(arg & ff)

    return ExtendedArgSplit(extendedArg0: arg0,
                            extendedArg1: arg1,
                            extendedArg2: arg2,
                            instructionArg: instructionArg)
  }
}
