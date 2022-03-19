import XCTest
import VioletCore
@testable import VioletObjects

// For some reason 'int' does not have '--' separator.
private let intDoc = """
  int([x]) -> integer
  int(x, base=10) -> integer

  Convert a number or string to an integer, or return 0 if no arguments
  are given.  If x is a number, return x.__int__().  For floating point
  numbers, this truncates towards zero.

  If x is not a number or if base is given, then x must be a string,
  bytes, or bytearray instance representing an integer literal in the
  given base.  The literal can be preceded by '+' or '-' and be surrounded
  by whitespace.  The base defaults to 10.  Valid bases are 0 and 2-36.
  Base 0 means to interpret the base from the string as an integer literal.
  >>> int('0b100', base=0)
  4
  """

// List has proper '--'
private let listDoc = """
  list(iterable=(), /)
  --

  Built-in mutable sequence.

  If no argument is given, the constructor creates a new empty list.
  The argument must be an iterable if specified.
  """

// List has proper '--'
private let moduleDoc = """
  module(name, doc=None)
  --

  Create a module object.
  The name must be a string; the optional doc argument can have any type.
  """

class DocHelperTests: XCTestCase {

  // MARK: - Signature

  func test_signature_noSeparator_int() {
    let doc = self.getSignature(intDoc)
    XCTAssertNil(doc)
  }

  func test_signature_properSeparator_list() {
    let doc = self.getSignature(listDoc)
    let expected = "(iterable=(), /)"

    XCTAssertEqual(doc, expected)
  }

  func test_signature_properSeparator_module() {
    let doc = self.getSignature(moduleDoc)
    let expected = "(name, doc=None)"

    XCTAssertEqual(doc, expected)
  }

  // MARK: - Doc without signature

  func test_doc_noSeparator_int() {
    let doc = self.getDocWithoutSignature(intDoc)
    let expected = intDoc

    XCTAssertEqual(doc, expected)
  }

  func test_doc_properSeparator_list() {
    let doc = self.getDocWithoutSignature(listDoc)
    let expected = """
      Built-in mutable sequence.

      If no argument is given, the constructor creates a new empty list.
      The argument must be an iterable if specified.
      """

    XCTAssertEqual(doc, expected)
  }

  func test_doc_properSeparator_module() {
    let doc = self.getDocWithoutSignature(moduleDoc)
    let expected = """
      Create a module object.
      The name must be a string; the optional doc argument can have any type.
      """

    XCTAssertEqual(doc, expected)
  }

  // MARK: - Helpers

  private func getSignature(_ doc: String) -> String? {
    return DocHelper.getSignature(doc)
  }

  private func getDocWithoutSignature(_ doc: String) -> String {
    return DocHelper.getDocWithoutSignature(doc)
  }
}
