// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: PyInt proper implementation
// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// There is no limit for the length of integer literals apart
// from what can be stored in available memory.

public struct PyInt: Equatable {

  // Range: <-Int64.max, Int64.max> due to '-' being unary operator.
  public static let min = PyInt(-Int64.max)
  public static let max = PyInt(Int64.max)

  private let value: Int64

  public init(_ value: Int64) {
    self.value = value
  }

  /// This should be used only by the lexer!
  public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
    guard let val = Int64(text, radix: radix) else {
      return nil
    }
    self.value = val
  }
}
