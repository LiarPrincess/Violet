extension BigIntHeap {

  // Source:
  // https://github.com/benrimmington/swift-numerics/blob/BigInt/Sources/BigIntModule/BigInt.swift
  internal init<T: BinaryFloatingPoint>(_ source: T) {
    precondition(
      source.isFinite,
      "\(type(of: source)) value cannot be converted to BigInt because it is either infinite or NaN"
    )

    if source.isZero {
      self.init()
      return
    }

    var float = source < .zero ? -source : source
    if float < 1.0 {
      self.init()
      return
    }

    self.init(minimumStorageCapacity: 4)

    let radix = T(sign: .plus, exponent: T.Exponent(Word.bitWidth), significand: 1)
    repeat {
      let word = Word(float.truncatingRemainder(dividingBy: radix))
      self.storage.append(word)
      float = (float / radix).rounded(.towardZero)
    } while !float.isZero

    if source < .zero {
      self.storage.isNegative = true
    }

    self.checkInvariants()
  }

  internal init?<T: BinaryFloatingPoint>(exactly source: T) {
    guard source.isFinite else {
      return nil
    }

    guard source == source.rounded(.towardZero) else {
      return nil
    }

    self.init(source)
  }
}
