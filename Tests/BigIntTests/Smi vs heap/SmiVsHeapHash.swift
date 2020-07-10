import XCTest
@testable import Core

class SmiVsHeapHash: XCTestCase {

  func test_iWillTotallyRememberToNameItLater() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiResult = smi.hashValue

      let heap = BigIntHeap(raw)
      let heapResult = heap.hashValue

      XCTAssertEqual(smiResult, heapResult, "\(raw)")
    }
  }
}
