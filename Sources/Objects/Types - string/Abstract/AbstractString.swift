import BigInt

// swiftlint:disable type_name
// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c

/// Given a `PyObject` we try to extract a valid collection to use in
/// one of the functions mentioned in type name.
  internal enum AbstractString_ElementsForFindCountContainsIndexOf<T> {
    case value(T)
    case invalidObjectType
    case error(PyBaseException)
  }

/// Mixin with (almost) all of the `str/bytes/bytearray` methods.
/// Everything here is 'best-effort' because strings are hard.
///
/// All of the methods/properties should be prefixed with `_`.
/// DO NOT use them outside of the `str/bytes/bytearray` objects!
internal protocol AbstractString: PyObject {

  // MARK: - Types

  // All of the things in this protocol will get table-based dispatch.
  // This is 'meh', but acceptable.
  // What counts, is that the extensions will have static dispatch.

  /// - `Comparable` because we need to implement `__eq__`, `__lt__` etc.
  /// - `Hashable` - not needed, but gives us  O(1) `strip` lookups.
  associatedtype Element where Element: Comparable, Element: Hashable
  /// `UnicodeScalarView` for `str` and `Data` for `bytes`.
  ///
  /// - `Bidirectional` because we need to iterate backwards for `rfind` etc.
  associatedtype Elements: BidirectionalCollection where Elements.Element == Element
  /// See `StringBuilderType` documentation.
  /// `Builder.Result` is abstract and we will never touch it.
  associatedtype Builder: StringBuilderType where Builder.Elements == Elements

  /// Swift type representing this type (not exactly `Self`).
  associatedtype SwiftType: PyObject
  /// Swift type representing element type:
  /// - `str` for `str`
  /// - `int` for `bytes` and `bytearray`
  associatedtype ElementSwiftType: PyObject

  // MARK: - Properties

  /// Name of the type that uses this implementations (e.g. `str` or `bytes`).
  /// Used in error messages.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static var _pythonTypeName: String { get }

  var elements: Elements { get }

  // MARK: - Properties

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isWhitespace(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isLineBreak(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isAlphaNumeric(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isAlpha(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isAscii(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isDigit(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isLower(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isUpper(element: Element) -> Bool
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isTitle(element: Element) -> Bool
  /// Do you even case, bro?
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _isCased(element: Element) -> Bool

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _lowercaseMapping(element: Element) -> CaseMapping
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _uppercaseMapping(element: Element) -> CaseMapping
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _titlecaseMapping(element: Element) -> CaseMapping
  // casefold is only on 'str', not on 'bytes'

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _asUnicodeScalar(element: Element) -> UnicodeScalar

  // MARK: - Fill

  /// Default fill character (for example for `center`).
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static var _defaultFill: Element { get }
  /// Fill used by `zfill` function
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static var _zFill: Element { get }

  // MARK: - Elements, builder -> Object

  /// `str` for `str`; `int` for `bytes` and `bytearray`
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _toObject(element: Element) -> ElementSwiftType
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _toObject(elements: Elements) -> SwiftType
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _toObject(elements: Elements.SubSequence) -> SwiftType
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _toObject(result: Builder.Result) -> SwiftType

  // MARK: - Object -> Elements

  /// Given a `PyObject` we try to extract a valid `Elements`.
  ///
  /// Intended use:
  /// - `str` -> return elements if `other` is `str`.
  /// - `bytes/bytearray` -> return elements if `other` is `bytes/bytearray`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _getElements(object: PyObject) -> Elements?

  /// Given a `PyObject` we try to extract a valid `Elements` to use in
  /// one of the function mentioned in type name.
  ///
  /// Basically the same as `_getElements(object:)`, but for `bytes/bytearray`
  /// will also handle `int` (`69 in b'Elsa'` -> `True`).
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  static func _getElementsForFindCountContainsIndexOf(
    object: PyObject
  ) -> AbstractString_ElementsForFindCountContainsIndexOf<Elements>
}

// MARK: - Common things

extension AbstractString {

  /// Type returned by all of the case mapping functions.
  ///
  /// It has to be a collection because some scalars may have mapping that
  /// contains more than 1 scalar.
  /// For example: lowercase `“İ” (U+0130 LATIN CAPITAL LETTER I WITH DOT ABOVE)`
  /// becomes `U+0069 LATIN SMALL LETTER I` and `U+0307 COMBINING DOT ABOVE`.
  internal typealias CaseMapping = Builder.Elements

  /// This may be `O(n)`, but it is not like we care.
  ///
  /// ```
  /// len("Cafe\u0301") -> 5
  /// len("Café")       -> 4
  /// ```
  internal var _length: BigInt {
    let result = self.elements.count
    return BigInt(result)
  }

  /// In some algorithms we require `UnicodeScalars` to conform to conform to
  /// `RandomAccessCollection`, but they don't.
  /// In such places call this method, so we know to check them later.
  ///
  /// If we ever solve this, then remove this method, so that every function
  /// that uses it fails to compile.
  internal func _wouldBeBetterWithRandomAccessCollection() { }
}
