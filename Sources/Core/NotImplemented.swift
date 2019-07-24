// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum NotImplemented: Error {
  case encodingOtherThanUTF8(String)
  case unlimitedInteger
  case stringEscape(UnicodeScalar) // e.g. print("\N{Em Dash}")

  /// This will never be implemented, because of Swift limitations.
  /// https://www.python.org/dev/peps/pep-0401/
  case pep401
}

extension NotImplemented: CustomStringConvertible {
  public var description: String {
    switch self {
    case .encodingOtherThanUTF8(let encoding):
      return "Encoding '\(encoding)' is not currently supported (in fact only UTF-8 is)."
    case.unlimitedInteger:
      return "Integers outside of <\(PyInt.min), \(PyInt.max)> range are not currently supported."
    case .stringEscape(let escaped):
      return "String escape '\\\(escaped)' is not currently supported."
    case .pep401:
      return "Uh... Oh... that means that we have to implement '<>' now."
    }
  }
}
