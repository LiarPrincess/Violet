/// Sometimes we will slice `String` and then try to concat pieces together
/// (for example in `replace`).
/// We can use `Array` as an accumulator, but then we would have to convert
/// `Array<Scalar> -> String` and `Array<UInt8> -> Data` which is inefficient.
/// We will introduce abstract `StringBuilder` to append directly to final object.
internal protocol StringBuilderType {

  // We need 'Elements' constraint to optimize 'append' for empty builder.
  // This way we will be able to just replace `self.acc` with 'other'.
  associatedtype Elements: Collection
  /// Append result of a case transformation.
  associatedtype CaseMapping
  /// Builder result.
  /// Totally abstract and defined by specific `Builder` implementation.
  /// `AbstractString` will never interact with it directly.
  associatedtype Result

  /// Create new builder with provided capacity
  /// (to avoid re-allocations in the future).
  init(capacity: Int)
  /// Create new builder starting with given value.
  init(elements: Elements)

  /// Append a single element.
  mutating func append(element: Elements.Element)
  /// Append a single element repeated multiple times.
  mutating func append(element: Elements.Element, repeated: Int)
  /// Append multiple elements.
  mutating func append(contentsOf other: Elements)
  /// Append multiple elements.
  mutating func append(contentsOf other: Elements.SubSequence)
  /// Append case mapping.
  mutating func append(mapping: CaseMapping)

  func finalize() -> Result
}
