def print_unary_test(name, operator):
    name_upper = name
    name_lower = name_upper.lower()

    print(f'''\
  // MARK: - {name_upper}

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_{name_lower}_doesNotModifyOriginal() {{
    // {operator}smi
    var value = BigInt(SmiStorage.max)
    _ = {operator}value
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // {operator}heap
    value = BigInt(HeapWord.max)
    _ = {operator}value
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}
''')


def print_binary_tests(name, operator):
    name_upper = name
    name_lower = name_upper.lower()

    print(f'''\
  // MARK: - {name_upper}

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_{name_lower}_toCopy_doesNotModifyOriginal() {{
    // smi {operator} smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy {operator} self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi {operator} heap
    value = BigInt(SmiStorage.max)
    copy = value
    _ = copy {operator} self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap {operator} smi
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy {operator} self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap {operator} heap
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy {operator} self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_{name_lower}_toInout_doesNotModifyOriginal() {{
    // smi {operator} smi
    var value = BigInt(SmiStorage.max)
    self.{name_lower}Smi(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi {operator} heap
    value = BigInt(SmiStorage.max)
    self.{name_lower}Heap(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap {operator} smi
    value = BigInt(HeapWord.max)
    self.{name_lower}Smi(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap {operator} heap
    value = BigInt(HeapWord.max)
    self.{name_lower}Heap(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}

  private func {name_lower}Smi(toInout value: inout BigInt) {{
    _ = value {operator} self.smiValue
  }}

  private func {name_lower}Heap(toInout value: inout BigInt) {{
    _ = value {operator} self.heapValue
  }}

  func test_{name_lower}Equal_toCopy_doesNotModifyOriginal() {{
    // smi {operator} smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy {operator}= self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi {operator} heap
    value = BigInt(SmiStorage.max)
    copy = value
    copy {operator}= self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap {operator} smi
    value = BigInt(HeapWord.max)
    copy = value
    copy {operator}= self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap {operator} heap
    value = BigInt(HeapWord.max)
    copy = value
    copy {operator}= self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}

  func test_{name_lower}Equal_toInout_doesModifyOriginal() {{
    // smi {operator} smi
    var value = BigInt(SmiStorage.max)
    self.{name_lower}EqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // smi {operator} heap
    value = BigInt(SmiStorage.max)
    self.{name_lower}EqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap {operator} smi
    value = BigInt(HeapWord.max)
    self.{name_lower}EqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))

    // heap {operator} heap
    value = BigInt(HeapWord.max)
    self.{name_lower}EqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }}

  private func {name_lower}EqualSmi(toInout value: inout BigInt) {{
    value {operator}= self.smiValue
  }}

  private func {name_lower}EqualHeap(toInout value: inout BigInt) {{
    value {operator}= self.heapValue
  }}
''')


def print_shift_tests(direction, operator):
    direction_upper = direction
    direction_lower = direction_upper.lower()

    print(f'''\
  // MARK: - Shift {direction_lower}

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_shift{direction_upper}_copy_doesNotModifyOriginal() {{
    // smi {operator} int
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy {operator} self.shiftCount
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap {operator} int
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy {operator} self.shiftCount
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_shift{direction_upper}_inout_doesNotModifyOriginal() {{
    // smi {operator} int
    var value = BigInt(SmiStorage.max)
    self.shift{direction_upper}(value: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap {operator} int
    value = BigInt(HeapWord.max)
    self.shift{direction_upper}(value: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}

  private func shift{direction_upper}(value: inout BigInt) {{
    _ = value {operator} self.shiftCount
  }}

  func test_shift{direction_upper}Equal_copy_doesNotModifyOriginal() {{
    // smi {operator} int
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy {operator}= self.shiftCount
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap {operator} int
    value = BigInt(HeapWord.max)
    copy = value
    copy {operator}= self.shiftCount
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }}

  func test_shift{direction_upper}Equal_inout_doesModifyOriginal() {{
    // smi {operator} int
    var value = BigInt(SmiStorage.max)
    self.shift{direction_upper}Equal(value: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap {operator} int
    value = BigInt(HeapWord.max)
    self.shift{direction_upper}Equal(value: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }}

  private func shift{direction_upper}Equal(value: inout BigInt) {{
    value {operator}= self.shiftCount
  }}
''')


if __name__ == '__main__':
    print_unary_test('Plus', '+')
    print_unary_test('Minus', '-')
    print_unary_test('Invert', '~')

    print_binary_tests('Add', '+')
    print_binary_tests('Sub', '-')
    print_binary_tests('Mul', '*')
    print_binary_tests('Div', '/')
    print_binary_tests('Mod', '%')

    print_shift_tests('Left', '<<')
    print_shift_tests('Right', '>>')
