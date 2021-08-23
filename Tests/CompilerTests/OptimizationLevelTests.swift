import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

private typealias OptimizationLevel = Compiler.OptimizationLevel

class OptimizationLevelTests: XCTestCase {

  func test_compare_none() {
    let level = OptimizationLevel.none

    XCTAssertEqual(level, OptimizationLevel.none)
    XCTAssertNotEqual(level, OptimizationLevel.O)
    XCTAssertNotEqual(level, OptimizationLevel.OO)

    XCTAssertLessThan(level, OptimizationLevel.O)
    XCTAssertLessThan(level, OptimizationLevel.OO)
  }

  func test_compare_O() {
    let level = OptimizationLevel.O

    XCTAssertNotEqual(level, OptimizationLevel.none)
    XCTAssertEqual(level, OptimizationLevel.O)
    XCTAssertNotEqual(level, OptimizationLevel.OO)

    XCTAssertGreaterThan(level, OptimizationLevel.none)
    XCTAssertLessThan(level, OptimizationLevel.OO)
  }

  func test_compare_OO() {
    let level = OptimizationLevel.OO

    XCTAssertNotEqual(level, OptimizationLevel.none)
    XCTAssertNotEqual(level, OptimizationLevel.O)
    XCTAssertEqual(level, OptimizationLevel.OO)

    XCTAssertGreaterThan(level, OptimizationLevel.none)
    XCTAssertGreaterThan(level, OptimizationLevel.O)
  }
}
