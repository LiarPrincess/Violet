import Foundation

public func printErrorAndExit(_ msg: String) -> Never {
  print(msg)
  exit(EXIT_FAILURE)
}
