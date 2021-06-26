extension Unicode {

  /// Line breaks used in str implementation of `splitLines`.
  internal static var lineBreaks: Set<UnicodeScalar> {
    return data
  }
}

private let data: Set<UnicodeScalar> = Set([
  "\n", // \n - Line Feed
  "\r", // \r - Carriage Return
  // \r\n - Carriage Return + Line Feed
  "\u{0b}", // \v or \x0b - Line Tabulation
  "\u{0c}", // \f or \x0c - Form Feed
  "\u{1c}", // \x1c - File Separator
  "\u{1d}", // \x1d - Group Separator
  "\u{1e}", // \x1e - Record Separator
  "\u{85}", // \x85 - Next Line (C1 Control Code)
  "\u{2028}", // \u2028 - Line Separator
  "\u{2029}" // \u2029 - Paragraph Separator
])
