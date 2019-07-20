// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// https://docs.python.org/3/reference/lexical_analysis.html#grammar-token-stringprefix

internal struct StringPrefix {

  /// Bytes literal.
  internal var b = false

  /// Raw string which treats backslashes as literal characters.
  internal var r = false

  /// Unicode legacy literal.
  internal var u = false

  /// Formatted string literal.
  internal var f = false

  internal mutating func update(_ c: UnicodeScalar) -> Bool {
    // From CPython.

    if !(self.b || self.u || self.f) && (c == "b" || c == "B") {
      self.b = true
      return true
    }

    if !(self.b || self.u || self.r || self.f) && (c == "u" || c == "U") {
      self.u = true
      return true
    }

    if !(self.r || self.u) && (c == "r" || c == "R") {
      self.r = true
      return true
    }

    if !(self.f || self.b || self.u) && (c == "f" || c == "F") {
      self.f = true
      return true
    }

    return false
  }
}
