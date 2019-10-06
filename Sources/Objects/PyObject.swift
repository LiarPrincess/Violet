import Core

internal struct PyObjectFlags: OptionSet {
  let rawValue: UInt8

  /// This flag is used to control infinite recursion in `repr`, `str`, `print`
  /// etc.
  ///
  /// Container objects that may recursively contain themselves, e.g. builtin
  /// dictionaries and lists, should use `withReprLock()` to avoid infinite
  /// recursion.
  internal static let reprLock = PyObjectFlags(rawValue: 1 << 0)
}

public class PyObject {

  internal var flags: PyObjectFlags
  internal let type: PyType

  internal var context: PyContext {
    return self.type.context
  }

  internal var types: PyContextTypes {
    return self.context.types
  }

  internal init(type: PyType) {
    self.flags = []
    self.type = type
  }

  // MARK: - Repr

  /// This flag is used to control infinite recursion in `repr`, `str`, `print`
  /// etc.
  internal var hasReprLock: Bool {
    return self.flags.contains(.reprLock)
  }

  /// Set flag that is used to control infinite recursion in `repr`, `str`,
  /// `print` etc.
  internal func withReprLock<T>(body: () throws -> T) rethrows -> T {
    self.flags.formUnion(.reprLock)
    defer { _ = self.flags.subtracting(.reprLock) }

    return try body()
  }

  // MARK: - TODO: Remove

  internal func pyInt(_ value: BigInt) -> PyInt {
    return self.types.int.new(value)
  }

  internal func pyInt(_ value: Int) -> PyInt {
    return self.types.int.new(value)
  }

  internal func pyTuple(_ elements: [PyObject]) -> PyTuple {
    return self.types.tuple.new(elements)
  }

  internal func extractInt(_ object: PyObject) -> PyInt? {
    return object as? PyInt
  }

  /// PyLong_FromSsize_t
  internal func extractIndex(value: PyObject) -> BigInt? {
    //    guard let indexType = value.type as? IndexTypeClass else {
    //      return nil
    //    }

    //    let index = try indexType.index(value: value)
    //    let bigInt = try self.context.types.int.extractInt(index)
    //    guard let result = Int(exactly: bigInt) else {
    //      // i = PyNumber_AsSsize_t(item, PyExc_IndexError);
    //      fatalError()
    //    }

    //    return result
    //    return nil
    fatalError()
  }
}
