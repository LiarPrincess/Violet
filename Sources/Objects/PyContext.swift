// MARK: - Config

public struct PyContextConfig {
  public let hashKey0: UInt64
  public let hashKey1: UInt64

  public init(hashKey0: UInt64, hashKey1: UInt64) {
    self.hashKey0 = hashKey0
    self.hashKey1 = hashKey1
  }
}

// MARK: - Delegate

public protocol PyContextDelegate: AnyObject {
}

// MARK: - Context

public class PyContext {

  internal let hasher: Hasher
  internal weak var delegate: PyContextDelegate?

  public private(set) lazy var builtins = Builtins(context: self)

  public init(config: PyContextConfig, delegate: PyContextDelegate) {
    self.hasher = Hasher(key0: config.hashKey0, key1: config.hashKey1)
    self.delegate = delegate

    // This is hack, but we can access `self.builtins` here because they are
    // annotated as `lazy` (even though they need `PyContext` in ctor).
    self.builtins.onContextFullyInitailized()
  }

  deinit {
    self.builtins.onContextDeinit()
  }
}
