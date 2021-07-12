import VioletCore

// swiftlint:disable file_length
// cSpell:ignore uxxxx Uxxxxxxxx

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Repr

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  public func repr(object: PyObject) -> PyResult<PyString> {
    switch self.reprImpl(object: object) {
    case .string(let s):
      let py = Py.newString(s)
      return .value(py)
    case .pyString(let s):
      return .value(s)
    case .methodReturnedNonString(let o):
      let e = self.createReprReturnedNonStringError(object: o)
      return .error(e)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  public func reprString(object: PyObject) -> PyResult<String> {
    switch self.reprImpl(object: object) {
    case .string(let s):
      return .value(s)
    case .pyString(let s):
      return .value(s.value)
    case .methodReturnedNonString(let o):
      let e = self.createReprReturnedNonStringError(object: o)
      return .error(e)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private enum ReprImplResult {
    /// Result of the static call
    case string(String)
    /// Result of the dynamic call
    case pyString(PyString)
    /// When the dynamic call returns non-string
    case methodReturnedNonString(PyObject)
    case notCallable(PyBaseException)
    case error(PyBaseException)
  }

  private func reprImpl(object: PyObject) -> ReprImplResult {
    if let result = Fast.__repr__(object) {
      switch result {
      case let .value(s):
        return .string(s)
      case let .error(e):
        return .error(e)
      }
    }

    switch self.callMethod(object: object, selector: .__repr__) {
    case let .value(result):
      guard let pyString = PyCast.asString(result) else {
        return .methodReturnedNonString(result)
      }

      return .pyString(pyString)

    case .missingMethod:
      let generic = self.genericRepr(object: object)
      return .string(generic)

    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  private func createReprReturnedNonStringError(object: PyObject) -> PyBaseException {
    let type = object.typeName
    return Py.newTypeError(msg: "__repr__ returned non-string (\(type))")
  }

  // MARK: - Repr or generic

  /// Get object `__repr__`, if that fails then use generic representation.
  ///
  /// This is mostly for error messages, where we have to use _something_.
  public func reprOrGeneric(object: PyObject) -> PyString {
    switch self.reprImpl(object: object) {
    case .string(let s):
      return Py.newString(s)
    case .pyString(let s):
      return s
    case .methodReturnedNonString,
         .error,
         .notCallable:
      let generic = self.genericRepr(object: object)
      return Py.newString(generic)
    }
  }

  /// Get object `__repr__`, if that fails then use generic representation.
  ///
  /// This is mostly for error messages, where we have to use _something_.
  public func reprOrGenericString(object: PyObject) -> String {
    switch self.reprImpl(object: object) {
    case .string(let s):
      return s
    case .pyString(let s):
      return s.value
    case .methodReturnedNonString,
         .error,
         .notCallable:
      return self.genericRepr(object: object)
    }
  }

  private func genericRepr(object: PyObject) -> String {
    return "<\(object.typeName) object at \(object.ptr)>"
  }

  // MARK: - Str

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func str(object: PyObject) -> PyResult<PyString> {
    switch self.strImpl(object: object) {
    case .reprLock:
      return .value(Py.emptyString)
    case .string(let s):
      let py = Py.newString(s)
      return .value(py)
    case .pyString(let s):
      return .value(s)
    case .methodReturnedNonString(let o):
      return .typeError("__str__ returned non-string (\(o.typeName))")
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func strString(object: PyObject) -> PyResult<String> {
    switch self.strImpl(object: object) {
    case .reprLock:
      return .value("")
    case .string(let s):
      return .value(s)
    case .pyString(let s):
      return .value(s.value)
    case .methodReturnedNonString(let o):
      return .typeError("__str__ returned non-string (\(o.typeName))")
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  private enum StrImplResult {
    case reprLock
    /// Result of the static call
    case string(String)
    /// Result of the dynamic call
    case pyString(PyString)
    /// When the dynamic call returns non-string
    case methodReturnedNonString(PyObject)
    case notCallable(PyBaseException)
    case error(PyBaseException)

    fileprivate init(repr: ReprImplResult) {
      switch repr {
      case let .string(s): self = .string(s)
      case let .pyString(s): self = .pyString(s)
      case let .methodReturnedNonString(o): self = .methodReturnedNonString(o)
      case let .notCallable(e): self = .notCallable(e)
      case let .error(e): self = .error(e)
      }
    }
  }

  private func strImpl(object: PyObject) -> StrImplResult {
    if object.hasReprLock {
      return .reprLock
    }

    // If we do not override '__str__' then we have to use '__repr__'.
    guard self.hasCustom__str__(object: object) else {
      let repr = self.reprImpl(object: object)
      return StrImplResult(repr: repr)
    }

    if let result = Fast.__str__(object) {
      switch result {
      case let .value(s): return .string(s)
      case let .error(e): return .error(e)
      }
    }

    switch self.callMethod(object: object, selector: .__str__) {
    case let .value(result):
      guard let pyString = PyCast.asString(result) else {
        return .methodReturnedNonString(result)
      }

      return .pyString(pyString)

    case .missingMethod:
      // Hmm… we checked that we have custom '__str__', so we should not end up here
      let repr = self.reprImpl(object: object)
      return StrImplResult(repr: repr)

    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  private func hasCustom__str__(object: PyObject) -> Bool {
    let type = object.type

    guard let lookup = type.lookupWithType(name: .__str__) else {
      // 'object' has default implementation for '__str__',
      // if we did not find it then something went really wrong.
      let typeName = type.getNameString()
      trap("'\(typeName)' is not a subclass of 'object'")
    }

    let isFromObject = lookup.type === self.types.object
    return !isFromObject
  }

  // MARK: - ASCII

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func ascii(object: PyObject) -> PyResult<PyString> {
    switch self.asciiImpl(object: object) {
    case let .string(s):
      let py = Py.newString(s)
      return .value(py)
    case let .pystring(s):
      return .value(s)
    case let .error(e):
      return .error(e)
    }
  }

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func asciiString(object: PyObject) -> PyResult<String> {
    switch self.asciiImpl(object: object) {
    case let .string(s):
      return .value(s)
    case let .pystring(s):
      return .value(s.value)
    case let .error(e):
      return .error(e)
    }
  }

  private enum AsciiImplResult {
    case string(String)
    case pystring(PyString)
    case error(PyBaseException)
  }

  private func asciiImpl(object: PyObject) -> AsciiImplResult {
    switch self.reprImpl(object: object) {
    case .string(let s):
      let allASCII = s.unicodeScalars.allSatisfy { $0.isASCII }
      if allASCII {
        return .string(s)
      }

      return self.asciiImpl(string: s)

    case .pyString(let s):
      let allASCII = s.elements.allSatisfy { $0.isASCII }
      if allASCII {
        return .pystring(s)
      }

      return self.asciiImpl(string: s.value)

    case .methodReturnedNonString(let o):
      let e = self.createReprReturnedNonStringError(object: o)
      return .error(e)
    case let .notCallable(e),
         let .error(e):
      return .error(e)
    }
  }

  private func asciiImpl(string: String) -> AsciiImplResult {
    var result = ""

    for scalar in string.unicodeScalars {
      if scalar.isASCII {
        result.append(String(scalar))
      } else if scalar.value < 0x1_0000 {
        // \uxxxx Character with 16-bit hex value xxxx
        let hex = self.hex(value: scalar.value, padTo: 4)
        result.append("\\u\(hex)")
      } else {
        // \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx
        let hex = self.hex(value: scalar.value, padTo: 8)
        result.append("\\U\(hex)")
      }
    }

    return .string(result)
  }

  // MARK: - Join

  /// _PyUnicode_JoinArray
  public func join(strings elements: [PyObject],
                   separator: PyObject) -> PyResult<PyString> {
    if elements.isEmpty {
      return .value(self.emptyString)
    }

    if elements.count == 1 {
      if let s = PyCast.asString(elements[0]) {
        return .value(s)
      }
    }

    guard let sep = PyCast.asString(separator) else {
      return .typeError("separator: expected str instance, \(separator.typeName) found")
    }

    let strings: [PyString]
    switch self.asStringArray(elements: elements) {
    case let .value(r): strings = r
    case let .error(e): return .error(e)
    }

    var result = ""
    for (index, string) in strings.enumerated() {
      result.append(string.value)

      let isLast = index == strings.count - 1
      if !isLast {
        result.append(sep.value)
      }
    }

    return .value(self.newString(result))
  }

  private func asStringArray(elements: [PyObject]) -> PyResult<[PyString]> {
    var result = [PyString]()

    for (index, object) in elements.enumerated() {
      switch PyCast.asString(object) {
      case .some(let s):
        result.append(s)
      case .none:
        let msg = "sequence item \(index): expected str instance, \(object.typeName) found"
        return .typeError(msg)
      }
    }

    return .value(result)
  }

  // MARK: - Helpers

  private func hex(value: UInt32, padTo: Int) -> String {
    let string = String(value, radix: 16, uppercase: false)
    if string.count >= padTo {
      return string
    }

    let paddingCount = padTo - string.count
    assert(paddingCount > 0)
    let padding = String(repeating: "0", count: paddingCount)

    return padding + string
  }
}
