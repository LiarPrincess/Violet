internal protocol UnicodeScalarConvertible {
  var asUnicodeScalar: UnicodeScalar { get }
}

extension UnicodeScalar: UnicodeScalarConvertible {
  var asUnicodeScalar: UnicodeScalar { self }
}

extension UInt8: UnicodeScalarConvertible {
  var asUnicodeScalar: UnicodeScalar { UnicodeScalar(self) }
}
