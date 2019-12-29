// See annex #9 - 'UNICODE BIDIRECTIONAL ALGORITHM' to Unicode standard for details
// (https://www.unicode.org/reports/tr9/tr9-41.html#Bidi_Conformance_Testing).

// This file was generated with 'Scripts/unicode/BidirectionalClass.py'.
// To get the newest version of 'UnicodeData.txt' go to:
// https://www.unicode.org/Public/UCD/latest/ucd/

extension Unicode {

  /// Characters with bidirectional class: WS, B, or S
  internal static var bidiClass_ws_b_s: Set<UInt32> {
    return data
  }
}

private let data: Set<UInt32> = Set([
  0x0009, // <control>, S
  0x000A, // <control>, B
  0x000B, // <control>, S
  0x000C, // <control>, WS
  0x000D, // <control>, B
  0x001C, // <control>, B
  0x001D, // <control>, B
  0x001E, // <control>, B
  0x001F, // <control>, S
  0x0020, // SPACE, WS
  0x0085, // <control>, B
  0x1680, // OGHAM SPACE MARK, WS
  0x2000, // EN QUAD, WS
  0x2001, // EM QUAD, WS
  0x2002, // EN SPACE, WS
  0x2003, // EM SPACE, WS
  0x2004, // THREE-PER-EM SPACE, WS
  0x2005, // FOUR-PER-EM SPACE, WS
  0x2006, // SIX-PER-EM SPACE, WS
  0x2007, // FIGURE SPACE, WS
  0x2008, // PUNCTUATION SPACE, WS
  0x2009, // THIN SPACE, WS
  0x200A, // HAIR SPACE, WS
  0x2028, // LINE SEPARATOR, WS
  0x2029, // PARAGRAPH SEPARATOR, B
  0x205F, // MEDIUM MATHEMATICAL SPACE, WS
  0x3000  // IDEOGRAPHIC SPACE, WS
])
