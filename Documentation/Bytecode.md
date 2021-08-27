# Bytecode

Bytecode is an instruction set of our VM.

See `Bytecode - Instructions.md` for documentation of each instruction. Here we will only deal with an instruction set as a whole.

## Instruction size

Each of our instructions is *exactly* 2-bytes. What does that mean and why is it important?

### Multiple bytes per instruction

First, let's look at this type:

```Swift
enum Foo64 {
  case value(UInt64)
  case other
}
```

(Oh… yeah… we will be using Swift `enum` instead of dealing with raw bytes, it is easier this way.)

How would we represent it in memory?
Well… we know that we need to store `UInt64`, so that means that we need *at-least* 64 bits. We also need a way to differentiate between `Foo64.value` and `Foo64.other`, so that's another bit (let's call it `tag`).

This gives us:
- `value(UInt64)` - 64 bits for `UInt64` + 1 bit for `tag` = 65 bits
- `other` - 1 bit for `tag`, all of the other bits are unused

Which in Swift terms is:

```Swift
MemoryLayout<Foo64>.size // -> 9 bytes
MemoryLayout<Foo64>.stride // -> 16 bytes
```

Which means:
- Size: 9 bytes — 65 bits rounded up to next byte. Nothing interesting, but it shows that our logic is correct.
- Stride: 16 bytes — number of bytes used for a single instance when stored in an array (you know… just like we are doing inside `CodeObject`). Value of 16 means that after each instance there are 7 unused bytes (ooops…).

This type is bad for:
- Memory usage — all of the instances take 9 bytes, even if they represent `Foo64.other` (which needs only a single bit).
- Cache efficiency — tons of unused memory inside CPU cache, because `MemoryLayout<Foo64>.size != MemoryLayout<Foo64>.stride`.

### 2-bytes per instruction

Now, let's look at the following type:

```Swift
enum Foo8 {
  case value(UInt8)
  case other
}

MemoryLayout<Foo8>.size // -> 2
MemoryLayout<Foo8>.stride // -> 2
```

This means:
- Size: 2 bytes — 1 byte for tag + 1 for value.
- Stride: 2 bytes — `Foo8` instances are tightly packed inside the array with no space in-between.

This type uses less memory than `Foo64` and it is also more cache efficient.

The problem is that it has different semantics. `Foo64` allowed us to store a whole `UInt64`, while `Foo8` only `UInt8`! We can fix this with an additional `extendedArg` case:

```Swift
enum Foo8Extended {
  case value(UInt8)
  case other
  // Prefixes `value` when its argument is too big to fit into the `UInt8`. Ignored for `other`.
  case extendedArg(UInt8)
}

MemoryLayout<Foo8Extended>.size // -> 2
MemoryLayout<Foo8Extended>.stride // -> 2
```

Now if we want to emit `value` higher than `UInt8` we need to prefix it with one (or possibly more) `Foo8Extended.extendedArg` instances. To decode the original value we can:

```Swift
let extendedArg = UInt8(1)
let arg = UInt8(5)
let value = (UInt16(extendedArg) << 8) | UInt16(arg) // 261 (UInt16)
```

That may look very inefficient, but let's try to encode `UInt64` in both `Foo64` and `Foo8Extended`:
- `Foo64` — single `.value(UInt64)`, in total 9 bytes with stride of 16 bytes.
- `Foo8Extended` — needs 7x `Foo8Extended.extendedArg` and a single `Foo8Extended.value`. In total it is 16 bytes with stride of 16 bytes.

So, both of them take 16 bytes (stride is the thing that matters). We expect Violet to be memory-bound and not cpu-bound, so the small cpu overhead does not matter that much.

### Instruction set with `extendedArg`

Finally, let's look at our instruction set from the `extendedArg` angle.

Instructions that do not have an argument (so, basically they just have a tag):
- `Nop`, `PopTop`, `RotTwo`, `RotThree`, `DupTop`, `DupTopTwo`
- Unary, binary and in-place operations (all 30 of them)

Instructions with argument that will never need extended argument:
- `CompareOp` — there are only 11 possible comparison types which is far less than 256.
- `BuildSlice` — has only 2 possible arguments: `LowerUpper`, `LowerUpperStep`.
- `RaiseVarargs` — has `ReRaise`, `ExceptionOnly`, `ExceptionAndCause`.
- `FormatValue` — this is interesting, because we need to store `StringConversion` (which has 4 possible values - 2 bits) and `hasFormat` (which is `bool` - 1 bit). Can Swift pack this into 1 byte? Yes it can.

Instructions that may need extended argument:
- Collection builders — this includes: `BuildTuple`, `BuildList`, `BuildSet`, `BuildMap`, `BuildString` and a ton of other instructions. In this case we need to store the number of elements to pop from the stack and place inside of the collection. But often do we need to create a collection with more than 256 elements? And even then, using a single extended argument would give us 65536 elements.
- Jumps — this includes: `JumpAbsolute`, `PopJumpIfX`, `JumpIfXOrPop`, loops, exceptions and `SetupWith`. We can hold a target instruction index (which would require a lot of `extendedArgs`, since most code object have more than 255 instructions). But we can also hold an index inside of an auxiliary array (named `CodeObject.labels`) that holds jump targets. Most code object will contain less than 255 jumps, which means that they would not require `extendedArg`. This will also simplify code in peephole optimiser since all of our jumps targets are stored in one place. Oh… yeah… all of our jumps are absolute.
- `load`, `store` and `delete` — those are interesting because they need to store the name which is a `String`. `Strings` are massive in Swift (way bigger than `UInt64`), so yet again we will create an auxiliary array just for them (named `CodeObject.names`). Alternative design would be to store the name on the stack and then call `load` without arguments. However, this implies object allocation with some additional stack operations. Since we know the name during the compilation we can avoid it.

### Trivia: Gameboy instruction set

Btw. Similar trick was used in original [Gameboy](https://github.com/LiarPrincess/Swift-plays-Pokemon).

Gameboy instruction set contains more than 500 instructions. This is more than we can differentiate using a single byte. To solve this problem Nintendo used a special instruction (`0xcb`) that would instruct the cpu to decode the next instruction using *extended instruction set* which holds instructions above `0xff`.

The difference between what Violet does and what Nintendo did is that in the Violet case we modify next instruction **argument** and in Gameboy they modified the **instruction**.
