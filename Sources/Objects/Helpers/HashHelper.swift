import Foundation
import Core

// In CPython:
// Python -> pyhash.c <-- Seriously look it up!
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/complex.html

public typealias PyHash = Int

// For numeric types, the hash of a number x is based on the reduction
// of x modulo the prime P = 2**_PyHASH_BITS - 1.
// It's designed so that hash(x) == hash(y) whenever x and y are numerically
// equal, even if x and y have different types.
internal enum HashHelper {

  /// Prime multiplier used in string and various other hashes (0xf4243).
  internal static let multiplier: PyHash = 1_000_003
  /// Numeric hashes are based on reduction modulo the prime 2**_BITS - 1
  internal static let bits: PyHash = 61

  internal static var modulus: PyHash { return ((1 << bits) - 1) }
  internal static var inf:     PyHash { return 314_159 }
  internal static var nan:     PyHash { return 0 }
  internal static var imag:    PyHash { return multiplier }
  internal static var shift:   PyHash { return 30 }

  /// static Py_hash_t
  /// long_hash(PyLongObject *v)
  internal static func hash(_ value: BigInt) -> PyHash {
    // CPython returns '-2' when the hash is equal to '-1',
    // as '-1' is reserved for errors.
    // We don't have to do it.

    let modulus = BigInt(HashHelper.modulus)
    // swiftlint:disable:next force_unwrapping
    return PyHash(exactly: value % modulus)!
  }

  /// Py_hash_t
  /// _Py_HashDouble(double v)
  internal static func hash(_ value: Double) -> PyHash {
    if !value.isFinite {
      if value.isInfinite {
        return value > 0 ? inf : -inf
      } else {
        return nan
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
      x = ((x << 28) & modulus) | x >> (bits - 28)
      m *= 268_435_456.0  // 2**28
      e -= 28
      let y = PyHash(m)  // pull out integer part
      m -= Double(y)
      x += y
      if x >= modulus {
        x -= modulus
      }
    }

    // adjust for the exponent; first reduce it modulo BITS
    let bits32 = Int32(bits)
    e = e >= 0 ? e % bits32 : bits32 - 1 - ((-1 - e) % bits32)
    x = ((x << e) & modulus) | x >> (bits32 - e)

    return sign * x
  }

  internal static func hash(_ value: String) -> PyHash {
    return HashHelper.hash(value.unicodeScalars)
  }

  internal static func hash<Scalars: Collection>(_ value: Scalars) -> PyHash
    where Scalars.Element == UnicodeScalar {

    fatalError()
  }

  internal static func hash(_ value: ObjectIdentifier) -> PyHash {
//    Py_hash_t x;
//    size_t y = (size_t)p;
//    /* bottom 3 or 4 bits are likely to be 0; rotate y by 4 to avoid
//     excessive hash collisions for dicts and sets */
//    y = (y >> 4) | (y << (8 * SIZEOF_VOID_P - 4));
//    x = (Py_hash_t)y;
//    if (x == -1)
//    x = -2;
//    return x;
    fatalError()
  }

  // TODO: Remove this
  private static func separator() {
    print("-----------------")
  }
}
