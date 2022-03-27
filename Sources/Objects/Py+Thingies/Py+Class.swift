import VioletCore

// In CPython:
// Python -> builtinmodule.c

extension Py {

  // MARK: - Get __build_class__

  /// Get `__build_class__` from `builtins` module.
  public func get__build_class__() -> PyResult {
    let dict = self.builtins.__dict__

    if let fn = dict.get(self, id: .__build_class__) {
      return .value(fn)
    }

    let error = self.newAttributeError(message: "'__build_class__' not found")
    return .error(error.asBaseException)
  }

  // MARK: - __build_class__

  /// Low level `class` building machinery.
  /// Available in `Python` as `builtins.__build_class__`
  /// (just remember to `import builtins` before).
  ///
  /// static PyObject *
  /// builtin___build_class__(PyObject *self, PyObject *const *args, ...)
  ///
  /// - Warning:
  /// Order of arguments in Swift method is a bit different than in Python
  /// `builtins.__build_class__`! Idk. it makes more sense for me this way.
  ///
  /// - Parameters:
  ///   - name: class name
  ///   - bases: base classes (positional arguments in `class Alice(eat_me)`)
  ///   - bodyFn: function/closure created from the class body;
  ///             it has a single argument (`__locals__`) where the dict
  ///             (or MutableSequence) representing the locals is passed
  ///   - kwargs: keyword arguments and **kwds argument
  public func __build_class__(name: PyString,
                              bases basesTuple: PyTuple,
                              bodyFn: PyFunction,
                              kwargs: PyDict?) -> PyResult {
    let bases: [PyType]
    switch PyType.guaranteeAllBasesAreTypes(self, bases: basesTuple) {
    case let .value(b): bases = b
    case let .error(e): return .error(e)
    }

    // Type of our type. Most of the time it will be 'PyType' instance.
    // But technically you can 'class Elsa(some_object): pass'.
    // If you try hard enough with 'some_object' it may even work…
    let metatype: PyObject
    switch self.calculateMetaclass(bases: bases, kwargs: kwargs) {
    case let .value(m): metatype = m
    case let .error(e): return .error(e)
    }

    // Our class '__dict__' (the thing that contains methods etc.)
    // CPython: namespace
    let dict: PyDict
    switch self.createDict(name: name, bases: basesTuple, metatype: metatype, kwargs: kwargs) {
    case let .value(n): dict = n
    case let .error(e): return .error(e)
    }

    // Call 'bodyFn' and use class '__dict__' as locals.
    // This way 'def let_it_go(self, …)' in class definition will became entry
    // in '__dict__'.
    //
    // If we used '__class__' inside 'bodyFn' then we need to fill that cell.
    // class Elsa:
    //   def let_it_go(self):
    //     c = __class__ # <-- this uses '__class__' cell
    // It can also be 'None' if we have not used class cell.
    let __class__cell: PyObject
    switch self.eval(fn: bodyFn, locals: dict) {
    case let .value(c): __class__cell = c
    case let .error(e): return .error(e)
    }

    // Call our metatype to create type.
    // Most of the time it will call 'PyType.call'.
    let result: PyObject
    let metaArgs = [name.asObject, basesTuple.asObject, dict.asObject]
    switch self.call(callable: metatype, args: metaArgs, kwargs: kwargs) {
    case let .value(r):
      result = r
    case let .notCallable(e),
         let .error(e):
      return .error(e)
    }

    // Almost done!
    // If we use '__class__' then we have to set that cell.
    if let e = self.fill__class__cell(cell: __class__cell, with: result) {
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - Metaclass

  private func calculateMetaclass(bases: [PyType], kwargs: PyDict?) -> PyResult {
    var result: PyObject

    if let kwargs = kwargs, let meta = kwargs.get(self, id: .metaclass) {
      // 'metaclass' should not be propagated later when we call our 'metatype'
      // to create new type.
      _ = kwargs.del(self, id: .metaclass)
      result = meta
    } else {
      result = bases.first?.type.asObject ?? self.types.type.asObject
    }

    if let metaType = self.cast.asType(result) {
      // meta is really a class, so check for a more derived
      // metaclass, or possible metaclass conflicts:
      switch PyType.calculateMetaclass(self, metatype: metaType, bases: bases) {
      case let .value(winner):
        result = winner.asObject
      case let .error(e):
        return .error(e)
      }
    }
    // else:
    //   'result' is not a class, so we cannot do the metaclass calculation,
    //   we will use the given object as it is.

    return .value(result)
  }

  // MARK: - Dict

  private enum GetPrepareResult {
    case value(PyObject)
    case none
    case error(PyBaseException)
  }

  /// If our `metatype` has `__prepare__` then call it to obtain class `__dict__`.
  /// Otherwise just return empty dict.
  private func createDict(name: PyString,
                          bases: PyTuple,
                          metatype: PyObject,
                          kwargs: PyDict?) -> PyResultGen<PyDict> {
    switch self.get__prepare__(metatype: metatype) {
    case let .value(__prepare__):
      let object: PyObject
      let args = [name.asObject, bases.asObject]
      switch self.call(callable: __prepare__, args: args, kwargs: kwargs) {
      case let .value(o):
        object = o
      case let .error(e),
           let .notCallable(e):
        return .error(e)
      }

      guard let dict = self.cast.asDict(object) else {
        let t = metatype.typeName
        let message = "\(t).__prepare__() must return a mapping, not \(object.typeName)"
        return .typeError(self, message: message)
      }

      return .value(dict)

    case .none:
      // No '__prepare__'
      return .value(self.newDict())

    case let .error(e):
      return .error(e)
    }
  }

  private func get__prepare__(metatype: PyObject) -> GetPrepareResult {
    switch self.getAttribute(object: metatype, name: .__prepare__) {
    case let .value(o):
      return .value(o)

    case let .error(e):
      if self.cast.isAttributeError(e.asObject) {
        return .none
      }

      return .error(e)
    }
  }

  // MARK: - Eval

  private func eval(fn: PyFunction, locals: PyDict) -> PyResult {
    return self.delegate.eval(self,
                              name: nil,
                              qualname: nil,
                              code: fn.code,
                              args: [],
                              kwargs: nil,
                              defaults: [],
                              kwDefaults: nil,
                              globals: fn.globals,
                              locals: locals,
                              closure: fn.closure)
  }

  // MARK: - __class__

  private func fill__class__cell(cell _cell: PyObject,
                                 with _type: PyObject) -> PyBaseException? {
    guard let type = self.cast.asType(_type),
          let cell = self.cast.asCell(_cell) else {
      assert(self.cast.isNone(_cell), "__class__ should be cell or None. Compiler error?")
      return nil
    }

    // If content is nil -> it may be warning
    if cell.content == nil {
      let typeName = type.getNameString()
      let typeRepr = self.reprOrGenericString(type.asObject)
      let message = "__class__ not set defining \(typeName) as \(typeRepr). " +
                "Was __classcell__ propagated to type.__new__?"
      if let e = self.warn(type: .deprecation, message: message) {
        return e
      }
    }

    // If we already have content that is not our class -> throw
    if let content = cell.content, content.ptr !== type.ptr {
      let typeName = type.getNameString()
      let typeRepr = self.reprOrGenericString(type.asObject)
      let contentRepr = self.reprOrGenericString(content)
      let message = "__class__ set to \(contentRepr) defining \(typeName) as \(typeRepr)"
      let error = self.newTypeError(message: message)
      return error.asBaseException
    }

    cell.content = type.asObject
    return nil
  }
}
