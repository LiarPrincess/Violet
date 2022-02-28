/* MARKER
import BigInt
import VioletCore

// swiftlint:disable file_length

// We can force cast, because if the Swift type does not correspond to the Python
// type, then we are in deep trouble (this is one of the main invariants in Violet).
private func forceCast<T: PyObject>(object: PyObject, as type: T.Type) -> T {
  #if DEBUG
  guard let result = object as? T else {
    trap("Python type (\(object.typeName)) does not match Swift type (\(type)).")
  }

  return result
  #else
  // swiftlint:disable:next force_cast
  return object as! T
  #endif
}

// This file contains only the function wrappers for 'PyStaticCall'.
// See 'PyStaticCall' documentation for more information.
// See 'PyType+StaticallyKnownMethods' for the actual type definition.
extension PyType.StaticallyKnownNotOverriddenMethods {

  // MARK: StringConversionWrapper

  internal struct StringConversionWrapper {

    internal let fn: (PyObject) -> PyResult<String>

    internal init<T: PyObject>(_ fn: @escaping (T) -> PyResult<String>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)
      }
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> String) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        let result = fn(zelf)()
        return .value(result)
      }
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<String>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: HashWrapper

  internal struct HashWrapper {

    internal let fn: (PyObject) -> HashResult

    internal init(_ fn: @escaping (PyObject) -> PyHash) {
      self.fn = { (arg0: PyObject) in
        let result = fn(arg0)
        return .value(result)
      }
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyHash) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        let result = fn(zelf)()
        return .value(result)
      }
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> HashResult) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: DirWrapper

  internal struct DirWrapper {

    internal let fn: (PyObject) -> PyResult<DirResult>

    internal init(_ fn: @escaping (PyObject) -> PyResult<DirResult>) {
      self.fn = fn
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<DirResult>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: ComparisonWrapper

  internal struct ComparisonWrapper {

    internal let fn: (PyObject, PyObject) -> CompareResult

    internal init(_ fn: @escaping (PyObject, PyObject) -> CompareResult) {
      self.fn = fn
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> CompareResult) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: AsBoolWrapper

  internal struct AsBoolWrapper {

    internal let fn: (PyObject) -> Bool

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> Bool) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: AsIntWrapper

  internal struct AsIntWrapper {

    internal let fn: (PyObject) -> PyResult<PyInt>

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyInt) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        let result = fn(zelf)()
        return .value(result)
      }
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyInt>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: AsFloatWrapper

  internal struct AsFloatWrapper {

    internal let fn: (PyObject) -> PyResult<PyFloat>

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyFloat>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: AsComplexWrapper

  internal struct AsComplexWrapper {

    internal let fn: (PyObject) -> PyObject

    // This one is never used, so we do not need 'init'.
  }

  // MARK: AsIndexWrapper

  internal struct AsIndexWrapper {

    internal let fn: (PyObject) -> BigInt

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> BigInt) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: GetAttributeWrapper

  internal struct GetAttributeWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<PyObject>

    internal init(_ fn: @escaping (PyObject, PyObject) -> PyResult<PyObject>) {
      self.fn = fn
    }

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: SetAttributeWrapper

  internal struct SetAttributeWrapper {

    internal let fn: (PyObject, PyObject, PyObject?) -> PyResult<PyNone>

    internal init(
      _ fn: @escaping (PyObject, PyObject, PyObject?) -> PyResult<PyNone>
    ) {
      self.fn = fn
    }

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject, PyObject?) -> PyResult<PyNone>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1, arg2)
      }
    }
  }

  // MARK: DelAttributeWrapper

  internal struct DelAttributeWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<PyNone>

    internal init(_ fn: @escaping (PyObject, PyObject) -> PyResult<PyNone>) {
      self.fn = fn
    }

    internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> PyResult<PyNone>) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: GetItemWrapper

  internal struct GetItemWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<PyObject>

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: SetItemWrapper

  internal struct SetItemWrapper {

    internal let fn: (PyObject, PyObject, PyObject) -> PyResult<PyNone>

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject, PyObject) -> PyResult<PyNone>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1, arg2)
      }
    }
  }

  // MARK: DelItemWrapper

  internal struct DelItemWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<PyNone>

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject) -> PyResult<PyNone>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: IterWrapper

  internal struct IterWrapper {

    internal let fn: (PyObject) -> PyObject

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyObject) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: NextWrapper

  internal struct NextWrapper {

    internal let fn: (PyObject) -> PyResult<PyObject>

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyObject>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: GetLengthWrapper

  internal struct GetLengthWrapper {

    internal let fn: (PyObject) -> BigInt

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> BigInt) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: ContainsWrapper

  internal struct ContainsWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<Bool>

    internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> PyResult<Bool>) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: ReversedWrapper

  internal struct ReversedWrapper {

    internal let fn: (PyObject) -> PyObject

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyObject) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: KeysWrapper

  internal struct KeysWrapper {

    internal let fn: (PyObject) -> PyObject

    internal init(_ fn: @escaping (PyDict) -> () -> PyObject) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: PyDict.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: DelWrapper

  internal struct DelWrapper {

    internal let fn: (PyObject) -> PyResult<PyNone>

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyNone>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: CallWrapper

  internal struct CallWrapper {

    internal let fn: (PyObject, [PyObject], PyDict?) -> PyResult<PyObject>

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> ([PyObject], PyDict?) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, args: [PyObject], kwargs: PyDict?) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(args, kwargs)
      }
    }
  }

  // MARK: InstanceCheckWrapper

  internal struct InstanceCheckWrapper {

    internal let fn: (PyObject, PyObject) -> Bool

    internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> Bool) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: SubclassCheckWrapper

  internal struct SubclassCheckWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<Bool>

    internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> PyResult<Bool>) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: IsAbstractMethodWrapper

  internal struct IsAbstractMethodWrapper {

    internal let fn: (PyObject) -> PyResult<Bool>

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<Bool>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: NumericUnaryWrapper

  internal struct NumericUnaryWrapper {

    internal let fn: (PyObject) -> PyObject

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyObject) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: NumericTruncWrapper

  internal struct NumericTruncWrapper {

    internal let fn: (PyObject) -> PyResult<PyInt>

    internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyInt>) {
      self.fn = { (arg0: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)()
      }
    }
  }

  // MARK: NumericRoundWrapper

  internal struct NumericRoundWrapper {

    internal let fn: (PyObject, PyObject?) -> PyResult<PyObject>

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject?) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject?) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: NumericBinaryWrapper

  internal struct NumericBinaryWrapper {

    internal let fn: (PyObject, PyObject) -> PyResult<PyObject>

    internal init<T: PyObject>(
      _ fn: @escaping (T, PyObject) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf, arg1)
      }
    }

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1)
      }
    }
  }

  // MARK: NumericTernaryWrapper

  internal struct NumericPowWrapper {

    internal let fn: (PyObject, PyObject, PyObject?) -> PyResult<PyObject>

    internal init<T: PyObject>(
      _ fn: @escaping (T) -> (PyObject, PyObject?) -> PyResult<PyObject>
    ) {
      self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) in
        let zelf = forceCast(object: arg0, as: T.self)
        return fn(zelf)(arg1, arg2)
      }
    }
  }
}

*/