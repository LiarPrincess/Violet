# What is this?

This script will generate copy-on-write (COW) tests for our `BigInt` implementation. It is important, because even though `BigInt` is immutable, the heap that is points to is not.

Those tests should be placed in `/Tests/BigIntTests/BigInt/BigIntCOWTests.swift`.

Example test looks like this:

```Swift
func test_addEqual_toCopy_doesNotModifyOriginal() {
  // smi + smi
  var value = BigInt(SmiStorage.max)
  var copy = value
  copy += self.smiValue
  XCTAssertEqual(value, BigInt(SmiStorage.max))

  // smi + heap
  value = BigInt(SmiStorage.max)
  copy = value
  copy += self.heapValue
  XCTAssertEqual(value, BigInt(SmiStorage.max))

  // heap + smi
  value = BigInt(HeapWord.max)
  copy = value
  copy += self.smiValue
  XCTAssertEqual(value, BigInt(HeapWord.max))

  // heap + heap
  value = BigInt(HeapWord.max)
  copy = value
  copy += self.heapValue
  XCTAssertEqual(value, BigInt(HeapWord.max))
}
```

# How to run?

Run following command from the repository root:

> ./Scripts/bigint_generate_cow_tests/main.sh

This will generate `out.swift` file with the result.
