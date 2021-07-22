# What is this?

This script is used when updating [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) version for the whole project.

It will:
1. Get all of the possible rules (`swiftformat --rules` command).
2. Get all of the possible options (`swiftformat --options` command).
2. Read `.swiftformat` in root directory to check the rules mentioned there.
3. List all of the options and rules not mentioned in `.swiftformat`.

With that information go to [SwiftFormat/Rules.md](https://github.com/nicklockwood/SwiftFormat/blob/master/Rules.md) and read about every new option/rule deciding whether we want to enable it or not (the general rule is: enable everything that does not produce a lot of errors in already written code).
If the option/rule should not be enabled (or left with default value) then it should be *commented* in config.

# How to run?

Run following in root directory:
> python3 ./Scripts/swiftformat_version_migration
