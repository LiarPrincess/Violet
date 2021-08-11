public protocol PyHashable {

  /// The hash value.
  ///
  /// - Warning:
  /// Value should be either immutable or mutation should not change hash.
  var hash: PyHash { get }

  /// Returns a boolean value indicating whether two values are equal.
  func isEqual(to other: Self) -> PyResult<Bool>
}
