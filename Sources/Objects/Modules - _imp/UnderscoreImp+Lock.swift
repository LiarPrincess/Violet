// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Is held

  internal static let lockHeldDoc = """
    lock_held($module, /)
    --

    Return True if the import lock is currently held, else False.

    On platforms without threads, return False.
    """

  internal static func lock_held(_ py: Py) -> PyResult {
    let result = py._imp.lockHeld()
    return PyResult(result)
  }

  /// static PyObject *
  /// _imp_lock_held_impl(PyObject *module)
  public func lockHeld() -> PyBool {
    assert(Unimplemented.weDoNotHaveThreads)
    return self.py.false
  }

  // MARK: - Acquire

  internal static let acquireLockDoc = """
    acquire_lock($module, /)
    --

    Acquires the interpreter\'s import lock for the current thread.

    This lock should be used by import hooks to ensure thread-safety when importing
    modules. On platforms without threads, this function does nothing.
    """

  internal static func acquire_lock(_ py: Py) -> PyResult {
    py._imp.acquireLock()
    return .none(py)
  }

  /// static PyObject *
  /// _imp_acquire_lock_impl(PyObject *module)
  public func acquireLock() {
    assert(Unimplemented.weDoNotHaveThreads)
  }

  // MARK: - Release

  internal static let releaseLockDoc = """
    release_lock($module, /)
    --

    Release the interpreter\'s import lock.

    On platforms without threads, this function does nothing.
    """

  internal static func release_lock(_ py: Py) -> PyResult {
    py._imp.releaseLock()
    return .none(py)
  }

  /// static PyObject *
  /// _imp_release_lock_impl(PyObject *module)
  public func releaseLock() {
    assert(Unimplemented.weDoNotHaveThreads)
  }
}
