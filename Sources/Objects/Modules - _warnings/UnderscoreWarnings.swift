/* MARKER
// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

/// Basic warning filtering support.
///
/// It is a helper module to speed up interpreter start-up.
public final class UnderscoreWarnings: PyModuleImplementation {

  internal static let moduleName = "_warnings"

  internal static let doc = """
    _warnings provides basic warning filtering support.
    It is a helper module to speed up interpreter start-up.
    """

  // MARK: - Properties

  /// This dict will be used inside our `PyModule` instance.
  public let __dict__ = Py.newDict()

  // MARK: - Init

  internal init() {
    self.fill__dict__()
  }

  // MARK: - Fill dict

  private func fill__dict__() {
    self.setOrTrap(.filters, to: self.createInitialFilters())
    self.setOrTrap(._defaultaction, to: Py.newString("default"))
    self.setOrTrap(._onceregistry, to: Py.newDict())

    // Note that capturing 'self' is intended.
    // See comment at the top of 'PyModuleImplementation' for details.
    self.setOrTrap(.warn, doc: Self.warnDoc, fn: self.warn(args:kwargs:))
  }

  // MARK: - Properties

  internal struct Properties: CustomStringConvertible {

    internal static let filters = Properties(value: "filters")
    internal static let _defaultaction = Properties(value: "_defaultaction")
    internal static let _onceregistry = Properties(value: "_onceregistry")
    internal static let warn = Properties(value: "warn")

    private let value: String

    internal var description: String {
      return self.value
    }

    // Private so we can't create new values from the outside.
    private init(value: String) {
      self.value = value
    }
  }
}

*/