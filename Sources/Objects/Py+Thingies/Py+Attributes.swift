// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length
// cSpell:ignore attrid

extension PyInstance {

  // MARK: - Get

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  public func getattr(object: PyObject,
                      name: String,
                      default: PyObject? = nil) -> PyResult<PyObject> {
    let interned = self.asObject(name: name)
    return self.getattr(object: object,
                        name: interned,
                        default: `default`)
  }

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  public func getattr(object: PyObject,
                      name: IdString,
                      default: PyObject? = nil) -> PyResult<PyObject> {
    return self.getattr(object: object,
                        name: name.value,
                        default: `default`)
  }

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  ///
  /// static PyObject *
  /// builtin_getattr(PyObject *self, PyObject *const *args, Py_ssize_t nargs)
  /// static PyObject *
  /// slot_tp_getattr_hook(PyObject *self, PyObject *name)
  /// int
  /// _PyObject_LookupAttr(PyObject *v, PyObject *name, PyObject **result)
  public func getattr(object: PyObject,
                      name: PyObject,
                      default: PyObject? = nil) -> PyResult<PyObject> {
    guard let name = name as? PyString else {
      return .typeError("getattr(): attribute name must be string")
    }

    // https://docs.python.org/3.8/reference/datamodel.html#object.__getattribute__
    let __getattribute__AttributeError: PyBaseException
    switch self.call__getattribute__(object: object, name: name) {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if e.isAttributeError {
        __getattribute__AttributeError = e
        break // There is still a hope! Let's ask '__getattr__'.
      }

      return .error(e)
    }

    // https://docs.python.org/3.8/reference/datamodel.html#object.__getattr__
    var __getattr__AttributeError: PyBaseException?
    switch self.call__getattr__(object: object, name: name) {
    case let .value(o):
      return .value(o)
    case .missingMethod:
      break // __getattr__ is optional
    case let .error(e):
      if e.isAttributeError {
        __getattr__AttributeError = e
        break
      }

      return .error(e)
    }

    if let d = `default` {
      return .value(d)
    }

    // Try this:
    // a = AttributeError('a')
    // b = AttributeError('b')
    //
    // class Elsa:
    //   def __getattribute__(self, attr): raise a
    //   def __getattr__(self, attr): raise b
    //
    // e = Elsa()
    // getattr(e, 'let_it_go')
    //
    // And then comment '__getattr__' line
    let e = __getattr__AttributeError ?? __getattribute__AttributeError
    return .error(e)
  }

  private func call__getattribute__(object: PyObject,
                                    name: PyString) -> PyResult<PyObject> {
    // Fast protocol-based path
    if let result = Fast.__getattribute__(object, name: name) {
      return result
    }

    // Calling '__getattribute__' could ask for '__getattribute__' attribute.
    // That would create a cycle which we have to break.
    // Trust me it is not a hack, it is… yeah it is a hack.
    if name.value == "__getattribute__" {
      let result = AttributeHelper.getAttribute(from: object, name: name)
      return result
    }

    // Slow python path
    switch self.callMethod(object: object,
                           selector: .__getattribute__,
                           arg: name) {
    case let .value(o):
      return .value(o)
    case let .missingMethod(e),
         let .notCallable(e),
         let .error(e):
      return .error(e)
    }
  }

  private enum CallGetattrResult {
    case value(PyObject)
    case missingMethod
    case error(PyBaseException)

    fileprivate init(result: PyResult<PyObject>) {
      switch result {
      case let .value(o): self = .value(o)
      case let .error(e): self = .error(e)
      }
    }
  }

  private func call__getattr__(object: PyObject,
                               name: PyString) -> CallGetattrResult {
    // Fast protocol-based path
    if let result = Fast.__getattr__(object, name: name) {
      return CallGetattrResult(result: result)
    }

    // Slow python path
    switch self.callMethod(object: object, selector: .__getattr__, arg: name) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .missingMethod
    case .notCallable(let e),
         .error(let e):
      return .error(e)
    }
  }

  // MARK: - Has

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasattr(object: PyObject, name: String) -> PyResult<Bool> {
    let interned = self.asObject(name: name)
    return self.hasattr(object: object, name: interned)
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasattr(object: PyObject, name: IdString) -> PyResult<Bool> {
    return self.hasattr(object: object, name: name.value)
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasattr(object: PyObject, name: PyObject) -> PyResult<Bool> {
    guard let name = name as? PyString else {
      return .typeError("hasattr(): attribute name must be string")
    }

    switch self.getattr(object: object, name: name, default: nil) {
    case .value:
      return .value(true)

    case .error(let e):
      if e.isAttributeError {
        return .value(false)
      }

      return .error(e)
    }
  }

  // MARK: - Set

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setattr(object: PyObject,
                      name: String,
                      value: PyObject) -> PyResult<PyNone> {
    let interned = self.asObject(name: name)
    return self.setattr(object: object, name: interned, value: value)
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setattr(object: PyObject,
                      name: IdString,
                      value: PyObject) -> PyResult<PyNone> {
    return self.setattr(object: object, name: name.value, value: value)
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setattr(object: PyObject,
                      name: PyObject,
                      value: PyObject) -> PyResult<PyNone> {
    guard let name = name as? PyString else {
      return .typeError("setattr(): attribute name must be string")
    }

    if let result = Fast.__setattr__(object, name: name, value: value) {
      return result
    }

    let args = [name, value]
    switch self.callMethod(object: object, selector: .__setattr__, args: args) {
    case .value:
      return .value(self.none)
    case .missingMethod:
      let operation: AttributeOperation = value.isNone ? .del : .set
      let error = self.attributeModificationError(object: object,
                                                  name: name,
                                                  operation: operation)

      return .error(error)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private enum AttributeOperation {
    case del
    case set
  }

  private func attributeModificationError(
    object: PyObject,
    name: PyString,
    operation: AttributeOperation
  ) -> PyBaseException {
    let t = object.typeName
    let name = name.reprRaw()

    let details: String = {
      switch operation {
      case .del: return "(del \(name))"
      case .set: return "(assign to \(name))"
      }
    }()

    switch self.hasattr(object: object, name: name) {
    case .value(true):
      let msg = "'\(t)' object has only read-only attributes \(details)"
      return Py.newTypeError(msg: msg)
    case .value(false):
      let msg = "'\(t)' object has no attributes \(details)"
      return Py.newTypeError(msg: msg)
    case let .error(e):
      return e
    }
  }

  // MARK: - Delete

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delattr(object: PyObject, name: String) -> PyResult<PyNone> {
    let interned = self.asObject(name: name)
    return self.delattr(object: object, name: interned)
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delattr(object: PyObject, name: IdString) -> PyResult<PyNone> {
    return self.delattr(object: object, name: name.value)
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delattr(object: PyObject, name: PyObject) -> PyResult<PyNone> {
    guard let name = name as? PyString else {
      return .typeError("delattr(): attribute name must be string")
    }

    if let result = Fast.__delattr__(object, name: name) {
      return result
    }

    switch self.callMethod(object: object, selector: .__delattr__, arg: name) {
    case .value:
      return .value(self.none)
    case .missingMethod:
      let error = self.attributeModificationError(object: object,
                                                  name: name,
                                                  operation: .del)
      return .error(error)
    case .error(let e),
       .notCallable(let e):
    return .error(e)
    }
  }

  // MARK: - Lookup

  public enum LookupResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  /// Look for a name through the MRO.
  ///
  /// _PyObject_LookupSpecial(PyObject *self, _Py_Identifier *attrid)
  public func getFromType(object: PyObject, name: IdString) -> LookupResult {
    let type = object.type
    guard let attribute = type.lookup(name: name) else {
      return .notFound
    }

    if let descr = GetDescriptor(object: object, attribute: attribute) {
      switch descr.call() {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    return .value(attribute)
  }

  // MARK: - Helpers

  /// We will intern attribute names, because they tend to be repeated a lot.
  private func asObject(name: String) -> PyString {
    return self.intern(string: name)
  }
}
