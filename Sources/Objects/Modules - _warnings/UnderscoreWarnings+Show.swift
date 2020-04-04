// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

extension UnderscoreWarnings {

  /// https://docs.python.org/3.8/library/warnings.html#warnings.showwarning
  internal func show(warning: Warning) -> PyResult<PyNone> {
    let streamObject = Py.sys.stderr
    guard let stream = streamObject as? PyTextFile else {
      let msg = "'\(streamObject.typeName)' object has no attribute 'write'"
      return .attributeError(msg)
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

    let filename = warning.filename.value
    let lineNo = warning.lineNo.value
    let type = warning.category.getName()

    let content: String
    switch Py.strValue(warning.message) {
    case let .value(c): content = c
    case let .error(e): return .error(e)
    }

    let result = "\(filename):\(lineNo): \(type): \(content)\n"
    return .value(result)
  }
}
