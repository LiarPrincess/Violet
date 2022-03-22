// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

extension UnderscoreWarnings {

  /// https://docs.python.org/3.8/library/warnings.html#warnings.showwarning
  internal func show(warning: Warning) -> PyBaseException? {
    let stream: PyTextFile
    switch self.py.sys.getStderr() {
    case let .value(s): stream = s
    case let .error(e): return e
    }

    let content: String
    switch self.format(warning: warning) {
    case let .value(c): content = c
    case let .error(e): return e
    }

    return stream.write(self.py, string: content)
  }

  /// https://docs.python.org/3.8/library/warnings.html#warnings.formatwarning
  private func format(warning: Warning) -> PyResultGen<String> {
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
    let category = warning.category.getNameString()

    let content: String
    switch self.py.strString(warning.text) {
    case let .value(c): content = c
    case let .error(e): return .error(e)
    }

    let result = "\(filename):\(lineNo): \(category): \(content)\n"
    return .value(result)
  }
}
