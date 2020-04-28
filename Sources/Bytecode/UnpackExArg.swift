public struct UnpackExArg {

  public let value: Int

  public var countBefore: Int {
    return self.value & 0xff
  }

  public var countAfter: Int {
    return self.value >> 8
  }

  public init(value: Int) {
    self.value = value
  }

  public init(countBefore: Int, countAfter: Int) {
    precondition(0 <= countBefore && countBefore <= 0xff)
    precondition(0 <= countAfter && countAfter <= 0xff_ffff)
    self.value = countAfter << 8 | countBefore
  }
}
