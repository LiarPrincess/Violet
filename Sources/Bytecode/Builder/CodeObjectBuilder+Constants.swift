import Foundation
import Core

extension CodeObjectBuilder {

  /// Append a `loadConst(True)` instruction to this code object.
  public func appendTrue() {
    if let index = self.cachedIndices.true {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.true)
      self.cachedIndices.true = index
    }
  }

  /// Append a `loadConst(False)` instruction to this code object.
  public func appendFalse() {
    if let index = self.cachedIndices.false {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.false)
      self.cachedIndices.false = index
    }
  }

  /// Append a `loadConst(None)` instruction to this code object.
  public func appendNone() {
    if let index = self.cachedIndices.none {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.none)
      self.cachedIndices.none = index
    }
  }

  /// Append a `loadConst(Ellipsis)` instruction to this code object.
  public func appendEllipsis() {
    if let index = self.cachedIndices.ellipsis {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.ellipsis)
      self.cachedIndices.ellipsis = index
    }
  }

  /// Append a `loadConst(Integer)` instruction to this code object.
  public func appendInteger(_ value: BigInt) {
    if value == 0 {
      if let index = self.cachedIndices.zero {
        self.appendExistingConstant(index: index)
      } else {
        let index = self.appendNewConstant(.integer(value))
        self.cachedIndices.zero = index
      }
    } else if value == 1 {
      if let index = self.cachedIndices.one {
        self.appendExistingConstant(index: index)
      } else {
        let index = self.appendNewConstant(.integer(value))
        self.cachedIndices.one = index
      }
    } else {
      _ = self.appendNewConstant(.integer(value))
    }
  }

  /// Append a `loadConst(Float)` instruction to this code object.
  public func appendFloat(_ value: Double) {
    _ = self.appendNewConstant(.float(value))
  }

  /// Append a `loadConst(Complex)` instruction to this code object.
  public func appendComplex(real: Double, imag: Double) {
    _ = self.appendNewConstant(.complex(real: real, imag: imag))
  }

  /// Append a `loadConst(String)` instruction to this code object.
  public func appendString<S: ConstantString>(_ value: S) {

    let s = value.constant

    if let index = self.cachedIndices.strings[s] {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.string(s))
      self.cachedIndices.strings[s] = index
    }
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendBytes(_ value: Data) {
    _ = self.appendNewConstant(.bytes(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendTuple(_ value: [Constant]) {
    _ = self.appendNewConstant(.tuple(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendCode(_ value: CodeObject) {
    _ = self.appendNewConstant(.code(value))
  }

  // MARK: - Helpers

  private func appendNewConstant(_ constant: Constant) -> Int {
    let index = self.codeObject.constants.endIndex
    self.codeObject.constants.append(constant)

    self.appendExistingConstant(index: index)
    return index
  }

  private func appendExistingConstant(index: Int) {
    let arg = self.appendExtendedArgIfNeeded(index)
    self.append(.loadConst(index: arg))
  }
}
