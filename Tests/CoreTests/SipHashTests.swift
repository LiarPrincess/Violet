import XCTest
@testable import VioletCore

// swiftlint:disable number_separator
// swiftlint:disable function_body_length
// swiftformat:disable numberFormatting

// Use './Scripts/siphash.c' to generate test data.

private func XCTAssertHash(_ value: String,
                           _ expected: UInt64,
                           file: StaticString = #file,
                           line: UInt = #line) {
  // Key is 'I See the Light ' in ASCII
  let key: (UInt64, UInt64) = (0x4920536565207468, 0x65204c6967687420)

  let hash = value.utf8.withContiguousStorageIfAvailable { ptr -> UInt64 in
    SipHash.hash(key0: key.0, key1: key.1, bytes: ptr)
  }

  // swiftlint:disable:next force_unwrapping
  XCTAssertEqual(hash!, expected, file: file, line: line)
}

class SipHashTests: XCTestCase {

  // MARK: - Empty

  func test_empty() {
    XCTAssertHash("", 8600138830522006719)
  }

  // MARK: - Example from paper

  func test_example_from_paper() {
    let key0: UInt64 = 0x0706050403020100
    let key1: UInt64 = 0x0f0e0d0c0b0a0908
    let data: [UInt8] = Array(0..<15)

    let hash = data.withContiguousStorageIfAvailable { ptr -> UInt64 in
      SipHash.hash(key0: key0, key1: key1, bytes: ptr)
    }

    guard let h = hash else {
      XCTFail("Array does not have contiguous storage?")
      return
    }

    XCTAssertEqual(h, 0xa129ca6149be45e5)
  }

  // MARK: - 'I See the Light' song

  // Lyrics taken from:
  // https://genius.com/Walt-disney-records-i-see-the-light-lyrics
  func test_i_see_the_light() {
    XCTAssertHash("[RAPUNZEL]", 17128426921564907453)
    XCTAssertHash("All those days watching from the windows", 12084556205844325756)
    XCTAssertHash("All those years outside looking in", 7204810991338202327)
    XCTAssertHash("All that time never even knowing", 14138769137698236062)
    XCTAssertHash("Just how blind I've been", 5633983093180307194)
    XCTAssertHash("Now I'm here blinking in the starlight", 8083896276344063337)
    XCTAssertHash("Now I'm here suddenly I see", 853383907421416047)
    XCTAssertHash("Standing here it's all so clear", 6720719499670616045)
    XCTAssertHash("I'm where I'm meant to be", 2773147696801451022)

    XCTAssertHash("And at last I see the light", 8077556498384019551)
    XCTAssertHash("And it's like the fog has lifted", 3561799010760574116)
    XCTAssertHash("And at last I see the light", 8077556498384019551)
    XCTAssertHash("And it's like the sky is new", 4740323833675850490)
    XCTAssertHash("And it's warm and real and bright", 11367406826362248151)
    XCTAssertHash("And the world has somehow shifted", 7508608344832748481)
    XCTAssertHash("All at once everything looks different", 12229568755183969108)
    XCTAssertHash("Now that I see you", 9418091429171647485)

    XCTAssertHash("[FLYNN]", 8613833223099745980)
    XCTAssertHash("All those days chasing down a daydream", 14683934664480155017)
    XCTAssertHash("All those years living in a blur", 87270370235139673)
    XCTAssertHash("All that time never truly seeing", 8110893289567215589)
    XCTAssertHash("Things, the way they were", 7776305640915538527)
    XCTAssertHash("Now she's here shining in the starlight", 14218670068158657302)
    XCTAssertHash("Now she's here suddenly I know", 12726979810134084990)
    XCTAssertHash("If she's here it's crystal clear", 4229274370386620682)
    XCTAssertHash("I'm where I'm meant to go", 9632084373913809799)

    XCTAssertHash("[FLYNN & RAPUNZEL]", 13248193047975567481)
    XCTAssertHash("And at last I see the light", 8077556498384019551)

    XCTAssertHash("[FLYNN]", 8613833223099745980)
    XCTAssertHash("And it's like the fog has lifted", 3561799010760574116)

    XCTAssertHash("[FLYNN & RAPUNZEL]", 13248193047975567481)
    XCTAssertHash("And at last I see the light", 8077556498384019551)

    XCTAssertHash("[RAPUNZEL]", 17128426921564907453)
    XCTAssertHash("And it's like the sky is new", 4740323833675850490)

    XCTAssertHash("[FLYNN & RAPUNZEL]", 13248193047975567481)
    XCTAssertHash("And it's warm and real and bright", 11367406826362248151)
    XCTAssertHash("And the world has somehow shifted", 7508608344832748481)
    XCTAssertHash("All at once everything is different", 9286063250783511361)
    XCTAssertHash("Now that I see you", 9418091429171647485)

    XCTAssertHash("Now that I see you", 9418091429171647485)
  }
}
