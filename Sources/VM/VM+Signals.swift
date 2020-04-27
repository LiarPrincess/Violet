import VioletCore
import VioletObjects
import Foundation

/// We can't store this in VM because we can't access closure variables
/// in functions marked with '@convention(c)'.
internal var hasKeyboardInterrupt = false

extension VM {

  internal func registerSignalHandlers() -> PyBaseException? {
    return self.registerKeyboardInterruptHandler()
  }

  /// Register handler that will be fired when user presses 'Ctrl+C' (SIGINT)
  /// while executing Python code.
  ///
  /// From 'Modules/signalmodule.c':
  /// 'PyInit__signal(void)' sets 'SIGINT' handler to
  /// 'signal_default_int_handler(PyObject *self, PyObject *args)'.
  ///
  /// But since we don't have '_signal' module we will do it here.
  /// https://docs.python.org/3/library/signal.html
  private func registerKeyboardInterruptHandler() -> PyBaseException? {
    let handler: @convention(c) (Int32) -> Void = { num in
      assert(num == SIGINT)
      hasKeyboardInterrupt = true
    }

    var action = sigaction()
    #if os(macOS)
    action.__sigaction_u.__sa_handler = handler
    #elseif os(Linux)
    action.__sigaction_handler = .init(sa_handler: cHandler)
    #else
    let msg = "Unable to register SIGINT handler on this platform"
    return Py.newSystemError(msg: msg)
    #endif

    sigemptyset(&action.sa_mask)
    action.sa_flags = 0

    var oldAction = sigaction()
    if sigaction(SIGINT, &action, &oldAction) != 0 {
      let details = String(errno: errno) ?? "<unknown error>"
      let msg = "Unable to set SIGINT handler: \(details)"
      return Py.newSystemError(msg: msg)
    }

    return nil
  }
}
