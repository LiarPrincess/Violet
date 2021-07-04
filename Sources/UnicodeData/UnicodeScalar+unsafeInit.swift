// swiftlint:disable force_unwrapping

extension UnicodeScalar {

  internal init(unsafe value: UInt32) {
    self = UnicodeScalar(value)!
  }

  internal init(unsafe value: Int) {
    self = UnicodeScalar(value)!
  }
}
