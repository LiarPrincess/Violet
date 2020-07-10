@testable import BigInt

extension BigInt {

  internal var isSmi: Bool {
    switch self.value {
    case .smi: return true
    case .heap: return false
    }
  }

  internal var isHeap: Bool {
    return !self.isSmi
  }
}
