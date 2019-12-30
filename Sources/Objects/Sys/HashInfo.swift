public struct HashInfo {

  /// Name of the algorithm for hashing of str, bytes, and memoryview
  public let algorithm = Hasher.algorithm

  /// Width in bits used for hash values
  public let width = Hasher.width
  /// Internal output size of the hash algorithm
  public let hashBits = Hasher.hashBits
  /// Size of the seed key of the hash algorithm
  public let seedBits = Hasher.seedBits

  /// Prime modulus P used for numeric hash scheme
  public let modulus = Hasher.modulus
  /// Hash value returned for a positive infinity
  public let inf = Hasher.inf
  /// Hash value returned for a nan
  public let nan = Hasher.nan
  /// Multiplier used for the imaginary part of a complex number
  public let imag = Hasher.imag

  public let object: PyNamespace

  public init(context: PyContext) {
    let b = context.builtins

    // Ignore errors (because namespaces are made just to hold attributes).
    self.object = PyNamespace(context)
    _ = self.object.setAttribute(name: "width", value: b.newInt(self.width))
    _ = self.object.setAttribute(name: "modulus", value: b.newInt(self.modulus))
    _ = self.object.setAttribute(name: "inf", value: b.newInt(self.inf))
    _ = self.object.setAttribute(name: "nan", value: b.newInt(self.nan))
    _ = self.object.setAttribute(name: "imag", value: b.newInt(self.imag))
    _ = self.object.setAttribute(name: "algorithm", value: b.newString(self.algorithm))
    _ = self.object.setAttribute(name: "hash_bits", value: b.newInt(self.hashBits))
    _ = self.object.setAttribute(name: "seed_bits", value: b.newInt(self.seedBits))
  }
}
