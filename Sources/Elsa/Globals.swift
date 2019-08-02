extension Array where Element == String {

  /// The same as `self.joined(separator:_)`, but less typing.
  internal func joined(_ separator: String = "") -> String {
    return self.joined(separator: separator)
  }
}

internal func pascalCase(_ s: String) -> String {
  let first = s.first?.uppercased() ?? ""
  return first + s.dropFirst()
}

internal func camelCase(_ s: String) -> String {
  let first = s.first?.lowercased() ?? ""
  return first + s.dropFirst()
}
