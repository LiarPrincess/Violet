// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Please don't use those characters in '\r', '\n', '\r\n' form.
// The only exception is when parsing string escapes.
// (Don't ask why)

/// Carriage Return (MAC pre-OSX), \r, ASCII code 13.
internal let CR: Character = "\r"

/// Line Feed (Linux, MAC OSX), \n, ASCII code 10.
internal let LF: Character = "\n"

/// Carriage Return and Line Feed (Windows), \r\n, ASCII code 13 & 10.
/// Single character in Swift! Be carefull if we go back to code points!
internal let CRLF: Character = "\r\n"
