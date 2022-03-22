import Foundation

public protocol FileDescriptorType {

  /// Raw descriptor value.
  /// It should be set to `-1` when the file is closed.
  var raw: Int32 { get }

  func readLine() -> PyResultGen<Data>
  func readToEnd() -> PyResultGen<Data>
  func read(upToCount count: Int) -> PyResultGen<Data>

  func write<T: DataProtocol>(contentsOf data: T) -> PyBaseException?
  func flush() -> PyBaseException?

  func offset() -> PyResultGen<UInt64>

  @discardableResult
  func seekToEnd() -> PyResultGen<UInt64>
  func seek(toOffset offset: UInt64) -> PyBaseException?

  func close() -> PyBaseException?
}
