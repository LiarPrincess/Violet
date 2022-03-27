import XCTest
import Foundation
import VioletBytecode
@testable import VioletObjects

class PyFrameBlockStackTests: PyTestCase, PyFrameTestsMixin {

  typealias Block = PyFrame.Block

  // MARK: - Empty

  func test_empty() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    let stack = frame.blockStack
    self.assertStack(py, stack, expected: [])
  }

  // MARK: - Push

  func test_push() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    let stack = frame.blockStack
    var expectedStack = [Block]()
    self.assertStack(py, stack, expected: expectedStack)

    for i in 0..<PyFrame.maxBlockStackCount {
      let block = self.getBlockToPush(index: i)
      stack.push(block)
      expectedStack.push(block)
      self.assertStack(py, stack, expected: expectedStack)
    }
  }

  // MARK: - Pop

  func test_pop() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    let stack = frame.blockStack
    var expectedStack = [Block]()
    self.assertStack(py, stack, expected: expectedStack)

    // Push some objects
    for i in 0..<10 {
      let block = self.getBlockToPush(index: i)
      stack.push(block)
      expectedStack.push(block)
    }

    self.assertStack(py, stack, expected: expectedStack)

    // Actual test starts here
    for _ in 0..<10 {
      let got = stack.pop()
      let expected = expectedStack.popLast()
      XCTAssertEqual(got, expected)
      self.assertStack(py, stack, expected: expectedStack)
    }

    self.assertStack(py, stack, expected: [])
  }

  // MARK: - Helpers

  /// Expected is in `bottom-to-top` order.
  private func assertStack(_ py: Py,
                           _ stack: PyFrame.BlockStackProxy,
                           expected: [Block],
                           file: StaticString = #file,
                           line: UInt = #line) {
    XCTAssertEqual(stack.count, expected.count, "Count", file: file, line: line)

    // Better error message when we have 'if'
    if expected.isEmpty {
      XCTAssertTrue(stack.isEmpty, "isEmpty", file: file, line: line)
    } else {
      XCTAssertFalse(stack.isEmpty, "isEmpty", file: file, line: line)
    }

    let count = Swift.min(stack.count, expected.count)
    for indexFromTop in 0..<count {
      let indexFromBottom = count - indexFromTop - 1
      let object = expected[indexFromBottom]

      let peek = stack.peek(indexFromTop)
      XCTAssertEqual(peek, object, "peek \(indexFromTop)", file: file, line: line)

      if indexFromTop == 0 {
        if let current = stack.current {
          XCTAssertEqual(current, object, "current", file: file, line: line)
        } else {
          XCTFail("no current?", file: file, line: line)
        }
      }
    }
  }

  private let blocksToPush: [Block] = [
    .init(kind: .setupLoop(loopEndLabelIndex: 3), stackCount: 5),
    .init(kind: .setupExcept(firstExceptLabelIndex: 7), stackCount: 11),
    .init(kind: .setupFinally(finallyStartLabelIndex: 13), stackCount: 17),
    .init(kind: .exceptHandler, stackCount: 19),
    //
    .init(kind: .setupLoop(loopEndLabelIndex: 23), stackCount: 27),
    .init(kind: .setupExcept(firstExceptLabelIndex: 29), stackCount: 31),
    .init(kind: .setupFinally(finallyStartLabelIndex: 37), stackCount: 39),
    .init(kind: .exceptHandler, stackCount: 41)
  ]

  private func getBlockToPush(index: Int) -> Block {
    let rem = index % self.blocksToPush.count
    return self.blocksToPush[rem]
  }
}
