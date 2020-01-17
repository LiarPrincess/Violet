public class HashInfo {

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

  public lazy var object: PyNamespace = {
    let attributes = Attributes()
    attributes.set(key: "width", to: Py.newInt(self.width))
    attributes.set(key: "modulus", to: Py.newInt(self.modulus))
    attributes.set(key: "inf", to: Py.newInt(self.inf))
    attributes.set(key: "nan", to: Py.newInt(self.nan))
    attributes.set(key: "imag", to: Py.newInt(self.imag))
    attributes.set(key: "algorithm", to: Py.newString(self.algorithm))
    attributes.set(key: "hash_bits", to: Py.newInt(self.hashBits))
    attributes.set(key: "seed_bits", to: Py.newInt(self.seedBits))
    return Py.newNamespace(attributes: attributes)
  }()
}
