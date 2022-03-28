import XCTest
import Foundation
import BigInt
@testable import VioletObjects

class GenericLayoutTests: XCTestCase {

  func test_i32_i8_i8_i16_i64() {
    let layout = GenericLayout(
      initialOffset: 0,
      initialAlignment: 0,
      fields: [
        GenericLayout.Field(Int32.self), // offset: 0, size: 4
        GenericLayout.Field(Int8.self), // offset: 4, size: 1
        GenericLayout.Field(Int8.self), // offset: 5, size: 1
        GenericLayout.Field(Int16.self), // offset: 6, size: 2
        GenericLayout.Field(Int64.self) // offset: 8, size: 8
      ]
    )

    XCTAssertEqual(layout.size, 16)
    XCTAssertEqual(layout.alignment, 8)
    XCTAssertEqual(layout.offsets, [0, 4, 5, 6, 8])
  }

  func test_i32_i8_hole1_i16_i8_hole7_i64() {
    let layout = GenericLayout(
      initialOffset: 0,
      initialAlignment: 0,
      fields: [
        GenericLayout.Field(Int32.self), // offset: 0, size: 4
        GenericLayout.Field(Int8.self), // offset: 4, size: 1
        // hole 1 to align 5 -> 6
        GenericLayout.Field(Int16.self), // offset: 6, size: 2
        GenericLayout.Field(Int8.self), // offset: 8, size: 1
        // hole 7 to align 9 -> 16
        GenericLayout.Field(Int64.self) // offset: 16, size: 8
      ]
    )

    XCTAssertEqual(layout.size, 24)
    XCTAssertEqual(layout.alignment, 8)
    XCTAssertEqual(layout.offsets, [0, 4, 6, 8, 16])
  }

  func test_i32_i8_i8_u16x5_hole() {
    let layout = GenericLayout(
      initialOffset: 0,
      initialAlignment: 0,
      fields: [
        GenericLayout.Field(Int32.self), // offset: 0, size: 4
        GenericLayout.Field(Int8.self), // offset: 4, size: 1
        GenericLayout.Field(Int8.self), // offset: 5, size: 1
        GenericLayout.Field(Int16.self, repeatCount: 5), // offset: 6, size: 2x5
        // hole 1 to align(5 + 2x5) -> 16
        GenericLayout.Field(Int64.self) // offset: 16, size: 8
      ]
    )

    XCTAssertEqual(layout.size, 24)
    XCTAssertEqual(layout.alignment, 8)
    XCTAssertEqual(layout.offsets, [0, 4, 5, 6, 16])
  }
}
