import VioletCore
import VioletBytecode

// swiftlint:disable file_length
// cSpell:ignore localsplus fastlocals valuestack tstate

// In CPython:
// Objects -> frameobject.c
// https://docs.python.org/3.8/library/inspect.html#types-and-members <-- this!

// sourcery: pytype = frame, default, hasGC
/// Basic evaluation environment.
///
/// - Important:
/// CPython stores stack, local and free variables as a single block of memory
/// in `PyFrameObject.f_localsplus` using following layout:
/// ```
/// Layout:        fastlocals      | cells + free variables | stack
/// Variable name: ^ f_localsplus  ^ freevars               ^ f_valuestack
///  ```
///
/// We have separate `fastLocals`, `cellsAndFreeVariables` and `stack`.
/// Our cache usage will suck (3 arrays stored on heap), but… oh well….
/// This allows us to have typed `cellsAndFreeVariables`
/// (`[PyCell]` instead of `[PyObject]`).
public final class PyFrame: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // MARK: - Properties

  /// Code object being executed in this frame.
  ///
  /// Cpython: `f_code`.
  public let code: PyCode
  /// Next outer frame object (this frame’s caller).
  ///
  /// Cpython: `f_back`.
  public let parent: PyFrame?

  /// Stack of `PyObjects`.
  public var stack = ObjectStack()
  /// Stack of blocks (for loops, exception handlers etc.).
  public var blocks = BlockStack()

  /// Local namespace seen by this frame.
  ///
  /// CPython: `f_locals`.
  public let locals: PyDict
  /// Global namespace seen by this frame.
  ///
  /// CPython: `f_globals`.
  public let globals: PyDict
  /// Builtins namespace seen by this frame
  /// (most of the time it would be `Py.builtinsModule.__dict__`).
  ///
  /// CPython: `f_builtins`.
  public let builtins: PyDict

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
  public lazy var fastLocals: [PyObject?] = [PyObject?](
    //                        ^ we need this for Sourcery
    repeating: nil,
    count: self.code.variableCount
  )

  /// Free variables (variables from upper scopes).
  ///
  /// First cells and then free (see `loadClosure` or `deref` instructions).
  ///
  /// Btw. `Cell` = source for `free` variable.
  ///      `Free` = cell from upper scope.
  ///
  /// And yes, just as `self.fastLocals` they could be placed at the bottom
  /// of the stack.
  /// And no, we will not do this (see `self.fastLocals` comment).
  /// \#hipsters
  public lazy var cellsAndFreeVariables: [PyCell] = [PyCell](
    //                                   ^ we need this for Sourcery
    repeating: Py.newCell(content: nil),
    count: self.code.cellVariableCount + self.code.freeVariableCount
  )

  /// Index of last attempted instruction in bytecode
  /// (`nil` it we have not started).
  ///
  /// Note that this is not the `PC`!
  /// In fact it is `pc - 1` (most of the time, if an instuction causes
  /// change in `PC` - like jump instruction etc. - this corelation stops
  /// being true).
  ///
  /// CPython: `f_lasti`.
  public var currentInstructionIndex: Int?

  /// `PC`
  ///
  /// Index of the next executed instruction.
  /// Change this if you need to jump somewhere.
  public var nextInstructionIndex = 0

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

  // MARK: - Init

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  internal init(code: PyCode,
                locals: PyDict,
                globals: PyDict,
                parent: PyFrame?) {
    self.code = code
    self.parent = parent
    self.locals = locals
    self.globals = globals
    self.builtins = Self.getBuiltins(globals: globals, parent: parent)
    super.init(type: Py.types.frame)
  }

  private static func getBuiltins(globals: PyDict,
                                  parent: PyFrame?) -> PyDict {
    // If we share the globals, we share the builtins.
    // Saves a lookup and a call.
    if let p = parent, p.globals === globals {
      return p.builtins
    }

    let globalBuiltins = globals.get(id: .__builtins__)
    let globalBuiltinsModule = globalBuiltins.flatMap(PyCast.asModule(_:))
    if let module = globalBuiltinsModule {
      return module.getDict()
    }

    return Py.builtinsModule.getDict()
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let ptr = self.ptr
    let file = self.code.filename
    let line = self.currentInstructionLine
    let name = self.code.name
    let result = "<frame at \(ptr), file \(file), line \(line), code \(name)>"
    return .value(result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Properties

  // sourcery: pyproperty = f_back
  internal func getBack() -> PyFrame? {
    return self.parent
  }

  // sourcery: pyproperty = f_builtins
  internal func getBuiltins() -> PyDict {
    return self.builtins
  }

   // sourcery: pyproperty = f_globals
   internal func getGlobals() -> PyDict {
    return self.globals
   }

   // sourcery: pyproperty = f_locals
   internal func getLocals() -> PyResult<PyDict> {
    if let e = self.copyFastToLocals() {
      return .error(e)
    }

    return .value(self.locals)
   }

  // sourcery: pyproperty = f_code
  internal func getCode() -> PyCode {
    return self.code
  }

  // sourcery: pyproperty = f_lasti
  internal func getLasti() -> Int {
    return self.currentInstructionIndex ?? 0
  }

  // sourcery: pyproperty = f_lineno
  internal func getLineno() -> Int {
    return Int(self.currentInstructionLine)
  }

  // MARK: - Fast to locals

  /// Merge fast locals (arguments, local variables etc.) into 'self.locals'.
  ///
  /// We store function arguments and locals in `self.fastLocals`.
  /// In some cases (for example `__builtins__.locals()`) we need a proper
  /// `locals` dict.
  /// This method will copy values from `self.fastLocals` to `self.locals`.
  ///
  /// We will also do the same for `cells` and `frees`.
  ///
  /// CPython:
  /// int
  /// PyFrame_FastToLocalsWithError(PyFrameObject *f)
  public func copyFastToLocals() -> PyBaseException? {
    let variableNames = self.code.variableNames
    let fastLocals = self.fastLocals
    assert(variableNames.count == fastLocals.count)

    for (name, value) in zip(variableNames, fastLocals) {
      if self.isCellOrFree(name: name) {
        continue
      }

      // TODO: 'PyFrame.updateLocals' for fast: 'allowDelete: false'
      if let e = self.updateLocals(name: name, value: value, allowDelete: false) {
        return e
      }
    }

    // Same for cells and free
    let cellNames = self.code.cellVariableNames
    let freeNames = self.code.freeVariableNames
    let cellsAndFrees = self.cellsAndFreeVariables
    assert(cellNames.count + freeNames.count == cellsAndFrees.count)

    for (name, cell) in zip(cellNames, cellsAndFrees) {
      if let e = self.updateLocals(name: name, value: cell.content) {
        return e
      }
    }

    // Free variables are after cells in 'self.cellsAndFreeVariables'
    let frees = cellsAndFrees.dropFirst(cellNames.count)
    for (name, cell) in zip(freeNames, frees) {
      if let e = self.updateLocals(name: name, value: cell.content) {
        return e
      }
    }

    return nil
  }

  /// `O(n)`, but we do not expect a lot of 'cells' and 'frees'.
  private func isCellOrFree(name: MangledName) -> Bool {
    let cellNames = self.code.cellVariableNames
    let freeNames = self.code.freeVariableNames
    return cellNames.contains(name) || freeNames.contains(name)
  }

  private func updateLocals(name: MangledName,
                            value: PyObject?,
                            allowDelete: Bool = false) -> PyBaseException? {
    let locals = self.locals
    let key = self.createLocalsKey(name: name)

    // If we have value -> add it to locals
    if let value = value {
      switch locals.set(key: key, to: value) {
      case .ok:
        return nil
      case .error(let e):
        return e
      }
    }

    guard allowDelete else {
      return nil
    }

    // If we don't have value -> remove name from locals
    switch locals.del(key: key) {
    case .value,
         .notFound:
      return nil
    case .error(let e):
      return e
    }
  }

  private func createLocalsKey(name: MangledName) -> PyString {
    return Py.intern(string: name.value)
  }

  // MARK: - Locals to fast

  /// What should `PyFrame.copyLocalsToFast` do when the value is missing from
  /// `self.locals`?
  public enum LocalMissingStrategy {
    /// Leave the current value.
    case ignore
    /// Remove value (set to `nil`).
    case remove
  }

  /// Reversal of `self.copyFastToLocals` (<-- go there for documentation).
  public func copyLocalsToFast(
    onLocalMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    let variableNames = self.code.variableNames
    assert(variableNames.count == self.fastLocals.count)

    for (index, name) in variableNames.enumerated() {
      if self.isCellOrFree(name: name) {
        continue
      }

      if let e = self.updateFastFromLocal(index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    // Same for cells and free
    let cellNames = self.code.cellVariableNames
    let freeNames = self.code.freeVariableNames
    assert(cellNames.count + freeNames.count == self.cellsAndFreeVariables.count)

    for (index, name) in cellNames.enumerated() {
      if let e = self.updateCellOrFreeFromLocal(index: index,
                                                name: name,
                                                onMissing: onLocalMissing) {
        return e
      }
    }

    for (freeIndex, name) in freeNames.enumerated() {
      // Free variables are after cells in 'self.cellsAndFreeVariables'
      let cellOrFreeIndex = cellNames.count + freeIndex
      if let e = self.updateCellOrFreeFromLocal(index: cellOrFreeIndex,
                                                name: name,
                                                onMissing: onLocalMissing) {
        return e
      }
    }

    return nil
  }

  private func updateFastFromLocal(
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.fastLocals.count)

    switch self.getLocal(name: name) {
    case .value(let value):
      self.fastLocals[index] = value

    case .notFound:
      switch onMissing {
      case .ignore:
        break
      case .remove:
        self.fastLocals[index] = nil
      }

    case .error(let e):
      return e
    }

    return nil
  }

  private func updateCellOrFreeFromLocal(
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.cellsAndFreeVariables.count)

    switch self.getLocal(name: name) {
    case .value(let value):
      let cell = self.cellsAndFreeVariables[index]
      cell.content = value

    case .notFound:
      switch onMissing {
      case .ignore:
        break
      case .remove:
        let cell = self.cellsAndFreeVariables[index]
        cell.content = nil
      }

    case .error(let e):
      return e
    }

    return nil
  }

  private func getLocal(name: MangledName) -> PyDict.GetResult {
    let key = self.createLocalsKey(name: name)
    return self.locals.get(key: key)
  }
}
