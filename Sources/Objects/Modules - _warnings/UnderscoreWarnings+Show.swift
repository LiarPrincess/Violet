// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

extension UnderscoreWarnings {

  /// https://docs.python.org/3.8/library/warnings.html#warnings.showwarning
  internal func show(warning: Warning) -> PyResult<PyNone> {
    let stream: PyTextFile
    switch Py.sys.getStderr() {
    case let .value(s): stream = s
    case let .error(e): return .error(e)
    }

    let content: String
    switch self.format(warning: warning) {
    case let .value(c): content = c
    case let .error(e): return .error(e)
    }

    return stream.write(string: content)
  }

  /// https://docs.python.org/3.8/library/warnings.html#warnings.formatwarning
  private func format(warning: Warning) -> PyResult<String> {
    // >>> import warnings
    // >>> warnings.formatwarning('message', UserWarning, 'file', 1, 'line')
    // 'file:1: UserWarning: message\n  line\n'
    // >>> warnings.formatwarning('message', UserWarning, 'file', 1)
    // 'file:1: UserWarning: message\n'

    // Or you can do this:
    // >>> import _warnings
    // >>> _warnings.warn('Elsa')
    // __main__:1: UserWarning: Elsa
    // >>> _warnings.warn(ImportWarning)
    // __main__:1: UserWarning: <class 'ImportWarning'>

    let filename = warning.filename.value
    let lineNo = warning.lineNo.value
    let type = warning.category.getName()

    let content: String
    switch Py.strValue(warning.text) {
    case let .value(c): content = c
    case let .error(e): return .error(e)
    }

    let result = "\(filename):\(lineNo): \(type): \(content)\n"
    return .value(result)
  }
}