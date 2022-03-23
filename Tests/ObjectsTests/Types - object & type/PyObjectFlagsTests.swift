import XCTest
import Foundation
@testable import VioletObjects

private typealias Flags = PyObject.Flags

// MARK: - Flag collections

private let allEveryObjectFlags: [Flags] = [
  .reprLock,
  .descriptionLock
//  .reserved2,
//  .reserved3,
//  .reserved4,
//  .reserved5,
//  .reserved6,
//  .reserved7
]

private let allCustomFlags: [Flags] = [
  .custom0,
  .custom1,
  .custom2,
  .custom3,
  .custom4,
  .custom5,
  .custom6,
  .custom7,
  .custom8,
  .custom9,
  .custom10,
  .custom11,
  .custom12,
  .custom13,
  .custom14,
  .custom15,
  .custom16,
  .custom17,
  .custom18,
  .custom19,
  .custom20,
  .custom21,
  .custom22,
  .custom23
]

private let allFlags: [Flags] = allEveryObjectFlags + allCustomFlags

private let customUInt16Flags: [Flags] = [
  .custom0,
  .custom1,
  .custom2,
  .custom3,
  .custom4,
  .custom5,
  .custom6,
  .custom7,
  .custom8,
  .custom9,
  .custom10,
  .custom11,
  .custom12,
  .custom13,
  .custom14,
  .custom15
]

class PyObjectFlagsTests: XCTestCase {

  // MARK: - Set/unset

  func test_set_unset_changesFlagValue() {
    for flag in allFlags {
      var f = Flags()
      XCTAssertFalse(f.isSet(flag))

      f.set(flag)
      XCTAssertTrue(f.isSet(flag))

      f.unset(flag)
      XCTAssertFalse(f.isSet(flag))
    }
  }

  func test_setTrue_setFalse_changesFlagValue() {
    for flag in allFlags {
      var f = Flags()
      XCTAssertFalse(f.isSet(flag))

      f.set(flag, value: true)
      XCTAssertTrue(f.isSet(flag))

      f.set(flag, value: false)
      XCTAssertFalse(f.isSet(flag))
    }
  }

  // MARK: - Set custom flags

  func test_setCustomFlags_forEveryObjectFlags_doesNothing() {
    for flag in allEveryObjectFlags {
      var f = Flags()
      XCTAssertFalse(f.isSet(flag))

      f.setCustomFlags(from: flag)
      XCTAssertFalse(f.isSet(flag))
    }
  }

  func test_setCustomFlags_forCustomFlags_setsFlag() {
    for flag in allCustomFlags {
      var f = Flags()
      XCTAssertFalse(f.isSet(flag))

      f.setCustomFlags(from: flag)
      XCTAssertTrue(f.isSet(flag))
    }
  }

  // MARK: - Custom UInt16

  func test_customUInt16_isIn_customFlags_from0_to15() {
    var flags = Flags()
    let beforeSet = flags.customUInt16
    XCTAssertEqual(beforeSet, UInt16.zero)

    for f in customUInt16Flags {
      flags.set(f)
    }

    let afterSet = flags.customUInt16
    XCTAssertEqual(afterSet, UInt16.max)

    for f in allFlags {
      let isSet = flags.isSet(f)
      let expectedIsSet = self.isCustomUInt16Flag(f)
      XCTAssertEqual(isSet, expectedIsSet)
    }
  }

  func test_customUInt16_set() {
    var flags = Flags()
    let beforeSet = flags.customUInt16
    XCTAssertEqual(beforeSet, UInt16.zero)

    flags.customUInt16 = UInt16.max

    let afterSet = flags.customUInt16
    XCTAssertEqual(afterSet, UInt16.max)

    for f in allFlags {
      let isSet = flags.isSet(f)
      let expectedIsSet = self.isCustomUInt16Flag(f)
      XCTAssertEqual(isSet, expectedIsSet)
    }
  }

  private func isCustomUInt16Flag(_ f: Flags) -> Bool {
    return customUInt16Flags.contains(f)
  }

  // MARK: - No overlap

  func test_flags_doNot_overlap() {
    for flag in allFlags {
      for toSet in allFlags {
        if flag == toSet {
          continue
        }

        var withOtherFlagSet = flag
        withOtherFlagSet.set(toSet)
        XCTAssertNotEqual(withOtherFlagSet, flag)
      }
    }
  }
}
