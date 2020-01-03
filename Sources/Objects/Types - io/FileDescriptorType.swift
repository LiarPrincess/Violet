import Foundation

public protocol FileDescriptorType {

  /// Raw descriptor value.
  /// It should be set to `-1` when file is closed.
  var raw: Int32 { get }

  func readToEnd() throws -> Data
  func read(upToCount count: Int) throws -> Data

  func write<T: DataProtocol>(contentsOf data: T) throws
  func synchronize() throws

  func offset() throws -> UInt64

  @discardableResult
  func seekToEnd() throws -> UInt64
  func seek(toOffset offset: UInt64) throws

  func close() throws
}
