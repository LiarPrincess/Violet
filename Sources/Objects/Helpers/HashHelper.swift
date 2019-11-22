import Foundation
import Core

// In CPython:
// Python -> pyhash.c <-- Seriously look it up!
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/complex.html

// TODO: What on 32 bit systems?
public typealias PyHash = Int

// For numeric types, the hash of a number x is based on the reduction
// of x modulo the prime P = 2**_PyHASH_BITS - 1.
// It's designed so that hash(x) == hash(y) whenever x and y are numerically
// equal, even if x and y have different types.
internal enum HashHelper {

  /// Prime multiplier used in string and various other hashes (0xf4243).
  internal static let _PyHASH_MULTIPLIER: PyHash = 1_000_003
  /// Numeric hashes are based on reduction modulo the prime 2**_BITS - 1
  internal static let _PyHASH_BITS: PyHash = 61

  internal static var _PyHASH_MODULUS: PyHash { return ((1 << _PyHASH_BITS) - 1) }
  internal static var _PyHASH_INF:     PyHash { return 314_159 }
  internal static var _PyHASH_NAN:     PyHash { return 0 }
  internal static var _PyHASH_IMAG:    PyHash { return _PyHASH_MULTIPLIER }
  internal static var PyLong_SHIFT:    PyHash { return 30 }

  internal static func hash(_ value: Double) -> PyHash {
    if !value.isFinite {
      if value.isInfinite {
        return value > 0 ? _PyHASH_INF : -_PyHASH_INF
      } else {
        return _PyHASH_NAN
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
      x = ((x << 28) & _PyHASH_MODULUS) | x >> (_PyHASH_BITS - 28)
      m *= 268_435_456.0  // 2**28
      e -= 28
      let y = PyHash(m)  // pull out integer part
      m -= Double(y)
      x += y
      if x >= _PyHASH_MODULUS {
        x -= _PyHASH_MODULUS
      }
    }

    // adjust for the exponent; first reduce it modulo BITS
    let BITS32 = Int32(_PyHASH_BITS)
    e = e >= 0 ? e % BITS32 : BITS32 - 1 - ((-1 - e) % BITS32)
    x = ((x << e) & _PyHASH_MODULUS) | x >> (BITS32 - e)

    return sign * x
  }

  internal static func hash(_ value: BigInt) -> PyHash {
    let sign: PyHash = value < 0 ? -1 : 1
    var x: PyHash = 0
    var i = abs(value)

    while i > 0 {
      // swiftlint:disable:next force_unwrapping
      let digit = PyHash(exactly: i % 10)!

      x = ((x << PyLong_SHIFT) & _PyHASH_MODULUS) | (x >> (_PyHASH_BITS - PyLong_SHIFT))
      x += digit
      if x >= _PyHASH_MODULUS {
        x -= _PyHASH_MODULUS
      }

      // swiftlint:disable:next shorthand_operator
      i = i / 10
    }

    return sign * x
  }

  internal static func hash(_ value: String) -> PyHash {
    fatalError()
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
}
