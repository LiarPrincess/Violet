// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

/// (Extremely) low-level import machinery bits as used by importlib and imp.
/// Nuff said…
public final class UnderscoreImp: PyModuleImplementation {

  internal static let moduleName = "_imp"

  internal static let doc = """
    (Extremely) low-level import machinery bits as used by importlib and imp.
    """

  /// This dict will be used inside our `PyModule` instance.
  internal let __dict__: PyDict
  internal let py: Py

  internal init(_ py: Py) {
    self.py = py
    self.__dict__ = self.py.newDict()
    self.fill__dict__()
  }

  // MARK: - Fill dict

  private func fill__dict__() {
    // swiftlint:disable line_length
    self.setOrTrap(.lock_held, doc: Self.lockHeldDoc, fn: Self.lock_held(_:))
    self.setOrTrap(.acquire_lock, doc: Self.acquireLockDoc, fn: Self.acquire_lock(_:))
    self.setOrTrap(.release_lock, doc: Self.releaseLockDoc, fn: Self.release_lock(_:))

    self.setOrTrap(.is_builtin, doc: Self.isBuiltinDoc, fn: Self.is_builtin(_:name:))
    self.setOrTrap(.create_builtin, doc: Self.createBuiltinDoc, fn: Self.create_builtin(_:spec:))
    self.setOrTrap(.exec_builtin, doc: Self.execBuiltinDoc, fn: Self.exec_builtin(_:mod:))

    self.setOrTrap(.is_frozen, doc: Self.isFrozenDoc, fn: Self.is_frozen(_:name:))
    self.setOrTrap(.is_frozen_package, doc: Self.isFrozenPackageDoc, fn: Self.is_frozen_package(_:name:))
    self.setOrTrap(.get_frozen_object, doc: Self.getFrozenObjectDoc, fn: Self.get_frozen_object(_:name:))
    self.setOrTrap(.init_frozen, doc: Self.initFrozenDoc, fn: Self.init_frozen(_:name:))

    self.setOrTrap(.create_dynamic, doc: Self.createDynamicDoc, fn: Self.create_dynamic(_:spec:file:))
    self.setOrTrap(.exec_dynamic, doc: Self.execDynamicDoc, fn: Self.exec_dynamic(_:mode:))

    self.setOrTrap(.source_hash, doc: Self.sourceHashDoc, fn: Self.source_hash(_:key:source:))
    self.setOrTrap(.check_hash_based_pycs, doc: Self.checkHashBasedPycsDoc, fn: Self.check_hash_based_pycs(_:))
    self.setOrTrap(._fix_co_filename, doc: Self.fixCoFilenameDoc, fn: Self._fix_co_filename(_:code:path:))
    self.setOrTrap(.extension_suffixes, doc: Self.extensionSuffixesDoc, fn: Self.extension_suffixes(_:))
    // swiftlint:enable line_length
  }

  // MARK: - Spec helpers

  internal func getName(spec: PyObject) -> PyResultGen<PyString> {
    switch self.py.getAttribute(object: spec, name: .name) {
    case let .value(object):
      guard let str = self.py.cast.asString(object) else {
        return .typeError(self.py, message: "Module name must be a str, not \(object.typeName)")
      }

      return .value(str)

    case let .error(e):
      return .error(e)
    }
  }

  internal func getPath(spec: PyObject) -> PyResultGen<PyString> {
    switch self.py.getAttribute(object: spec, name: .origin) {
    case let .value(object):
      guard let str = self.py.cast.asString(object) else {
        return .typeError(self.py, message: "Module origin must be a str, not \(object.typeName)")
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
    internal static let check_hash_based_pycs = Properties(value: "check_hash_based_pycs")
    internal static let _fix_co_filename = Properties(value: "_fix_co_filename")
    internal static let extension_suffixes = Properties(value: "extension_suffixes")

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
