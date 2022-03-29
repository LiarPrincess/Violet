// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// cSpell:ignore attrid

extension Py {

  // MARK: - Get

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  public func getAttribute(object: PyObject,
                           name: String,
                           default: PyObject? = nil) -> PyResult {
    let n = self.asObject(name: name)
    return self.getAttribute(object: object, name: n, default: `default`)
  }

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  public func getAttribute(object: PyObject,
                           name: IdString,
                           default: PyObject? = nil) -> PyResult {
    let n = self.resolve(id: name).asObject
    return self.getAttribute(object: object, name: n, default: `default`)
  }

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  public func getAttribute(object: PyObject,
                           name: PyString,
                           default: PyObject? = nil) -> PyResult {
    let n = name.asObject
    return self.getAttribute(object: object, name: n, default: `default`)
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
  public func getAttribute(object: PyObject,
                           name: PyObject,
                           default: PyObject? = nil) -> PyResult {
    guard self.isString(name: name) else {
      return .typeError(self, message: "getattr(): attribute name must be string")
    }

    // https://docs.python.org/3.8/reference/datamodel.html#object.__getattribute__
    let __getattribute__AttributeError: PyBaseException
    switch self.call__getattribute__(object: object, name: name) {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if self.cast.isAttributeError(e.asObject) {
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
      if self.cast.isAttributeError(e.asObject) {
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

  private func call__getattribute__(object: PyObject, name: PyObject) -> PyResult {
    assert(self.isString(name: name), "Attribute should be string.")

    // Fast path: we know the method at compile time
    if let result = PyStaticCall.__getattribute__(self, object: object, name: name) {
      return result
    }

    // Calling '__getattribute__' could ask for '__getattribute__' attribute.
    // That would create a cycle which we have to break.
    // Trust me it is not a hack, it is… yeah it is a hack.
    if let n = self.cast.asString(name), n.value == "__getattribute__" {
      let result = AttributeHelper.getAttribute(self, object: object, name: name)
      return result
    }

    // Slow python path
    switch self.callMethod(object: object, selector: .__getattribute__, arg: name) {
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

    fileprivate init(result: PyResult) {
      switch result {
      case let .value(o): self = .value(o)
      case let .error(e): self = .error(e)
      }
    }
  }

  private func call__getattr__(object: PyObject, name: PyObject) -> CallGetattrResult {
    assert(self.isString(name: name), "Attribute should be string.")

    // Fast path: we know the method at compile time
    if let result = PyStaticCall.__getattr__(self, object: object, name: name) {
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
  public func hasAttribute(object: PyObject, name: String) -> PyResultGen<Bool> {
    let n = self.asObject(name: name)
    return self.hasAttribute(object: object, name: n)
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasAttribute(object: PyObject, name: IdString) -> PyResultGen<Bool> {
    let n = self.resolve(id: name).asObject
    return self.hasAttribute(object: object, name: n)
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasAttribute(object: PyObject, name: PyString) -> PyResultGen<Bool> {
    let n = name.asObject
    return self.hasAttribute(object: object, name: n)
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasAttribute(object: PyObject, name: PyObject) -> PyResultGen<Bool> {
    guard self.isString(name: name) else {
      return .typeError(self, message: "hasattr(): attribute name must be string")
    }

    switch self.getAttribute(object: object, name: name, default: nil) {
    case .value:
      return .value(true)

    case .error(let e):
      if self.cast.isAttributeError(e.asObject) {
        return .value(false)
      }

      return .error(e)
    }
  }

  // MARK: - Set

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(object: PyObject,
                           name: String,
                           value: PyObject) -> PyResult {
    let n = self.asObject(name: name)
    return self.setAttribute(object: object, name: n, value: value)
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(object: PyObject,
                           name: IdString,
                           value: PyObject) -> PyResult {
    let n = self.resolve(id: name).asObject
    return self.setAttribute(object: object, name: n, value: value)
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(object: PyObject,
                           name: PyString,
                           value: PyObject) -> PyResult {
    let n = name.asObject
    return self.setAttribute(object: object, name: n, value: value)
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(object: PyObject,
                           name nameObject: PyObject,
                           value: PyObject) -> PyResult {
    guard let name = self.cast.asString(nameObject) else {
      return .typeError(self, message: "setattr(): attribute name must be string")
    }

    if let result = PyStaticCall.__setattr__(self, object: object, name: nameObject, value: value) {
      return result
    }

    let args = [nameObject, value]
    switch self.callMethod(object: object, selector: .__setattr__, args: args) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      let operation: AttributeOperation = self.cast.isNone(value) ? .del : .set
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
    let name = name.repr()

    let details: String
    switch operation {
    case .del: details = "(del \(name))"
    case .set: details = "(assign to \(name))"
    }

    let type = object.typeName
    switch self.hasAttribute(object: object, name: name) {
    case .value(true):
      let message = "'\(type)' object has only read-only attributes \(details)"
      let error = self.newTypeError(message: message)
      return error.asBaseException
    case .value(false):
      let message = "'\(type)' object has no attributes \(details)"
      let error = self.newTypeError(message: message)
      return error.asBaseException
    case let .error(e):
      return e
    }
  }

  // MARK: - Delete

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delAttribute(object: PyObject, name: String) -> PyResult {
    let n = self.asObject(name: name)
    return self.delAttribute(object: object, name: n)
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delAttribute(object: PyObject, name: IdString) -> PyResult {
    let n = self.resolve(id: name).asObject
    return self.delAttribute(object: object, name: n)
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delAttribute(object: PyObject, name: PyString) -> PyResult {
    let n = name.asObject
    return self.delAttribute(object: object, name: n)
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delAttribute(object: PyObject,
                           name nameObject: PyObject) -> PyResult {
    guard let name = self.cast.asString(nameObject) else {
      return .typeError(self, message: "delattr(): attribute name must be string")
    }

    if let result = PyStaticCall.__delattr__(self, object: object, name: nameObject) {
      return result
    }

    switch self.callMethod(object: object, selector: .__delattr__, arg: nameObject) {
    case .value(let o):
      return .value(o)
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

  // MARK: - Helpers

  private func isString(name: PyObject) -> Bool {
    return self.cast.isString(name)
  }

  /// We will intern attribute names, because they tend to be repeated a lot.
  private func asObject(name: String) -> PyObject {
    let interned = self.intern(string: name)
    return interned.asObject
  }
}
