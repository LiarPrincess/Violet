import XCTest
import Core
@testable import Objects

internal func XCTAssertTypeError(error: PyBaseException,
                                 msg: String,
                                 file: StaticString = #file,
                                 line: UInt         = #line) {
  XCTAssert(error is PyTypeError,
            "'\(error.typeName)' is not a type error.",
            file: file,
            line: line)

  if let m = extractMsgFromFirstArg(error: error, file: file, line: line) {
    XCTAssertEqual(m, msg)
  }
}

private func extractMsgFromFirstArg(error: PyBaseException,
                                    file: StaticString,
                                    line: UInt) -> String? {
  guard let firstArg = error.args.elements.first else {
    XCTAssert(false, "Empty args.", file: file, line: line)
    return nil
  }

  guard let msgString = firstArg as? PyString else {
    XCTAssert(false, String(describing: firstArg), file: file, line: line)
    return nil
  }

  return msgString.value
}
