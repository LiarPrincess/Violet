/// Sometimes we will slice `String` and then try to concat pieces together
/// (for example in `replace`).
/// We can use `Array` as an accumulator, but then we would have to convert
/// `Array<Scalar> -> String` and `Array<UInt8> -> Data` which is inefficient.
/// We will introduce abstract `StringBuilder` to append directly to final object.
internal protocol StringBuilderType {

  associatedtype Element
  /// Builder result.
  /// Totally abstract and defined by specific `Builder` implementation.
  /// `PyStringImpl` will never interact with it directly.
  associatedtype Result

  /// Builder final value.
  var result: Result { get }

  /// Create new empty builder.
  init()

  /// Append single element.
  mutating func append(_ value: Element)
  /// Append multiple elements.
  mutating func append<C: Sequence>(contentsOf other: C) where C.Element == Self.Element
}
