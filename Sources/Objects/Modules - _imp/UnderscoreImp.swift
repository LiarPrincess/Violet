// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

/// (Extremely) low-level import machinery bits as used by importlib and imp.
/// Nuff said...
public final class UnderscoreImp: PyModuleImplementation {

  internal static let moduleName = "_imp"

  internal static let doc = """
    (Extremely) low-level import machinery bits as used by importlib and imp.
    """

  // MARK: - Properties

  /// This dict will be used inside our `PyModule` instance.
  public let __dict__ = Py.newDict()

  // MARK: - Init

  internal init() {
    self.fill__dict__()
  }

  // MARK: - Fill dict

  // swiftlint:disable:next function_body_length
  private func fill__dict__() {
    // Not that capturing 'self' is intended.
    // See comment at the top of 'PyModuleImplementation' for details.
    self.setOrTrap(.lock_held,
                   doc: UnderscoreImp.lockHeldDoc,
                   fn: self.lockHeld)
    self.setOrTrap(.acquire_lock,
                   doc: UnderscoreImp.acquireLockDoc,
                   fn: self.acquireLock)
    self.setOrTrap(.release_lock,
                   doc: UnderscoreImp.releaseLockDoc,
                   fn: self.releaseLock)
    self.setOrTrap(.is_builtin,
                   doc: UnderscoreImp.isBuiltinDoc,
                   fn: self.isBuiltin)
    self.setOrTrap(.create_builtin,
                   doc: UnderscoreImp.createBuiltinDoc,
                   fn: self.createBuiltin)
    self.setOrTrap(.exec_builtin,
                   doc: UnderscoreImp.execBuiltinDoc,
                   fn: self.execBuiltin)
    self.setOrTrap(.is_frozen,
                   doc: UnderscoreImp.isFrozenDoc,
                   fn: self.isFrozen)
    self.setOrTrap(.is_frozen_package,
                   doc: UnderscoreImp.isFrozenPackageDoc,
                   fn: self.isFrozenPackage)
    self.setOrTrap(.get_frozen_object,
                   doc: UnderscoreImp.getFrozenObjectDoc,
                   fn: self.getFrozenObject)
    self.setOrTrap(.init_frozen,
                   doc: UnderscoreImp.initFrozenDoc,
                   fn: self.initFrozen)
    self.setOrTrap(.create_dynamic,
                   doc: UnderscoreImp.createDynamicDoc,
                   fn: self.createDynamic)
    self.setOrTrap(.exec_dynamic,
                   doc: UnderscoreImp.execDynamicDoc,
                   fn: self.execDynamic)
    self.setOrTrap(.source_hash,
                   doc: UnderscoreImp.sourceHashDoc,
                   fn: self.sourceHash)
    self.setOrTrap(.check_hash_based_pycs,
                   doc: UnderscoreImp.checkHashBasedPycsDoc,
                   fn: self.checkHashBasedPycs)
    self.setOrTrap(._fix_co_filename,
                   doc: UnderscoreImp.fixCoFilenameDoc,
                   fn: self.fixCoFilename)
    self.setOrTrap(.extension_suffixes,
                   doc: UnderscoreImp.extensionSuffixesDoc,
                   fn: self.extensionSuffixes)
  }

  // MARK: - Spec helpers

  internal func getName(spec: PyObject) -> PyResult<PyString> {
    switch Py.getAttribute(spec, name: .name) {
    case let .value(object):
      guard let str = object as? PyString else {
        return .typeError("Module name must be a str, not \(object.typeName)")
      }

      return .value(str)

    case let .error(e):
      return .error(e)
    }
  }

  internal func getPath(spec: PyObject) -> PyResult<PyString> {
    switch Py.getAttribute(spec, name: .origin) {
    case let .value(object):
      guard let str = object as? PyString else {
        return .typeError("Module origin must be a str, not \(object.typeName)")
      }

      return .value(str)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Properties

  internal struct Properties: CustomStringConvertible {

    internal static let lock_held = Properties(value: "lock_held")
    internal static let acquire_lock = Properties(value: "acquire_lock")
    internal static let release_lock = Properties(value: "release_lock")
    internal static let is_builtin = Properties(value: "is_builtin")
    internal static let create_builtin = Properties(value: "create_builtin")
    internal static let exec_builtin = Properties(value: "exec_builtin")
    internal static let is_frozen = Properties(value: "is_frozen")
    internal static let is_frozen_package = Properties(value: "is_frozen_package")
    internal static let get_frozen_object = Properties(value: "get_frozen_object")
    internal static let init_frozen = Properties(value: "init_frozen")
    internal static let create_dynamic = Properties(value: "create_dynamic")
    internal static let exec_dynamic = Properties(value: "exec_dynamic")
    internal static let source_hash = Properties(value: "source_hash")
    internal static let check_hash_based_pycs =
      Properties(value: "check_hash_based_pycs")
    internal static let _fix_co_filename =
      Properties(value: "_fix_co_filename")
    internal static let extension_suffixes =
      Properties(value: "extension_suffixes")

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
