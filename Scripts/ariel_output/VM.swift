====================
=== VM+Run.swift ===
====================

extension VM {
  public enum RunResult {}
  public func run() -> RunResult
}

================
=== VM.swift ===
================

public final class VM {
  public let py: Py
  public init(arguments: Arguments, environment: Environment)
}

