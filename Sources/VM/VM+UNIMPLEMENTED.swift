import Objects
import Bytecode

extension VM {

  // MARK: - Import

  /// PyImport_ImportModule
  internal func importModule(_ name: String) -> PyModule {
    return Py.builtinsModule
  }
}
