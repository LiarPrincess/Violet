import Foundation

// swiftlint:disable let_var_whitespace

internal protocol FileManagerType {

  /// Returns an array of characters suitable for passing to lower-level POSIX
  /// style APIs. The string is provided in the representation most appropriate
  /// for the filesystem in question.
  func fileSystemRepresentation(withPath path: String) -> UnsafePointer<Int8>
  /// Returns an NSString created from an array of bytes that are in the filesystem
  /// representation.
  func string(withFileSystemRepresentation str: UnsafePointer<Int8>,
              length len: Int) -> String

  /// The following methods are of limited utility.
  ///
  /// Attempting to predicate behavior based on the current state of the filesystem
  /// or a particular file on the filesystem is encouraging odd behavior in the face
  /// of filesystem race conditions.
  ///
  /// It's far better to attempt an operation (like loading a file or creating a
  /// directory) and handle the error gracefully than it is to try to figure out
  /// ahead of time whether the operation will succeed.
  func fileExists(atPath path: String) -> Bool

  /// Process working directory management.
  /// Despite the fact that these are instance methods on NSFileManager,
  /// these methods report and change (respectively) the working directory for
  /// the entire process.
  /// Developers are cautioned that doing so is fraught with peril.
  var currentDirectoryPath: String { get }
  func changeCurrentDirectoryPath(_ path: String) -> Bool
}

extension FileManager: FileManagerType {}
