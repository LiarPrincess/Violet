import Foundation

public protocol FileDescriptorType {

  /// Raw descriptor value.
  /// It should be set to `-1` when the file is closed.
  var raw: Int32 { get }

  func readLine() -> PyResult<Data>
  func readToEnd() -> PyResult<Data>
  func read(upToCount count: Int) -> PyResult<Data>

  func write<T: DataProtocol>(contentsOf data: T) -> PyResult<PyNone>
  func flush() -> PyResult<PyNone>

  func offset() -> PyResult<UInt64>

  @discardableResult
  func seekToEnd() -> PyResult<UInt64>
  func seek(toOffset offset: UInt64) -> PyResult<PyNone>

  func close() -> PyResult<PyNone>
}
