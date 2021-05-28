# BigInt

Unlimited integer type used as a storage of `int` type in Violet.

## Unlimited integer vs BigInt

While *technically* we do implement every operation expected from `BigInt` type, what we *actually* have is more of a *general-purpose unlimited integer*.

Here are some differences:

BigInt:
- assumes that most of the code will use built-in Swift integer types. `BigInt` will be used, but only in places that can overflow.
- focuses on performance for big numbers, since small ones will be handled using Swift types.
- is more of a *auxiliary* type, rather than a thing on its own.
- it's *ok* to allocate for every instance (most of the `BigInt` implementations will do just that). Although this should be avoided if possible.

Unlimited/general purpose integer:
- assumes that this is the only integer type available in the system (`Python` has only single `int` type).
- will probably optimize for small numbers (think: `0`, `1`, `256` etc.) rather than big ones (think: `123_123_123_123_123_123`).

So, while both types look the same from the outside (in terms of supported operations), their internal implementation can differ quite dramatically.

**Important:**
If you’re looking for `BigInt` implementation then this module may not be it!

## Design

In our current implementation we use [tagged pointer](https://en.wikipedia.org/wiki/Tagged_pointer) to store either:
- inline small integer (currently `Int32`) - we call this variant `Smi`, because this is how [V8](https://github.com/v8/v8) named similar type.
- pointer to heap allocated storage - for integers that are outside of `Smi` range. This allows us to store any possible value (as long as it can fit in memory).

The idea is as follows:
- if we are dealing with small integer then we use `Smi` representation:
  - it saves us heap allocation on creation
  - prevents cache miss since there is no memory to fetch (we already have the value, we just have to decode it)
  - takes less space in cpu cache since there no need to store heap object (may seems trivial, but those objects can quickly add up)
  - can be promoted to heap allocated representation if the value no longer fits inside `Smi`
- if the value does not fit inside `Smi`, then we will allocate space on the heap:
  - allocated space can grow to accommodate bigger values (although it will change the value stored in pointer, but that's not a problem)
  - can be demoted to `Smi` to release memory

While this representation is a little bit more cpu-intensive (we need to check with which representation we are dealing with) we hope that memory savings will help us regain this loss of performance.

Btw. don't worry if this section is quite cryptic, we will explain all of the concepts in [Requirements](#Design%20requirements) and [Alternative designs](#Alternative%20designs) sections.

**Code example**

The whole implementation looks more-or-less like this:

``` Swift
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

- PyObject pointer -> (dereference) -> PyInt -> Smi -> Done
- PyObject pointer -> (dereference) -> PyInt -> Heap -> (dereference) -> Done

Since `int` is very popular we could move `Smi` a little bit forward:
- PyObject pointer or Smi -> Smi -> Done
- PyObject pointer or Smi -> PyObject pointer -> (dereference) -> Things

This method is very popular in JavaScript engines (both V8 and SpiderMonkey use it).

As a side-note: it is also possible to store 64-bit IEEE 754 floating point (in addition to `Smi`) inside tagged pointer, so at some point in time we may look into this.

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
| Tuple of multiple Swift `UInt` (+sign) that pretend to be single `Int` | <ul><li>gets really close to proper `BigInt` implementation - most users will not notice</li><li>inline - does not require heap allocation</li></ul> | <ul><li>most of the numbers are small, so we are wasting cache/memory to store `0`s (or `1` if we went with 2 complement)</li><li>tuple size is an additional parameter that we have to optimize/test</li><li>passing it around may be quite costly</li><li>non-trivial to implement - tuples are not `Collections` in Swift</li></ul> |
| Heap | <ul><li>actual `BigInt` without gotchas</li><li>there are some existing Swift libraries that use this option, so we can “borrow” code from them</li></ul> | <ul><li>heap allocation</li></ul> |

We used the 1st option for a very long time (basically the whole Violet development), but then (due to sheer amount of tests that we had to comment out) we decided to implement our own `BigInt`.

“Tuple” representation is a bit harder to implement than “heap” and it does not solve our problem in full capacity (because it still has some upper bound and also it wastes a lot of memory).

So that leaves us “heap” variant which has an obvious flaw: heap allocation. But there is an interesting technique to (partially) mitigate this:

**Tagged pointer**

> In most of the computer architectures memory address (and thus pointer) has to be aligned to certain value (usually a word). This means that you can't address a single byte in memory (well… technically…), but it also means that some of the pointer bits are unused (they are always zero).
>
> For example:
> - on a 32-bit architecture word-aligned addresses are always a multiple of 4 leaving the last 2 bits available
> - on a 64-bit architecture word-aligned addresses are always a multiple of 8, leaving the last 3 bits available
>
> Since we know how the correct address should look like, we can use those bits for some other purpose (as long as we “repair” the pointer before every read/write).
>
> This may seem scarry, but it is really easy in Swift thanks to [enums where payload types have spare bits (extra inhabitants)](https://github.com/apple/swift/blob/main/docs/ABI/TypeLayout.rst#multi-payload-enums).

We will use “tagged pointers” in the following way:
- tag bit is 0: value is an actual address of the location in memory
- tag bit is 1: value is NOT an memory address, remaining bits can be used to store whatever data we want (for example 64-bit machines gives us 63 bits to use)

**Smi**

So, what can we do with all of *dem bits*?
- store 63-bit integer - unfortunately Swift does not have built-in `Int63` type, so we would have to frankenstein it from smaller types. There is also the sign/2 complement to worry about. *ugh…*
- store `Int63` as `Int64` and manually manage tag, this will also mean that we have to deal with unpacking and sign extension
- store `UInt32` + `Bool` for sign which gives us `Int33` (with 2 zero representations)
- just store `Int32`

We went with option 3: “store `Int32`”, because it is really simple to implement.

**Heap**

But now what about this pointer-thingy? What does it actually points to?
- object that stores sign + magnitude
- object that stores only magnitude, because we will use yet another bit inside the pointer to remember if the number is negative

“Option 2” is very interesting because it means that `x` and `-x` will point to exactly the same object in memory (since magnitude is the same), and the sign information is stored inside the pointer. Unfortunately it is quite difficult to implement, thats why we went with “option 1”.

Ok, but how do we allocate this object?
- [Array](https://developer.apple.com/documentation/swift/array) - arrays do not allow us to use tagged pointers which basically invalidates everything we talked about. Also, they are bigger in size than pointer (tested on x64) without any spare bits.
- [UnsafeBufferPointer](https://developer.apple.com/documentation/swift/unsafebufferpointer) - the problem is that this is *unowned* memory and we can't trivially find the owner that would be responsible for deallocation. To solve this we would have to implement our own garbage collection or ARC.
- [ManagedBufferPointer](https://developer.apple.com/documentation/swift/managedbufferpointer) - this is basically a bunch of memory with *Header* and *Elements* controlled by ARC… which is exactly what we need

**Two complement vs sign + magnitude**

We also have to decide between “[2 complement](https://en.wikipedia.org/wiki/Two%27s_complement)” or “sign + magnitude” representation.

We went with “sign + magnitude”. Essentially all this boils down to: “how complicated do you want your `div`?” (`div` is the most difficult operation to implement, we went with simpler `div` at a cost of more complicated `and`, `or` and `xor`).

Final design is available in [Design](#Design) section.

## Karatsuba multiplication & other performance tricks

In general when asked for algorithm we always followed “The Art of Computer Programming” chapter  “4.3.1. The Classical Algorithms”.

However, those interested in number theory know that there other (seemingly faster) methods.

For example in chapter “4.3.3. How Fast Can We Multiply?” Knuth describes “[Karatsuba algorithm](https://en.wikipedia.org/wiki/Karatsuba_algorithm)”. While it could be seen as better than our “classical/school method”, it has rather long and costly preparation phase. To quote [Wikipedia](https://en.wikipedia.org/wiki/Karatsuba_algorithm#Efficiency_analysis):

> The point of positive return depends on the computer platform and context. As a rule of thumb, Karatsuba method is usually faster when the multiplicands are longer than 320–640 bits.

This is how it stacks against our [Requirements](#Design%20Requirements):
- `Smi` - will be performed directly on ALU
- mid range integers - cache line size is around “the point of positive return”, but the cost of fetching those values from memory will probably outweigh the cost of multiplication
- big integers - main target for “Karatsuba method”, but we do not care them (even `O(n^3)` is “ok”)

Also, is quite difficult to implement.

We used the same approach when discussing other “fast” algorithms (not only for multiplication), which means that none of them are implemented.