// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

class NewLineConverterTests: XCTestCase {

  // MARK: - Base

  func test_withoutNewLines_returnsBase() {
    self.assertEqualAfterConversion("Under the sea", "Under the sea")
  }

  // MARK: - Single newline

  /// \n -> \n
  func test_withUnixNewLine_returnsBase() {
    self.assertEqualAfterConversion("Under\nthe sea", "Under\nthe sea")
  }

  /// \r -> \n
  func test_withOldMacNewLine_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("Under\rthe sea", "Under\nthe sea")
  }

  /// \r\n -> \n
  func test_withWindowsNewLine_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("Under\r\nthe sea", "Under\nthe sea")
  }

  // MARK: - Multiple new lines

  /// \n -> \n
  /// \r -> \n
  /// \r\n -> \n
  func test_withAllNewLines_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("Un\nder\rthe\r\nsea", "Un\nder\nthe\nsea")
  }

  // MARK: - Beginning/end

  /// \r\nxxx -> \nxxx
  func test_withNewLine_atBeginning_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("\r\nUnder the sea", "\nUnder the sea")
  }

  /// xxx\r\n -> xxx\n
  func test_withNewLine_atEnd_convertsToUnixNewLine() {
    self.assertEqualAfterConversion("Under the sea\r\n", "Under the sea\n")
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
