extension String {
  // This may be faster than native Swift implementation.
  public init(_ value: BigInt, radix: Int = 10, uppercase: Bool = false) {
    self = value.toString(radix: radix, uppercase: uppercase)
  }
}

extension BigInt {

  public var description: String {
    switch self.value {
    case let .smi(smi):
      return smi.description
    case let .heap(heap):
      return heap.description
    }
  }

  public var debugDescription: String {
    let value = String(self, radix: 10, uppercase: false)

    let storage: String = {
      switch self.value {
      case let .smi(smi):
        return smi.debugDescription
      case let .heap(heap):
        return heap.debugDescription
      }
    }()

    return "\(value) (storage: \(storage))"
  }

  // 'toString' because we Java now
  internal func toString(radix: Int, uppercase: Bool) -> String {
    precondition(2 <= radix && radix <= 36, "radix must be in range 2...36")
    switch self.value {
    case let .smi(smi):
      return smi.toString(radix: radix, uppercase: uppercase)
    case let .heap(heap):
      return heap.toString(radix: radix, uppercase: uppercase)
    }
  }
}
