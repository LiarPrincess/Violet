// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

// MARK: - PyType

extension PyType {
  public struct MemoryLayout {
    internal func isEqual(to other: MemoryLayout) -> Bool {
      fatalError()
    }

    internal func isAddingNewProperties(to other: MemoryLayout) -> Bool {
      fatalError()
    }
  }
}
