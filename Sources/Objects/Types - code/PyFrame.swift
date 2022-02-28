/* MARKER
import VioletCore
import VioletBytecode

// swiftformat:disable redundantType
// cSpell:ignore localsplus fastlocals valuestack tstate

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
public final class PyFrame: PyObject, CustomReflectable {

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
  public var fastLocals: [PyObject?]

  /// Cell variables (variables from upper scopes).
  ///
  /// Btw. `Cell` = source for `free` variable.
  ///
  /// And yes, just as `self.fastLocals` they could be placed at the bottom
  /// of the stack. And no, we will not do this (see `self.fastLocals` comment).
  /// \#hipsters
  public var cellVariables: [PyCell]

  /// Free variables (variables from upper scopes).
  ///
  /// Btw. `Free` = cell from upper scope.
  ///
  /// And yes, just as `self.fastLocals` they could be placed at the bottom
  /// of the stack. And no, we will not do this (see `self.fastLocals` comment).
  /// \#hipsters
  public var freeVariables: [PyCell]

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

  // MARK: - Mirror

  // We use mirrors to create description.
  public var customMirror: Mirror {
    return Mirror(
      self,
      children: [
        "code": self.code,
        "currentInstructionIndex": self.currentInstructionIndex as Any,
        "nextInstructionIndex": self.nextInstructionIndex,
        "currentInstructionLine": self.currentInstructionLine,
        "parent": self.parent as Any
      ]
    )
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
    self.fastLocals = [PyObject?](repeating: nil, count: self.code.variableCount)
    self.cellVariables = Self.createEmptyCells(count: self.code.cellVariableCount)
    self.freeVariables = Self.createEmptyCells(count: self.code.freeVariableCount)
    super.init(type: Py.types.frame)
  }

  private static func createEmptyCells(count: Int) -> [PyCell] {
    var result = [PyCell]()
    result.reserveCapacity(count)

    for _ in 0..<count {
      let cell = PyMemory.newCell(content: nil)
      result.append(cell)
    }

    return result
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
  internal func repr() -> String {
    let ptr = self.ptr
    let file = self.code.filename
    let line = self.currentInstructionLine
    let name = self.code.name
    return "<frame at \(ptr), file \(file), line \(line), code \(name)>"
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
}

*/