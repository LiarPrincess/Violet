import XCTest
import VioletCore

class UseScalarsToHashStringTests: XCTestCase {

  func test_empty_areEqual() {
    let lhs = UseScalarsToHashString("")
    let rhs = UseScalarsToHashString("")
    XCTAssertEqual(lhs, rhs)
    XCTAssertEqual(lhs.hashValue, rhs.hashValue)
  }

  func test_equal_areEqual() {
    let lhs = UseScalarsToHashString("elsa")
    let rhs = UseScalarsToHashString("elsa")
    XCTAssertEqual(lhs, rhs)
    XCTAssertEqual(lhs.hashValue, rhs.hashValue)
  }

  func test_different_byLength_areNotEqual() {
    let lhs = UseScalarsToHashString("elsa")
    let rhs = UseScalarsToHashString("elsa of Arendelle")
    XCTAssertNotEqual(lhs, rhs)
    XCTAssertNotEqual(rhs, lhs)
    XCTAssertNotEqual(lhs.hashValue, rhs.hashValue)
    XCTAssertNotEqual(rhs.hashValue, lhs.hashValue)
  }

  // cspell:disable-next
  func test_different_ecuteAccents_areNotEqual() {
    let lhs = "élsa"
    let rhs = "e\u{0301}lsa"
    XCTAssertEqual(lhs, rhs, "Equal by Swift")
    XCTAssertEqual(lhs.hashValue, rhs.hashValue)

    let lhsScalar = UseScalarsToHashString(lhs)
    let rhsScalar = UseScalarsToHashString(rhs)
    XCTAssertNotEqual(lhsScalar, rhsScalar, "Not equal in Python")
    XCTAssertNotEqual(lhsScalar.hashValue, rhsScalar.hashValue)
  }
}
