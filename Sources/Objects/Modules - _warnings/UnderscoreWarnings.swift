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
  internal let __dict__: PyDict
  internal let py: Py

  // MARK: - Init

  internal init(_ py: Py) {
    self.py = py
    self.__dict__ = self.py.newDict()
    self.fill__dict__()
  }

  // MARK: - Fill dict

  private func fill__dict__() {
    let filters = self.createInitialFilters()
    let defaultAction = self.py.newString("default")
    let onceRegistry = self.py.newDict()
    self.setOrTrap(.filters, value: filters.asObject)
    self.setOrTrap(._defaultaction, value: defaultAction.asObject)
    self.setOrTrap(._onceregistry, value: onceRegistry.asObject)

    self.setOrTrap(.warn, doc: Self.warnDoc, fn: Self.warn(_:args:kwargs:))
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
