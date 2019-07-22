// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum NotImplemented: Error {
  case stringEscape(UnicodeScalar)
}

extension NotImplemented: CustomStringConvertible {
  public var description: String {
    switch self {
    case .stringEscape(let escaped):
      return "String escape '\\\(escaped)' is not currently supported."
    }
  }
}
