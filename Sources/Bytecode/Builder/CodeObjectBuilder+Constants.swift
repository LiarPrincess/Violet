import Foundation
import BigInt
import VioletCore

extension CodeObjectBuilder {

  /// Append a `loadConst(True)` instruction to this code object.
  public func appendTrue() {
    if let index = self.cache.true {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.true)
      self.cache.true = index
    }
  }

  /// Append a `loadConst(False)` instruction to this code object.
  public func appendFalse() {
    if let index = self.cache.false {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.false)
      self.cache.false = index
    }
  }

  /// Append a `loadConst(None)` instruction to this code object.
  public func appendNone() {
    if let index = self.cache.none {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.none)
      self.cache.none = index
    }
  }

  /// Append a `loadConst(Ellipsis)` instruction to this code object.
  public func appendEllipsis() {
    if let index = self.cache.ellipsis {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.ellipsis)
      self.cache.ellipsis = index
    }
  }

  /// Append a `loadConst(Integer)` instruction to this code object.
  public func appendInteger(_ value: BigInt) {
    if value == 0 {
      if let index = self.cache.zero {
        self.appendExistingConstant(index: index)
      } else {
        let index = self.appendNewConstant(.integer(value))
        self.cache.zero = index
      }
    } else if value == 1 {
      if let index = self.cache.one {
        self.appendExistingConstant(index: index)
      } else {
        let index = self.appendNewConstant(.integer(value))
        self.cache.one = index
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
    let key = UseScalarsToHashString(s)

    if let index = self.cache.constantStrings[key] {
      self.appendExistingConstant(index: index)
    } else {
      let index = self.appendNewConstant(.string(s))
      self.cache.constantStrings[key] = index
    }
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendBytes(_ value: Data) {
    _ = self.appendNewConstant(.bytes(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendTuple(_ value: [CodeObject.Constant]) {
    _ = self.appendNewConstant(.tuple(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendCode(_ value: CodeObject) {
    _ = self.appendNewConstant(.code(value))
  }

  // MARK: - Add

  /// Simply add new constant, without emitting any instruction.
  public func addConstant(string: String) {
    let constant = CodeObject.Constant.string(string)
    self.code.constants.append(constant)
  }

  // MARK: - Helpers

  private func appendNewConstant(_ constant: CodeObject.Constant) -> Int {
    let index = self.code.constants.endIndex
    self.code.constants.append(constant)

    self.appendExistingConstant(index: index)
    return index
  }

  private func appendExistingConstant(index: Int) {
    let arg = self.appendExtendedArgIfNeeded(index)
    self.append(.loadConst(index: arg))
  }
}
