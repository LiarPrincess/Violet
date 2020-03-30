import Core
import Objects

extension VM {

  /// PyImport_ImportModule
  internal func importModule(_ name: String) -> PyModule {
    return Py.builtinsModule
  }

  internal func unhandled(error: PyBaseException) -> Never {
    trap("Unhandled: \(error)")
  }

  internal func unimplemented(fn: StaticString = #function) -> Never {
    trap("Unimplemented '\(fn)'.")
  }
}
