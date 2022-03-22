import BigInt

// swiftlint:disable type_name
// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c

/// Given a `PyObject` we try to extract a valid collection to use in
/// one of the functions mentioned in type name.
internal enum AbstractStringElementsForFindCountContainsIndexOf<T> {
  case value(T)
  case invalidObjectType
  case error(PyBaseException)
}

/// Mixin with (almost) all of the `str/bytes/bytearray` methods.
/// Everything here is 'best-effort' because strings are hard.
///
/// DO NOT use them outside of the `str/bytes/bytearray` objects!
internal protocol AbstractString: PyObjectMixin {

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

  /// Swift type representing element type:
  /// - `str` for `str`
  /// - `int` for `bytes` and `bytearray`
  associatedtype ElementType: PyObjectMixin

  // MARK: - Properties

  /// Name of the type that uses this implementations (e.g. `str` or `bytes`).
  /// Used in error messages.
  static var pythonTypeName: String { get }

  // Main requirement.
  var elements: Elements { get }
  // We also need 'count' because 'String.unicodeScalars.count' is O(n).
  // (yes, on EVERY call!)
  //
  // So never, ever, use 'self.elements.count', use 'self.count'!
  var count: Int { get }

  // MARK: - Unicode

  static func isWhitespace(element: Element) -> Bool
  static func isLineBreak(element: Element) -> Bool
  static func isAlphaNumeric(element: Element) -> Bool
  static func isAlpha(element: Element) -> Bool
  static func isAscii(element: Element) -> Bool
  static func isDigit(element: Element) -> Bool
  static func isLower(element: Element) -> Bool
  static func isUpper(element: Element) -> Bool
  static func isTitle(element: Element) -> Bool
  /// Do you even case, bro?
  static func isCased(element: Element) -> Bool

  /// Is this `+` or `-` (`0x2B` and `0x2D` in ASCII respectively).
  /// Used inside `zfill`.
  static func isPlusOrMinus(element: Element) -> Bool
  /// Is this `HT` (`0x09` in ASCII)?
  /// Used inside `expandTabs`.
  static func isHorizontalTab(element: Element) -> Bool
  /// Is this `CR` (`0x0D` in ASCII)?
  /// Used inside `splitLines`.
  static func isCarriageReturn(element: Element) -> Bool
  /// Is this `LF` (`0x0A` in ASCII)?
  /// Used inside `splitLines`.
  static func isLineFeed(element: Element) -> Bool

  static func lowercaseMapping(element: Element) -> CaseMapping
  static func uppercaseMapping(element: Element) -> CaseMapping
  static func titlecaseMapping(element: Element) -> CaseMapping
  // casefold is only on 'str', not on 'bytes'

  // MARK: - Fill

  /// Default fill character (for example for `center`).
  static var defaultFill: Element { get }
  /// Fill used by `zfill` function
  static var zFill: Element { get }

  // MARK: - Elements, builder -> Object

  /// `str` for `str`; `int` for `bytes` and `bytearray`
  static func newObject(_ py: Py, element: Element) -> ElementType
  static func newObject(_ py: Py, elements: Elements) -> Self
  static func newObject(_ py: Py, elements: Elements.SubSequence) -> Self
  static func newObject(_ py: Py, result: Builder.Result) -> Self

  // MARK: - Object -> Element(s)

  /// Given a `PyObject` we try to extract a valid `Elements`.
  ///
  /// Intended use:
  /// - `str` -> return elements if `object` is `str`.
  /// - `bytes/bytearray` -> return elements if `object` is `bytes/bytearray`.
  static func getElements(_ py: Py, object: PyObject) -> Elements?

  /// Given a `PyObject` we try to extract a valid `Elements` to use in
  /// one of the functions mentioned in function name.
  ///
  /// Basically the same as `getElements(object:)`, but for `bytes/bytearray`
  /// will also handle `int` (`69 in b'Elsa'` -> `True`).
  static func getElementsForFindCountContainsIndexOf(
    _ py: Py,
    object: PyObject
  ) -> AbstractStringElementsForFindCountContainsIndexOf<Elements>

  /// Convert `object` to this type.
  ///
  /// - For `tuple` it should return `tuple`.
  /// - For `list` it should return `list`.
  static func downcast(_ py: Py, _ object: PyObject) -> Self?
}

// MARK: - Common things

extension AbstractString {

  /// Type returned by all of the case mapping functions.
  ///
  /// It has to be a collection because some scalars may have mapping that
  /// contains more than 1 scalar.
  /// For example: lowercase `“İ” (U+0130 LATIN CAPITAL LETTER I WITH DOT ABOVE)`
  /// becomes `U+0069 LATIN SMALL LETTER I` and `U+0307 COMBINING DOT ABOVE`.
  internal typealias CaseMapping = Builder.CaseMapping

  /// In some algorithms we require `UnicodeScalars` to conform to
  /// `RandomAccessCollection`, but they don't.
  /// In such places call this method, so we know to check them later.
  ///
  /// If we ever solve this, then remove this method, so that every function
  /// that uses it fails to compile.
  ///
  /// Btw. In reality it is no that bad. All of the `String` indices we are using
  /// are trivially scalar-aligned, which makes them a bit faster.
  internal static func wouldBeBetterWithRandomAccessCollection() {}

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
