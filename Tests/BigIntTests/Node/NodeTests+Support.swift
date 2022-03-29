import XCTest
import BigInt

// swiftlint:disable function_parameter_count

// Basically all of the code that does not need to be regenerated by Node.
extension NodeTests {

  // MARK: - Unary operations

  internal func plusTest(value: String,
                         expecting: String,
                         file: StaticString = #file,
                         line: UInt = #line) {
    self.unaryOp(
      value: value,
      expecting: expecting,
      op: { +$0 },
      file: file,
      line: line
    )
  }

  internal func minusTest(value: String,
                          expecting: String,
                          file: StaticString = #file,
                          line: UInt = #line) {
    self.unaryOp(
      value: value,
      expecting: expecting,
      op: { -$0 },
      file: file,
      line: line
    )
  }

  internal func invertTest(value: String,
                           expecting: String,
                           file: StaticString = #file,
                           line: UInt = #line) {
    self.unaryOp(
      value: value,
      expecting: expecting,
      op: { ~$0 },
      file: file,
      line: line
    )
  }

  internal typealias UnaryOperation = (BigInt) -> BigInt

  private func unaryOp(value valueString: String,
                       expecting expectedString: String,
                       op: UnaryOperation,
                       file: StaticString,
                       line: UInt) {
    let value: BigInt
    do {
      value = try self.create(string: valueString, radix: 10)
    } catch {
      XCTFail("Unable to parse value: \(error)", file: file, line: line)
      return
    }

    let expected: BigInt
    do {
      expected = try self.create(string: expectedString, radix: 10)
    } catch {
      XCTFail("Unable to parse expected: \(error)", file: file, line: line)
      return
    }

    let result = op(value)
    XCTAssertEqual(result, expected, file: file, line: line)
  }

  // MARK: - Binary operations

  internal func addTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 + $1 },
      inoutOp: { $0 += $1 },
      file: file,
      line: line
    )
  }

  internal func subTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 - $1 },
      inoutOp: { $0 -= $1 },
      file: file,
      line: line
    )
  }

  internal func mulTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 * $1 },
      inoutOp: { $0 *= $1 },
      file: file,
      line: line
    )
  }

  internal func divTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 / $1 },
      inoutOp: { $0 /= $1 },
      file: file,
      line: line
    )
  }

  internal func modTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 % $1 },
      inoutOp: { $0 %= $1 },
      file: file,
      line: line
    )
  }

  internal func andTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 & $1 },
      inoutOp: { $0 &= $1 },
      file: file,
      line: line
    )
  }

  internal func orTest(lhs: String,
                       rhs: String,
                       expecting: String,
                       file: StaticString = #file,
                       line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 | $1 },
      inoutOp: { $0 |= $1 },
      file: file,
      line: line
    )
  }

  internal func xorTest(lhs: String,
                        rhs: String,
                        expecting: String,
                        file: StaticString = #file,
                        line: UInt = #line) {
    self.binaryOp(
      lhs: lhs,
      rhs: rhs,
      expecting: expecting,
      op: { $0 ^ $1 },
      inoutOp: { $0 ^= $1 },
      file: file,
      line: line
    )
  }

  internal typealias BinaryOperation = (BigInt, BigInt) -> BigInt
  internal typealias InoutBinaryOperation = (inout BigInt, BigInt) -> Void

  private func binaryOp(lhs lhsString: String,
                        rhs rhsString: String,
                        expecting expectedString: String,
                        op: BinaryOperation,
                        inoutOp: InoutBinaryOperation,
                        file: StaticString,
                        line: UInt) {
    let lhs: BigInt
    let lhsBeforeInout: BigInt // Later to check if 'inout' did not modify original
    do {
      lhs = try self.create(string: lhsString, radix: 10)
      lhsBeforeInout = try self.create(string: lhsString, radix: 10)
    } catch {
      XCTFail("Unable to parse lhs: \(error)", file: file, line: line)
      return
    }

    let rhs: BigInt
    do {
      rhs = try self.create(string: rhsString, radix: 10)
    } catch {
      XCTFail("Unable to parse rhs: \(error)", file: file, line: line)
      return
    }

    let expected: BigInt
    do {
      expected = try self.create(string: expectedString, radix: 10)
    } catch {
      XCTFail("Unable to parse expected: \(error)", file: file, line: line)
      return
    }

    // Check 'standard' op
    let result = op(lhs, rhs)
    XCTAssertEqual(result, expected, file: file, line: line)

    // Check 'inout' op
    var inoutLhs = lhs
    inoutOp(&inoutLhs, rhs)
    XCTAssertEqual(inoutLhs, expected, "INOUT!!1", file: file, line: line)

    // Make sure that 'inout' did not modify original
    let inoutMsg = "Inout did modify shared/original value"
    XCTAssertEqual(lhs, lhsBeforeInout, inoutMsg, file: file, line: line)
  }

  // MARK: - Div mod

  internal func divModTest(lhs lhsString: String,
                           rhs rhsString: String,
                           div divString: String,
                           mod modString: String,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let lhs: BigInt
    do {
      lhs = try self.create(string: lhsString, radix: 10)
    } catch {
      XCTFail("Unable to parse lhs: \(error)", file: file, line: line)
      return
    }

    let rhs: BigInt
    do {
      rhs = try self.create(string: rhsString, radix: 10)
    } catch {
      XCTFail("Unable to parse rhs: \(error)", file: file, line: line)
      return
    }

    let div: BigInt
    do {
      div = try self.create(string: divString, radix: 10)
    } catch {
      XCTFail("Unable to parse div: \(error)", file: file, line: line)
      return
    }

    let mod: BigInt
    do {
      mod = try self.create(string: modString, radix: 10)
    } catch {
      XCTFail("Unable to parse mod: \(error)", file: file, line: line)
      return
    }

    let result = lhs.quotientAndRemainder(dividingBy: rhs)
    XCTAssertEqual(result.quotient, div, "div", file: file, line: line)
    XCTAssertEqual(result.remainder, mod, "mod", file: file, line: line)
  }

  // MARK: - Power

  internal func powerTest(base baseString: String,
                          exponent exponentInt: Int,
                          expecting expectedString: String,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let base: BigInt
    do {
      base = try self.create(string: baseString, radix: 10)
    } catch {
      XCTFail("Unable to parse lhs: \(error)", file: file, line: line)
      return
    }

    let expected: BigInt
    do {
      expected = try self.create(string: expectedString, radix: 10)
    } catch {
      XCTFail("Unable to parse expected: \(error)", file: file, line: line)
      return
    }

    let exp = BigInt(exponentInt)
    let result = base.power(exponent: exp)
    XCTAssertEqual(result, expected, file: file, line: line)
  }

  // MARK: - Shifts

  internal func shiftLeftTest(value: String,
                              count: Int,
                              expecting: String,
                              file: StaticString = #file,
                              line: UInt = #line) {
    self.shiftOp(
      value: value,
      count: count,
      expecting: expecting,
      op: { $0 << $1 },
      inoutOp: { $0 <<= $1 },
      file: file,
      line: line
    )
  }

  internal func shiftRightTest(value: String,
                               count: Int,
                               expecting: String,
                               file: StaticString = #file,
                               line: UInt = #line) {
    self.shiftOp(
      value: value,
      count: count,
      expecting: expecting,
      op: { $0 >> $1 },
      inoutOp: { $0 >>= $1 },
      file: file,
      line: line
    )
  }

  internal typealias ShiftOperation = (BigInt, BigInt) -> BigInt
  internal typealias InoutShiftOperation = (inout BigInt, BigInt) -> Void

  private func shiftOp(value valueString: String,
                       count countInt: Int,
                       expecting expectedString: String,
                       op: ShiftOperation,
                       inoutOp: InoutShiftOperation,
                       file: StaticString,
                       line: UInt) {

    let value: BigInt
    let valueBeforeInout: BigInt // Later to check if 'inout' did not modify original
    do {
      value = try self.create(string: valueString, radix: 10)
      valueBeforeInout = try self.create(string: valueString, radix: 10)
    } catch {
      XCTFail("Unable to parse lhs: \(error)", file: file, line: line)
      return
    }

    let count = BigInt(countInt)

    let expected: BigInt
    do {
      expected = try self.create(string: expectedString, radix: 10)
    } catch {
      XCTFail("Unable to parse expected: \(error)", file: file, line: line)
      return
    }

    // Check 'standard' op
    let result = op(value, count)
    XCTAssertEqual(result, expected, file: file, line: line)

    // Check 'inout' op
    var inoutValue = value
    inoutOp(&inoutValue, count)
    XCTAssertEqual(inoutValue, expected, "INOUT!!1", file: file, line: line)

    // Make sure that 'inout' did not modify original
    let inoutMsg = "Inout did modify shared/original value"
    XCTAssertEqual(value, valueBeforeInout, inoutMsg, file: file, line: line)
  }

  // MARK: - Helpers

  /// Abstraction over `BigInt.init(_:radix:)`.
  private func create(string: String, radix: Int) throws -> BigInt {
    return try BigInt(string, radix: radix)
  }
}
