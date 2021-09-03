# Violet

`Violet` is the main executable inside Violet project (duh…).

This module contains only a single `main.swift` file that will:
1. Read arguments from `CommandLine.arguments`
2. Read environment from `ProcessInfo.processInfo.environment`
3. Run `VM` with provided arguments and environment
4. Interpret results
