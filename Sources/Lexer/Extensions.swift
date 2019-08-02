extension Array {

  /// Basically: `self.append(element)`
  internal mutating func push(_ element: Element) {
    self.append(element)
  }
}

extension String {

  /// Create String instance from given scalars.
  /// It can produce broken strings such as '\u{0301}' (COMBINING ACUTE ACCENT).
  /// Even if string does look correct it may not have sense, e.g. ' \u{0301}'.
  internal init(_ scalars: [UnicodeScalar]) {
    let view = UnicodeScalarView(scalars)
    self.init(view)
  }
}
