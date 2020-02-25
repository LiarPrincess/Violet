import Core

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
    let dict = PyDict()

    func set(name: String, value: PyObject) {
      let interned = Py.getInterned(name)
      switch dict.set(key: interned, to: value) {
      case .ok:
        break
      case .error(let e):
        trap("Error when creating 'hash_info' namespace: \(e)")
      }
    }

    set(name: "width", value: Py.newInt(self.width))
    set(name: "modulus", value: Py.newInt(self.modulus))
    set(name: "inf", value: Py.newInt(self.inf))
    set(name: "nan", value: Py.newInt(self.nan))
    set(name: "imag", value: Py.newInt(self.imag))
    set(name: "algorithm", value: Py.newString(self.algorithm))
    set(name: "hash_bits", value: Py.newInt(self.hashBits))
    set(name: "seed_bits", value: Py.newInt(self.seedBits))

    return Py.newNamespace(dict: dict)
  }()
}
