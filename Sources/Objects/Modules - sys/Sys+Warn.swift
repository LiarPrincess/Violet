import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // sourcery: pyproperty = warnoptions
  internal var warnOptions: PyObject {
    if let value = self.get(key: .warnoptions) {
      return value
    }

    let strings = self.createDefaultWarnOptions()
    let objects = strings.map(Py.newString(_:))
    return Py.newList(objects)
  }

  /// static _PyInitError
  /// config_init_warnoptions(_PyCoreConfig *config, _PyCmdline *cmdline)
  ///
  /// Then:
  /// 1. It is moved to '_PyMainInterpreterConfig' (in '_PyMainInterpreterConfig_Read')
  /// 2. Set as 'sys.warnoptions' (in _PySys_EndInit)
  private func createDefaultWarnOptions() -> [String] {
    var result = [String]()

    let options = self.flags.warnings
    let filters = options.map(String.init(describing:))
    result.append(contentsOf: filters)

    switch self.flags.bytesWarning {
    case .ignore:
      break
    case .warning:
      result.append("default::BytesWarning")
    case .error:
      result.append("error::BytesWarning")
    }

    return result
  }
}
