import XCTest
@testable import BigInt

class BigIntPowerTests: XCTestCase {

  // MARK: - Trivial base

  /// 0 ^ n = 0 (or sometimes 1)
  func test_base_zero() {
    let zero = BigInt(0)
    let one = BigInt(1)

    for smi in generateSmiValues(countButNotReally: 100) {
      let exponentSmi = smi.magnitude
      let exponent = BigInt(exponentSmi)
      let result = zero.power(exponent: exponent)

      // 0 ^ 0 = 1, otherwise 0
      let expected = exponentSmi == 0 ? one : zero
      XCTAssertEqual(result, expected, "0 ^ \(exponentSmi)")
    }
  }

  /// 1 ^ n = 1
  func test_base_one() {
    let one = BigInt(1)

    for smi in generateSmiValues(countButNotReally: 100) {
      let exponentSmi = smi.magnitude
      let exponent = BigInt(exponentSmi)
      let result = one.power(exponent: exponent)

      let expected = one
      XCTAssertEqual(result, expected, "1 ^ \(exponentSmi)")
    }
  }

  /// (-1) ^ n = (-1) or 1
  func test_base_minusOne() {
    let plusOne = BigInt(1)
    let minusOne = BigInt(-1)

    for smi in generateSmiValues(countButNotReally: 100) {
      let exponentSmi = smi.magnitude
      let exponent = BigInt(exponentSmi)
      let result = minusOne.power(exponent: exponent)

      let expected = exponentSmi.isMultiple(of: 2) ? plusOne : minusOne
      XCTAssertEqual(result, expected, "(-1) ^ \(exponentSmi)")
    }
  }

  // MARK: - Trivial exponent

  /// n ^ 0 = 1
  func test_exponent_zero() {
    let zero = BigInt(0)
    let one = BigInt(1)

    for smi in generateSmiValues(countButNotReally: 100) {
      let base = BigInt(smi)
      let result = base.power(exponent: zero)

      let expected = one
      XCTAssertEqual(result, expected, "\(smi) ^ 1")
    }
  }

  /// n ^ 1 = n
  func test_exponent_one() {
    let one = BigInt(1)

    for smi in generateSmiValues(countButNotReally: 100) {
      let base = BigInt(smi)
      let result = base.power(exponent: one)

      let expected = base
      XCTAssertEqual(result, expected, "\(smi) ^ 1")
    }
  }

  func test_exponent_two() {
    let two = BigInt(2)

    for p in generateHeapValues(countButNotReally: 2) {
      let baseHeap = BigIntHeap(isNegative: false, words: p.words)
      let base = BigInt(baseHeap)
      let result = base.power(exponent: two)

      let expected = base * base
      XCTAssertEqual(result, expected, "\(base) ^ 2")
    }
  }

  func test_exponent_three() {
    let three = BigInt(3)

    for p in generateHeapValues(countButNotReally: 2) {
      let baseHeap = BigIntHeap(isNegative: false, words: p.words)
      let base = BigInt(baseHeap)
      let result = base.power(exponent: three)

      let expected = base * base * base
      XCTAssertEqual(result, expected, "\(base) ^ 3")
    }
  }

  // MARK: - Smi

  func test_againstFoundationPow() {
    // THIS IS NOT A PERFECT TEST!
    // It is 'good enough' to be usable, but don't think about it too much!
    let mantissaCount = Double.significandBitCount // well… technically '+1'
    let maxExactlyRepresentable = UInt(pow(Double(2), Double(mantissaCount)))

    // 'smi ^ 2' has greater possibility of being in 'Double' range than 'Int'
    var values = generateSmiValues(countButNotReally: 20)
    for i in -10...10 {
      values.append(Smi.Storage(i))
    }

    for (baseSmi, expSmiSigned) in allPossiblePairings(values: values) {
      let expSmi = expSmiSigned.magnitude

      guard let baseDouble = Double(exactly: baseSmi),
            let expDouble = Double(exactly: expSmi) else {
          continue
      }

      let expectedDouble = pow(baseDouble, expDouble)
      guard let expectedInt = Int(exactly: expectedDouble),
                expectedInt.magnitude < maxExactlyRepresentable else {
        continue
      }

      // Some tests will actually get here, not a lot, but some
      let base = BigInt(baseSmi)
      let exp = BigInt(expSmi)
      let result = base.power(exponent: exp)

      let expected = BigInt(expectedInt)
      XCTAssertEqual(result, expected, "\(baseSmi) ^ \(expSmi)")
    }
  }
}
