import VioletCore
import VioletBytecode

// swiftformat:disable redundantType
// cSpell:ignore localsplus fastlocals valuestack tstate
// swiftlint:disable file_length

// In CPython:
// Objects -> frameobject.c
// https://docs.python.org/3.8/library/inspect.html#types-and-members <-- this!

// sourcery: pytype = frame, isDefault, hasGC
/// Basic evaluation environment.
///
/// - Important:
/// CPython stores stack, local and free variables as a single block of memory
/// in `PyFrameObject.f_localsplus` using following layout:
/// ```
/// Layout:        fastlocals      | cell/free variables | stack
/// Variable name: ^ f_localsplus  ^ freevars            ^ f_valuestack
///  ```
///
/// We have separate `fastLocals`, `cell/free variables` and `stack`.
/// Our cache usage will suck (3 arrays stored on heap), but… oh well….
/// This allows us to have typed `cell` and `free` (`[PyCell]` instead of `[PyObject]`).
public struct PyFrame: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  /// Code object being executed in this frame.
  ///
  /// Cpython: `f_code`.
  public var code: PyCode { self.codePtr.pointee }

  // sourcery: storedProperty
  /// Next outer frame object (this frame’s caller).
  ///
  /// Cpython: `f_back`.
  public var parent: PyFrame? { self.parentPtr.pointee }

  // sourcery: storedProperty
  /// Stack of `PyObjects`.
  public var stack: ObjectStack { self.stackPtr.pointee }

  // sourcery: storedProperty
  /// Stack of blocks (for loops, exception handlers etc.).
  public var blocks: BlockStack { self.blocksPtr.pointee }

  // sourcery: storedProperty
  /// Local namespace seen by this frame.
  ///
  /// CPython: `f_locals`.
  public var locals: PyDict { self.localsPtr.pointee }

  // sourcery: storedProperty
  /// Global namespace seen by this frame.
  ///
  /// CPython: `f_globals`.
  public var globals: PyDict { self.globalsPtr.pointee }

  // sourcery: storedProperty
  /// Builtins namespace seen by this frame
  /// (most of the time it would be `Py.builtinsModule.__dict__`).
  ///
  /// CPython: `f_builtins`.
  public var builtins: PyDict { self.builtinsPtr.pointee }

  // sourcery: storedProperty
  /// Function args and local variables.
  ///
  /// We could use `self.localSymbols` but that would be `O(1)` with
  /// massive constants.
  /// We could also put them at the bottom of our stack (like in other languages),
  /// but as 'the hipster trash that we are' (quote from @bestdressed)
  /// we won't do this.
  /// We use array, which is like dictionary, but with lower constants.
  ///
  /// CPython: `f_localsplus`.
  public var fastLocals: [PyObject?] {
    get { self.fastLocalsPtr.pointee }
    nonmutating _modify { yield &self.fastLocalsPtr.pointee }
  }

  // sourcery: storedProperty
  /// Cell variables (variables from upper scopes).
  ///
  /// Btw. `Cell` = source for `free` variable.
  ///
  /// And yes, just as `self.fastLocals` they could be placed at the bottom
  /// of the stack. And no, we will not do this (see `self.fastLocals` comment).
  /// \#hipsters
  public var cellVariables: [PyCell] { self.cellVariablesPtr.pointee }

  // sourcery: storedProperty
  /// Free variables (variables from upper scopes).
  ///
  /// Btw. `Free` = cell from upper scope.
  ///
  /// And yes, just as `self.fastLocals` they could be placed at the bottom
  /// of the stack. And no, we will not do this (see `self.fastLocals` comment).
  /// \#hipsters
  public var freeVariables: [PyCell] { self.freeVariablesPtr.pointee }

  // sourcery: storedProperty
  /// Index of last attempted instruction in bytecode
  /// (`nil` it we have not started).
  ///
  /// Note that this is not the `PC`!
  /// In fact it is `pc - 1` (most of the time, if an instuction causes
  /// change in `PC` - like jump instruction etc. - this corelation stops
  /// being true).
  ///
  /// CPython: `f_lasti`.
  public var currentInstructionIndex: Int? { self.currentInstructionIndexPtr.pointee }

  // sourcery: storedProperty
  /// `PC`
  ///
  /// Index of the next executed instruction.
  /// Change this if you need to jump somewhere.
  public var nextInstructionIndex: Int { self.nextInstructionIndexPtr.pointee }

  /// Current line number in Python source code.
  /// If we do not have started execution it will return first instruction line.
  ///
  /// Cpython: `f_lineno`.
  public var currentInstructionLine: SourceLine {
    guard let index = self.currentInstructionIndex else {
      return self.code.firstLine
    }

    return self.code.getLine(instructionIndex: index)
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  internal func initialize(_ py: Py,
                           type: PyType,
                           code: PyCode,
                           locals: PyDict,
                           globals: PyDict,
                           parent: PyFrame?) {
    self.initializeBase(py, type: type)
    self.codePtr.initialize(to: code)
    self.parentPtr.initialize(to: parent)
    self.localsPtr.initialize(to: locals)
    self.globalsPtr.initialize(to: globals)

    self.stackPtr.initialize(to: ObjectStack())
    self.blocksPtr.initialize(to: BlockStack())

    let builtins = Self.getBuiltins(py, globals: globals, parent: parent)
    self.builtinsPtr.initialize(to: builtins)

    let fastLocals = [PyObject?](repeating: nil, count: self.code.variableCount)
    self.fastLocalsPtr.initialize(to: fastLocals)

    let cellVariables = Self.createEmptyCells(py, count: self.code.cellVariableCount)
    self.cellVariablesPtr.initialize(to: cellVariables)

    let freeVariables = Self.createEmptyCells(py, count: self.code.freeVariableCount)
    self.freeVariablesPtr.initialize(to: freeVariables)

    self.currentInstructionIndexPtr.initialize(to: nil)
    self.nextInstructionIndexPtr.initialize(to: 0)
  }

  private static func createEmptyCells(_ py: Py, count: Int) -> [PyCell] {
    var result = [PyCell]()
    result.reserveCapacity(count)

    for _ in 0..<count {
      let cell = py.newCell(content: nil)
      result.append(cell)
    }

    return result
  }

  private static func getBuiltins(_ py: Py, globals: PyDict, parent: PyFrame?) -> PyDict {
    // If we share the globals, we share the builtins.
    // Saves a lookup and a call.
    if let p = parent, p.globals.ptr === globals.ptr {
      return p.builtins
    }

    let globalBuiltins = globals.get(py, id: .__builtins__)
    let globalBuiltinsModule = globalBuiltins.flatMap(py.cast.asModule(_:))
    if let module = globalBuiltinsModule {
      return module.getDict(py)
    }

    return py.builtins.__dict__
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyFrame(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "code", value: zelf.code)
    result.append(name: "currentInstructionIndex", value: zelf.currentInstructionIndex as Any)
    result.append(name: "nextInstructionIndex", value: zelf.nextInstructionIndex)
    result.append(name: "currentInstructionLine", value: zelf.currentInstructionLine)
    result.append(name: "parent", value: zelf.parent as Any)
    return result
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__repr__")
    }

    let ptr = zelf.ptr
    let file = zelf.code.filename
    let line = zelf.currentInstructionLine
    let name = zelf.code.name
    let result = "<frame at \(ptr), file \(file), line \(line), code \(name)>"
    return PyResultGen(py, interned: result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__setattr__")
    }

    return AttributeHelper.setAttribute(py, object: zelf.asObject, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__delattr__")
    }

    return AttributeHelper.delAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Properties

  // sourcery: pyproperty = f_back
  internal static func f_back(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_back")
    }

    if let parent = zelf.parent {
      return PyResultGen(parent)
    }

    return .none(py)
  }

  // sourcery: pyproperty = f_builtins
  internal static func f_builtins(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_builtins")
    }

    return PyResultGen(zelf.builtins)
  }

  // sourcery: pyproperty = f_globals
  internal static func f_globals(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_globals")
    }

    return PyResultGen(zelf.globals)
  }

  // sourcery: pyproperty = f_locals
  internal static func f_locals(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_locals")
    }

    if let e = zelf.copyFastToLocals(py) {
      return .error(e)
    }

    return PyResultGen(zelf.locals)
  }

  // sourcery: pyproperty = f_code
  internal static func f_code(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_code")
    }

    return PyResultGen(zelf.code)
  }

  // sourcery: pyproperty = f_lasti
  internal static func f_lasti(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_lasti")
    }

    let result = zelf.currentInstructionIndex ?? 0
    return PyResultGen(py, result)
  }

  // sourcery: pyproperty = f_lineno
  internal static func f_lineno(_ py: Py, zelf: PyObject) -> PyResultGen<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "f_lineno")
    }

    let result = Int(zelf.currentInstructionLine)
    return PyResultGen(py, result)
  }
}
