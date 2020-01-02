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

// MARK: - New

public protocol FileDescriptor {
  var name: String? { get }
  var mode: FileMode { get }

  func readData(ofLength length: Int) -> Data
  func readDataToEndOfFile() -> Data

//  @available(OSX, introduced: 10.0, deprecated: 100000)
//  open func write(_ data: Data)

//  @available(OSX, introduced: 10.0, deprecated: 100000)
//  open func seek(toFileOffset offset: UInt64)
//  @available(OSX, introduced: 10.0, deprecated: 100000)
//  open func closeFile()
}
