import XCTest
import Objects

// swiftlint:disable weak_delegate

/// Test case that uses `Py`.
class PyTestCaseOtherwiseItWillTrap: XCTestCase {

  let config = PyConfig()
  let delegate = PyFakeDelegate()

  override func setUp() {
    super.setUp()
    Py.initialize(config: self.config, delegate: self.delegate)
  }

  override func tearDown() {
    super.tearDown()
    Py.destroy()
  }
}
