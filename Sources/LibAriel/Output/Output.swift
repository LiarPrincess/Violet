import Foundation

public protocol Output: TextOutputStream {
  func close()
}
