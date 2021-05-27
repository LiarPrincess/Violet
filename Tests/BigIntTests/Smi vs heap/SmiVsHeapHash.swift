import XCTest
@testable import BigInt

class SmiVsHeapHash: XCTestCase {

  func test_compareHashValue() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiHash = smi.hashValue

      let heap = BigIntHeap(raw)
      let heapHash = heap.hashValue

      XCTAssertEqual(smiHash, heapHash, "\(raw)")
    }
  }
}
