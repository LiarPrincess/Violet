import Foundation
import Core

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

  // MARK: - Int

  /// static Py_hash_t
  /// long_hash(PyLongObject *v)
  internal func hash(_ value: BigInt) -> PyHash {
    // CPython returns '-2' when the hash is equal to '-1',
    // as '-1' is reserved for errors.
    // We don't have to do it.

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

    var e: Int32 = 0
    var m = frexp(value, &e)

    var sign: PyHash = 1
    if m < 0 {
      sign = -1
      m = -m
    }

    // process 28 bits at a time;
    // this should work well both for binary and hexadecimal floating point.
    var x: PyHash = 0
    while m > 0 {
      x = ((x << 28) & Hasher.modulus) | x >> (Hasher.bits - 28)
      m *= 268_435_456.0  // 2**28
      e -= 28
      let y = PyHash(m)  // pull out integer part
      m -= Double(y)
      x += y
      if x >= Hasher.modulus {
        x -= Hasher.modulus
      }
    }

    // adjust for the exponent; first reduce it modulo BITS
    let bits32 = Int32(Hasher.bits)
    e = e >= 0 ? e % bits32 : bits32 - 1 - ((-1 - e) % bits32)
    x = ((x << e) & Hasher.modulus) | x >> (bits32 - e)

    return sign * x
  }

  // MARK: - String

  internal func hash(_ value: String) -> PyHash {
    if value.isEmpty {
      return 0
    }

    let hashOrNil = value.utf8.withContiguousStorageIfAvailable { ptr -> UInt64 in
      SipHash.hash(key0: self.key0, key1: self.key1, bytes: ptr)
    }

    guard let hash = hashOrNil else {
      let method = "utf8.withContiguousStorageIfAvailable"
      trap("Error when hashing '\(value)', unable to obtain '\(method)'")
    }

    return self.toPyHash(hash)
  }

  internal func hash(_ value: Data) -> PyHash {
    if value.isEmpty {
      return 0
    }

    let hashOrNil = value.withContiguousStorageIfAvailable { ptr -> UInt64 in
      SipHash.hash(key0: self.key0, key1: self.key1, bytes: ptr)
    }

    guard let hash = hashOrNil else {
      let method = "Data.withContiguousStorageIfAvailable"
      trap("Error when hashing '\(value)', unable to obtain '\(method)'")
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

  // MARK: - Pointer

  internal func hash(_ value: ObjectIdentifier) -> PyHash {
    // In Swift we dont really have access to pointers
    // (we could if we really had to but the language does not guarantee that
    // it will work in all cases).
    // So we will use Swift hash.
    return value.hashValue
  }
}
