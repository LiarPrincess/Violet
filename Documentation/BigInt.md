# BigInt

Unlimited integer type used as a storage of `int` type in Violet.

**Important:**
If you’re looking for a `BigInt` implementation then this module may not be it! (See the next section for details.)

- [BigInt](#bigint)
  - [Unlimited integer vs BigInt](#unlimited-integer-vs-bigint)
  - [Design](#design)
  - [Design requirements](#design-requirements)
  - [Alternative designs](#alternative-designs)
  - [Karatsuba multiplication & other performance tricks](#karatsuba-multiplication--other-performance-tricks)

## Unlimited integer vs BigInt

While *technically* we do implement every operation expected from `BigInt` type, what we actually have is more of a *general-purpose unlimited integer*.

BigInt:
- Assumes that most of the code will use built-in Swift integer types. `BigInt` will be used, but only in places that can overflow.
- Focuses on performance for big numbers, since small ones will be handled using Swift types.
- Is more of a auxiliary type, than a thing on its own.
- It's *ok* to allocate for every instance (most of the `BigInt` implementations will do just that). Although this should be avoided if possible.

Unlimited/general purpose integer (we made-up this name, so don't Google it):
- Assumes that this is the only integer type available in the system (`Python` has only a single `int` type).
- Will probably optimise for small numbers (think: `0`, `1`, `256` etc.) rather than big ones (think: `123_123_123_123_123_123`).

The same but in different words:

“Standard” `BigInt` assumes uniform distribution of inputs, meaning that `1` is as likely as `123_123_123_123_123_123`. In our case this distribution is skewed towards small numbers, meaning that `1` is much more probable than `123_123_123_123_123_123`.

This is kind of similar to how single letters (or in general: short texts) are way more common than other `Strings`. To accommodate this Swift standard library treats them in a special way and stores inline, instead of allocating on the heap.

Tbh. at this point one could wonder if there is even something like “standard `BigInt`”, since both implementations expose the same interface, but their performance characteristics and expected usage patterns are quite different. Sometimes just saying “I need a `BigInt` library to handle X”, may not be enough, because the design of this `BigInt` may assume things that will not be true in your use case.

## Design

In our current implementation we use [tagged pointer](https://en.wikipedia.org/wiki/Tagged_pointer) to store either:
- Inline small integer (currently `Int32`) - we call this variant `Smi`, because this is how [V8](https://github.com/v8/v8) named similar type.
- Pointer to heap allocated storage - for integers that are outside of `Smi` range. This allows us to store any possible value as long as it fits in memory.

The idea is as follows:
- If we are dealing with small integer then we use `Smi` representation:
    - it saves us heap allocation on creation
    - prevents cache miss since there is no memory to fetch - we already have the value, we just have to decode it
    - takes less space in cpu cache since there no need to store heap object - may seems trivial, but those objects can quickly add up
    - can be promoted to heap allocated representation if the value no longer fits inside `Smi`
- If the value does not fit inside `Smi`, then we will allocate space on the heap:
    - allocated space can grow to accommodate bigger values -  it will change the value stored in pointer, but that's not a problem because any operation that requires this, should have `mutating` semantic anyway
    - can be demoted to `Smi` to release memory

While this representation is a little bit more cpu-intensive (we need to check with which representation we are dealing with before every operation) we hope that memory savings will help us regain this loss of performance.

Btw. don't worry if this section is quite cryptic, we will explain all of the concepts in [requirements](#design-requirements) and [alternative designs](#alternative-designs) sections.

**Code example**

The whole implementation looks more-or-less like this:

```Swift
struct BigInt {

  enum Storage {
    case smi(Smi)
    case heap(BigIntHeap)
  }

  var value: Storage
}

struct Smi {
  let value: Int32
}

struct BigIntHeap {
  // In an actual implementation we have yet another type that deals with COW.
  var ptr: ManagedBufferPointer
}
```

**Future (maybe/probably/hopefully/never)**

Current access path for `PyInt` value looks like this:

- `PyObject` pointer -> (dereference) -> `PyInt` -> `Smi` -> Done
- `PyObject` pointer -> (dereference) -> `PyInt` -> Heap -> (dereference) -> Done

Since `int` is very popular we could move `Smi` forward:
- `PyObject` pointer or `Smi` -> `Smi` -> Done
- `PyObject` pointer or `Smi` -> `PyObject` pointer -> (dereference) -> Things

This method is very popular in JavaScript engines (both V8 and SpiderMonkey use it).

As a side-note: it is also possible to store 64-bit IEEE 754 floating point (in addition to `Smi`) inside tagged pointer, so at some point we may look into this.

## Design requirements

The main thing that drives our design is that “not all integers are created equal” (literally and figuratively). We distinguish following classes of integers:

- **small integers** (around word size) - those integers will be used most often (for example: `0` and `1` will be used in almost every loop). Their performance is crucial for overall `int` performance. Ideally we should use built-in Swift types to represent them.
- **mid range integers** (around cache line size) - those integers are big, but we should handle them in reasonably fast manner. Please remember to factor Swift type metadata and ARC into design (only if used).
- **big integers** (above cache line size) - all bets are off, we don't care about those. `O(n^2)` (or even `O(n^3)`) is acceptable.

## Alternative designs

In general we would differentiate 3 main ways of implementing `BigInt`:

| Option | Pros | Cons |
|--------|------|------|
| Wrap biggest Swift `Int` type and pretend that it is a `BigInt` | <ul><li>trivial to implement</li></ul>| <ul><li>not really a `BigInt`</li><li>would force us to comment all of the Python tests that require an actual `BigInt`</li></ul> |
| Tuple of multiple Swift `UInt` (+sign) that pretend to be a  single `Int` | <ul><li>gets really close to proper `BigInt` implementation - most users will not notice</li><li>inline - does not require heap allocation</li></ul> | <ul><li>most of the numbers are small, so we are wasting cache/memory to store `0`s (or `1` if we went with 2 complement)</li><li>tuple size is an additional parameter that we have to optimise/test</li><li>passing it around may be quite costly</li><li>non-trivial to implement - tuples are not `Collections` in Swift</li></ul> |
| Heap | <ul><li>actual `BigInt` without gotchas</li><li>there are some existing Swift libraries that use this option, so we can “borrow” code from them</li></ul> | <ul><li>heap allocation</li></ul> |

We used the 1st option for a very long time (basically the whole Violet development), but then (due to sheer amount of tests that we had to comment out) we decided to implement our own `BigInt`.

“Tuple” representation is a bit harder to implement than “heap” and it does not solve our problem in full capacity (because it still has some upper bound and it wastes memory for unused bits).

So that leaves us “heap” variant which has an obvious flaw: heap allocation. But there is an interesting technique that can (partially) mitigate this:

**Tagged pointer**

In most of the computer architectures memory address (and thus pointer) has to be aligned to a certain value. This means that some of the pointer bits are unused (they are always zero).

For example:
- on a 32-bit architectures word-aligned addresses are always a multiple of 4 leaving the last 2 bits available
- on a 64-bit architectures word-aligned addresses are always a multiple of 8, leaving the last 3 bits available

Since we know how the correct address should look like, we can use those bits for some other purpose (as long as we “repair” the pointer before every read/write).

This may seem scary, but it is really easy in Swift thanks to [enums where payload types have spare bits (extra inhabitants)](https://github.com/apple/swift/blob/main/docs/ABI/TypeLayout.rst#multi-payload-enums).

We will use “tagged pointers” in the following way:
- if tag bit is not set: value is an actual address of the location in memory
- if tag bit is set: value is NOT a memory address, remaining bits can be used to store whatever data we want (for example 64-bit machine gives us 63 bits to use)

**Smi**

So, what can we do with all of *dem bits*?
- store 63-bit integer - unfortunately Swift does not have built-in `Int63` type, so we would have to frankenstein it from smaller types. There is also the sign/2 complement to worry about. *ugh…*
- store `Int63` as `Int64` and manually manage tag, this will also mean that we have to deal with unpacking and sign extension
- store `UInt32` + `Bool` for sign which gives us `Int33` (with 2 zero representations)
- just store `Int32`

We went with option 4: “store `Int32`”, because it is really simple to implement.

**Heap**

But what about this pointer-thingy? How do we allocate this object?
- [Array](https://developer.apple.com/documentation/swift/array) - arrays do not allow us to use tagged pointers which basically invalidates everything we talked about. Also, they are bigger in size than a pointer (tested on intel x64).
- [UnsafeBufferPointer](https://developer.apple.com/documentation/swift/unsafebufferpointer) - the problem is that this is an *unowned* memory and we can't trivially find the owner that would be responsible for deallocation. To solve this we would have to implement our own garbage collection or ARC.
- [ManagedBufferPointer](https://developer.apple.com/documentation/swift/managedbufferpointer) - this is basically a bunch of memory with *Header* and *Elements* controlled by ARC… which is exactly what we need

**Two complement vs sign + magnitude**

Ok, but how do we represent our `int`? What do we store on the heap?
- sign + magnitude
- [two complement](https://en.wikipedia.org/wiki/Two%27s_complement)
- only magnitude, because we will use yet another bit inside the pointer to remember if the number is negative

“Option 3” is very interesting because it means that `x` and `-x` will point to exactly the same object in memory (since magnitude is the same), and the sign information would be stored inside the pointer. Given that `ManagedBufferPointer` uses ARC for memory management, this whole operation would just `retain` the buffer without any allocation. Unfortunately all of this it is quite difficult to implement, so we will pass.

The remaining 2 options are “2 complement” and “sign + magnitude”. This choice boils down to: “how complicated do you want your `div`?” (`div` is the most complicated operation to implement).

We went with “sign + magnitude” which gives us simpler `div` at the cost of more complicated `and`, `or` and `xor`.

Final design is available in [design](#design) section.

## Karatsuba multiplication & other performance tricks

In general when asked for algorithm we always followed “The Art of Computer Programming” chapter  “4.3.1. The Classical Algorithms”.

However, those interested in number theory know that there are other (seemingly faster) methods.

For example in chapter “4.3.3. How Fast Can We Multiply?” Knuth describes “[Karatsuba algorithm](https://en.wikipedia.org/wiki/Karatsuba_algorithm)”. While it could be seen as better than our “classical/school method”, it has rather long and costly preparation phase. To quote [Wikipedia](https://en.wikipedia.org/wiki/Karatsuba_algorithm#Efficiency_analysis):

> The point of positive return depends on the computer platform and context. As a rule of thumb, Karatsuba method is usually faster when the multiplicands are longer than 320–640 bits.

This is how it stacks against our [requirements](#design-requirements):
- `Smi` — will be performed directly on ALU
- mid range integers — cache line size is around “the point of positive return”, but the cost of fetching those values from memory will probably outweigh the cost of multiplication
- big integers — main target for “Karatsuba method”, but we do not care them (even `O(n^3)` is “ok”)

Also, is quite difficult to implement.

We used the same approach when discussing other “fast” algorithms (not only for multiplication), which means that none of them are implemented.
