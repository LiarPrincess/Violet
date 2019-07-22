// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal protocol FileDescriptor: AnyObject {
  func readData(ofLength length: Int) -> Data
  func closeFile()
}

extension FileHandle: FileDescriptor { }

// TODO: FileStreamState: notOpen(FH), open(FD), reading, closed; throw only when advance
internal class FileStream: InputStream {

  /// File from which we are reading.
  /// Nil when we finish reading.
  private var fd: FileDescriptor?

  /// How much data do we read at once?
  private let bufferSize: Int

  /// Encoding that we use to read file.
  private let encoding: String.Encoding

  /// Internal stream to which we will put data that we just read.
  private var stream = StringStream.empty

  convenience internal init(url:        URL,
                            encoding:   String.Encoding = .utf8,
                            bufferSize: Int = 4_096) throws {

    let fileHandle = try FileHandle(forReadingFrom: url)
    self.init(fd: fileHandle, encoding: encoding, bufferSize: bufferSize)
  }

  internal init(fd:         FileDescriptor,
                encoding:   String.Encoding = .utf8,
                bufferSize: Int = 4_096) {

    self.fd = fd
    self.encoding   = encoding
    self.bufferSize = bufferSize
  }

  deinit {
    self.close()
  }

  // MARK: - InputStream

  internal var peek: UnicodeScalar? {
    if let value = self.stream.peek {
      return value
    }

    self.fillStreamIfNotAtEnd()
    return self.stream.peek
  }

  internal func advance() -> UnicodeScalar? {
    if let value = self.stream.advance() {
      return value
    }

    self.fillStreamIfNotAtEnd()
    return self.stream.advance()
  }

  // MARK: - File handling

  /// Try to fill the stream (again) from file.
  private func fillStreamIfNotAtEnd() {
    guard let fd = self.fd else {
      return
    }

    let data = fd.readData(ofLength: self.bufferSize)

    // free fd as soon as we can
    if data.count < self.bufferSize {
      self.close()
    }

    if data.isEmpty {
      return
    }

    guard let result = String(data: data, encoding: self.encoding) else {
      // TODO: Handle file encoding error.
      fatalError("Just so the linter does not complain.")
    }

    self.stream = StringStream(result)
  }

  /// Close the underlying file.
  private func close() {
    self.fd?.closeFile()
    self.fd = nil
  }
}
