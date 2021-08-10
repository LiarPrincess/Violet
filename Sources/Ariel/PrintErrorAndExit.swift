import Foundation

func printErrorAndExit(_ msg: String) -> Never {
  print(msg)
  exit(EXIT_FAILURE)
}
