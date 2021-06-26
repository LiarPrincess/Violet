import BigInt
import VioletCore

/// Given a `PyObject` we try to extract valid `Self` value to use in function.
/// This a result of this 'extraction'.
internal enum PyStringImplExtractedSelf<T> {
  case value(T)
  case notSelf
  case error(PyBaseException)
}

/// (Almost) all of the `str` methods.
/// Everything here is 'best-effort' because strings are hard.
///
/// Note that we will use the same implementation for `str` and `bytes`.
///
/// Also: look at us! Using traits/protocols as intended!
internal protocol PyStringImpl {

  /// `UnicodeScalarView` for str and `Data` for bytes.
  ///
  /// - `Bidirectional` because we need to iterate backwards for `rfind` etc.
  /// - `Comparable` because we need to implement `__eq__`, `__lt__` etc.
  /// - `Hashable` - not needed, but gives us  O(1) `strip` lookups.
  associatedtype Scalars: BidirectionalCollection where
    Scalars.Element: Comparable,
    Scalars.Element: Hashable

  /// See `StringBuilderType` documentation.
  /// `Builder.Result` is abstract and we will never touch it.
  associatedtype Builder: StringBuilderType where
    Builder.Element == Scalars.Element

  /// `UnicodeScalarView` for `str` and `Data` for `bytes`.
  ///
  /// We improperly use name `scalars` for both because this is easier to
  /// visualize than `elements/values/etc.`.
  var scalars: Scalars { get }

  /// Name of the type that uses this implementations (e.g. `str` or `bytes`).
  /// Used in error messages.
  static var typeName: String { get }
  /// Default fill character (for example for `center`).
  static var defaultFill: Element { get }
  /// Fill used by `zfill` function
  static var zFill: Element { get }

  /// Convert value to `UnicodeScalar`.
  ///
  /// Sometimes we will do that when we really need to work on strings
  /// (for example to classify something as whitespace).
  static func toUnicodeScalar(_ element: Element) -> UnicodeScalar
  /// Given a `PyObject` try to extract valid value to use in function.
  ///
  /// For `str`: `Self` will be `str`.
  /// For `bytes`: `Self` will be `bytes`.
  /// Used for example in `find` where you can only `find` homogenous value.
  static func extractSelf(from object: PyObject) -> PyStringImplExtractedSelf<Self>
}

extension PyStringImpl {

  // MARK: - Aliases

  internal typealias Index = Scalars.Index
  internal typealias Element = Scalars.Element
  internal typealias SubSequence = Scalars.SubSequence

  // MARK: - Is(thingie) predicates

  internal static func isWhitespace(_ value: Element) -> Bool {
    let scalar = Self.toUnicodeScalar(value)
    return scalar.properties.isWhitespace
  }

  internal static func isLineBreak(_ value: Element) -> Bool {
    let scalar = Self.toUnicodeScalar(value)
    return Unicode.lineBreaks.contains(scalar)
  }

  // MARK: - Length

  internal var first: Element? {
    return self.scalars.first
  }

  internal var isEmpty: Bool {
    return self.scalars.isEmpty
  }

  internal var any: Bool {
    return !self.isEmpty
  }

  /// This may be `O(n)`, but it is not like we care.
  ///
  /// ```
  /// len("Cafe\u0301") -> 5
  /// len("Café")       -> 4
  /// ```
  internal var count: Int {
    return self.scalars.count
  }

  // MARK: - Helpers

  @available(*, deprecated, message: "Use only for debug")
  private func toString(_ value: Self.Scalars) -> String {
    // swiftlint:disable force_cast
    let view = value as! String.UnicodeScalarView
    return String(view)
  }

  @available(*, deprecated, message: "Use only for debug")
  private func toString(_ value: Self.SubSequence) -> String {
    // swiftlint:disable force_cast
    let view = value as! String.SubSequence.UnicodeScalarView
    return String(view)
  }
}
