public class PyContext {

  internal let hasher: PyHasher

  public private(set) lazy var builtins = Builtins(context: self)

  public init(hashKey0: UInt64, hashKey1: UInt64) {
    self.hasher = PyHasher(key0: hashKey0, key1: hashKey1)

    // This is hack, but we can access `self.builtins` here because they were
    // annotated as `lazy` (even though they need `PyContext` in ctor).
    self.builtins.onContextFullyInitailized()
  }

  deinit {
    self.builtins.onContextDeinit()
  }
}
