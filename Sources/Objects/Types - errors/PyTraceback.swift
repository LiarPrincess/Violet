import VioletCore

// In CPython:
// Python -> traceback.c
// https://docs.python.org/3/library/traceback.html

// sourcery: pytype = traceback, default, hasGC
public class PyTraceback: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    TracebackType(tb_next, tb_frame, tb_lasti, tb_lineno)
    --

    Create a new traceback object.
    """

  // MARK: - Properties

  /// Next inner traceback object (called by this level)
  ///
  /// CPython: `tb_next`.
  private var next: PyTraceback?
  /// Frame object at this level
  ///
  /// CPython: `tb_frame`.
  private let frame: PyFrame
  /// Index of last attempted instruction in bytecode
  ///
  /// CPython: `tb_lasti`.
  private let lastInstruction: PyInt
  /// Current line number in Python source code
  ///
  /// CPython: `tb_lineno`.
  private let lineNo: PyInt

  // MARK: - Init

  internal init(next: PyTraceback?,
                frame: PyFrame,
                lastInstruction: PyInt,
                lineNo: PyInt) {
    self.next = next
    self.frame = frame
    self.lastInstruction = lastInstruction
    self.lineNo = lineNo
    super.init(type: Py.types.traceback)
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

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  /// static PyObject *
  /// tb_dir(PyTracebackObject *self)
  internal func dir() -> PyResult<DirResult> {
    let result = DirResult()
    result.append(Py.intern(string: "tb_frame"))
    result.append(Py.intern(string: "tb_next"))
    result.append(Py.intern(string: "tb_lasti"))
    result.append(Py.intern(string: "tb_lineno"))
    return .value(result)
  }

  // MARK: - Frame

  // sourcery: pyproperty = tb_frame
  internal func getFrame() -> PyFrame {
    return self.frame
  }

  // MARK: - Last instruction

  // sourcery: pyproperty = tb_lasti
  internal func getLastInstruction() -> PyInt {
    return self.lastInstruction
  }

  // MARK: - Line number

  // sourcery: pyproperty = tb_lineno
  internal func getLineNo() -> PyInt {
    return self.lineNo
  }

  // MARK: - Next

  // sourcery: pyproperty = tb_next, setter = setNext
  internal func getNext() -> PyTraceback? {
    return self.next
  }

  internal func setNext(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .typeError("can't delete tb_next attribute")
    }

    // We accept None or a traceback object, and map None -> nil

    if value.isNone {
      self.next = nil
      return .value()
    }

    if let traceback = PyCast.asTraceback(value) {
      if let e = self.checkForLoop(with: traceback) {
        return .error(e)
      }

      self.next = traceback
      return .value()
    }

    return .typeError("expected traceback object, got '\(value.typeName)'")
  }

  private func checkForLoop(with other: PyTraceback) -> PyBaseException? {
    var current: PyTraceback? = other

    while let c = current {
      if c === self {
        return Py.newValueError(msg: "traceback loop detected")
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
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyTraceback> {
    switch self.newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 4, "Invalid required argument count.")
      assert(binding.optionalCount == 0, "Invalid optional argument count.")

      let next = binding.required(at: 0)
      let frame = binding.required(at: 1)
      let lastInstruction = binding.required(at: 2)
      let lineNo = binding.required(at: 3)

      return Self.pyNew(type: type,
                        next: next,
                        frame: frame,
                        lastInstruction: lastInstruction,
                        lineNo: lineNo)

    case let .error(e):
      return .error(e)
    }
  }

  private static func pyNew(type: PyType,
                            next _next: PyObject,
                            frame _frame: PyObject,
                            lastInstruction _lastInstruction: PyObject,
                            lineNo _lineNo: PyObject) -> PyResult<PyTraceback> {
    let fn = "TracebackType.__new__()"

    var next: PyTraceback?
    if _next.isNone {
      next = nil
    } else if let traceback = PyCast.asTraceback(_next) {
      next = traceback
    } else {
      let t = _next.typeName
      return .typeError("\(fn) argument 1 must be traceback or None, not \(t)")
    }

    guard let frame = PyCast.asFrame(_frame) else {
      let t = _frame.typeName
      return .typeError("\(fn) argument 2 must be frame, not \(t)")
    }

    guard let lastInstruction = PyCast.asInt(_lastInstruction) else {
      let t = _lastInstruction.typeName
      return .typeError("\(fn) argument 3 must be int, not \(t)")
    }

    guard let lineNo = PyCast.asInt(_lineNo) else {
      let t = _lineNo.typeName
      return .typeError("\(fn) argument 4 must be int, not \(t)")
    }

    let result = PyMemory.newTraceback(next: next,
                                       frame: frame,
                                       lastInstruction: lastInstruction,
                                       lineNo: lineNo)

    return .value(result)
  }
}
