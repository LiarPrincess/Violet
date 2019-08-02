// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum ParserErrorKind: Equatable {

  /// Non-default argument follows default argument.
  case defaultFollowedByNonDefaultArgument
  /// Duplicate non-keyworded variable length argument (the one with '*').
  case duplicateVarargs
  /// Duplicate keyworded variable length argument (the one with '**').
  case duplicateKwargs
  /// Argument after keyworded variable length argument (the one with '**').
  case argsAfterKwargs
  /// Non-keyworded variable length argument (the one with '*') after
  /// keyworded variable length argument (the one with '**').
  case varargsAfterKwargs
  /// Named arguments must follow bare *.
  case starWithoutFollowingArguments

  case unimplemented(String)
}

extension ParserErrorKind: CustomStringConvertible {
  public var description: String {
    switch self {

    case .defaultFollowedByNonDefaultArgument:
      return "Non-default argument follows default argument."
    case .duplicateVarargs:
      return "Duplicate non-keyworded variable length argument (the one with '*')."
    case .duplicateKwargs:
      return "Duplicate keyworded variable length argument (the one with '**')."
    case .argsAfterKwargs:
      return "Argument after keyworded variable length argument (the one with '**')."
    case .varargsAfterKwargs:
      return "Non-keyworded variable length argument (the one with '*') after " +
             "keyworded variable length argument (the one with '**')."
    case .starWithoutFollowingArguments:
      return "Named arguments must follow bare *."

    case .unimplemented(let msg):
      return "Unimplemented: '\(msg)'"
    }
  }
}
