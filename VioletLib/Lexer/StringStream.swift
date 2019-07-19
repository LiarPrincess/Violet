// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Convert ordinary string to input stream.
internal struct StringStream: InputStream {

  internal static var empty: StringStream {
    return StringStream("")
  }

  // TODO: Check performance
  private var scalars: String.UnicodeScalarView
  private var index:   String.UnicodeScalarView.Index

  private var isAtEnd: Bool {
    return self.index == self.scalars.endIndex
  }

  internal init(_ value: String) {
    self.scalars = value.unicodeScalars
    self.index = self.scalars.startIndex
  }

  internal var peek: UnicodeScalar? {
    return self.isAtEnd ? nil : self.scalars[index]
  }

  internal mutating func advance() -> UnicodeScalar? {
    guard !self.isAtEnd else {
      return nil
    }

    let value = self.scalars[self.index]
    self.index = self.scalars.index(after: self.index)
    return value
  }
}
