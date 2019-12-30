import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

public final class Sys {

  // MARK: - Prompt values

  private var _ps1: PyObject?
  private var _ps2: PyObject?

  public var ps1: PyObject {
    get { return self._ps1 ?? self.context.intern(">>> ") }
    set { self._ps1 = newValue }
  }

  public var ps2: PyObject {
    get { return self._ps2 ?? self.context.intern("... ") }
    set { self._ps2 = newValue }
  }

  /// String that should be printed in interactive mode.
  public var ps1String: String {
    switch self.builtins.strValue(self.ps1) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  /// String that should be printed in interactive mode.
  public var ps2String: String {
    switch self.builtins.strValue(self.ps2) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  // MARK: - Platform

  private var _platform: PyObject?

  public lazy var platform: PyObject = {
    if let p = self._platform {
      return p
    }

    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    let name = "darwin"
    #elseif os(Linux) || os(Android)
    let name = "linux"
    #elseif os(Cygwin) // Is this even a thing?
    let name = "cygwin"
    #elseif os(Windows)
    let name = "win32"
    #else
    let name = "unknown"
    #endif

    return self.context.intern(name)
  }()

  // MARK: - Context

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
