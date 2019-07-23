// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Core

// https://docs.python.org/3/reference/lexical_analysis.html#encoding-declarations
// There is also https://www.python.org/dev/peps/pep-0263/ but it is for 2.3.
// Regex is better there (less work for us), but I don't want to use it since
// I don't know how it interacts with Python 3.6+.

// swiftlint:disable:next force_try
private let encodingRegex = try! NSRegularExpression(
  pattern: "coding[=:]\\s*([-\\w.]+)",
  options: [.caseInsensitive]
)

private let startLine = SourceLocation.start.line
private let encodingMaxLine = startLine + 2

extension Lexer {

  internal mutating func comment() throws {
    let line = self.location.line
    let commentIndex = self.sourceIndex

    assert(self.peek == "#")
    while let p = self.peek, !self.isEOL(p) {
      self.advance()
    }

    if line < encodingMaxLine {
      try self.checkForEncodingAndPossiblyThrow(commentIndex)
    }
  }

  /// Do we have anything in line before '#'? -> nop
  /// Do we have encoding after '#' -> check if utf-8
  private func checkForEncodingAndPossiblyThrow(_ commentIndex: String.Index) throws {
    // if we are in 2nd line we should also check if 1st is also comment,
    // but it is not that simple because we can have whitespace before '#'

    guard self.hasOnlyWhitespaceBefore(commentIndex) else {
      return
    }

    let comment = String(self.source[commentIndex..<self.sourceIndex])
    let range = NSRange(comment.startIndex..., in: comment)

    guard let match = encodingRegex.firstMatch(in: comment, options: [], range: range),
          match.range.location != NSNotFound,
          match.numberOfRanges > 0 else {
      return
    }

    guard let encodingRange = Range(match.range(at: 1), in: comment) else {
      return // no idea here
    }

    let encoding = comment[encodingRange]
    guard self.isValidEncoding(encoding) else {
      throw NotImplemented.encodingOtherThanUTF8(String(encoding))
    }

    // uff... we are safe, no BadThings™ can happen now
  }

  private func isValidEncoding(_ encoding: Substring) -> Bool {
    let lower = encoding.lowercased()
    return lower == "utf-8" || lower == "utf-8-"
  }

  private func hasOnlyWhitespaceBefore(_ index: String.Index) -> Bool {
    guard index != self.source.startIndex else { // fast path
      return true
    }

    var index = self.source.index(before: index)
    while index != self.source.startIndex {
      let c = self.source[index]

      if self.isEOL(c) {
        return true
      }

      if !self.isWhitespace(c) {
        return false
      }

      self.source.formIndex(before: &index)
    }

    // index == self.source.startIndex
    return true
  }

  private func isWhitespace(_ c: Character) -> Bool {
    return c == " " || c == "\t"
  }

  private func isEOL(_ c: Character) -> Bool {
    return c == "\n" || c == "\r"
  }
}
