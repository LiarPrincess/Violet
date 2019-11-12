public class PyContext {

  // Internal typed values
  internal lazy var _true  = PyBool(self, value: true)
  internal lazy var _false = PyBool(self, value: false)
  internal lazy var _none  = PyNone(self)
  internal lazy var _ellipsis = PyEllipsis(self)
  internal lazy var _notImplemented = PyNotImplemented(self)
  internal lazy var _emptyTuple = PyTuple(self, elements: [])

  // Public PyObject values
  public var `true`:   PyObject { return self._true }
  public var `false`:  PyObject { return self._false }
  public var none:     PyObject { return self._none }
  public var ellipsis: PyObject { return self._ellipsis }
  public var notImplemented: PyObject { return self._notImplemented }
  public var emptyTuple: PyObject { return self._emptyTuple }

  public lazy var builtins = Builtins(context: self)

  public init() { }
}
