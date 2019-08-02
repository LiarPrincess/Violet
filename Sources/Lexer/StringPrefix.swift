// Code mostly from CPython.
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

  internal var isString: Bool { return !self.b }

  internal mutating func update(_ c: UnicodeScalar) -> Bool {
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
