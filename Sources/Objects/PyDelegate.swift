public protocol PyDelegate: AnyObject {
  /// Extension point for opening files.
  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Extension point for opening files.
  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType>
}
