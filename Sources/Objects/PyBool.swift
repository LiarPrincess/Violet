import Core

public final class PyBool: PyInt {
  fileprivate init(type: PyBoolType, value: BigInt) {
    super.init(type: type, value: value)
  }
}

public final class PyBoolType: PyIntType {

  override public var name: String { return "bool" }
  override public var base: PyType? { return self.context.types.int }
  override public var doc:  String { return """
bool(x) -> bool

Returns True when the argument x is true, False otherwise.
The builtins True and False are the only two instances of the class bool.
The class bool is a subclass of the class int, and cannot be subclassed
"""}

  // MARK: - Ctors

  public lazy var `true`:  PyBool = PyBool(type: self, value: BigInt(1))
  public lazy var `false`: PyBool = PyBool(type: self, value: BigInt(0))

  override public func new(_ value: BigInt) -> PyBool {
    return value.isZero ? self.false : self.true
  }

  // MARK: - String

  override public func repr(value: PyObject) throws -> String {
    let value = try self.extractInt(value)
    return value.isZero ? "False" : "True"
  }

  override public func str(value: PyObject) throws -> String {
    return try self.repr(value: value)
  }

  // MARK: - Binary

  override public func and(left: PyObject, right: PyObject) throws -> PyObject {
    guard let l = self.extractIntOrNil(left),
          let r = self.extractIntOrNil(right) else {
        return try super.and(left: left, right: right)
    }
    return self.new(l & r)
  }

  override public func or(left: PyObject, right: PyObject) throws -> PyObject {
    guard let l = self.extractIntOrNil(left),
          let r = self.extractIntOrNil(right) else {
        return try super.and(left: left, right: right)
    }
    return self.new(l | r)
  }

  override public func xor(left: PyObject, right: PyObject) throws -> PyObject {
    guard let l = self.extractIntOrNil(left),
          let r = self.extractIntOrNil(right) else {
        return try super.and(left: left, right: right)
    }
    return self.new(l ^ r)
  }
}
