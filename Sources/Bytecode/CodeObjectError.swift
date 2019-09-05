import Core

// MARK: - Error

public struct CodeObjectError: Error, Equatable {

  /// Type of the error.
  public let kind: CodeObjectErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public init(_ kind: CodeObjectErrorKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}

extension CodeObjectError: CustomStringConvertible {
  public var description: String {
    return "\(self.location): \(self.kind)"
  }
}

// MARK: - Kind

public enum CodeObjectErrorKind: Equatable {
  /// More than 'Instruction.maxArgument' objects in single code object
  case instructionArgumentTooBig
}
