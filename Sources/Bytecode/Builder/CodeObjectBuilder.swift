import Core

/// Indices of already added constants (so that we don't store duplicates).
internal struct CachedIndices {

  internal var `true`: Int?
  internal var `false`: Int?
  internal var none: Int?
  internal var ellipsis: Int?
  internal var zero: Int?
  internal var one: Int?
  /// Constant string
  internal var strings = [String:Int]()
  /// Names
  internal var names = [String:Int]()
}

/// Helper for adding new instructions to `CodeObject`.
/// It will store reference to `codeObject`,
/// it is acceptable to have multiple builders to a single `CodeObject`.
public class CodeObjectBuilder {

  /// `CodeObject` that we are adding instructions to.
  internal let codeObject: CodeObject

  /// Location on which next `append` occurs.
  private var appendLocation = SourceLocation.start

  /// Indices of already added constants (so that we don't store duplicates).
  internal var cachedIndices = CachedIndices()

  internal var instructions: [Instruction] {
    _read { yield self.codeObject.instructions }
    _modify { yield &self.codeObject.instructions }
  }

  internal var instructionLines: [SourceLine] {
    _read { yield self.codeObject.instructionLines }
    _modify { yield &self.codeObject.instructionLines }
  }

  public init(codeObject: CodeObject) {
    self.codeObject = codeObject
    self.fillCachedIndices()
  }

  private func fillCachedIndices() {
    for (index, constant) in self.codeObject.constants.enumerated() {
      switch constant {
      case .true:
        self.cachedIndices.true = index
      case .false:
        self.cachedIndices.false = index
      case .none:
        self.cachedIndices.none = index
      case .ellipsis:
        self.cachedIndices.ellipsis = index

      case let .string(s):
        self.cachedIndices.strings[s] = index

      case let .integer(i) where i.isZero:
        self.cachedIndices.zero = index
      case let .integer(i) where i.isOne:
        self.cachedIndices.one = index

      case .integer, .float, .complex, .bytes, .code, .tuple:
        break
      }
    }
  }

  // MARK: - Append

  // This function does not throw, but we will mark it as one for the future.
  // Also some of the 'append' functions throw
  // and it would be weird to use 'try' only on some of the functions in api.
  internal func append(_ instruction: Instruction) throws {
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
  public func createLabel() -> Label {
    let index = self.codeObject.labels.endIndex
    self.codeObject.labels.append(Label.notAssigned)
    return Label(index: index)
  }

  /// Set label to next emitted instruction.
  public func setLabel(_ label: Label) {
    assert(label.index < self.codeObject.labels.count)
    assert(self.codeObject.labels[label.index] == Label.notAssigned)

    let jumpTarget = self.instructions.endIndex
    self.codeObject.labels[label.index] = jumpTarget
  }

  // MARK: - Extended arg

  internal func addNameWithExtendedArgIfNeeded<S: ConstantString>(name: S) throws -> UInt8 {
    let c = name.constant

    // If this name was already used then reuse this index.
    let index = self.cachedIndices.names[c] ?? self.codeObject.names.endIndex
    let arg = try self.appendExtendedArgIfNeeded(index)
    self.codeObject.names.append(c)
    return arg
  }

  internal func addLabelWithExtendedArgIfNeeded(_ label: Label) throws -> UInt8 {
    return try self.appendExtendedArgIfNeeded(label.index)
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
  internal func appendExtendedArgIfNeeded(_ arg: Int) throws -> UInt8 {
    assert(arg >= 0)
    if arg > Instruction.maxArgument {
      throw self.error(.instructionArgumentTooBig, location: self.appendLocation)
    }

    let ffMask = 0xff

    var shift = 24
    var mask = ffMask << shift
    var value = UInt8((arg & mask) >> shift)

    let emit1 = value > 0
    if emit1 {
      try self.append(.extendedArg(value))
    }

    shift = 16
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit2 = emit1 || value > 0
    if emit2 {
      try self.append(.extendedArg(value))
    }

    shift = 8
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit3 = emit2 || value > 0
    if emit3 {
      try self.append(.extendedArg(value))
    }

    return UInt8(arg & ffMask)
  }

  // MARK: - Error

  /// Create code object error
  internal func error(_ kind: CodeObjectErrorKind,
                      location: SourceLocation) -> CodeObjectError {
    return CodeObjectError(kind, location: location)
  }

  // MARK: - Unimplemented

  // TODO: remove this
  internal func unimplemented(fn: StaticString = #function) -> Error {
    return UnimplementedError(fn: fn)
  }
}

internal struct UnimplementedError: Error, CustomStringConvertible {

  private let fn: StaticString

  internal init(fn: StaticString) {
    self.fn = fn
  }

  internal var description: String {
    return "Unimplemented: " + self.fn.description
  }
}
