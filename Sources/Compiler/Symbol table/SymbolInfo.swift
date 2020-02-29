import Core

public struct SymbolInfo: Equatable, CustomStringConvertible {

  /// Symbol information.
  public let flags: SymbolFlags

  /// Location of the first occurence of given symbol.
  public let location: SourceLocation

  public var description: String {
    return "SymbolInfo(flags: \(self.flags), location: \(self.location))"
  }
}
