import Foundation
import Core

// In CPython:
// Python -> pyhash.c <-- Seriously look it up!
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/complex.html

internal typealias PyHash = Int64

// For numeric types, the hash of a number x is based on the reduction
// of x modulo the prime P = 2**_PyHASH_BITS - 1.
// It's designed so that hash(x) == hash(y) whenever x and y are numerically
// equal, even if x and y have different types.
internal struct Hasher {

  /// Prime multiplier used in string and various other hashes (0xf4243).
  internal let _PyHASH_MULTIPLIER: PyHash = 1_000_003
  /// Numeric hashes are based on reduction modulo the prime 2**_BITS - 1
  internal let _PyHASH_BITS: PyHash = 61

  internal var _PyHASH_MODULUS: PyHash { return ((1 << _PyHASH_BITS) - 1) }
  internal var _PyHASH_INF:     PyHash { return 314_159 }
  internal var _PyHASH_NAN:     PyHash { return 0 }
  internal var _PyHASH_IMAG:    PyHash { return _PyHASH_MULTIPLIER }
  internal var PyLong_SHIFT:    PyHash { return 30 }

  internal func hash(_ value: Double) -> PyHash {
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

    x *= sign
    if x == -1 {
      x = -2
    }
    return x
  }

  internal func hash(_ value: BigInt) -> PyHash {
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

    x *= sign
    if x == -1 {
      x = -2
    }
    return x
  }
}
