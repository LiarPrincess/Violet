// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// Quote:
//   There is no limit for the length of integer literals apart
//   from what can be stored in available memory.
// We don't have that in Swift, so we will aproximate:

public struct BigInt: Equatable, Hashable {

  // Range: <-Int64.max, Int64.max> due to '-' being unary operator.
  public static let min = BigInt(-Int64.max)
  public static let max = BigInt(Int64.max)

  fileprivate let value: Int64

  public init(_ value: Int) {
    self.value = Int64(value)
  }

  public init(_ value: UInt8) {
    self.value = Int64(value)
  }

  public init(_ value: Int64) {
    self.value = value
  }

  public init(_ value: Double) {
    self.value = Int64(value)
  }

  public var isZero: Bool { return self.value == 0 }
  public var isOne:  Bool { return self.value == 1 }

  /// This should be used only by the lexer!
  public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
    guard let value = Int64(text, radix: radix) else {
      return nil
    }
    self.value = value
  }
}

extension BigInt: CustomStringConvertible {
  public var description: String {
    return String(describing: self.value)
  }
}

extension Double {
  public init(_ value: BigInt) {
    self = Double(integerLiteral: value.value)
  }
}
