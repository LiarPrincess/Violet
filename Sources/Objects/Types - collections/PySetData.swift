/// Small trick: when we use `Void` (which is the same as `()`) as value
/// then it would not take any space in dictionary!
/// For example `struct { Int, Void }` has the same storage as `struct { Int }`.
/// This trick is sponsored by 'go lang': `map[T]struct{}`.
internal typealias PySetData = OrderedDictionary<PySetElement, ()>

extension OrderedDictionary where Value == Void {
  internal mutating func insert(key: Key) -> InsertResult {
    return self.insert(key: key, value: ())
  }
}

internal struct PySetElement: PyHashable {

  internal var hash: PyHash
  internal var object: PyObject

  private var builtins: Builtins {
    return self.object.builtins
  }

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: PySetElement) -> PyResult<Bool> {

    guard self.hash == other.hash else {
      return .value(false)
    }

    return self.builtins.isEqualBool(left: self.object, right: other.object)
  }
}
