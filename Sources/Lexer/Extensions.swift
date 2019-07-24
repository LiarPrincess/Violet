// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
