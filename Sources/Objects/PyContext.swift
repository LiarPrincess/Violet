public class PyContext {

  public lazy var builtins = Builtins(context: self)

  internal let hasher: PyHasher

  public init(hashKey0: UInt64, hashKey1: UInt64) {
    self.hasher = PyHasher(key0: hashKey0, key1: hashKey1)
  }
}
