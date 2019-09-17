import Foundation
import XCTest
@testable import VM

extension VM.Environment {
  init() {
    self.init(from: [:])
  }
}
