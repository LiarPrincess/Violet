import VioletCore

// In CPython:
// Python -> traceback.c
// https://docs.python.org/3/library/traceback.html

// sourcery: pytype = traceback, isDefault, hasGC
public struct PyTraceback: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    TracebackType(tb_next, tb_frame, tb_lasti, tb_lineno)
    --

    Create a new traceback object.
    """

  // sourcery: storedProperty
  /// Next inner traceback object (called by this level)
  ///
  /// CPython: `tb_next`.
  private var next: PyTraceback? {
    get { self.nextPtr.pointee }
    nonmutating set { self.nextPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// Frame object at this level
  ///
  /// CPython: `tb_frame`.
  private var frame: PyFrame { self.framePtr.pointee }

  // sourcery: storedProperty
  /// Index of last attempted instruction in bytecode
  ///
  /// CPython: `tb_lasti`.
  private var lastInstruction: PyInt { self.lastInstructionPtr.pointee }

  // sourcery: storedProperty
  /// Current line number in Python source code
  ///
  /// CPython: `tb_lineno`.
  private var lineNo: PyInt { self.lineNoPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           next: PyTraceback?,
                           frame: PyFrame,
                           lastInstruction: PyInt,
                           lineNo: PyInt) {
    self.initializeBase(py, type: type)
    self.nextPtr.initialize(to: next)
    self.framePtr.initialize(to: frame)
    self.lastInstructionPtr.initialize(to: lastInstruction)
    self.lineNoPtr.initialize(to: lineNo)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyType(ptr: ptr)
    return PyObject.DebugMirror(object: zelf)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  /// static PyObject *
  /// tb_dir(PyTracebackObject *self)
  internal static func __dir__(_ py: Py, zelf: PyObject) -> PyResultGen<DirResult> {
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(py, zelf, Self.pythonTypeName)
    }

    var result = DirResult()

    let frame = py.intern(string: "tb_frame")
    result.append(frame.asObject)

    let next = py.intern(string: "tb_next")
    result.append(next.asObject)

    let lasti = py.intern(string: "tb_lasti")
    result.append(lasti.asObject)

    let lineno = py.intern(string: "tb_lineno")
    result.append(lineno.asObject)

    return .value(result)
  }

  // MARK: - Frame

  // sourcery: pyproperty = tb_frame
  internal static func tb_frame(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "tb_frame")
    }

    let result = zelf.getFrame()
    return PyResult(result)
  }

  internal func getFrame() -> PyFrame {
    return self.frame
  }

  // MARK: - Last instruction

  // sourcery: pyproperty = tb_lasti
  internal static func tb_lasti(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "tb_lasti")
    }

    let result = zelf.getLastInstruction()
    return PyResult(result)
  }

  internal func getLastInstruction() -> PyInt {
    return self.lastInstruction
  }

  // MARK: - Line number

  // sourcery: pyproperty = tb_lineno
  internal static func tb_lineno(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "tb_lineno")
    }

    let result = zelf.getLineNo()
    return PyResult(result)
  }

  internal func getLineNo() -> PyInt {
    return self.lineNo
  }

  // MARK: - Next

  // sourcery: pyproperty = tb_next, setter
  internal static func tb_next(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "tb_next")
    }

    let result = zelf.getNext()
    return PyResult(py, result)
  }

  internal func getNext() -> PyTraceback? {
    return self.next
  }

  internal static func tb_next(_ py: Py,
                               zelf _zelf: PyObject,
                               value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "tb_next")
    }

    guard let value = value else {
      return .typeError(py, message: "can't delete tb_next attribute")
    }

    // We accept None or a traceback object, and map None -> nil

    if py.cast.isNone(value) {
      zelf.next = nil
      return .none(py)
    }

    if let traceback = py.cast.asTraceback(value) {
      if let e = Self.checkForLoop(py, zelf: zelf, other: traceback) {
        return .error(e.asBaseException)
      }

      zelf.next = traceback
      return .none(py)
    }

    let message = "expected traceback object, got '\(value.typeName)'"
    return .typeError(py, message: message)
  }

  private static func checkForLoop(_ py: Py,
                                   zelf: PyTraceback,
                                   other: PyTraceback) -> PyValueError? {
    var current: PyTraceback? = other

    while let c = current {
      if c.ptr === zelf.ptr {
        return py.newValueError(message: "traceback loop detected")
      }

      current = c.next
    }

    return nil
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["tb_next", "tb_frame", "tb_lasti", "tb_lineno"],
    format: "OOii:TracebackType"
  )

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    switch self.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 4, "Invalid required argument count.")
      assert(binding.optionalCount == 0, "Invalid optional argument count.")

      let next = binding.required(at: 0)
      let frame = binding.required(at: 1)
      let lastInstruction = binding.required(at: 2)
      let lineNo = binding.required(at: 3)

      return Self.__new__(py,
                          type: type,
                          next: next,
                          frame: frame,
                          lastInstruction: lastInstruction,
                          lineNo: lineNo)

    case let .error(e):
      return .error(e)
    }
  }

  // swiftlint:disable:next function_parameter_count
  private static func __new__(_ py: Py,
                              type: PyType,
                              next _next: PyObject,
                              frame _frame: PyObject,
                              lastInstruction _lastInstruction: PyObject,
                              lineNo _lineNo: PyObject) -> PyResult {
    let fn = "TracebackType.__new__()"

    var next: PyTraceback?
    if py.cast.isNone(_next) {
      next = nil
    } else if let traceback = py.cast.asTraceback(_next) {
      next = traceback
    } else {
      let message = "\(fn) argument 1 must be traceback or None, not \(_next.typeName)"
      return .typeError(py, message: message)
    }

    guard let frame = py.cast.asFrame(_frame) else {
      let message = "\(fn) argument 2 must be frame, not \(_frame.typeName)"
      return .typeError(py, message: message)
    }

    guard let lastInstruction = py.cast.asInt(_lastInstruction) else {
      let message = "\(fn) argument 3 must be int, not \(_lastInstruction.typeName)"
      return .typeError(py, message: message)
    }

    guard let lineNo = py.cast.asInt(_lineNo) else {
      let message = "\(fn) argument 4 must be int, not \(_lineNo.typeName)"
      return .typeError(py, message: message)
    }

    let result = py.memory.newTraceback(type: type,
                                        next: next,
                                        frame: frame,
                                        lastInstruction: lastInstruction,
                                        lineNo: lineNo)

    return PyResult(result)
  }
}
