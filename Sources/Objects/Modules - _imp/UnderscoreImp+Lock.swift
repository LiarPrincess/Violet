// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Is held

  internal static var lockHeldDoc: String {
    return """
    lock_held($module, /)
    --

    Return True if the import lock is currently held, else False.

    On platforms without threads, return False.
    """
  }

  /// static PyObject *
  /// _imp_lock_held_impl(PyObject *module)
  public func lockHeld() -> PyBool {
    assert(Unimplemented.weDontHaveThreads)
    return Py.false
  }

  // MARK: - Acquire

  internal static var acquireLockDoc: String {
    return """
    acquire_lock($module, /)
    --

    Acquires the interpreter\'s import lock for the current thread.

    This lock should be used by import hooks to ensure thread-safety when importing
    modules. On platforms without threads, this function does nothing.
    """
  }

  /// static PyObject *
  /// _imp_acquire_lock_impl(PyObject *module)
  public func acquireLock() -> PyObject {
    assert(Unimplemented.weDontHaveThreads)
    return Py.none
  }

  // MARK: - Release

  internal static var releaseLockDoc: String {
    return """
    release_lock($module, /)
    --

    Release the interpreter\'s import lock.

    On platforms without threads, this function does nothing.
    """
  }

  /// static PyObject *
  /// _imp_release_lock_impl(PyObject *module)
  public func releaseLock() -> PyObject {
    assert(Unimplemented.weDontHaveThreads)
    return Py.none
  }
}
