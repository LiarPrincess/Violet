// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal protocol InputStream {

  /// Peek next item without consuming it.
  var peek: UnicodeScalar? { get }

  /// Consume item.
  mutating func advance() -> UnicodeScalar?
}

// MARK: - StringStream

/// Convert ordinary string to input stream.
internal struct StringStream: InputStream {

  private let scalars: String.UnicodeScalarView
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

// MARK: - NewLineConverter

/// Switch `\r` (old mac) and `\r\n` (windows) into `\n`. Based on briliant
/// idea from [RustPython](https://github.com/RustPython/RustPython).
internal struct NewLineConverter: InputStream {

  private var base: InputStream

  internal init(base: InputStream) {
    self.base = base
  }

  internal var peek: UnicodeScalar? {
    return self.base.peek
  }

  internal mutating func advance() -> UnicodeScalar? {
    let value = self.base.advance()
    if value != "\r" {
      return value
    }

    // if we have "\r\n" then consume '\n' as well
    if self.base.peek == "\n" {
      _ = self.base.advance()
    }

    return "\n"
  }
}
