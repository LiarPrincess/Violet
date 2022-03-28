import Foundation
import VioletCore
import VioletObjects

// swiftlint:disable type_name
// swiftformat:disable wrapAttributes
// cSpell:ignore signalmodule sighandler sigflags PyMODINIT

// In CPython:
// Modules -> signalmodule.c
//
// But since we don't have '_signal' module we will do it VM.
// https://docs.python.org/3/library/signal.html
//
// This may be helpful:
// https://www.gnu.org/software/libc/manual/html_node/Signal-Handling.html#Signal-Handling

// MARK: - Global state

private struct WeakBox {
  fileprivate weak var vm: VM?
}

private var vms = [WeakBox]()

private func handleKeyboardInterrupt(signum: Int32) {
  assert(signum == SIGINT)
  for vm in vms {
    vm.vm?.delegate.hasKeyboardInterrupt = true
  }
}

// MARK: - Main

extension VM {

  /// PyMODINIT_FUNC
  /// PyInit__signal(void)
  internal func registerSignalHandlers() -> PySystemError? {
    let box = WeakBox(vm: self)
    vms.append(box)

    switch register(SIGINT, flags: .restart, handler: handleKeyboardInterrupt(signum:)) {
    case .ok:
      break
    case .unsupportedPlatform:
      let message = "Unable to register signal handlers on this platform"
      return self.py.newSystemError(message: message)
    case .error:
      let details = String(errno: errno) ?? "<unknown error>"
      let message = "Unable to set signal handler: \(details)"
      return self.py.newSystemError(message: message)
    }

    return nil
  }
}

// MARK: - Helpers

/// The same as thing as `Foundation.sig_`.
private typealias sighandler_t = @convention(c) (Int32) -> Void

private struct sigflags_t: OptionSet {
  fileprivate let rawValue: Int32

  /// You probably do not need this one.
  static let nocldstop = sigflags_t(rawValue: SA_NOCLDSTOP)
  /// You probably do not need this one.
  static let onstack = sigflags_t(rawValue: SA_ONSTACK)

  /// This flag controls what happens when a signal is delivered during certain
  /// primitives (such as `open`, `read` or `write`),
  /// and the signal handler returns normally.
  ///
  /// There are two alternatives: the library function can resume,
  /// or it can return failure with error code `EINTR`.
  ///
  /// The choice is controlled by the `SA_RESTART` flag for the particular kind
  /// of signal that was delivered.
  /// If the flag is set, returning from a handler resumes the library function.
  /// If the flag is clear, returning from a handler makes the function fail.
  static let restart = sigflags_t(rawValue: SA_RESTART)
}

private enum RegisterResult {
  case ok
  case unsupportedPlatform
  case error
}

private func register(_ signum: Int32,
                      flags: sigflags_t,
                      handler: @escaping sighandler_t) -> RegisterResult {
  var action = sigaction()

  // sighandler_t sa_handler
  // This is used in the same way as the action argument to the signal function.
  // The value can be SIG_DFL, SIG_IGN, or a function pointer.
  #if os(macOS)
  action.__sigaction_u.__sa_handler = handler
  #elseif os(Linux)
  action.__sigaction_handler = .init(sa_handler: handler)
  #else
  return .unsupportedPlatform
  #endif

  // sigset_t sa_mask
  // This specifies a set of signals to be blocked while the handler runs.
  sigemptyset(&action.sa_mask)

  // int32 sa_flags
  // This specifies various flags which can affect the behavior of the signal.
  action.sa_flags = flags.rawValue

  var oldAction = sigaction()
  if sigaction(SIGINT, &action, &oldAction) != 0 {
    return .error
  }

  return .ok
}
