import Core
import Objects

extension VM {

  /// Call this method if given funcionality is not implemented.
  internal func unimplemented(fn: StaticString = #function) -> Never {
    trap("Unimplemented '\(fn)'.")
  }
}
