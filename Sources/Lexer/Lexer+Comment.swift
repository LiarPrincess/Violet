import Foundation
import VioletCore

// https://docs.python.org/3/reference/lexical_analysis.html#encoding-declarations
// https://www.python.org/dev/peps/pep-3120/
// https://www.python.org/dev/peps/pep-0263/

// swiftlint:disable:next force_try
private let encodingRegex = try! NSRegularExpression(
  pattern: "coding[=:]\\s*([-\\w.]+)",
  options: [.caseInsensitive]
)

private let startLine = SourceLocation.start.line
private let encodingMaxLine = startLine + 2

extension Lexer {

  internal func comment() throws -> Token {
    let start = self.location
    let index = self.sourceIndex

    assert(self.peek == "#")
    while let p = self.peek, !self.isNewLine(p) {
      self.advance()
    }

    if start.line < encodingMaxLine {
      try self.checkForEncodingAndPossiblyThrow(index)
    }

    // We will include '#'
    let value = String(self.source[index..<self.sourceIndex])
    return self.token(.comment(value), start: start)
  }

  /// Do we have anything in line before '#'? -> nop
  /// Do we have encoding after '#' -> check if utf-8
  private func checkForEncodingAndPossiblyThrow(
    _ commentIndex: UnicodeScalarIndex
  ) throws {
    // If we are in 2nd line we should also check if 1st is also comment,
    // but it is not that simple because we can have whitespace before '#'.

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
      throw self.unimplemented(.nonUTF8Encoding(encoding: String(encoding)))
    }

    // uff… we are safe, no BadThings™ can happen now
  }

  private func isValidEncoding(_ encoding: Substring) -> Bool {
    let lower = encoding.lowercased()
    return lower == "utf-8" || lower == "utf-8-"
  }

  private func hasOnlyWhitespaceBefore(_ index: UnicodeScalarIndex) -> Bool {
    let isFirstCharInSource = index == self.source.startIndex
    guard !isFirstCharInSource else {
      return true // fast path
    }

    var index = self.source.index(before: index)
    while index != self.source.startIndex {
      let c = self.source[index]

      if self.isNewLine(c) {
        return true
      }

      if !self.isWhitespace(c) {
        return false
      }

      self.source.formIndex(before: &index)
    }

    // we have: index == self.source.startIndex
    return true
  }
}
