import Foundation

/// `value == mantissa * 2 ** exponent`
///
/// # Important
/// Do not use `Double.significand‚` or `Foundation.frexp`
/// (version that returns tuple)!
///
/// They return different results than `frexp` in CPython (which makes comparing
/// code very non-intuitive).
///
/// In Swift `value.significand` is always positive (afaik), for example:
/// ``` Swift
/// let value = -1.0
/// print(value.sign) -> minus
/// print(value.significand) -> 1.0 <- it is positive!
/// print(value.exponent) -> 0
/// ```
///
/// CPython uses version where significand is negative when value is negative
/// [cplusplus.com/frexp](https://www.cplusplus.com/reference/cmath/frexp).
///
/// # Naming
/// We could create our own `frexp` function, but then every reader would just
/// assume that we are using `Foundation` version.
/// If we start with uppercase then everyone will be like:
/// `wtf? uppercase? what is this? <surprised Pikachu face>`.
internal struct Frexp {

  internal let exponent: Int
  /// Negative if input number was negative!
  internal let mantissa: Double

  internal init(value: Double) {
    var e = Int32(0)
    self.mantissa = Foundation.frexp(value, &e) // non-tuple version
    self.exponent = Int(e)
  }
}
