import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

public final class Sys {

  internal unowned let context: PyContext

  internal var builtins: Builtins {
    return self.context.builtins
  }

  // MARK: - Init

  /// Stage 1: Create all objects
  internal init(context: PyContext) {
    self.context = context
  }

  /// Stage 2: Fill type objects
  internal func onContextFullyInitailized() { }

  // MARK: - Deinit

  internal func onContextDeinit() { }
}
