import XCTest
@testable import BigInt

class BigIntHeapHashableTests: XCTestCase {

  // We need to hash to the same value as 'Smi'
  func test_smiRepresentable_hasTheSameHash_asSmi() {
    for value in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(value)
      let heap = BigIntHeap(value)
      XCTAssertEqual(smi.hashValue, heap.hashValue, "\(value)")
    }
  }

  func test_notSmi_doesNotTrap_etc() {
    for p in generateHeapValues(countButNotReally: 100) {
      let heap = p.create()

      // Is it outside of the Smi range?
      guard heap.asSmiIfPossible() == nil else {
        continue
      }

      // Just check if it does not crash… no assert here
      _ = heap.hashValue
    }
  }
}
