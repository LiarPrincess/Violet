<!-- cSpell:ignore extendedarg -->

# Bytecode

Bytecode is an instruction set of our VM.

See `Bytecode - Instructions.md` for documentation of each instruction. Here we will only deal with an instruction set as a whole.

- [Bytecode](#bytecode)
  - [Instruction size](#instruction-size)
    - [Multiple bytes per instruction](#multiple-bytes-per-instruction)
    - [2-bytes per instruction](#2-bytes-per-instruction)
    - [Instruction set with `extendedArg`](#instruction-set-with-extendedarg)
    - [Trivia: Gameboy instruction set](#trivia-gameboy-instruction-set)
  - [Jumps and labels](#jumps-and-labels)
    - [Relative jumps](#relative-jumps)
    - [Absolute jumps](#absolute-jumps)
  - [Cells and free](#cells-and-free)
    - [Load nonlocal name](#load-nonlocal-name)
    - [Cell and free](#cell-and-free)
    - [Nomenclature](#nomenclature)

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
- Jumps — this includes: `JumpAbsolute`, `PopJumpIfX`, `JumpIfXOrPop`, loops, exceptions and `SetupWith`. We can hold a target instruction index (which would require a lot of `extendedArgs`, since most code object have more than 255 instructions). But we can also hold an index inside of an auxiliary array (named `CodeObject.labels`) that holds jump targets. Most code object will contain less than 255 jumps, which means that they would not require `extendedArg`. This will also simplify code in peephole optimizer since all of our jumps targets are stored in one place. Oh… yeah… all of our jumps are absolute (more about this later).
- `load`, `store` and `delete` — those are interesting because they need to store the name which is a `String`. `Strings` are massive in Swift (way bigger than `UInt64`), so yet again we will create an auxiliary array just for them (named `CodeObject.names`). Alternative design would be to store the name on the stack and then call `load` without arguments. However, this implies object allocation with some additional stack operations. Since we know the name during the compilation we can avoid it.

### Trivia: Gameboy instruction set

Btw. Similar trick was used in original [Gameboy](https://github.com/LiarPrincess/Swift-plays-Pokemon).

Gameboy instruction set contains more than 500 instructions. This is more than we can differentiate using a single byte. To solve this problem Nintendo used a special instruction (`0xcb`) that would instruct the cpu to decode the next instruction using *extended instruction set* which holds instructions above `0xff`.

The difference between what Violet does and what Nintendo did is that in the Violet case we modify next instruction **argument** and in Gameboy they modified the **instruction**.

## Jumps and labels

### Relative jumps

We do not support relative jumps, we always use absolute ones. In some cases relative jumps would require changes to already emitted code.

For example: `if` condition failed, we have to jump over the `body`, but we have not yet emitted it. After we emit the `body` code we have to go back to our jump and fix its argument.

Since our instruction set is fixed at 2-bytes-per-instruction this would (sometimes) require  insertion of `ExtendedArg` opcode (for jumps above 255) which could break other jump targets. Well… it can be done, but it is rather complicated.

### Absolute jumps

To handle absolute jumps we store jump targets in a separate `CodeObject.labels` array. When emitting jump we use the label index as an argument.

This is how you emit a jump:

```Swift
let builder = CodeObjectBuilder(…)

// Create empty jump target.
let end = builder.createLabel()

// Emit code before jump - always executed.
try self.visit(codeBefore)

// Jump.
builder.appendJumpAbsolute(to: end)

// Emit code that we will jump over - never executed.
try self.visit(codeToJumpOver)

// Set target for 'end' label - we will jump here.
builder.setLabel(end)
```

## Cells and free

Let's look at the following Python code:

```Python
def drink_me():
  alice = 'smol Alice'

  def eat_me():
    alice = 'big Alice'

  eat_me()
  print(alice)
```

If we ran this it would print “smol Alice” (and Alice would still be trapped under the table).

Why?

When we use a `name` in Python it is assumed that this `name` belongs to the current scope. In our example `alice = 'smol Alice'` and `alice = 'big Alice'` were 2 totally distinct variables (one in the `drink_me` and the other in `eat_me` scopes).

If we wanted to share the variable we would have to do something like:

```Python
def drink_me():
  alice = 'smol Alice'

  def eat_me():
    nonlocal alice # <— HERE
    alice = 'big Alice'

  eat_me()
  print(alice)
```

This would print “big Alice”.

Now, how do we handle this inside of the VM?

### Load nonlocal name

This is the original code that treats `alice` as a local variable inside of the nested `eat_me`:

```Python
loadConst "big Alice"
storeName "alice"
```

To handle `nonlocal` we could try to generate:

```Python
loadConst "big Alice"
storeNonlocalName "alice"
```

Where `storeNonlocalName` instruction would:
1. Get the current call stack
2. Get the caller frame
3. Look up the `alice`
4. (If that fails, then go to the parent-parent frame, and try again)

This would work in our example, but how about:

```Python
def drink_me():
  alice = 'Alice'

  def nested():
    nonlocal alice
    alice = 'smol Alice'

  return nested
```

So, we return the `nested` function (!) that has a reference to the `nonlocal alice`. This may seem easy, but what happens when we call the returned function?

```Python
make_alice_smol = drink_me()
make_alice_smol()
```

When calling `make_alice_smol()` we need the reference to the `nonlocal alice`. The problem is that the `drink_me` function has already finished execution and it is no longer on the call stack, so the `alice` is no longer available.

To solve this we would have to retain the whole frame for `drink_me` and with it all of its local variables etc. It is even worse when you realise that some of those variables could be file descriptors waiting to be closed (because the user did not use `with` syntax).

There must be a better way!

### Cell and free

Going back to our first example:

```Python
def drink_me():
  alice = 'smol Alice'

  def eat_me():
    nonlocal alice
    alice = 'big Alice'

  eat_me()
  print(alice)
```

What if the shared `Alice` variable was not attached to the `drink_me` function and instead it was living in a whole separate entity? We would call it `cell` and allocate on the heap. Then we will share the address of this `cell` to both `drink_me` and `eat_me` functions.

The most complicated situation that could arise is the interleaved access from both outer and inner function:

```Python
def drink_me():
  # Allocate cell with 'smol Alice' as content
  alice = 'smol Alice'

  def eat_me():
    nonlocal alice
    alice = 'big Alice'

  eat_me() # set cell content to 'big Alice'
  alice = 'smol Alice' # back to 'smol Alice'
  eat_me() # and then again to 'big Alice'

  raise AliceIsFullException()
```

This would work, since they operate on the same piece of the memory (`cell`). Please note that we can’t just share the variable value, because some values are immutable (for example `int`, `str`), so if we set it in 1 place, we can’t modify it in another, we need some indirection layer.

Now, going back to the:

```Python
def drink_me():
  alice = 'Alice'

  def nested():
    nonlocal alice
    alice = 'smol Alice'

  return nested

make_alice_smol = drink_me()
make_alice_smol()
```

Here when we call `make_alice_smol()` the `alice` is stored inside of the `cell`, so the `drink_me` frame is no longer needed.

### Nomenclature

In violet we will use following names:
- `cell` — source of a variable in the outer function
- `free` — reference to the variable in the inner function, see “[Free variables and bound variables on Wikipedia](https://en.wikipedia.org/wiki/Free_variables_and_bound_variables)”

We need this distinction because our nested/inner function can be have yet another nested function with its set of `free` variables.

In practice:

```Python
def drink_me():
  # Allocate cell with 'smol Alice' as content
  alice = 'smol Alice'

  def eat_me():
    # Use cell from outer function.
    nonlocal alice
    alice = 'big Alice'
```

This will generate:

```Python
# def drink_me
loadConst "smol Alice"
storeCell "alice"

# def eat_me
loadConst "big Alice"
storeFree "alice"
```
