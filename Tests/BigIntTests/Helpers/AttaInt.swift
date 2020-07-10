import XCTest
import BigIntProxy
@testable import Core

internal func attaInt<T: BinaryInteger>(_ value: T) -> BigIntProxy {
  let word = BigIntStorage.Word(value.magnitude)
  return attaInt(isNegative: value.isNegative, words: [word])
}

internal func attaInt(isNegative: Bool,
                      words: [BigIntStorage.Word]) -> BigIntProxy {
  let sign: BigIntProxy.Sign = isNegative ? .minus : .plus
  let magnitude = BigUIntProxy(words: words)
  return BigIntProxy(sign: sign, magnitude: magnitude)
}

internal func attaInt(heap: BigIntHeap) -> BigIntProxy {
  let words = Array(heap.storage)
  return attaInt(isNegative: heap.isNegative, words: words)
}

internal func attaInt(string: String, radix: Int = 10) -> BigIntProxy {
  // swiftlint:disable:next force_unwrapping
  return BigIntProxy(string, radix: radix)!
}
