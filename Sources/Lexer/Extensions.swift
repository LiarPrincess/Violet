// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// MARK: - Collection

extension Collection {

  /// Basically: `!self.isEmpty`
  internal var any: Bool {
    return !self.isEmpty
  }
}

// MARK: - Array

extension Array {

  /// Basically: `self.append(element)`
  internal mutating func push(_ element: Element) {
    self.append(element)
  }
}

// MARK: - String

extension String {

  internal init(_ scalars: [UnicodeScalar]) {
    self.init(String.UnicodeScalarView(scalars))
  }
}
