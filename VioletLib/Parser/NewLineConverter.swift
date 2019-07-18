// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Switch `\r` (old mac) and `\r\n` (windows) into `\n`. Based on brilliant
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
