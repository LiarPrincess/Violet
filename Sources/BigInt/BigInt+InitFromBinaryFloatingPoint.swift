extension BigInt {

  private typealias Word = BigIntHeap.Word

  public init<T: BinaryFloatingPoint>(_ source: T) {
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

    var storage = BigIntStorage(minimumCapacity: 4)
    let token = storage.guaranteeUniqueBufferReference()

    let radix = T(sign: .plus, exponent: T.Exponent(Word.bitWidth), significand: 1)
    repeat {
      let word = Word(float.truncatingRemainder(dividingBy: radix))
      storage.appendWithPossibleGrow(token, element: word)
      float = (float / radix).rounded(.towardZero)
    } while !float.isZero

    if source < .zero {
      storage.setIsNegative(token, value: true)
    }

    storage.checkInvariants()
    let heap = BigIntHeap(storageWithValidInvariants: storage)
    self = BigInt(heap)
    self.downgradeToSmiIfPossible()
  }

  public init?<T: BinaryFloatingPoint>(exactly source: T) {
    guard source.isFinite else {
      return nil
    }

    guard source == source.rounded(.towardZero) else {
      return nil
    }

    self.init(source)
  }
}
