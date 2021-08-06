import Foundation
@testable import FileSystem

// swiftlint:disable force_unwrapping

class FakeFileManager: FileManagerType {

  // MARK: - File system representation

  func fileSystemRepresentation(withPath path: String) -> UnsafePointer<Int8> {
    let scalars = path.unicodeScalars
    let count = scalars.count

    let countPlusNullTerminator = count + 1
    let bufferPtr = UnsafeMutableBufferPointer<Int8>.allocate(
      capacity: countPlusNullTerminator
    )

    for (index, scalar) in scalars.enumerated() {
      assert(scalar.isASCII)
      bufferPtr[index] = Int8(scalar.value)
    }
    bufferPtr[count] = 0

    // Caller is responsible for deallocation
    let ptr = bufferPtr.baseAddress!
    return UnsafePointer(ptr)
  }

  func string(withFileSystemRepresentation str: UnsafePointer<Int8>,
              length len: Int) -> String {
    var result = ""
    result.reserveCapacity(len)

    var ptr = str
    for _ in 0..<len {
      let i8 = ptr.pointee
      let u8 = UInt8(bitPattern: i8)
      let scalar = UnicodeScalar(u8)

      result.unicodeScalars.append(scalar)
      ptr = ptr.advanced(by: 1)
    }

    return result
  }

  // MARK: - File exists

  var existingFiles = Set<String>()

  func fileExists(atPath path: String) -> Bool {
    return self.existingFiles.contains(path)
  }

  // MARK: - Current directory path

  var currentDirectoryPath = "CURRENT_WORKING_DIRECTORY"

  var canChangeCurrentDirectoryPath = true

  func changeCurrentDirectoryPath(_ path: String) -> Bool {
    if self.canChangeCurrentDirectoryPath {
      self.currentDirectoryPath = path
    }

    return self.canChangeCurrentDirectoryPath
  }
}
