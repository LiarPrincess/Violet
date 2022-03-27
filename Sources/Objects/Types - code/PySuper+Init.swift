extension PySuper {

  internal static func __init__(_ py: Py,
                                zelf: PySuper,
                                type typeArg: PyObject?,
                                object objectArg: PyObject?) -> PyResult {
    let type: PyType
    var object = objectArg

    if let typeAsObject = typeArg {
      guard let typeAsType = py.cast.asType(typeAsObject) else {
        let t = typeAsObject.typeName
        return .typeError(py, message: "super() argument 1 must be type, not \(t)")
      }

      type = typeAsType
    } else {
      // Call super(), without args, fill:
      // - object from first local variable on the stack
      // - type from its '__class__'
      assert(object == nil)

      switch Self.getObjectAndTypeFromFrame(py) {
      case let .value(objectType):
        type = objectType.type
        object = objectType.object
      case let .error(e):
        return .error(e)
      }
    }

    if let o = object, py.cast.isNone(o) {
      object = nil
    }

    var objectType: PyType?
    if let o = object {
      switch self.checkSuper(py, zelf: zelf, type: type, object: o) {
      case let .value(t): objectType = t
      case let .error(e): return .error(e)
      }
    }

    zelf.thisClass = type
    zelf.object = object
    zelf.objectType = objectType
    return .none(py)
  }

  // MARK: - Without args (from frame)

  private struct ObjectAndType {
    fileprivate let object: PyObject
    fileprivate let type: PyType
  }

  private static func getObjectAndTypeFromFrame(_ py: Py) -> PyResultGen<ObjectAndType> {
    guard let frame = py.delegate.getCurrentlyExecutedFrame(py) else {
      return .runtimeError(py, message: "super(): no current frame")
    }

    let code = frame.code

    if code.argCount == 0 {
      return .runtimeError(py, message: "super(): no arguments")
    }

    let object: PyObject
    switch Self.getSelfObjectFromFirstArgument(py, frame: frame, code: code) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    switch Self.getTypeFrom__class__(py, frame: frame, code: code) {
    case .value(let type):
      let result = ObjectAndType(object: object, type: type)
      return .value(result)
    case .notFound:
      return .runtimeError(py, message: "super(): __class__ cell not found")
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - 'self' from 1st arg

  /// By convention 'firstArgument' should be named 'self',
  /// but users can actually put anything they want there,
  /// so we can't rely that.
  private static func getSelfObjectFromFirstArgument(_ py: Py,
                                                     frame: PyFrame,
                                                     code: PyCode) -> PyResult {
    // Note the double optional below:
    // - 'frame.fastLocals' stores 'PyObject?'
    // - 'Collection.first' returns 'Element?'
    // 'guard' will handle optional from 'Collection.first'
    guard var firstArgOrNil = frame.fastLocals.first else {
      return .runtimeError(py, message: "super(): arg[0] deleted")
    }

    // The first argument might be a cell.
    if firstArgOrNil == nil {
      firstArgOrNil = Self.handleFirstArgumentCell(frame: frame, code: code)
    }

    guard let firstArg = firstArgOrNil else {
      return .runtimeError(py, message: "super(): arg[0] deleted")
    }

    return .value(firstArg)
  }

  private static func handleFirstArgumentCell(frame: PyFrame,
                                              code: PyCode) -> PyObject? {
    guard let firstArgument = code.variableNames.first else {
      return nil
    }

    // We will try to find the cell with the same name as 'firstArgument'.
    for (index, cellName) in code.cellVariableNames.enumerated() {
      // swiftlint:disable:next for_where
      if cellName == firstArgument {
        let cell = frame.cellVariables[index]
        return cell.content
      }
    }

    return nil
  }

  // MARK: - 'type' from '__class__'

  private enum TypeFromClass {
    case value(PyType)
    case notFound
    case error(PyBaseException)
  }

  private static func getTypeFrom__class__(_ py: Py,
                                           frame: PyFrame,
                                           code: PyCode) -> TypeFromClass {
    for (index, name) in code.freeVariableNames.enumerated() {
      guard name.value == "__class__" else {
        continue
      }

      let cell = frame.freeVariables[index]

      guard let content = cell.content else {
        let error = py.newRuntimeError(message: "super(): empty __class__ cell")
        return .error(error.asBaseException)
      }

      guard let type = py.cast.asType(content) else {
        let message = "super(): __class__ is not a type (\(content.typeName))"
        let error = py.newRuntimeError(message: message)
        return .error(error.asBaseException)
      }

      return .value(type)
    }

    return .notFound
  }

  // MARK: - Check super

  /// Check that a super() call makes sense.
  ///
  /// `object` can be a class, or an instance of one:
  ///
  /// - If it is a class, it must be a subclass of 'type'.
  ///   This case is used for class methods; the return value is `object`.
  ///
  /// - If it is an instance, it must be an instance of `type`.
  ///   This is the normal case; the return value is `obj.__class__`.
  ///
  /// But… when obj is an instance, we want to allow for the case where
  /// `Py_TYPE(obj)` is not a subclass of type, but `object.__class__` is!
  /// This will allow using `super()` with a proxy for `object`.
  internal static func checkSuper(_ py: Py,
                                  zelf: PySuper,
                                  type: PyType,
                                  object: PyObject) -> PyResultGen<PyType> {
    if let objectAsType = py.cast.asType(object), objectAsType.isSubtype(of: type) {
      return .value(objectAsType)
    }

    let objectType = object.type
    if objectType.isSubtype(of: type) {
      return .value(objectType)
    }

    switch py.getAttribute(object: objectType.asObject, name: .__class__) {
    case .value(let classObject):
      if let classType = py.cast.asType(classObject), classType.isSubtype(of: type) {
        return .value(classType)
      }
    case .error:
      break // Ignore, we have our own error
    }

    let message = "super(type, obj): obj must be an instance or subtype of type"
    return .typeError(py, message: message)
  }
}
