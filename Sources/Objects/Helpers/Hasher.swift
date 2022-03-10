import Foundation
import BigInt
import VioletCore

// cSpell:ignore pyhash longobject

// In CPython:
// Python -> pyhash.c <-- Seriously look it up!
// Objects -> longobject.c
// https://www.python.org/dev/peps/pep-0456
//
// >>> import sys
// >>> sys.hash_info
// sys.hash_info(width=64,
//               modulus=2305843009213693951,
//               inf=314159,
//               nan=0,
//               imag=1000003,
//               algorithm='siphash24',
//               hash_bits=64,
//               seed_bits=128,
//               cutoff=0)

// MARK: - PyHash

public typealias PyHash = Int

// MARK: - Helper

// For numeric types, the hash of a number x is based on the reduction
// of x modulo the prime P = 2**_PyHASH_BITS - 1.
// It's designed so that hash(x) == hash(y) whenever x and y are numerically
// equal, even if x and y have different types.
internal struct Hasher {

  // MARK: - Constants

  /// Name of the algorithm for hashing of str, bytes, and memoryview
  internal static let algorithm = "siphash24"

  /// Width in bits used for hash values
  internal static let width: PyHash = 64
  /// Internal output size of the hash algorithm
  internal static let hashBits: PyHash = 64
  /// Size of the seed key of the hash algorithm
  internal static let seedBits: PyHash = 128

  /// Prime modulus P used for numeric hash scheme
  internal static let modulus: PyHash = ((1 << bits) - 1)
  /// Prime multiplier used in string and various other hashes (0xf4243).
  internal static let multiplier: PyHash = 1_000_003
  /// Numeric hashes are based on reduction modulo the prime 2**_BITS - 1
  internal static let bits: PyHash = 61

  /// Value used as hash for infinity.
  internal static let inf: PyHash = 314_159
  /// Value used as hash for nan.
  internal static let nan: PyHash = 0
  /// Value used for hashing complex values.
  internal static let imag: PyHash = multiplier

  // MARK: - Init

  private let key0: UInt64
  private let key1: UInt64

  internal init(key0: UInt64, key1: UInt64) {
    self.key0 = key0
    self.key1 = key1
  }

  // MARK: - Ptr

  internal func hash(_ ptr: RawPtr) -> PyHash {
    let int = Int(bitPattern: ptr)
    return self.hash(int)
  }

  // MARK: - Int

  /// static Py_hash_t
  /// long_hash(PyLongObject *v)
  internal func hash(_ value: Int) -> PyHash {
    // CPython returns '-2' when the hash is equal to '-1',
    // as '-1' is reserved for errors.
    // We don't have to do it.

    let modulus = Hasher.modulus
    // swiftlint:disable:next force_unwrapping
    return PyHash(exactly: value % modulus)!
  }

  /// static Py_hash_t
  /// long_hash(PyLongObject *v)
  internal func hash(_ value: BigInt) -> PyHash {
    let modulus = BigInt(Hasher.modulus)
    // swiftlint:disable:next force_unwrapping
    return PyHash(exactly: value % modulus)!
  }

  // MARK: - Double

  /// Py_hash_t
  /// _Py_HashDouble(double v)
  internal func hash(_ value: Double) -> PyHash {
    if !value.isFinite {
      if value.isInfinite {
        return value > 0 ? Hasher.inf : -Hasher.inf
      } else {
        return Hasher.nan
      }
    }

    // Complicated stuff incoming, basically 1:1 from CPython:
    let frexp = Frexp(value: value)
    var exponent = frexp.exponent
    var mantissa = frexp.mantissa

    var sign: PyHash = 1
    if mantissa < 0 {
      sign = -1
      mantissa = -mantissa
    }

    // process 28 bits at a time
    var result: PyHash = 0
    while mantissa > 0 {
      result = ((result << 28) & Hasher.modulus) | result >> (Hasher.bits - 28)
      mantissa *= 268_435_456.0 // 2**28
      exponent -= 28

      let mantissaInt = PyHash(mantissa) // pull out integer part
      mantissa -= Double(mantissaInt)
      result += mantissaInt

      if result >= Hasher.modulus {
        result -= Hasher.modulus
      }
    }

    // adjust for the exponent; first reduce it modulo BITS
    let bits = Hasher.bits
    exponent = exponent >= 0 ?
      exponent % bits :
      bits - 1 - ((-1 - exponent) % bits)
    result = ((result << exponent) & Hasher.modulus) | result >> (bits - exponent)

    return sign * result
  }

  // MARK: - String

  internal func hash(_ value: String) -> PyHash {
    if value.isEmpty {
      return 0
    }

    // If I understand this correctly then for native strings (our typical case)
    // it will not mutate which will prevent allocation
    // (native strings already have contiguous storage).
    // But I don't really have time to look at this more closely.
    var fingersCrossedForNoAllocation = value
    let hash = fingersCrossedForNoAllocation.withUTF8 { ptr in
      SipHash.hash(key0: self.key0, key1: self.key1, bytes: ptr)
    }

    return self.toPyHash(hash)
  }

  internal func hash(_ value: Data) -> PyHash {
    if value.isEmpty {
      return 0
    }

    // This is based on how Foundation hashes Data (at least in 'LargeSlice'
    // representation, and also they use only the first 80 bytes).
    //
    // Note that 'withContiguousStorageIfAvailable' will always fail.
    let hash = value.withUnsafeBytes { ptr in
      SipHash.hash(key0: self.key0, key1: self.key1, bytes: ptr)
    }

    return self.toPyHash(hash)
  }

  private func toPyHash(_ value: UInt64) -> PyHash {
    // We support only 64 bit platforms which means that `PyHash` is 64 bit.
    // SipHash returns UInt64 value.
    // 'truncatingIfNeeded' in this case means bit cast, for example:
    //   let sipHash: UInt64 = 12084556205844325756
    //   PyHash(truncatingIfNeeded: sipHash) // which is -6362187867865225860
    // Which is the same as:
    //  Int64(bitPattern: sipHash)
    return PyHash(truncatingIfNeeded: value)
  }
}
