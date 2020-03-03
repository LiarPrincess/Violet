import Bytecode

// In CPython:
// Objects -> typeobject.c

// swiftlint:disable file_length

// sourcery: pytype = super, default, hasGC, baseType
public class PySuper: PyObject {

  // MARK: - Remove this

  private struct CodeDummy {
    let argCount = 0
    let nLocals = 0
    let variableNames = [MangledName]()
    let freeVariableNames = [MangledName]()
    let cellVariableNames = [MangledName]()
  }

  private struct FrameDummy {
    let code: CodeDummy?
    let fastLocals: [PyObject?] = []
    let cellsAndFreeVariables = [PyCell]()
  }

  private static var frame: FrameDummy? {
    return nil
  }

  // MARK: - Doc

  internal static var doc = """
    super() -> same as super(__class__, <first argument>)
    super(type) -> unbound super object
    super(type, obj) -> bound super object; requires isinstance(obj, type)
    super(type, type2) -> bound super object; requires issubclass(type2, type)
    Typical use to call a cooperative superclass method:
    class C(B):
        def meth(self, arg):
            super().meth(arg)
    This works for class methods too:
    class C(B):
        @classmethod
        def cmeth(cls, arg):
            super().cmeth(arg)
    """

  /// Type that the user requested (1st arg).
  ///
  /// For example:
  /// `super(int, True)` -> `requestedType` = `int` (even though value is `bool`).
  private var requestedType: PyType?
  private var object: PyObject?
  private var objectType: PyType?

  internal convenience init(requestedType: PyType?,
                            object: PyObject?,
                            objectType: PyType?) {
    self.init(type: Py.types.super,
              requestedType: requestedType,
              object: object,
              objectType: objectType )
  }

  /// Use only in `__new__`!
  internal init(type: PyType,
                requestedType: PyType?,
                object: PyObject?,
                objectType: PyType?) {
    self.requestedType = type
    self.object = object
    self.objectType = objectType
    super.init(type: type)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    let result = PySuper(
      type: type,
      requestedType: nil,
      object: nil,
      objectType: nil
    )

    return .value(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["", ""],
    format: "|OO:super"
  )

  // sourcery: pymethod = __init__
  internal class func pyInit(zelf: PySuper,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNone> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "super", kwargs: kwargs) {
      return .error(e)
    }

    switch PySuper.initArguments.bind(args: args, kwargs: nil) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let type = binding.optional(at: 0)
      let object = binding.optional(at: 1)
      return PySuper.pyInit(zelf: zelf, type: type, object: object)

    case let .error(e):
      return .error(e)
    }
  }

  internal class func pyInit(zelf: PySuper,
                             type typeArg: PyObject?,
                             object objectArg: PyObject?) -> PyResult<PyNone> {
    let type: PyType
    var object = objectArg

    if let typeAsObject = typeArg {
      guard let typeAsType = typeAsObject as? PyType else {
        let t = typeAsObject.typeName
        return .typeError("super() argument 1 must be type, not \(t)")
      }

      type = typeAsType
    } else {
      // Call super(), without args, fill:
      // - object from first local variable on the stack
      // - type from '__class__'
      assert(object == nil)

      switch Self.getObjectAndTypeFromFrame() {
      case let .value(objectType):
        type = objectType.type
        object = objectType.object
      case let .error(e):
        return .error(e)
      }
    }

    if let o = object, o.isNone {
      object = nil
    }

    var objectType: PyType?
    if let o = object {
      switch self.checkSuper(type: type, object: o) {
      case let .value(t): objectType = t
      case let .error(e): return .error(e)
      }
    }

    zelf.requestedType = type
    zelf.object = object
    zelf.objectType = objectType
    return .value(Py.none)
  }

  // MARK: - Without args (from frame)

  private struct ObjectAndType {
    fileprivate let object: PyObject
    fileprivate let type: PyType
  }

  private static func getObjectAndTypeFromFrame() -> PyResult<ObjectAndType> {
    guard let frame = self.frame else {
      return .runtimeError("super(): no current frame")
    }

    guard let code = frame.code else {
      return .runtimeError("super(): no code object")
    }

    if code.argCount == 0 {
      return .runtimeError("super(): no arguments")
    }

    let object: PyObject
    switch Self.getSelfObjectFromFirstArgument(frame: frame, code: code) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    switch Self.getTypeFrom__class__(frame: frame, code: code) {
    case .value(let type):
      let result = ObjectAndType(object: object, type: type)
      return .value(result)
    case .notFound:
      return .runtimeError("super(): __class__ cell not found")
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Get 'self' object from 1st arg

  /// By convention 'firstArgument' should be named 'self',
  /// but users can actually put anything they want there,
  /// so we can't rely that.
  private static func getSelfObjectFromFirstArgument(
    frame: FrameDummy,
    code: CodeDummy
  ) -> PyResult<PyObject> {
    // Note double optional below:
    // - 'frame.fastLocals' stores 'PyObject?'
    // - 'Collection.first' returns 'Element?'
    // 'guard' will handle optional from 'Collection.first'
    guard var firstArgOrNil = frame.fastLocals.first else {
      return .runtimeError("super(): arg[0] deleted")
    }

    // The first argument might be a cell.
    if firstArgOrNil == nil {
      firstArgOrNil = Self.handleFirstArgumentCell(frame: frame, code: code)
    }

    guard let firstArg = firstArgOrNil else {
      return .runtimeError("super(): arg[0] deleted")
    }

    return .value(firstArg)
  }

  private static func handleFirstArgumentCell(frame: FrameDummy,
                                              code: CodeDummy) -> PyObject? {
    guard let firstArgument = code.variableNames.first else {
      return nil
    }

    // We will try to find cell with the same name as 'firstArgument'
    for (i, cellName) in code.cellVariableNames.enumerated() {
      // swiftlint:disable:next for_where
      if cellName == firstArgument {
        let cell = frame.cellsAndFreeVariables[i]
        return cell.content
      }
    }

    return nil
  }

  // MARK: - Get 'type' from __class__

  private enum TypeFromClass {
    case value(PyType)
    case notFound
    case error(PyBaseException)
  }

  private static func getTypeFrom__class__(
    frame: FrameDummy,
    code: CodeDummy
  ) -> TypeFromClass {
    for (i, name) in code.freeVariableNames.enumerated() {
      guard name.value == "__class__" else {
        continue
      }

      // We store cells and free in the same array,
      // cells are first so we have to offset 'free'.
      let index = code.cellVariableNames.count + i
      let cell = frame.cellsAndFreeVariables[index]

      guard let content = cell.content else {
        let msg = "super(): empty __class__ cell"
        return .error(Py.newRuntimeError(msg: msg))
      }

      guard let type = content as? PyType else {
        let msg = "super(): __class__ is not a type (\(content.typeName))"
        return .error(Py.newRuntimeError(msg: msg))
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
  /// But... when obj is an instance, we want to allow for the case where
  /// `Py_TYPE(obj)` is not a subclass of type, but `object.__class__` is!
  /// This will allow using `super()` with a proxy for `object`.
  private static func checkSuper(type: PyType,
                                 object: PyObject) -> PyResult<PyType> {
    if let objectAsType = object as? PyType, objectAsType.isSubtype(of: type) {
      return .value(objectAsType)
    }

    let objectType = object.type
    if objectType.isSubtype(of: type) {
      return .value(objectType)
    }

    switch Py.getAttribute(objectType, name: .__class__) {
    case .value(let classObject):
      if let classType = classObject as? PyType, classType.isSubtype(of: type) {
        return .value(classType)
      }
    case .error:
      break // Ignore, we have our own error
    }

    let msg = "super(type, obj): obj must be an instance or subtype of type"
    return .typeError(msg)
  }
}
