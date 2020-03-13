import Core

// In CPython:
// Python -> import.c

extension UnderscoreImp {

  // MARK: - Frozen

  internal static var isFrozenDoc: String {
    return """
    is_frozen($module, name, /)
    --

    Returns True if the module name corresponds to a frozen module.
    """
  }

  // sourcery: pymethod = is_frozen, doc = isFrozenDoc
  public func isFrozen() -> PyObject {
    self.unimplemented()
  }

  internal static var getFrozenObjectDoc: String {
    return """
    get_frozen_object($module, name, /)
    --

    Create a code object for a frozen module.
    """
  }

  // sourcery: pymethod = get_frozen_object, doc = getFrozenObjectDoc
  public func getFrozenObject() -> PyObject {
    self.unimplemented()
  }

  internal static var initFrozenDoc: String {
    return """
    init_frozen($module, name, /)
    --

    Initializes a frozen module.
    """
  }

  // sourcery: pymethod = init_frozen, doc = initFrozenDoc
  public func initFrozen() -> PyObject {
    self.unimplemented()
  }

  internal static var isFrozenPackageDoc: String {
    return """
    is_frozen_package($module, name, /)
    --

    Returns True if the module name is of a frozen package.
    """
  }

  // sourcery: pymethod = is_frozen_package, doc = isFrozenPackageDoc
  public func isFrozenPackage() -> PyObject {
    self.unimplemented()
  }

  // MARK: - Dynamic

  internal static var createDynamicDoc: String {
    return """
    create_dynamic($module, spec, file=None, /)
    --

    Create an extension module.
    """
  }

  // sourcery: pymethod = create_dynamic, doc = createDynamicDoc
  public func createDynamic() -> PyObject {
    self.unimplemented()
  }

  internal static var execDynamicDoc: String {
    return """
    exec_dynamic($module, mod, /)
    --

    Initialize an extension module.
    """
  }

  // sourcery: pymethod = exec_dynamic, doc = execDynamicDoc
  public func execDynamic() -> PyObject {
    self.unimplemented()
  }

  // MARK: - Lock

  internal static var lockHeldDoc: String {
    return """
    lock_held($module, /)
    --

    Return True if the import lock is currently held, else False.

    On platforms without threads, return False.
    """
  }

  // sourcery: pymethod = lock_held, doc = lockHeldDoc
  public func lockHeld() -> PyObject {
    self.unimplemented()
  }

  internal static var acquireLockDoc: String {
    return """
    acquire_lock($module, /)
    --

    Acquires the interpreter\'s import lock for the current thread.

    This lock should be used by import hooks to ensure thread-safety when importing
    modules. On platforms without threads, this function does nothing.
    """
  }

  // sourcery: pymethod = acquire_lock, doc = acquireLockDoc
  public func acquireLock() -> PyObject {
    self.unimplemented()
  }

  internal static var releaseLockDoc: String {
    return """
    release_lock($module, /)
    --

    Release the interpreter\'s import lock.

    On platforms without threads, this function does nothing.
    """
  }

  // sourcery: pymethod = release_lock, doc = releaseLockDoc
  public func releaseLock() -> PyObject {
    self.unimplemented()
  }

  // MARK: - Hash

  internal static var sourceHashDoc: String {
    return """
    source_hash($module, /, key, source)
    --
    """
  }

  // sourcery: pymethod = source_hash, doc = sourceHashDoc
  public func sourceHash() -> PyObject {
    self.unimplemented()
  }

  internal static var checkHashBasedPycsDoc: String {
    return ""
  }

  // sourcery: pymethod = check_hash_based_pycs, doc = checkHashBasedPycsDoc
  public func checkHashBasedPycs() -> PyObject {
    self.unimplemented()
  }

  // MARK: - Other

  internal static var fixCoFilenameDoc: String {
    return """
    _fix_co_filename($module, code, path, /)
    --

    Changes code.co_filename to specify the passed-in file path.

    code
    Code object to change.
    path
    File path to use.
    """
  }

  // sourcery: pymethod = _fix_co_filename, doc = fixCoFilenameDoc
  public func fixCoFilename() -> PyObject {
    self.unimplemented()
  }

  internal static var extensionSuffixesDoc: String {
    return """
    extension_suffixes($module, /)
    --

    Returns the list of file suffixes used to identify extension modules.
    """
  }

  // sourcery: pymethod = extension_suffixes, doc = extensionSuffixesDoc
  public func extensionSuffixes() -> PyObject {
    self.unimplemented()
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: String = #function) -> Never {
    trap("'\(fn)' is not implemented")
  }
}
