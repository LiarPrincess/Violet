import VioletCore

let loc0 = getLocation(0)
let loc1 = getLocation(1)
let loc2 = getLocation(2)
let loc3 = getLocation(3)
let loc4 = getLocation(4)
let loc5 = getLocation(5)
let loc6 = getLocation(6)
let loc7 = getLocation(7)
let loc8 = getLocation(8)
let loc9 = getLocation(9)
let loc10 = getLocation(10)
let loc11 = getLocation(11)
let loc12 = getLocation(12)
let loc13 = getLocation(13)
let loc14 = getLocation(14)
let loc15 = getLocation(15)
let loc16 = getLocation(16)
let loc17 = getLocation(17)
let loc18 = getLocation(18)
let loc19 = getLocation(19)
let loc20 = getLocation(20)
let loc21 = getLocation(21)
let loc22 = getLocation(22)
let loc23 = getLocation(23)
let loc24 = getLocation(24)
let loc25 = getLocation(25)
let loc26 = getLocation(26)
let loc27 = getLocation(27)
let loc28 = getLocation(28)
let loc29 = getLocation(29)
let loc30 = getLocation(30)
let loc31 = getLocation(31)

private func getLocation(_ n: UInt32) -> SourceLocation {
  let line = SourceLine(n)
  let column = SourceColumn((n % 2) * 5 + line) // some random
  return SourceLocation(line: line, column: column)
}
