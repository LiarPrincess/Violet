// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

class NewLineConverterTests: XCTestCase {

  // MARK: - Base

  /// abc -> abc
  func test_withoutNewLines_returnsBase() {
    self.assertEqualAfterConversion("abc", "abc")
  }

  // MARK: - Single newline

  /// a\nbc -> a\nbc
  func test_withUnixNewLine_returnsBase() {
    self.assertEqualAfterConversion("a\nbc", "a\nbc")
  }

  /// a\rb\nc -> a\nb\nc
  func test_withOldMacNewLine_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("a\rb\nc", "a\nb\nc")
  }

  /// a\r\nb\nc -> a\nb\nc
  func test_withWindowsNewLine_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("a\r\nb\nc", "a\nb\nc")
  }

  // MARK: - Multiple new lines

  /// a\r\n\rb\nc -> a\n\nb\nc
  func test_withAllNewLines_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("a\r\n\rb\nc", "a\n\nb\nc")
  }

  // MARK: - Beginning/end

  /// \r\nabc -> abc
  func test_withNewLine_atBeginning_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("\r\nabc", "\nabc")
  }

  /// abc\r\n -> abc
  func test_withNewLine_atEnd_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("abc\r\n", "abc\n")
  }

  // MARK: - Helper

  private func assertEqualAfterConversion(_ input:  String,
                                          _ output: String,
                                          file:     StaticString = #file,
                                          line:     UInt = #line) {
    let base = StringStream(input)
    var stream = NewLineConverter(base: base)

    var result = ""
    while let c = stream.advance() {
      result.unicodeScalars.append(c)
    }

    XCTAssertEqual(result, output, file: file, line: line)
  }
}
