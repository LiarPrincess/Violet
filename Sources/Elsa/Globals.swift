// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Array where Element == String {

  /// The same as `self.joined(separator:_)`, but less typing.
  internal func joined(_ separator: String = "") -> String {
    return self.joined(separator: separator)
  }
}
