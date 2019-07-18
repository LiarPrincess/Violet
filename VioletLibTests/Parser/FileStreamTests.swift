// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
@testable import VioletLib

private class FakeFileDescriptor: FileDescriptor {

  fileprivate var data: Data
  fileprivate var closeFileHitCount = 0

  fileprivate init(data: Data = Data()) {
    self.data = data
  }

  fileprivate func readData(ofLength length: Int) -> Data {
    let resultCount = min(length, self.data.count)
    let result = self.data[0..<resultCount]

    // so that we don't read the same data again
    self.data = self.data.subdata(in: resultCount..<self.data.count)
    return result
  }

  fileprivate func closeFile() {
    self.closeFileHitCount += 1
  }
}

class FileStreamTests: XCTestCase {

  private let asciiABC: [UInt8] = [0x41, 0x42, 0x43]

  func test_closesFile_onDeinit() {
    let fd = FakeFileDescriptor()

    do { // just so we have scope
      let stream = FileStream(fd: fd)
      XCTAssertEqual(fd.closeFileHitCount, 0)
    }

    XCTAssertEqual(fd.closeFileHitCount, 1)
  }

  func test_readingWholeFile_returnsData_andClosesFile() {
    let dataCount  = 15
    let bufferSize = 10 // < dataCount, so we fill buffer 2 times

    let dataRaw = (0..<dataCount).map { self.asciiABC[$0 % 3] }
    let fd = FakeFileDescriptor(data: Data(dataRaw))

    let stream = FileStream(fd: fd, encoding: .ascii, bufferSize: bufferSize)
    XCTAssertEqual(fd.closeFileHitCount, 0)

    // first 10 - fill full buffer
    for i in 0..<bufferSize {
      let c = UnicodeScalar(dataRaw[i])
      XCTAssertEqual(stream.peek, c)
      XCTAssertEqual(stream.advance(), c)
      XCTAssertEqual(fd.closeFileHitCount, 0)
    }

    // next 5 - fill part of the buffer (should close fd)
    for i in bufferSize..<dataCount {
      let c = UnicodeScalar(dataRaw[i])
      XCTAssertEqual(stream.peek, c)
      XCTAssertEqual(stream.advance(), c)
      XCTAssertEqual(fd.closeFileHitCount, 1)
    }
  }
}
