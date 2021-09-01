# FileSystem

`FileSystem` is a convenient interface to the contents of the file system, and the primary mean of interacting with it.

## Important files

- `FileSystem.swift` — main exported type, very similar to `Foundation.FileManager`. Contains things like: `basename`, `extname`, `dirname`, `stat`, `mkdir`, `readdir` etc.

- `FileDescriptor.swift` — our own wrapper around file descriptor.

## FileDescriptor

So, we are going to write a custom file descriptor.

.

..

...

Wait. What?

### Why?

Darwin version of `Foundation` (macOS 10.14.6) has following problems:
- Read/write/etc. methods are not marked as throwing — this means that operating on closed/invalid files will always trap without giving us a chance to handle errors (well technically… but we are not going there). As of 10.15 those methods are [deprecated](developer.apple.com/documentation/foundation/filehandle/1410936-write).
- In 10.15 new methods were introduced (for example: `func __write(_ data: Data, error: ()) throws`). But they are not usable on 10.14.

### Problems to solve

This is why the 'always trapping' file operations are no-go:

- Error handling - when can we crash?
    - It is acceptable for Violet to crash when some core invariant is not satisfied — working with invalid state while having access to effects (for example IO) may end badly.
    - It is NOT acceptable for Violet to crash because of user error (for example writing to file after closing it).

### Solutions

1. Use 'macOS 10.15' version of `Foundation` — but that forces everyone to upgrade, so NOPE.
2. Link against [common `Foundation`](github.com/apple/swift-corelibs-foundation) — but then we have to describe it in our README and that may seem like magic for most of the users (even if we automate this). And if that fails (even for a single user) then that would be a TERRIBLE user experience (literally the worst thing). NOPE.
3. Use `FileHandle` from `swift-corelibs-foundation` as a base for our own wrapper - in README we can describe it as: 'works only on macOS and Linux, Windows not supported' (we could copy Windows part, but we are too lazy). This is simple, transparent and SETS CLEAR BOUNDARIES.
4. (Placeholder for some other simple solution that I will feel dump about in the future.)

We went with option '3'.
