//===--- InitFromIntTests.swift -------------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import BigInt

class InitFromIntTests: XCTestCase {

  // MARK: - Exactly

  func test_exactly_signed() {
    self.exactly_inRange(type: Int8.self)
    self.exactly_inRange(type: Int16.self)
    self.exactly_inRange(type: Int32.self)
    self.exactly_inRange(type: Int64.self)
    self.exactly_inRange(type: Int.self)
  }

  func test_exactly_unsigned() {
    self.exactly_inRange(type: UInt8.self)
    self.exactly_inRange(type: UInt16.self)
    self.exactly_inRange(type: UInt32.self)
    self.exactly_inRange(type: UInt64.self)
    self.exactly_inRange(type: UInt.self)
  }

  private func exactly_inRange<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    var cases: [T] = [0, 42, T.max, T.max - 1, T.min, T.min + 1]
    cases.append(contentsOf: PositivePowersOf2(type: T.self).map { $0.value })

    if T.isSigned {
      cases.append(-1)
      cases.append(-42)
      cases.append(contentsOf: NegativePowersOf2(type: T.self).map { $0.value })
    }

    let typeName = String(describing: T.self)

    for int in cases {
      let big = BigInt(int)

      // String representation should be equal - trivial test for value
      let intString = String(int, radix: 10, uppercase: false)
      let bigString = String(big, radix: 10, uppercase: false)
      XCTAssertEqual(bigString, intString, "String(radix:)", file: file, line: line)

      // T -> BigInt -> T
      let revert = T(exactly: big)
      XCTAssertEqual(int,
                     revert,
                     "\(typeName) -> BigInt -> \(typeName)(exactly:)",
                     file: file,
                     line: line)
    }
  }

  func test_exactly_signed_moreThanMax() {
    self.exactly_moreThanMax(type: Int8.self)
    self.exactly_moreThanMax(type: Int16.self)
    self.exactly_moreThanMax(type: Int32.self)
    self.exactly_moreThanMax(type: Int64.self)
    self.exactly_moreThanMax(type: Int.self)
  }

  func test_exactly_unsigned_moreThanMax() {
    self.exactly_moreThanMax(type: UInt8.self)
    self.exactly_moreThanMax(type: UInt16.self)
    self.exactly_moreThanMax(type: UInt32.self)
    self.exactly_moreThanMax(type: UInt64.self)
    self.exactly_moreThanMax(type: UInt.self)
  }

  private func exactly_moreThanMax<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let max = BigInt(type.max)
    let cases = [1, 3, 7, 23, max, 2 * max - 3]

    for n in cases {
      let moreThanMax = max + n
      let exactly = T(exactly: moreThanMax)
      XCTAssertNil(exactly, "max + \(n)", file: file, line: line)
    }
  }

  func test_exactly_signed_lessThanMin() {
    self.exactly_lessThanMin(type: Int8.self)
    self.exactly_lessThanMin(type: Int16.self)
    self.exactly_lessThanMin(type: Int32.self)
    self.exactly_lessThanMin(type: Int64.self)
    self.exactly_lessThanMin(type: Int.self)
  }

  func test_exactly_unsigned_lessThanMin() {
    self.exactly_lessThanMin(type: UInt8.self)
    self.exactly_lessThanMin(type: UInt16.self)
    self.exactly_lessThanMin(type: UInt32.self)
    self.exactly_lessThanMin(type: UInt64.self)
    self.exactly_lessThanMin(type: UInt.self)
  }

  private func exactly_lessThanMin<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let min = BigInt(type.min)
    let max = BigInt(type.max)
    let cases = [1, 3, 7, 23, max, 2 * max - 3]

    for n in cases {
      let lessThanMin = min - n
      let exactly = T(exactly: lessThanMin)
      XCTAssertNil(exactly, "min - \(n)", file: file, line: line)
    }
  }

  // MARK: - Clamping

  func test_clamping_signed() {
    self.clamping_inRange(type: Int8.self)
    self.clamping_inRange(type: Int16.self)
    self.clamping_inRange(type: Int32.self)
    self.clamping_inRange(type: Int64.self)
    self.clamping_inRange(type: Int.self)
  }

  func test_clamping_unsigned() {
    self.clamping_inRange(type: UInt8.self)
    self.clamping_inRange(type: UInt16.self)
    self.clamping_inRange(type: UInt32.self)
    self.clamping_inRange(type: UInt64.self)
    self.clamping_inRange(type: UInt.self)
  }

  private func clamping_inRange<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {

    var cases: [T] = [0, 42, T.max, T.max - 1, T.min, T.min + 1]
    cases.append(contentsOf: PositivePowersOf2(type: T.self).map { $0.value })

    if T.isSigned {
      cases.append(-1)
      cases.append(-42)
      cases.append(contentsOf: NegativePowersOf2(type: T.self).map { $0.value })
    }

    let typeName = String(describing: T.self)

    for int in cases {
      let big = BigInt(int)

      // String representation should be equal - trivial test for value
      let intString = String(int, radix: 10, uppercase: false)
      let bigString = String(big, radix: 10, uppercase: false)
      XCTAssertEqual(bigString, intString, "String(radix:)", file: file, line: line)

      // T -> BigInt -> T
      let revert = T(clamping: big)
      XCTAssertEqual(int,
                     revert,
                     "\(typeName) -> BigInt -> \(typeName)(clamping:)",
                     file: file,
                     line: line)
    }
  }

  func test_clamping_signed_moreThanMax() {
    self.clamping_moreThanMax(type: Int8.self)
    self.clamping_moreThanMax(type: Int16.self)
    self.clamping_moreThanMax(type: Int32.self)
    self.clamping_moreThanMax(type: Int64.self)
    self.clamping_moreThanMax(type: Int.self)
  }

  func test_clamping_unsigned_moreThanMax() {
    self.clamping_moreThanMax(type: UInt8.self)
    self.clamping_moreThanMax(type: UInt16.self)
    self.clamping_moreThanMax(type: UInt32.self)
    self.clamping_moreThanMax(type: UInt64.self)
    self.clamping_moreThanMax(type: UInt.self)
  }

  private func clamping_moreThanMax<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let maxT = type.max
    let max = BigInt(maxT)
    let cases = [1, 3, 7, 23, max, 2 * max - 3]

    for n in cases {
      let moreThanMax = max + n
      let clamped = T(clamping: moreThanMax)
      XCTAssertEqual(clamped, maxT, "max + \(n)", file: file, line: line)
    }
  }

  func test_clamping_signed_lessThanMin() {
    self.clamping_lessThanMin(type: Int8.self)
    self.clamping_lessThanMin(type: Int16.self)
    self.clamping_lessThanMin(type: Int32.self)
    self.clamping_lessThanMin(type: Int64.self)
    self.clamping_lessThanMin(type: Int.self)
  }

  func test_clamping_unsigned_lessThanMin() {
    self.clamping_lessThanMin(type: UInt8.self)
    self.clamping_lessThanMin(type: UInt16.self)
    self.clamping_lessThanMin(type: UInt32.self)
    self.clamping_lessThanMin(type: UInt64.self)
    self.clamping_lessThanMin(type: UInt.self)
  }

  private func clamping_lessThanMin<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let minT = type.min
    let min = BigInt(minT)
    let max = BigInt(type.max)
    let cases = [1, 3, 7, 23, max, 2 * max - 3]

    for n in cases {
      let lessThanMin = min - n
      let clamped = T(clamping: lessThanMin)
      XCTAssertEqual(clamped, minT, "min - \(n)", file: file, line: line)
    }
  }

  // MARK: - Truncating if needed

  func test_truncatingIfNeeded_signed() {
    self.truncatingIfNeeded_inRange(type: Int8.self)
    self.truncatingIfNeeded_inRange(type: Int16.self)
    self.truncatingIfNeeded_inRange(type: Int32.self)
    self.truncatingIfNeeded_inRange(type: Int64.self)
    self.truncatingIfNeeded_inRange(type: Int.self)
  }

  func test_truncatingIfNeeded_unsigned() {
    self.truncatingIfNeeded_inRange(type: UInt8.self)
    self.truncatingIfNeeded_inRange(type: UInt16.self)
    self.truncatingIfNeeded_inRange(type: UInt32.self)
    self.truncatingIfNeeded_inRange(type: UInt64.self)
    self.truncatingIfNeeded_inRange(type: UInt.self)
  }

  private func truncatingIfNeeded_inRange<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {

    var cases: [T] = [0, 42, T.max, T.max - 1, T.min, T.min + 1]
    cases.append(contentsOf: PositivePowersOf2(type: T.self).map { $0.value })

    if T.isSigned {
      cases.append(-1)
      cases.append(-42)
      cases.append(contentsOf: NegativePowersOf2(type: T.self).map { $0.value })
    }

    let typeName = String(describing: T.self)

    for int in cases {
      let big = BigInt(int)

      // String representation should be equal - trivial test for value
      let intString = String(int, radix: 10, uppercase: false)
      let bigString = String(big, radix: 10, uppercase: false)
      XCTAssertEqual(bigString, intString, "String(radix:)", file: file, line: line)

      // T -> BigInt -> T
      let revert = T(truncatingIfNeeded: big)
      XCTAssertEqual(int,
                     revert,
                     "\(typeName) -> BigInt -> \(typeName)(truncatingIfNeeded:)",
                     file: file,
                     line: line)
    }
  }

  func test_truncatingIfNeeded_signed_moreThanMax() {
    self.truncatingIfNeeded_moreThanMax(type: Int8.self)
    self.truncatingIfNeeded_moreThanMax(type: Int16.self)
    self.truncatingIfNeeded_moreThanMax(type: Int32.self)
    self.truncatingIfNeeded_moreThanMax(type: Int64.self)
    self.truncatingIfNeeded_moreThanMax(type: Int.self)
  }

  func test_truncatingIfNeeded_unsigned_moreThanMax() {
    self.truncatingIfNeeded_moreThanMax(type: UInt8.self)
    self.truncatingIfNeeded_moreThanMax(type: UInt16.self)
    self.truncatingIfNeeded_moreThanMax(type: UInt32.self)
    self.truncatingIfNeeded_moreThanMax(type: UInt64.self)
    self.truncatingIfNeeded_moreThanMax(type: UInt.self)
  }

  private func truncatingIfNeeded_moreThanMax<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    do {
      // signed:   0111 + 1 =   1000 -> min
      // unsigned: 1111 + 1 = 1 0000 -> 0
      let value = BigInt(type.max) + 1
      let truncated = T(truncatingIfNeeded: value)
      let expected = T.isSigned ? type.min : type.zero
      XCTAssertEqual(truncated, expected, "max + 1", file: file, line: line)
    }

    let max = BigInt(type.max)
    let cases = [1, 3, 7, 23, max - 3, max]
    let discarded = BigInt(1) << T.bitWidth

    for n in cases {
      let moreThanMax = discarded + n
      let truncated = T(truncatingIfNeeded: moreThanMax)
      let truncatedBig = BigInt(truncated)
      XCTAssertEqual(truncatedBig, n, "1 << \(T.bitWidth) + \(n)", file: file, line: line)
    }
  }

  func test_truncatingIfNeeded_signed_lessThanMin() {
    self.truncatingIfNeeded_lessThanMin(type: Int8.self)
    self.truncatingIfNeeded_lessThanMin(type: Int16.self)
    self.truncatingIfNeeded_lessThanMin(type: Int32.self)
    self.truncatingIfNeeded_lessThanMin(type: Int64.self)
    self.truncatingIfNeeded_lessThanMin(type: Int.self)
  }

  func test_truncatingIfNeeded_unsigned_lessThanMin() {
    self.truncatingIfNeeded_lessThanMin(type: UInt8.self)
    self.truncatingIfNeeded_lessThanMin(type: UInt16.self)
    self.truncatingIfNeeded_lessThanMin(type: UInt32.self)
    self.truncatingIfNeeded_lessThanMin(type: UInt64.self)
    self.truncatingIfNeeded_lessThanMin(type: UInt.self)
  }

  private func truncatingIfNeeded_lessThanMin<T: FixedWidthInteger>(
    type: T.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let min = BigInt(type.min)

    do {
      // signed:   1000 - 1 = 0111 = max
      // unsigned: 0000 - 1 = 1111 = max
      let value = min - 1
      let truncated = T(truncatingIfNeeded: value)
      XCTAssertEqual(truncated, type.max, "min - 1", file: file, line: line)
    }

    // signed:   -12 = (1111) 0100 = -12
    // unsigned: -12 = (1111) 0100 = ?
    let max = BigInt(type.max)
    let cases = [1, 3, 7, 23, max - 3, max]
    let discarded = BigInt(1) << T.bitWidth

    for n in cases {
      let lessThanMin = -(discarded + n)
      assert(lessThanMin < min)

      let truncated = T(truncatingIfNeeded: lessThanMin)
      let complement = ~truncated + 1 // no overflow possible
      let truncatedBig = BigInt(complement)
      XCTAssertEqual(truncatedBig, n, "1 << \(T.bitWidth) + \(n)", file: file, line: line)
    }
  }
}
