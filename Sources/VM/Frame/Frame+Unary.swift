import Bytecode

extension Frame {

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() throws {
    self.unimplemented()
  }

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() throws {
    self.unimplemented()
  }

  /// Implements `TOS = not TOS`.
  internal func unaryNot() throws {
    self.unimplemented()
  }

  /// Implements `TOS = ~TOS`.
  internal func unaryInvert() throws {
    self.unimplemented()
  }
}
