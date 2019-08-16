import Core

internal var loc0:  SourceLocation { return getLocation( 0) }
internal var loc1:  SourceLocation { return getLocation( 1) }
internal var loc2:  SourceLocation { return getLocation( 2) }
internal var loc3:  SourceLocation { return getLocation( 3) }
internal var loc4:  SourceLocation { return getLocation( 4) }
internal var loc5:  SourceLocation { return getLocation( 5) }
internal var loc6:  SourceLocation { return getLocation( 6) }
internal var loc7:  SourceLocation { return getLocation( 7) }
internal var loc8:  SourceLocation { return getLocation( 8) }
internal var loc9:  SourceLocation { return getLocation( 9) }
internal var loc10: SourceLocation { return getLocation(10) }
internal var loc11: SourceLocation { return getLocation(11) }
internal var loc12: SourceLocation { return getLocation(12) }
internal var loc13: SourceLocation { return getLocation(13) }
internal var loc14: SourceLocation { return getLocation(14) }
internal var loc15: SourceLocation { return getLocation(15) }
internal var loc16: SourceLocation { return getLocation(16) }
internal var loc17: SourceLocation { return getLocation(17) }
internal var loc18: SourceLocation { return getLocation(18) }
internal var loc19: SourceLocation { return getLocation(19) }
internal var loc20: SourceLocation { return getLocation(20) }
internal var loc21: SourceLocation { return getLocation(21) }
internal var loc22: SourceLocation { return getLocation(22) }
internal var loc23: SourceLocation { return getLocation(23) }
internal var loc24: SourceLocation { return getLocation(24) }
internal var loc25: SourceLocation { return getLocation(25) }
internal var loc26: SourceLocation { return getLocation(26) }
internal var loc27: SourceLocation { return getLocation(27) }
internal var loc28: SourceLocation { return getLocation(28) }
internal var loc29: SourceLocation { return getLocation(29) }
internal var loc30: SourceLocation { return getLocation(30) }
internal var loc31: SourceLocation { return getLocation(31) }

private func getLocation(_ n: Int) -> SourceLocation {
  let line = n
  let column = (n % 2) * 5 + line // some random
  return SourceLocation(line: line, column: column)
}
