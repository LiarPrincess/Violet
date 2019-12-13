import Foundation

public protocol StandardOutput {
  func write(_ value: String)
}

extension FileHandle: StandardOutput {
  public func write(_ value: String) {
    // swiftlint:disable:next force_unwrapping
    let data = value.data(using: .utf8)!
    self.write(data)
  }
}
