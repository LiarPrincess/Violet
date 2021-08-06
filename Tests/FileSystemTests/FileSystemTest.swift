import XCTest
@testable import FileSystem

// swiftlint:disable implicitly_unwrapped_optional

/// Base class that will take care of creating `FileSystem`.
class FileSystemTest: XCTestCase {

  private(set) var fileSystem: FileSystem!
  private(set) var manager: FakeFileManager!

  override func setUp() {
    super.setUp()
    self.manager = FakeFileManager()
    self.fileSystem = FileSystem(fileManager: self.manager)
  }
}
