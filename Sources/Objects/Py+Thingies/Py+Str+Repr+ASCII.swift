import VioletCore

// cSpell:ignore uxxxx Uxxxxxxxx

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Repr

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  public func repr(_ object: PyObject) -> PyResultGen<PyString> {
    switch self.reprImpl(object) {
    case .string(let s):
      let py = self.newString(s)
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
  public func reprString(_ object: PyObject) -> PyResultGen<String> {
    switch self.reprImpl(object) {
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
    case string(String)
    case pyString(PyString)
    case methodReturnedNonString(PyObject)
    case notCallable(PyBaseException)
    case error(PyBaseException)

    fileprivate init(_ py: Py, object: PyObject) {
      switch py.cast.asString(object) {
      case .some(let string):
        self = .pyString(string)
      case .none:
        self = .methodReturnedNonString(object)
      }
    }
  }

  private func reprImpl(_ object: PyObject) -> ReprImplResult {
    if let result = PyStaticCall.__repr__(self, object: object) {
      switch result {
      case let .value(o): return ReprImplResult(self, object: o)
      case let .error(e): return .error(e)
      }
    }

    switch self.callMethod(object: object, selector: .__repr__) {
    case let .value(object):
      return ReprImplResult(self, object: object)
    case .missingMethod:
      let generic = self.genericRepr(object)
      return .string(generic)
    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  private func createReprReturnedNonStringError(object: PyObject) -> PyBaseException {
    let type = object.typeName
    let error = self.newTypeError(message: "__repr__ returned non-string (\(type))")
    return error.asBaseException
  }

  // MARK: - Repr or generic

  /// Get object `__repr__`, if that fails then use generic representation.
  ///
  /// This is mostly for error messages, where we have to use _something_.
  public func reprOrGeneric(_ object: PyObject) -> PyString {
    switch self.reprImpl(object) {
    case .string(let s):
      return self.newString(s)
    case .pyString(let s):
      return s
    case .methodReturnedNonString,
         .error,
         .notCallable:
      let generic = self.genericRepr(object)
      return self.newString(generic)
    }
  }

  /// Get object `__repr__`, if that fails then use generic representation.
  ///
  /// This is mostly for error messages, where we have to use _something_.
  public func reprOrGenericString(_ object: PyObject) -> String {
    switch self.reprImpl(object) {
    case .string(let s):
      return s
    case .pyString(let s):
      return s.value
    case .methodReturnedNonString,
         .error,
         .notCallable:
      return self.genericRepr(object)
    }
  }

  private func genericRepr(_ object: PyObject) -> String {
    return "<\(object.typeName) object at \(object.ptr)>"
  }

  // MARK: - Str

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func str(_ object: PyObject) -> PyResultGen<PyString> {
    switch self.strImpl(object) {
    case .reprLock:
      return .value(self.emptyString)
    case .string(let s):
      let py = self.newString(s)
      return .value(py)
    case .pyString(let s):
      return .value(s)
    case .methodReturnedNonString(let o):
      return .typeError(self, message: "__str__ returned non-string (\(o.typeName))")
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  public func strString(_ string: PyString) -> String {
    return string.value
  }

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func strString(_ object: PyObject) -> PyResultGen<String> {
    switch self.strImpl(object) {
    case .reprLock:
      return .value("")
    case .string(let s):
      return .value(s)
    case .pyString(let s):
      return .value(s.value)
    case .methodReturnedNonString(let o):
      return .typeError(self, message: "__str__ returned non-string (\(o.typeName))")
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  private enum StrImplResult {
    case reprLock
    case string(String)
    case pyString(PyString)
    case methodReturnedNonString(PyObject)
    case notCallable(PyBaseException)
    case error(PyBaseException)

    fileprivate init(_ py: Py, object: PyObject) {
      switch py.cast.asString(object) {
      case .some(let string):
        self = .pyString(string)
      case .none:
        self = .methodReturnedNonString(object)
      }
    }

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

  private func strImpl(_ object: PyObject) -> StrImplResult {
    if let str = self.cast.asExactlyString(object) {
      return .pyString(str)
    }

    if object.hasReprLock {
      return .reprLock
    }

    // If we do not override '__str__' then we have to use '__repr__'.
    guard self.hasCustom__str__(object: object) else {
      let repr = self.reprImpl(object)
      return StrImplResult(repr: repr)
    }

    if let result = PyStaticCall.__str__(self, object: object) {
      switch result {
      case let .value(o): return StrImplResult(self, object: o)
      case let .error(e): return .error(e)
      }
    }

    switch self.callMethod(object: object, selector: .__str__) {
    case let .value(object):
      return StrImplResult(self, object: object)
    case .missingMethod:
      // Hmm… we checked that we have custom '__str__', so we should not end up here
      let repr = self.reprImpl(object)
      return StrImplResult(repr: repr)
    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  private func hasCustom__str__(object: PyObject) -> Bool {
    let type = object.type

    guard let lookup = type.mroLookup(self, name: .__str__) else {
      // 'object' has default implementation for '__str__',
      // if we did not find it then something went really wrong.
      let typeName = type.getNameString()
      trap("'\(typeName)' is not a subclass of 'object'?")
    }

    let isFromObject = lookup.type === self.types.object
    return !isFromObject
  }

  // MARK: - ASCII

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func ascii(_ object: PyObject) -> PyResultGen<PyString> {
    switch self.asciiImpl(object) {
    case let .string(s):
      let py = self.newString(s)
      return .value(py)
    case let .pystring(s):
      return .value(s)
    case let .error(e):
      return .error(e)
    }
  }

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func asciiString(_ object: PyObject) -> PyResultGen<String> {
    switch self.asciiImpl(object) {
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

  private func asciiImpl(_ object: PyObject) -> AsciiImplResult {
    switch self.reprImpl(object) {
    case .string(let s):
      let allASCII = s.unicodeScalars.allSatisfy { $0.isASCII }
      if allASCII {
        return .string(s)
      }

      return self.asciiImpl(s)

    case .pyString(let s):
      let allASCII = s.elements.allSatisfy { $0.isASCII }
      if allASCII {
        return .pystring(s)
      }

      return self.asciiImpl(s.value)

    case .methodReturnedNonString(let o):
      let e = self.createReprReturnedNonStringError(object: o)
      return .error(e)
    case let .notCallable(e),
         let .error(e):
      return .error(e)
    }
  }

  private func asciiImpl(_ string: String) -> AsciiImplResult {
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
