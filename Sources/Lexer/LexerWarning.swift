// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: (LexerWarning) We have warnings, but we don't do anything with them.
internal enum LexerWarning {

  /// Changed in version 3.6:
  /// Unrecognized escape sequences produce a DeprecationWarning.
  /// In some future version of Python they will be a SyntaxError.
  case unrecognizedEscapeSequence
}
